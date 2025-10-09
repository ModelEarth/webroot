#!/usr/bin/env python3
"""
Salesforce csv pull using JWT Bearer Authentication with .env support
Usage:
  With .env file: python sf_export.py --report-id 00O0c000009XxxX
  With CLI args: python sf_export.py --report-id 00O0c000009XxxX --username your@email.com --consumer-key yourconsumerkey --private-key-file path/to/private.key
"""

import requests
import argparse
import sys
import os
import time
import jwt
from datetime import datetime, timedelta
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend
from cryptography import x509
from cryptography.x509.oid import NameOID
from dotenv import load_dotenv

class SalesforceJWTReportExporter:
    def __init__(self, username=None, consumer_key=None, private_key_path=None, audience_url=None):
        # Load environment variables
        load_dotenv()
        
        # Use provided values or fall back to environment variables
        self.username = username or os.getenv('SF_USERNAME')
        self.consumer_key = consumer_key or os.getenv('SF_CONSUMER_KEY')
        self.private_key_path = private_key_path or os.getenv('SF_PRIVATE_KEY_FILE')
        self.audience_url = audience_url or os.getenv('SF_AUDIENCE_URL', 'https://login.salesforce.com')
        
        # Validate required parameters
        if not self.username:
            raise ValueError("Username is required (set SF_USERNAME in .env or use --username)")
        if not self.consumer_key:
            raise ValueError("Consumer key is required (set SF_CONSUMER_KEY in .env or use --consumer-key)")
        if not self.private_key_path:
            raise ValueError("Private key file is required (set SF_PRIVATE_KEY_FILE in .env or use --private-key-file)")
            
        self.instance_url = None
        self.access_token = None
        self.session = requests.Session()
        
    def load_private_key(self):
        """Load the private key from file"""
        try:
            with open(self.private_key_path, 'rb') as key_file:
                private_key = serialization.load_pem_private_key(
                    key_file.read(),
                    password=None,
                    backend=default_backend()
                )
            return private_key
        except Exception as e:
            print(f"✗ Error loading private key: {e}")
            return None
    
    def create_jwt_assertion(self):
        """Create JWT assertion for authentication"""
        private_key = self.load_private_key()
        if not private_key:
            return None
            
        # JWT payload
        now = datetime.utcnow()
        payload = {
            'iss': self.consumer_key,           # Consumer Key from Connected App
            'sub': self.username,               # Salesforce username
            'aud': self.audience_url,           # Salesforce login URL
            'exp': now + timedelta(minutes=3),  # Expiration (max 5 minutes)
            'iat': now                          # Issued at
        }
        
        try:
            # Create JWT token
            jwt_token = jwt.encode(
                payload, 
                private_key, 
                algorithm='RS256'
            )
            return jwt_token
        except Exception as e:
            print(f"✗ Error creating JWT assertion: {e}")
            return None
    
    def authenticate(self):
        """Authenticate with Salesforce using JWT Bearer flow"""
        print("Authenticating with Salesforce using JWT Bearer flow...")
        
        # Create JWT assertion
        jwt_assertion = self.create_jwt_assertion()
        if not jwt_assertion:
            return False
        
        # Determine token endpoint
        token_url = f"{self.audience_url}/services/oauth2/token"
        
        data = {
            'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion': jwt_assertion
        }
        
        try:
            response = self.session.post(token_url, data=data)
            response.raise_for_status()
            
            auth_data = response.json()
            self.access_token = auth_data['access_token']
            self.instance_url = auth_data['instance_url']
            
            print(f"✓ Successfully authenticated with {self.instance_url}")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"✗ Authentication failed: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Error details: {e.response.text}")
            return False
    
    def get_report_metadata(self, report_id):
        """Get report metadata to understand its structure"""
        print(f"Fetching report metadata for {report_id}...")
        
        url = f"{self.instance_url}/services/data/v58.0/analytics/reports/{report_id}"
        headers = {
            'Authorization': f'Bearer {self.access_token}',
            'Content-Type': 'application/json'
        }
        
        try:
            response = self.session.get(url, headers=headers)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"✗ Failed to get report metadata: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Error details: {e.response.text}")
            return None
    
    def run_report_async(self, report_id):
        """Run report asynchronously and return instance ID"""
        print(f"Running report {report_id} asynchronously...")
        
        url = f"{self.instance_url}/services/data/v58.0/analytics/reports/{report_id}/instances"
        headers = {
            'Authorization': f'Bearer {self.access_token}',
            'Content-Type': 'application/json'
        }
        
        # Request details-only format
        data = {
            'reportMetadata': {
                'reportFormat': 'TABULAR'
            }
        }
        
        try:
            response = self.session.post(url, headers=headers, json=data)
            response.raise_for_status()
            
            result = response.json()
            instance_id = result['id']
            print(f"✓ Report instance created: {instance_id}")
            return instance_id
            
        except requests.exceptions.RequestException as e:
            print(f"✗ Failed to run report: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Error details: {e.response.text}")
            return None
    
    def wait_for_report_completion(self, report_id, instance_id, max_wait=300):
        """Wait for report to complete processing"""
        print("Waiting for report to complete...")
        
        url = f"{self.instance_url}/services/data/v58.0/analytics/reports/{report_id}/instances/{instance_id}"
        headers = {
            'Authorization': f'Bearer {self.access_token}',
            'Content-Type': 'application/json'
        }
        
        start_time = time.time()
        while time.time() - start_time < max_wait:
            try:
                response = self.session.get(url, headers=headers)
                response.raise_for_status()
                
                result = response.json()
                status = result.get('status', 'Unknown')
                
                if status == 'Success':
                    print("✓ Report completed successfully")
                    return result
                elif status == 'Error':
                    print(f"✗ Report failed: {result.get('statusMessage', 'Unknown error')}")
                    return None
                else:
                    print(f"  Report status: {status}")
                    time.sleep(5)
                    
            except requests.exceptions.RequestException as e:
                print(f"✗ Error checking report status: {e}")
                return None
        
        print("✗ Report timed out")
        return None
    
    def convert_to_csv(self, report_data, output_file):
        """Convert report data to CSV format"""
        print(f"Converting report data to CSV: {output_file}")
        
        try:
            # Extract column information
            report_metadata = report_data.get('reportMetadata', {})
            detail_columns = report_metadata.get('detailColumns', [])
            
            # Get the actual data
            fact_map = report_data.get('factMap', {})
            
            # For tabular reports, data is usually in 'T!T' key
            rows_data = None
            for key, value in fact_map.items():
                if 'rows' in value:
                    rows_data = value['rows']
                    break
            
            if not rows_data:
                print("✗ No data rows found in report")
                return False
            
            # Write CSV file with UTF-8 encoding
            with open(output_file, 'w', encoding='utf-8', newline='') as csvfile:
                # Write header
                header_row = []
                extended_metadata = report_data.get('reportExtendedMetadata', {})
                detail_column_info = extended_metadata.get('detailColumnInfo', {})
                
                for col in detail_columns:
                    col_info = detail_column_info.get(col, {})
                    label = col_info.get('label', col)
                    header_row.append(f'"{label}"')
                
                csvfile.write(','.join(header_row) + '\n')
                
                # Write data rows
                for row in rows_data:
                    data_cells = row.get('dataCells', [])
                    csv_row = []
                    
                    for cell in data_cells:
                        value = cell.get('value', '')
                        # Handle None values and escape quotes
                        if value is None:
                            value = ''
                        else:
                            value = str(value).replace('"', '""')  # Escape quotes
                        csv_row.append(f'"{value}"')
                    
                    csvfile.write(','.join(csv_row) + '\n')
            
            print(f"✓ Successfully exported {len(rows_data)} rows to {output_file}")
            return True
            
        except Exception as e:
            print(f"✗ Error converting to CSV: {e}")
            return False
    
    def export_report(self, report_id, output_file=None):
        """Main method to export report to CSV"""
        if not self.authenticate():
            return False
        
        # Set default output filename if not provided
        if not output_file:
            output_file = f"salesforce_report_{report_id}_{int(time.time())}.csv"
        
        # Get report metadata first
        metadata = self.get_report_metadata(report_id)
        if not metadata:
            return False
        
        print(f"Report Name: {metadata.get('reportMetadata', {}).get('name', 'Unknown')}")
        
        # Run report asynchronously
        instance_id = self.run_report_async(report_id)
        if not instance_id:
            return False
        
        # Wait for completion
        report_data = self.wait_for_report_completion(report_id, instance_id)
        if not report_data:
            return False
        
        # Convert to CSV
        return self.convert_to_csv(report_data, output_file)

