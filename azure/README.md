# Azure Database Management Script

A user-friendly bash script for managing Azure SQL and PostgreSQL databases with configuration file support.

### 1. Initial Setup
```bash
chmod +x azure.sh
./azure.sh
```

### 2. Interactive Configuration
The script will guide you through:
- Database type selection (SQL or PostgreSQL)
- Azure resource configuration
- Server and database settings
- Schema URL configuration
- Auto-apply preferences

### 3. Menu Options

1. **Deploy infrastructure from config**: Creates all resources based on configuration
2. **Update existing resources**: Updates or ensures resources exist
3. **View current configuration**: Displays current settings (passwords hidden)
4. **Update configuration**: Modify settings interactively
5. **Apply schema from URL**: Download and apply schema from GitHub
6. **Delete resources**: Remove databases, servers, or entire resource groups
7. **Exit**: Close the application

## Schema Management

### GitHub Schema URLs
The script supports GitHub raw URLs for schema files:
```
https://raw.githubusercontent.com/username/repository/branch/path/to/schema.sql
```

### Schema Application Process
1. **Download**: SuiteCRM Schema is provided to Azure from the specified URL
2. **Preview**: First 20 lines are displayed for confirmation
3. **Confirmation**: User confirms before application
4. **Application**: Schema is applied using appropriate database client

### Auto-Apply Feature
- Set `"auto_apply": true` in configuration
- Schema will be automatically applied after database creation
- Useful for CI/CD pipelines and automated deployments

## Database Type Comparison

| Feature | Azure SQL Database | Azure PostgreSQL |
|---------|-------------------|------------------|
| **Pricing Tiers** | Basic, Standard, Premium | Basic, General Purpose, Memory Optimized |
| **Compute Sizes** | S0-S12, P1-P15 | B_Gen5_1/2, GP_Gen5_2/4/8/16/32 |
| **Connection Port** | 1433 | 5432 |
| **Client Tool** | sqlcmd | psql |
| **SSL** | Encrypt=True | sslmode=require |


## Features

- **Configuration-based**: Store all settings in a JSON configuration file
- **Interactive setup**: Create configurations interactively or manually
- **Secure**: Configuration files are excluded from version control
- **Comprehensive**: Deploy, update, and delete Azure resources
- **Connection info**: Automatically generates connection strings

## Prerequisites

