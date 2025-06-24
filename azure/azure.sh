#!/bin/bash

# azure.sh Database Management Script with Configuration File
# This script helps manage Azure SQL and PostgreSQL databases with user-friendly prompts
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

# Function to check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        print_message $RED "curl is not installed. Please install it first:"
        print_message $YELLOW "Ubuntu/Debian: sudo apt-get install curl"
        print_message $YELLOW "macOS: curl is usually pre-installed"
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
  "database_type": "sql",
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
    "url": "https://raw.githubusercontent.com/ModelEarth/profile/refs/heads/main/crm/sql/crm-postgres.sql",
    "auto_apply": false,
    "local_file": ""
  },
  "connection": {
    "server_fqdn": "",
    "connection_string_template": "Server=tcp:{server_fqdn},1433;Initial Catalog={database_name};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    "postgresql_connection_string_template": "host={server_fqdn} port=5432 dbname={database_name} user={username}@{server_name} password={password} sslmode=require"
  }
}
EOF
    print_message $GREEN "Configuration template created: $CONFIG_TEMPLATE"
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
    print_message $YELLOW "Select database type:"
    echo "1) Azure SQL Database"
    echo "2) Azure Database for PostgreSQL"
    
    read -p "Choose database type (1-2): " db_type_choice
    
    case $db_type_choice in
        1)
            database_type="sql"
            ;;
        2)
            database_type="postgresql"
            ;;
        *)
            print_message $YELLOW "Invalid choice, using SQL Database"
            database_type="sql"
            ;;
    esac
    
    echo
    read -p "Enter Azure resource group name: " rg_name
    read -p "Enter Azure location (e.g., eastus, westus2) [eastus]: " azure_location
    azure_location=${azure_location:-eastus}
    
    echo
    if [[ "$database_type" == "sql" ]]; then
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
        
        server_fqdn="$server_name.database.windows.net"
        conn_template="Server=tcp:$server_name.database.windows.net,1433;Initial Catalog=$db_name;Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    else
        read -p "Enter PostgreSQL server name: " server_name
        read -p "Enter PostgreSQL admin username: " admin_user
        read -s -p "Enter PostgreSQL admin password: " admin_password
        echo
        read -p "Enter PostgreSQL server location [eastus]: " pg_location
        pg_location=${pg_location:-eastus}
        
        echo
        read -p "Enter database name: " db_name
        
        echo "Select SKU (pricing tier):"
        echo "1) B_Gen5_1 (Basic, 1 vCore)"
        echo "2) B_Gen5_2 (Basic, 2 vCore)"
        echo "3) GP_Gen5_2 (General Purpose, 2 vCore)"
        echo "4) GP_Gen5_4 (General Purpose, 4 vCore)"
        
        read -p "Choose SKU (1-4): " sku_choice
        
        case $sku_choice in
            1)
                sku_name="B_Gen5_1"
                ;;
            2)
                sku_name="B_Gen5_2"
                ;;
            3)
                sku_name="GP_Gen5_2"
                ;;
            4)
                sku_name="GP_Gen5_4"
                ;;
            *)
                print_message $YELLOW "Invalid choice, using B_Gen5_1"
                sku_name="B_Gen5_1"
                ;;
        esac
        
        read -p "Enter storage size in MB [5120]: " storage_mb
        storage_mb=${storage_mb:-5120}
        
        read -p "Enter PostgreSQL version (11, 12, 13, 14) [11]: " pg_version
        pg_version=${pg_version:-11}
        
        server_fqdn="$server_name.postgres.database.azure.com"
        conn_template="host=$server_name.postgres.database.azure.com port=5432 dbname=$db_name user=$admin_user@$server_name password={password} sslmode=require"
    fi
    
    echo
    read -p "Enter schema URL (GitHub raw URL) [https://raw.githubusercontent.com/]: " schema_url
    schema_url=${schema_url:-"https://raw.githubusercontent.com/ModelEarth/profile/refs/heads/main/crm/sql/crm-postgres.sql"}
    
    read -p "Auto-apply schema after database creation? (y/n) [n]: " auto_apply
    if [[ "$auto_apply" == "y" || "$auto_apply" == "Y" ]]; then
        auto_apply_bool=true
    else
        auto_apply_bool=false
    fi
    
    # Create configuration file
    if [[ "$database_type" == "sql" ]]; then
        cat > "$CONFIG_FILE" << EOF
{
  "database_type": "$database_type",
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
    "name": "$db_name",
    "service_tier": "$service_tier",
    "compute_size": "$compute_size"
  },
  "schema": {
    "url": "$schema_url",
    "auto_apply": $auto_apply_bool,
    "local_file": ""
  },
  "connection": {
    "server_fqdn": "$server_fqdn",
    "connection_string_template": "$conn_template",
    "postgresql_connection_string_template": "host={server_fqdn} port=5432 dbname={database_name} user={username}@{server_name} password={password} sslmode=require"
  }
}
EOF
    else
        cat > "$CONFIG_FILE" << EOF
{
  "database_type": "$database_type",
  "azure": {
    "subscription_id": "",
    "resource_group": "$rg_name",
    "location": "$azure_location"
  },
  "sql_server": {
    "name": "",
    "admin_user": "",
    "admin_password": "",
    "location": "eastus"
  },
  "postgresql_server": {
    "name": "$server_name",
    "admin_user": "$admin_user",
    "admin_password": "$admin_password",
    "location": "$pg_location",
    "sku_name": "$sku_name",
    "storage_mb": $storage_mb,
    "version": "$pg_version"
  },
  "database": {
    "name": "$db_name",
    "service_tier": "N/A",
    "compute_size": "N/A"
  },
  "schema": {
    "url": "$schema_url",
    "auto_apply": $auto_apply_bool,
    "local_file": ""
  },
  "connection": {
    "server_fqdn": "$server_fqdn",
    "connection_string_template": "Server=tcp:{server_fqdn},1433;Initial Catalog={database_name};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
    "postgresql_connection_string_template": "$conn_template"
  }
}
EOF
    fi
    
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
    echo "5) Apply schema from URL"
    echo "6) Delete resources"
    echo "7) Exit"
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

