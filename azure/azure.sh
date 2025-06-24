#!/bin/bash

# Azure Database Management Script with Configuration File
# This script helps manage Azure SQL databases with user-friendly prompts
# Configuration is stored in azure-db-config.json

set -e  # Exit on any error

# Configuration file path
CONFIG_FILE="azure-db-config.json"
CONFIG_TEMPLATE="azure-db-config.template.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        print_message $RED "jq is not installed. Please install it first:"
        print_message $YELLOW "Ubuntu/Debian: sudo apt-get install jq"
        print_message $YELLOW "macOS: brew install jq"
        print_message $YELLOW "Or visit: https://stedolan.github.io/jq/download/"
        exit 1
    fi
}

# Detect platform
platform="$(uname)"
case "$platform" in
  Darwin*)
    os="macos"
    ;;
  Linux*)
    os="linux"
    ;;
  CYGWIN*|MINGW*|MSYS*)
    os="windows"
    ;;
  FreeBSD*|OpenBSD*|NetBSD*)
    os="bsd"  # Group BSD variants together
    ;;
  SunOS*)
    os="solaris"  # Keep separate due to significant differences
    ;;
  AIX*)
    os="aix"  # Keep separate due to significant differences
    ;;
  *)
    echo "Warning: Unrecognized platform: $platform" >&2
    echo "Assuming Unix-like system, using linux defaults" >&2
    os="linux"  # Safe fallback for most Unix-like systems
    ;;
esac

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_message $RED "Azure CLI is not installed. Please install it first:"
        print_message $YELLOW "Visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        if [[ "$os" == "macos" ]]; then
            print_message $BLUE "Or run: brew update && brew install azure-cli"
        fi
        exit 1
    fi
}

# Function to create configuration template
create_config_template() {
    cat > "$CONFIG_TEMPLATE" << 'EOF'
{
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
  "database": {
    "name": "",
    "service_tier": "Basic",
    "compute_size": "Basic"
  },
  "connection": {
    "server_fqdn": "",
    "connection_string_template": "Server=tcp:{server_fqdn},1433;Initial Catalog={database_name};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
EOF
    print_message $GREEN "Configuration template created: $CONFIG_TEMPLATE"
    #print_message $YELLOW "You can either copy this to $CONFIG_FILE and fill in your values, or enter here."
}

# Function to load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        # Configuration file not found, provide options for creating.
        
        if [[ ! -f "$CONFIG_TEMPLATE" ]]; then
            create_config_template
        fi
        
        print_message $BLUE "Would you like to:"
        echo "1) Create a new configuration interactively"
        echo "2) Exit and manually copy to azure-db-config.json and edit"
        
        read -p "Choose option (1-2): " config_choice
        
        case $config_choice in
            1)
                create_config_interactively
                ;;
            2)
                print_message $YELLOW "Please copy $CONFIG_TEMPLATE to $CONFIG_FILE and fill in your values"
                exit 0
                ;;
            *)
                print_message $RED "Invalid option"
                exit 1
                ;;
        esac
    fi
    
    # Validate JSON
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        print_message $RED "Invalid JSON in configuration file: $CONFIG_FILE"
        exit 1
    fi
    
    print_message $GREEN "Configuration loaded from: $CONFIG_FILE"
}

