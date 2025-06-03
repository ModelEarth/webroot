[Profile Tools](../../../)

# Partner Tools integrated with Salesforce

Steps for creating a Salesforce-integrated front-end for your partner tools.

Under development for use with the [SuiteCRM installer for Azure](../../../crm)

## Prerequisites & Permissions Setup

Add your parameters in the .env file in the current folder.

### A. Create a Connected App in Salesforce

First, create a Connected App to get your API credentials:

1.) Go to **Setup** → **App Manager** → **New Connected App**

2.) Fill in basic information. "PartnerIntegration" can be renamed, and can differ for each:
   - Connected App Name: "PartnerIntegration"
   - API Name: "PartnerIntegration"
   - Contact Email: your email

3.) Enable OAuth Settings:

   - Callback URL: `https://login.salesforce.com` (A placeholder which is not actually used.)

4.) ☑️ Enable OAuth Settings
5.) ☑️ Use digital signatures and 📁 [Upload your public key file]

To create the public key file to upload for the digital signature, run with the report-id found in the link to your report. Replace 00O0c000XXXXXXX:

    python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    pip install requests python-dotenv jwt
    
    python csv.py --generate-keys --report-id 00O0c000XXXXXXX


Salesforce requires a certificate in X.509 format (.crt or .pem), not just a raw public key (.key).

6.) Selected OAuth Scopes:
- Access the identity URL service (id, profile, email, address, phone)
- Manage user data via APIs (api)  
- Perform requests at any time (refresh_token, offline_access)

Optional scopes:
- Manage user data via Web browsers (web) - Only needed for web apps
- If your reports use advanced Analytics features, you might also add:
Access Analytics REST API resources (wave_api) - For Einstein Analytics/Tableau CRM reports


7.) Save and note down the **Consumer Key** and **Consumer Secret**

### B. Get Your Security Token
1. Go to **Personal Settings** → **Reset My Security Token**
2. Check your email for the security token

### C. Install Required Python Packages in a virtual env
pip --upgrade is optional (remove if it is slow.)
```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install requests python-dotenv jwt
```

## Usage Instructions

### 1. Update parameters in your .env file.

### 2. Or run the script with your credentials:

These need to be modified to match the .env file:

```bash
python csv.py \
  --report-id 00O0c000XXXXXXX \
  --username your.email@company.com \
  --security-token YourSecurityToken \
  --consumer-key YourConsumerKey \
  --consumer-secret YourConsumerSecret \
  --output directory.csv
```

### 3. Parameter Explanations:

- `--report-id`: The report ID from your URL (00O0c000XXXXXXX)
- `--username`: Your Salesforce login email
- `--security-token`: Security token from email (reset if needed)
- `--consumer-key`: From your Connected App
- `--consumer-secret`: From your Connected App
- `--output`: Optional output filename (defaults to timestamped name)

### 4. For Enhanced Security (Recommended):

Create a `.env` file in the same directory:

```bash
SF_USERNAME=your.email@company.com
SF_PASSWORD=YourPassword
SF_SECURITY_TOKEN=YourSecurityToken
SF_CONSUMER_KEY=YourConsumerKey
SF_CONSUMER_SECRET=YourConsumerSecret
```

Then modify the script to read from environment variables instead of command line arguments.

## Troubleshooting

**Authentication Issues:**
- Ensure your IP is trusted in Salesforce (Setup → Network Access)
- Verify your security token is current
- Check that your Connected App has correct OAuth scopes

**Report Access Issues:**
- Ensure your user has permission to view the report
- Verify the report ID is correct
- Check that the report is not in a private folder

**API Limits:**
- Salesforce has daily API call limits
- The script uses async reporting API which has separate limits

The script will output a UTF-8 encoded CSV file with all report details, including proper header names and escaped values for Excel compatibility.



Upon completion, you can delete your local venv folders.