# Function to ensure PostgreSQL server exists
ensure_postgresql_server() {
    local server_name=$(get_config_value '.postgresql_server.name')
    local rg_name=$(get_config_value '.azure.resource_group')
    local admin_user=$(get_config_value '.postgresql_server.admin_user')
    local admin_password=$(get_config_value '.postgresql_server.admin_password')
    local location=$(get_config_value '.postgresql_server.location')
    local sku_name=$(get_config_value '.postgresql_server.sku_name')
    local storage_mb=$(get_config_value '.postgresql_server.storage_mb')
    local version=$(get_config_value '.postgresql_server.version')
    
    print_message $YELLOW "Checking PostgreSQL server: $server_name"
    
    if ! az postgres server show --name "$server_name" --resource-group "$rg_name" &>/dev/null; then
        print_message $YELLOW "Creating PostgreSQL server: $server_name"
        az postgres server create \
            --name "$server_name" \
            --resource-group "$rg_name" \
            --location "$location" \
            --admin-user "$admin_user" \
            --admin-password "$admin_password" \
            --sku-name "$sku_name" \
            --storage-size "$storage_mb" \
            --version "$version"
        
        print_message $GREEN "PostgreSQL server created successfully!"
        
        # Configure firewall to allow Azure services
        print_message $YELLOW "Configuring firewall rules..."
        az postgres server firewall-rule create \
            --resource-group "$rg_name" \
            --server "$server_name" \
            --name "AllowAzureServices" \
            --start-ip-address 0.0.0.0 \
            --end-ip-address 0.0.0.0
    else
        print_message $GREEN "PostgreSQL server already exists: $server_name"
    fi
}