# Function to create configuration interactively
create_config_interactively() {
    print_message $BLUE "=== Interactive Configuration Setup ==="
    
    echo
    read -p "Enter Azure resource group name: " rg_name
    read -p "Enter Azure location (e.g., eastus, westus2) [eastus]: " azure_location
    azure_location=${azure_location:-eastus}
    
    echo
    read -p "Enter SQL server name: " server_name
    read -p "Enter SQL admin username: " admin_user
    read -s -p "Enter SQL admin password: " admin_password
    echo
    read -p "Enter SQL server location [eastus]: " sql_location
    sql_location=${sql_location:-eastus}
    
    echo
    read -p "Enter database name: " db_name
    
    echo "Select service tier:"
    echo "1) Basic (for development/testing)"
    echo "2) Standard (for production workloads)"
    echo "3) Premium (for mission-critical workloads)"
    
    read -p "Choose service tier (1-3): " tier_choice
    
    case $tier_choice in
        1)
            service_tier="Basic"
            compute_size="Basic"
            ;;
        2)
            service_tier="Standard"
            read -p "Enter compute size (S0, S1, S2, S3) [S0]: " compute_size
            compute_size=${compute_size:-S0}
            ;;
        3)
            service_tier="Premium"
            read -p "Enter compute size (P1, P2, P4, P6, P11, P15) [P1]: " compute_size
            compute_size=${compute_size:-P1}
            ;;
        *)
            print_message $YELLOW "Invalid choice, using Basic tier"
            service_tier="Basic"
            compute_size="Basic"
            ;;
    esac
    
    # Create configuration file
    cat > "$CONFIG_FILE" << EOF
{
  "azure": {
    "subscription_id": "",
    "resource_group": "$rg_name",
    "location": "$azure_location"
  },
  "sql_server": {
    "name": "$server_name",
    "admin_user": "$admin_user",
    "admin_password": "$admin_password",
    "location": "$sql_location"
  },
  "database": {
    "name": "$db_name",
    "service_tier": "$service_tier",
    "compute_size": "$compute_size"
  },
  "connection": {
    "server_fqdn": "$server_name.database.windows.net",
    "connection_string_template": "Server=tcp:$server_name.database.windows.net,1433;Initial Catalog=$db_name;Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
EOF
    
    print_message $GREEN "Configuration file created: $CONFIG_FILE"
}

# Function to get configuration value
get_config_value() {
    local key=$1
    jq -r "$key" "$CONFIG_FILE"
}

# Function to update configuration value
update_config_value() {
    local key=$1
    local value=$2
    local temp_file=$(mktemp)
    
    jq "$key = \"$value\"" "$CONFIG_FILE" > "$temp_file" && mv "$temp_file" "$CONFIG_FILE"
}

# Function to display menu
show_menu() {
    echo
    print_message $BLUE "=== Azure Database Management ==="
    echo "1) Deploy infrastructure from config"
    echo "2) Update existing resources"
    echo "3) View current configuration"
    echo "4) Update configuration"
    echo "5) Delete resources"
    echo "6) Exit"
    echo
}

# Function to handle Azure login
azure_login() {
    print_message $YELLOW "Logging into Azure..."
    
    # Check if already logged in
    if az account show &>/dev/null; then
        current_account=$(az account show --query "name" -o tsv)
        print_message $GREEN "Already logged in to: $current_account"
        
        read -p "Do you want to use this account? (y/n): " use_current
        if [[ $use_current != "y" && $use_current != "Y" ]]; then
            az logout
            az login
        fi
    else
        az login
    fi
    
    # Update subscription ID in config if empty
    subscription_id=$(az account show --query "id" -o tsv)
    config_sub_id=$(get_config_value '.azure.subscription_id')
    
    if [[ -z "$config_sub_id" || "$config_sub_id" == "null" ]]; then
        update_config_value '.azure.subscription_id' "$subscription_id"
        print_message $GREEN "Updated subscription ID in configuration"
    fi
    
    # Display current subscription
    subscription=$(az account show --query "name" -o tsv)
    print_message $GREEN "Using subscription: $subscription ($subscription_id)"
}

# Function to ensure resource group exists
ensure_resource_group() {
    local rg_name=$(get_config_value '.azure.resource_group')
    local location=$(get_config_value '.azure.location')
    
    print_message $YELLOW "Checking resource group: $rg_name"
    
    if ! az group show --name "$rg_name" &>/dev/null; then
        print_message $YELLOW "Creating resource group: $rg_name"
        az group create --name "$rg_name" --location "$location"
        print_message $GREEN "Resource group created successfully!"
    else
        print_message $GREEN "Resource group already exists: $rg_name"
    fi
}

# Function to ensure SQL server exists
ensure_sql_server() {
    local server_name=$(get_config_value '.sql_server.name')
    local rg_name=$(get_config_value '.azure.resource_group')
    local admin_user=$(get_config_value '.sql_server.admin_user')
    local admin_password=$(get_config_value '.sql_server.admin_password')
    local location=$(get_config_value '.sql_server.location')
    
    print_message $YELLOW "Checking SQL server: $server_name"
    
    if ! az sql server show --name "$server_name" --resource-group "$rg_name" &>/dev/null; then
        print_message $YELLOW "Creating SQL server: $server_name"
        az sql server create \
            --name "$server_name" \
            --resource-group "$rg_name" \
            --location "$location" \
            --admin-user "$admin_user" \
            --admin-password "$admin_password"
        
        print_message $GREEN "SQL server created successfully!"
        
        # Configure firewall to allow Azure services
        print_message $YELLOW "Configuring firewall rules..."
        az sql server firewall-rule create \
            --resource-group "$rg_name" \
            --server "$server_name" \
            --name "AllowAzureServices" \
            --start-ip-address 0.0.0.0 \
            --end-ip-address 0.0.0.0
    else
        print_message $GREEN "SQL server already exists: $server_name"
    fi
}

# Function to ensure database exists
ensure_database() {
    local server_name=$(get_config_value '.sql_server.name')
    local rg_name=$(get_config_value '.azure.resource_group')
    local db_name=$(get_config_value '.database.name')
    local compute_size=$(get_config_value '.database.compute_size')
    
    print_message $YELLOW "Checking database: $db_name"
    
    if ! az sql db show --name "$db_name" --server "$server_name" --resource-group "$rg_name" &>/dev/null; then
        print_message $YELLOW "Creating database: $db_name"
        az sql db create \
            --name "$db_name" \
            --server "$server_name" \
            --resource-group "$rg_name" \
            --service-objective "$compute_size"
        
        print_message $GREEN "Database created successfully!"
    else
        print_message $GREEN "Database already exists: $db_name"
    fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
    print_message $BLUE "=== Deploying Infrastructure ==="
    
    ensure_resource_group
    ensure_sql_server
    ensure_database
    
    print_message $GREEN "Infrastructure deployment completed!"
    display_connection_info
}

# Function to display connection information
display_connection_info() {
    echo
    print_message $BLUE "=== Connection Information ==="
    
    local server_fqdn=$(get_config_value '.connection.server_fqdn')
    local db_name=$(get_config_value '.database.name')
    local conn_template=$(get_config_value '.connection.connection_string_template')
    
    print_message $YELLOW "Server: $server_fqdn"
    print_message $YELLOW "Database: $db_name"
    print_message $YELLOW "Connection String Template:"
    echo "$conn_template"
}

# Function to view current configuration
view_configuration() {
    print_message $BLUE "=== Current Configuration ==="
    
    # Display config without sensitive information
    jq 'del(.sql_server.admin_password)' "$CONFIG_FILE"
}

# Function to update configuration menu
update_configuration_menu() {
    echo
    print_message $BLUE "=== Update Configuration ==="
    echo "1) Update resource group"
    echo "2) Update SQL server settings"
    echo "3) Update database settings"
    echo "4) Back to main menu"
    
    read -p "Choose option (1-4): " update_choice
    
    case $update_choice in
        1)
            read -p "Enter new resource group name: " new_rg
            read -p "Enter new location: " new_location
            update_config_value '.azure.resource_group' "$new_rg"
            update_config_value '.azure.location' "$new_location"
            print_message $GREEN "Resource group configuration updated"
            ;;
        2)
            read -p "Enter new SQL server name: " new_server
            read -p "Enter new admin username: " new_admin
            read -s -p "Enter new admin password: " new_password
            echo
            update_config_value '.sql_server.name' "$new_server"
            update_config_value '.sql_server.admin_user' "$new_admin"
            update_config_value '.sql_server.admin_password' "$new_password"
            update_config_value '.connection.server_fqdn' "$new_server.database.windows.net"
            print_message $GREEN "SQL server configuration updated"
            ;;
        3)
            read -p "Enter new database name: " new_db
            read -p "Enter new service tier (Basic/Standard/Premium): " new_tier
            read -p "Enter new compute size: " new_compute
            update_config_value '.database.name' "$new_db"
            update_config_value '.database.service_tier' "$new_tier"
            update_config_value '.database.compute_size' "$new_compute"
            print_message $GREEN "Database configuration updated"
            ;;
        4)
            return
            ;;
        *)
            print_message $RED "Invalid option"
            ;;
    esac
}