def create_sample_env():
    """Create a sample .env file with placeholder values"""
    env_content = """# Salesforce JWT Authentication Configuration
# Copy this file to .env and fill in your actual values

# Your Salesforce username (email)
SF_USERNAME=your.email@company.com

# Consumer Key from your Connected App
SF_CONSUMER_KEY=your_consumer_key_here

# Path to your private key file (generated with --generate-keys)
SF_PRIVATE_KEY_FILE=salesforce_jwt_private.key

# Salesforce login URL (use https://test.salesforce.com for sandbox)
SF_AUDIENCE_URL=https://login.salesforce.com

# Optional: Default output directory for CSV files
# SF_OUTPUT_DIR=./exports/
"""
    
    env_file = '.env'
    if os.path.exists(env_file):
        print(f"⚠️  {env_file} already exists. Create backup before overwriting.")
        response = input("Overwrite existing .env file? (y/N): ")
        if response.lower() != 'y':
            print("Cancelled.")
            return
    
    with open(env_file, 'w') as f:
        f.write(env_content)
    
    print(f"✓ Created sample .env file")
    print(f"📝 Edit {env_file} with your actual Salesforce credentials")
    print(f"\nNext steps:")
    print(f"1. Generate keys: python sf_export.py --generate-keys")
    print(f"2. Edit .env with your values")
    print(f"3. Run export: python csv.py --report-id YOUR_REPORT_ID")

