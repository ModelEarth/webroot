# Azure Database Management Script

A user-friendly bash script for managing Azure SQL databases with configuration file support.

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

## Quick Start

1. **Make the script executable**:
   ```bash
   chmod +x azure.sh
   ```

2. **Run the script**:
   ```bash
   ./azure.sh
   ```

3. **First run setup**:
   - The script will detect that no configuration exists
   - Choose option 1 to create configuration interactively
   - Or choose option 2 to create manually from template

## Configuration File

The script uses `azure-db-config.json` for all settings:

```json
{
  "azure": {
    "subscription_id": "your-subscription-id",
    "resource_group": "my-resource-group",
    "location": "eastus"
  },
  "sql_server": {
    "name": "my-sql-server",
    "admin_user": "sqladmin",
    "admin_password": "YourSecurePassword123!",
    "location": "eastus"
  },
  "database": {
    "name": "my-database",
    "service_tier": "Basic",
    "compute_size": "Basic"
  },
  "connection": {
    "server_fqdn": "my-sql-server.database.windows.net",
    "connection_string_template": "Server=tcp:my-sql-server.database.windows.net,1433;Initial Catalog=my-database;Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
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
your-project/
├── azure.sh          # Main script
├── azure-db-config.json           # Your configuration (not in Git)
├── azure-db-config.template.json  # Template file (safe to commit)
├── .gitignore                      # Excludes config files
└── README.md                       # This file
```

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

## Error Handling

The script includes comprehensive error handling:
- Validates Azure CLI installation
- Validates jq installation
- Validates JSON configuration syntax
- Checks Azure login status
- Verifies resource existence before operations

## Connection String

After deployment, the script provides:
- Server FQDN
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

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This script is provided as-is for educational and development purposes.