# Function to delete resources
delete_resources() {
    print_message $RED "=== Delete Resources ==="
    print_message $RED "WARNING: This will delete all resources!"
    
    echo "What would you like to delete?"
    echo "1) Database only"
    echo "2) SQL Server and Database"
    echo "3) Entire Resource Group"
    echo "4) Cancel"
    
    read -p "Choose option (1-4): " delete_choice
    
    local server_name=$(get_config_value '.sql_server.name')
    local rg_name=$(get_config_value '.azure.resource_group')
    local db_name=$(get_config_value '.database.name')
    
    case $delete_choice in
        1)
            read -p "Are you sure you want to delete database '$db_name'? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                az sql db delete --name "$db_name" --server "$server_name" --resource-group "$rg_name" --yes
                print_message $GREEN "Database deleted successfully"
            fi
            ;;
        2)
            read -p "Are you sure you want to delete SQL server '$server_name' and all its databases? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                az sql server delete --name "$server_name" --resource-group "$rg_name" --yes
                print_message $GREEN "SQL server deleted successfully"
            fi
            ;;
        3)
            read -p "Are you sure you want to delete resource group '$rg_name' and ALL its resources? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                az group delete --name "$rg_name" --yes
                print_message $GREEN "Resource group deleted successfully"
            fi
            ;;
        4)
            print_message $YELLOW "Deletion cancelled"
            ;;
        *)
            print_message $RED "Invalid option"
            ;;
    esac
}

# Main script execution
main() {
    print_message $GREEN "Azure Database Management Script"
    print_message $YELLOW "===============================\n"
    
    # Check prerequisites
    check_azure_cli
    check_jq
    
    # Load configuration
    load_config
    
    # Azure login
    azure_login
    
    # Main menu loop
    while true; do
        show_menu
        read -p "Please select an option (1-6): " choice
        
        case $choice in
            1)
                deploy_infrastructure
                ;;
            2)
                print_message $YELLOW "Updating existing resources..."
                deploy_infrastructure
                ;;
            3)
                view_configuration
                ;;
            4)
                update_configuration_menu
                ;;
            5)
                delete_resources
                ;;
            6)
                print_message $YELLOW "Goodbye!"
                exit 0
                ;;
            *)
                print_message $RED "Invalid option. Please choose 1-6."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"