def generate_key_pair_and_cert(key_name="salesforce_jwt", cert_subject="CN=Salesforce JWT"):
    """Generate RSA key pair and self-signed X.509 certificate"""
    print(f"Generating RSA key pair and X.509 certificate...")
    
    # Generate private key
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    
    # Create a self-signed certificate
    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COMMON_NAME, cert_subject),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, "Salesforce JWT Integration"),
        x509.NameAttribute(NameOID.ORGANIZATIONAL_UNIT_NAME, "API Access"),
    ])
    
    # Certificate valid for 10 years
    cert = x509.CertificateBuilder().subject_name(
        subject
    ).issuer_name(
        issuer
    ).public_key(
        private_key.public_key()
    ).serial_number(
        x509.random_serial_number()
    ).not_valid_before(
        datetime.utcnow()
    ).not_valid_after(
        datetime.utcnow() + timedelta(days=3650)  # 10 years
    ).add_extension(
        x509.SubjectAlternativeName([
            x509.DNSName("localhost"),
        ]),
        critical=False,
    ).add_extension(
        x509.BasicConstraints(ca=False, path_length=None), 
        critical=True,
    ).add_extension(
        x509.KeyUsage(
            key_encipherment=True,
            digital_signature=True,
            key_agreement=False,
            key_cert_sign=False,
            crl_sign=False,
            content_commitment=False,
            data_encipherment=False,
            encipher_only=False,
            decipher_only=False
        ),
        critical=True,
    ).sign(private_key, hashes.SHA256(), default_backend())
    
    # Serialize private key
    private_pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )
    
    # Serialize certificate
    cert_pem = cert.public_bytes(serialization.Encoding.PEM)
    
    # Write files
    private_key_file = f"{key_name}_private.key"
    cert_file = f"{key_name}_certificate.crt"
    
    with open(private_key_file, 'wb') as f:
        f.write(private_pem)
    
    with open(cert_file, 'wb') as f:
        f.write(cert_pem)
    
    print(f"✓ Private key saved to: {private_key_file}")
    print(f"✓ X.509 Certificate saved to: {cert_file}")
    print(f"\n📋 Next steps:")
    print(f"1. Upload {cert_file} to your Salesforce Connected App:")
    print(f"   - Go to Setup → App Manager → Your Connected App → Edit")
    print(f"   - In 'Digital Certificates' section, click 'Choose File'")
    print(f"   - Upload the {cert_file} file")
    print(f"   - Save the Connected App")
    print(f"2. Update your .env file to use {private_key_file}")
    print(f"3. Test with: python sf_export.py --report-id YOUR_REPORT_ID")
    print(f"\n🔐 Certificate Details:")
    print(f"   Subject: {cert_subject}")
    print(f"   Valid for: 10 years from today")
    print(f"   Key Size: 2048 bits RSA")
    
    return private_key_file, cert_file