# Function to ensure database exists
ensure_database() {
    local db_type=$(get_config_value '.database_type')
    local db_name=$(get_config_value '.database.name')
    local rg_name=$(get_config_value '.azure.resource_group')
    
    if [[ "$db_type" == "sql" ]]; then
        local server_name=$(get_config_value '.sql_server.name')
        local compute_size=$(get_config_value '.database.compute_size')
        
        print_message $YELLOW "Checking SQL database: $db_name"
        
        if ! az sql db show --name "$db_name" --server "$server_name" --resource-group "$rg_name" &>/dev/null; then
            print_message $YELLOW "Creating SQL database: $db_name"
            az sql db create \
                --name "$db_name" \
                --server "$server_name" \
                --resource-group "$rg_name" \
                --service-objective "$compute_size"
            
            print_message $GREEN "SQL database created successfully!"
        else
            print_message $GREEN "SQL database already exists: $db_name"
        fi
    else
        local server_name=$(get_config_value '.postgresql_server.name')
        
        print_message $YELLOW "Checking PostgreSQL database: $db_name"
        
        if ! az postgres db show --name "$db_name" --server-name "$server_name" --resource-group "$rg_name" &>/dev/null; then
            print_message $YELLOW "Creating PostgreSQL database: $db_name"
            az postgres db create \
                --name "$db_name" \
                --server-name "$server_name" \
                --resource-group "$rg_name"
            
            print_message $GREEN "PostgreSQL database created successfully!"
        else
            print_message $GREEN "PostgreSQL database already exists: $db_name"
        fi
    fi
}

# Function to download and apply schema
apply_schema() {
    local schema_url=$(get_config_value '.schema.url')
    local db_type=$(get_config_value '.database_type')
    
    if [[ -z "$schema_url" || "$schema_url" == "null" || "$schema_url" == "https://raw.githubusercontent.com/" ]]; then
        print_message $YELLOW "No schema URL configured. Skipping schema application."
        return
    fi
    
    print_message $BLUE "=== Applying Database Schema ==="
    print_message $YELLOW "Downloading schema from: $schema_url"
    
    local temp_schema_file=$(mktemp)
    
    if curl -s -f "$schema_url" -o "$temp_schema_file"; then
        print_message $GREEN "Schema downloaded successfully"
        
        # Display schema content for confirmation
        print_message $BLUE "Schema content preview:"
        echo "----------------------------------------"
        head -20 "$temp_schema_file"
        echo "----------------------------------------"
        
        read -p "Do you want to apply this schema? (y/n): " apply_confirm
        
        if [[ "$apply_confirm" == "y" || "$apply_confirm" == "Y" ]]; then
            if [[ "$db_type" == "sql" ]]; then
                apply_sql_schema "$temp_schema_file"
            else
                apply_postgresql_schema "$temp_schema_file"
            fi
        else
            print_message $YELLOW "Schema application cancelled"
        fi
    else
        print_message $RED "Failed to download schema from: $schema_url"
        print_message $YELLOW "Please check the URL and try again"
    fi
    
    rm -f "$temp_schema_file"
}

# Function to apply SQL schema
apply_sql_schema() {
    local schema_file=$1
    local server_name=$(get_config_value '.sql_server.name')
    local db_name=$(get_config_value '.database.name')
    local admin_user=$(get_config_value '.sql_server.admin_user')
    local admin_password=$(get_config_value '.sql_server.admin_password')
    
    print_message $YELLOW "Applying schema to SQL database..."
    
    # Note: This requires sqlcmd to be installed
    if command -v sqlcmd &> /dev/null; then
        sqlcmd -S "$server_name.database.windows.net" -d "$db_name" -U "$admin_user" -P "$admin_password" -i "$schema_file"
        print_message $GREEN "Schema applied successfully to SQL database"
    else
        print_message $YELLOW "sqlcmd not found. You can apply the schema manually using:"
        print_message $BLUE "Server: $server_name.database.windows.net"
        print_message $BLUE "Database: $db_name"
        print_message $BLUE "Schema file: $schema_file"
    fi
}

