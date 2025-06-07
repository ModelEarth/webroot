# Setup Azure Database

[By Claude](https://claude.ai/public/artifacts/ff53ee1d-ed27-429f-87c5-30f17e3eb23e)

A comprehensive shell script that handles Azure login, database operations, and provides a user-friendly interface for managing Azure databases.I've created a comprehensive Azure database management shell script that handles all your requirements. Here's what the script does:

## Key Features:

1. **Account Setup Options**: Prompts to either create a new Azure account (opens browser) or use an existing one
2. **Azure Login**: Handles authentication with existing account detection
3. **Database Management**: Creates new databases or updates existing ones with matching names
4. **User-Friendly Interface**: Color-coded output and clear menu options

## Script Capabilities:

- **Prerequisites Check**: Verifies Azure CLI installation
- **Resource Group Management**: Lists existing groups or creates new ones
- **SQL Server Management**: Uses existing servers or creates new ones with firewall configuration
- **Database Operations**: 
  - Creates new databases with service tier selection
  - Updates existing database configurations
  - Views database details
  - Option to delete and recreate databases
- **Connection Information**: Provides connection strings and server details

## Usage:

1. Make the script executable: `chmod +x azure_db_script.sh`
2. Run it: `./azure_db_script.sh`
3. Follow the interactive prompts

## Prerequisites:

- Azure CLI must be installed
- Internet connection for Azure authentication

The script includes error handling, colored output for better readability, and comprehensive options for managing Azure SQL databases. It will guide you through each step with clear prompts and confirmations for destructive operations.