def main():
    # Load environment variables first
    load_dotenv()
    
    parser = argparse.ArgumentParser(description='Export Salesforce report as CSV using JWT Bearer authentication')
    parser.add_argument('--report-id', help='Salesforce Report ID (e.g., 00O0c000009XxxX)')
    parser.add_argument('--username', help='Salesforce username (or set SF_USERNAME in .env)')
    parser.add_argument('--consumer-key', help='Connected App Consumer Key (or set SF_CONSUMER_KEY in .env)')
    parser.add_argument('--private-key-file', help='Path to private key file (or set SF_PRIVATE_KEY_FILE in .env)')
    parser.add_argument('--audience-url', help='Salesforce login URL (or set SF_AUDIENCE_URL in .env, defaults to https://login.salesforce.com)')
    parser.add_argument('--output', '-o', help='Output CSV filename (optional)')
    parser.add_argument('--generate-keys', action='store_true', 
                       help='Generate RSA key pair and X.509 certificate for JWT authentication')
    parser.add_argument('--create-env', action='store_true',
                       help='Create a sample .env file')
    parser.add_argument('--cert-subject', default='CN=Salesforce JWT',
                       help='Certificate subject (default: CN=Salesforce JWT)')
    
    args = parser.parse_args()
    
    # Create sample .env file if requested
    if args.create_env:
        create_sample_env()
        return
    
    # Generate keys and certificate if requested
    if args.generate_keys:
        generate_key_pair_and_cert(cert_subject=args.cert_subject)
        return
    
    # Require report-id for actual export
    if not args.report_id:
        print("✗ --report-id is required for export operations")
        print("Use --help to see all available options")
        sys.exit(1)
    
    try:
        # Create exporter instance (will validate parameters)
        exporter = SalesforceJWTReportExporter(
            username=args.username,
            consumer_key=args.consumer_key,
            private_key_path=args.private_key_file,
            audience_url=args.audience_url
        )
        
        # Validate private key file exists
        if not os.path.exists(exporter.private_key_path):
            print(f"✗ Private key file not found: {exporter.private_key_path}")
            print("Use --generate-keys to create a new key pair and certificate")
            sys.exit(1)
        
        print(f"Using configuration:")
        print(f"  Username: {exporter.username}")
        print(f"  Private Key: {exporter.private_key_path}")
        print(f"  Audience URL: {exporter.audience_url}")
        print(f"  Consumer Key: {exporter.consumer_key[:8]}...")
        
        # Export the report
        success = exporter.export_report(args.report_id, args.output)
        
        if success:
            print("\n🎉 Export completed successfully!")
            sys.exit(0)
        else:
            print("\n❌ Export failed!")
            sys.exit(1)
            
    except ValueError as e:
        print(f"✗ Configuration error: {e}")
        print("\nOptions:")
        print("1. Create .env file: python sf_export.py --create-env")
        print("2. Use command line arguments")
        print("3. Generate keys: python sf_export.py --generate-keys")
        sys.exit(1)

if __name__ == "__main__":
    main()