# Function to apply PostgreSQL schema
apply_postgresql_schema() {
    local schema_file=$1
    local server_name=$(get_config_value '.postgresql_server.name')
    local db_name=$(get_config_value '.database.name')
    local admin_user=$(get_config_value '.postgresql_server.admin_user')
    local admin_password=$(get_config_value '.postgresql_server.admin_password')
    
    print_message $YELLOW "Applying schema to PostgreSQL database..."
    
    # Note: This requires psql to be installed
    if command -v psql &> /dev/null; then
        PGPASSWORD="$admin_password" psql -h "$server_name.postgres.database.azure.com" -U "$admin_user@$server_name" -d "$db_name" -f "$schema_file"
        print_message $GREEN "Schema applied successfully to PostgreSQL database"
    else
        print_message $YELLOW "psql not found. You can apply the schema manually using:"
        print_message $BLUE "Host: $server_name.postgres.database.azure.com"
        print_message $BLUE "Database: $db_name"
        print_message $BLUE "User: $admin_user@$server_name"
        print_message $BLUE "Schema file: $schema_file"
    fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
    local db_type=$(get_config_value '.database_type')
    
    print_message $BLUE "=== Deploying Infrastructure ==="
    print_message $YELLOW "Database type: $db_type"
    
    ensure_resource_group
    
    if [[ "$db_type" == "sql" ]]; then
        ensure_sql_server
    else
        ensure_postgresql_server
    fi
    
    ensure_database
    
    # Check if schema should be auto-applied
    local auto_apply=$(get_config_value '.schema.auto_apply')
    if [[ "$auto_apply" == "true" ]]; then
        apply_schema
    fi
    
    print_message $GREEN "Infrastructure deployment completed!"
    display_connection_info
}

# Function to display connection information
display_connection_info() {
    echo
    print_message $BLUE "=== Connection Information ==="
    
    local db_type=$(get_config_value '.database_type')
    local server_fqdn=$(get_config_value '.connection.server_fqdn')
    local db_name=$(get_config_value '.database.name')
    
    print_message $YELLOW "Database Type: $db_type"
    print_message $YELLOW "Server: $server_fqdn"
    print_message $YELLOW "Database: $db_name"
    
    if [[ "$db_type" == "sql" ]]; then
        local conn_template=$(get_config_value '.connection.connection_string_template')
        print_message $YELLOW "SQL Connection String Template:"
        echo "$conn_template"
    else
        local conn_template=$(get_config_value '.connection.postgresql_connection_string_template')
        print_message $YELLOW "PostgreSQL Connection String Template:"
        echo "$conn_template"
    fi
}

# Function to view current configuration
view_configuration() {
    print_message $BLUE "=== Current Configuration ==="
    
    # Display config without sensitive information
    jq 'del(.sql_server.admin_password) | del(.postgresql_server.admin_password)' "$CONFIG_FILE"
}