- **Azure CLI**: [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- **jq**: JSON processor for configuration management
  - Ubuntu/Debian: `sudo apt-get install jq`
  - macOS: `brew install jq`
  - Windows: Download from [jq website](https://stedolan.github.io/jq/download/)


## Configuration Structure

When no configuration file exists, you'll be guided to create one manually or interactively.

The script uses a JSON configuration file (`azure-db-config.json`) with the following structure:

```json
{
  "database_type": "sql|postgresql",
  "azure": {
    "subscription_id": "",
    "resource_group": "",
    "location": "eastus"
  },
  "sql_server": {
    "name": "",
    "admin_user": "",
    "admin_password": "",
    "location": "eastus"
  },
  "postgresql_server": {
    "name": "",
    "admin_user": "",
    "admin_password": "",
    "location": "eastus",
    "sku_name": "B_Gen5_1",
    "storage_mb": 5120,
    "version": "11"
  },
  "database": {
    "name": "",
    "service_tier": "Basic",
    "compute_size": "Basic"
  },
  "schema": {
    "url": "https://raw.githubusercontent.com/username/repo/main/schema.sql",
    "auto_apply": false,
    "local_file": ""
  },
  "connection": {
    "server_fqdn": "",
    "connection_string_template": "...",
    "postgresql_connection_string_template": "..."
  }
}
```


### Basic SQL Database Setup
```json
{
  "database_type": "sql",
  "azure": {
    "resource_group": "myapp-rg",
    "location": "eastus"
  },
  "sql_server": {
    "name": "myapp-sql-server",
    "admin_user": "sqladmin",
    "location": "eastus"
  },
  "database": {
    "name": "myapp-db",
    "service_tier": "Basic",
    "compute_size": "Basic"
  },
  "schema": {
    "url": "https://raw.githubusercontent.com/ModelEarth/profile/refs/heads/main/crm/sql/crm.sql",
    "auto_apply": true
  }
}
```

### PostgreSQL with Custom SKU
```json
{
  "database_type": "postgresql",
  "postgresql_server": {
    "name": "myapp-pg-server",
    "admin_user": "pgadmin",
    "sku_name": "GP_Gen5_2",
    "storage_mb": 10240,
    "version": "13"
  },
  "schema": {
    "url": "https://raw.githubusercontent.com/ModelEarth/profile/refs/heads/main/crm/sql/crm-postgres.sql",
    "auto_apply": false
  }
}
```


### Service Tiers and Compute Sizes

- **Basic**: `Basic` (for development/testing)
- **Standard**: `S0`, `S1`, `S2`, `S3` (for production workloads)
- **Premium**: `P1`, `P2`, `P4`, `P6`, `P11`, `P15` (for mission-critical workloads)

## Menu Options

1. **Deploy infrastructure from config**: Creates all resources based on configuration
2. **Update existing resources**: Updates resources with current configuration
3. **View current configuration**: Shows current settings (passwords hidden)
4. **Update configuration**: Modify settings interactively
5. **Delete resources**: Remove database, server, or entire resource group
6. **Exit**: Quit the script

## Security Features

- **Gitignore protection**: Configuration files are automatically excluded from Git
- **Password masking**: Passwords are hidden in configuration display
- **Secure input**: Password prompts use secure input (no echo)
- **Template separation**: Sensitive template is separate from actual config

## File Structure

```
profile/
├── .gitignore                         # Excludes config files
├── azure/
    ├── azure.sh                       # Main script
    ├── azure-db-config.json           # Your configuration (not in Git)
    ├── azure-db-config.template.json  # Template file (safe to commit)
    └── README.md                      # This file
```

<!--
## Usage Examples

### Initial Setup
```bash
./azure.sh
# Choose option 1 for interactive configuration
# Follow prompts to set up your Azure resources
```

### Deploy Infrastructure
```bash
./azure.sh
# Choose option 1 to deploy all resources from config
```

### Update Database Tier
```bash
./azure.sh
# Choose option 4 to update configuration
# Choose option 3 to update database settings
# Then option 1 to deploy changes
```
-->

## Error Handling

The script includes comprehensive error handling:
- Validates Azure CLI installation
- Validates jq installation
- Validates JSON configuration syntax
- Checks Azure login status
- Verifies resource existence before operations

## Connection String

After deployment, the script provides:
- Server Fully Qualified Domain Name (FQDN)
- Database name
- Complete connection string template

Replace `{username}` and `{password}` in the connection string with your actual credentials.

## Troubleshooting

### Common Issues

1. **jq not found**: Install jq using your package manager
2. **Azure CLI not found**: Install Azure CLI from Microsoft docs
3. **Invalid JSON**: Check configuration file syntax with `jq . azure-db-config.json`
4. **Login expired**: Run `az login` to re-authenticate

### Getting Help

- Check Azure CLI version: `az --version`
- Validate JSON: `jq . azure-db-config.json`
- Check Azure login: `az account show`


### 1. PostgreSQL Support
- **Multi-Database Support**: Choose between Azure SQL Database and Azure Database for PostgreSQL
- **PostgreSQL-Specific Configuration**: SKU selection, storage sizing, and version management
- **Dedicated Connection Strings**: Separate connection string templates for each database type
- **PostgreSQL Firewall Rules**: Automatic configuration of firewall rules for Azure services

### 2. Automated Schema Management
- **GitHub Integration**: Direct schema deployment from GitHub raw URLs
- **Auto-Apply Option**: Automatically apply schemas during infrastructure deployment
- **Manual Schema Application**: Dedicated menu option for applying schemas on-demand
- **Schema Preview**: View schema content before application for confirmation
- **Multi-Format Support**: Works with both SQL and PostgreSQL schema files

### 3. Enhanced Configuration System
- **Database Type Selection**: Interactive choice between SQL and PostgreSQL
- **PostgreSQL SKU Options**: 
  - B_Gen5_1 (Basic, 1 vCore)
  - B_Gen5_2 (Basic, 2 vCore) 
  - GP_Gen5_2 (General Purpose, 2 vCore)
  - GP_Gen5_4 (General Purpose, 4 vCore)
- **Storage Configuration**: Customizable storage size for PostgreSQL
- **Version Selection**: PostgreSQL version support (11, 12, 13, 14)


## Prerequisites

### Required Tools
- **Azure CLI**: For Azure resource management
- **jq**: For JSON configuration processing
- **curl**: For downloading schemas from GitHub
- **sqlcmd** (optional): For SQL Server schema application
- **psql** (optional): For PostgreSQL schema application


### Azure CLI Installation Commands

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install azure-cli jq curl postgresql-client mssql-tools
```

#### macOS
```bash
brew update
brew install azure-cli jq curl postgresql
```

#### Windows (WSL/Git Bash)
```bash
# Install Azure CLI from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# Install other tools through package managers or direct downloads
```


## Troubleshooting

### Common Issues

#### 1. jq not found
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

#### 2. Azure CLI not authenticated
```bash
az login
az account set --subscription "your-subscription-id"
```

#### 3. Schema application fails
- Ensure sqlcmd (SQL) or psql (PostgreSQL) is installed
- Check firewall rules allow your IP address
- Verify database credentials are correct

#### 4. Server name conflicts
- Server names must be globally unique across Azure
- Try adding random numbers or your organization prefix

---
<br>
Also see: [Script for installing SuiteCRM](../crm/)