# Function to update configuration menu
update_configuration_menu() {
    echo
    print_message $BLUE "=== Update Configuration ==="
    echo "1) Update resource group"
    echo "2) Update server settings"
    echo "3) Update database settings"
    echo "4) Update schema settings"
    echo "5) Back to main menu"
    
    read -p "Choose option (1-5): " update_choice
    
    case $update_choice in
        1)
            read -p "Enter new resource group name: " new_rg
            read -p "Enter new location: " new_location
            update_config_value '.azure.resource_group' "$new_rg"
            update_config_value '.azure.location' "$new_location"
            print_message $GREEN "Resource group configuration updated"
            ;;
        2)
            local db_type=$(get_config_value '.database_type')
            if [[ "$db_type" == "sql" ]]; then
                read -p "Enter new SQL server name: " new_server
                read -p "Enter new admin username: " new_admin
                read -s -p "Enter new admin password: " new_password
                echo
                update_config_value '.sql_server.name' "$new_server"
                update_config_value '.sql_server.admin_user' "$new_admin"
                update_config_value '.sql_server.admin_password' "$new_password"
                update_config_value '.connection.server_fqdn' "$new_server.database.windows.net"
            else
                read -p "Enter new PostgreSQL server name: " new_server
                read -p "Enter new admin username: " new_admin
                read -s -p "Enter new admin password: " new_password
                echo
                update_config_value '.postgresql_server.name' "$new_server"
                update_config_value '.postgresql_server.admin_user' "$new_admin"
                update_config_value '.postgresql_server.admin_password' "$new_password"
                update_config_value '.connection.server_fqdn' "$new_server.postgres.database.azure.com"
            fi
            print_message $GREEN "Server configuration updated"
            ;;
        3)
            read -p "Enter new database name: " new_db
            update_config_value '.database.name' "$new_db"
            
            local db_type=$(get_config_value '.database_type')
            if [[ "$db_type" == "sql" ]]; then
                read -p "Enter new service tier (Basic/Standard/Premium): " new_tier
                read -p "Enter new compute size: " new_compute
                update_config_value '.database.service_tier' "$new_tier"
                update_config_value '.database.compute_size' "$new_compute"
            fi
            print_message $GREEN "Database configuration updated"
            ;;
        4)
            read -p "Enter new schema URL: " new_schema_url
            read -p "Auto-apply schema? (true/false): " new_auto_apply
            update_config_value '.schema.url' "$new_schema_url"
            update_config_value '.schema.auto_apply' "$new_auto_apply"
            print_message $GREEN "Schema configuration updated"
            ;;
        5)
            return
            ;;
        *)
            print_message $RED "Invalid option"
            ;;
    esac
}

# Function to delete resources
delete_resources() {
    local db_type=$(get_config_value '.database_type')
    
    print_message $RED "=== Delete Resources ==="
    print_message $RED "WARNING: This will delete all resources!"
    
    echo "What would you like to delete?"
    echo "1) Database only"
    echo "2) Server and Database"
    echo "3) Entire Resource Group"
    echo "4) Cancel"
    
    read -p "Choose option (1-4): " delete_choice
    
    local rg_name=$(get_config_value '.azure.resource_group')
    local db_name=$(get_config_value '.database.name')
    
    if [[ "$db_type" == "sql" ]]; then
        local server_name=$(get_config_value '.sql_server.name')
    else
        local server_name=$(get_config_value '.postgresql_server.name')
    fi
    
    case $delete_choice in
        1)
            read -p "Are you sure you want to delete database '$db_name'? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                if [[ "$db_type" == "sql" ]]; then
                    az sql db delete --name "$db_name" --server "$server_name" --resource-group "$rg_name" --yes
                else
                    az postgres db delete --name "$db_name" --server-name "$server_name" --resource-group "$rg_name" --yes
                fi
                print_message $GREEN "Database deleted successfully"
            fi
            ;;
        2)
            read -p "Are you sure you want to delete server '$server_name' and all its databases? (yes/no): " confirm
            if [[ "$confirm" == "yes" ]]; then
                if [[ "$db_type" == "sql" ]]; then
                    az sql server delete --name "$server_name" --resource-group "$rg_name" --yes
                else
                    az postgres server delete --name "$server_name" --resource-group "$rg_name" --yes
                fi
                print_message $GREEN "Server deleted successfully"
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
    print_message $YELLOW "Enhanced with PostgreSQL Support"
    print_message $YELLOW "===============================\n"
    
    # Check prerequisites
    check_azure_cli
    check_jq
    check_curl
    
    # Load configuration
    load_config
    
    # Azure login
    azure_login
    
    # Main menu loop
    while true; do
        show_menu
        read -p "Please select an option (1-7): " choice
        
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
                apply_schema
                ;;
            6)
                delete_resources
                ;;
            7)
                print_message $YELLOW "Goodbye!"
                exit 0
                ;;
            *)
                print_message $RED "Invalid option. Please choose 1-7."
                ;;
        esac
        
        echo
        read -p "Press Enter to continue..."
    done
}

# Run main function
main "$@"