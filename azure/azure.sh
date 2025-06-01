#!/bin/bash

# Azure Database Management Script
# This script helps manage Azure SQL databases with user-friendly prompts

set -e  # Exit on any error

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

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_message $RED "Azure CLI is not installed. Please install it first:"
        print_message $YELLOW "Visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
}

# Function to display menu
show_menu() {
    echo
    print_message $BLUE "=== Azure Database Management ==="
    echo "1) Create new Azure account (opens browser)"
    echo "2) Use existing Azure account"
    echo "3) Exit"
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
    
    # Display current subscription
    subscription=$(az account show --query "name" -o tsv)
    subscription_id=$(az account show --query "id" -o tsv)
    print_message $GREEN "Using subscription: $subscription ($subscription_id)"
}

# Function to get resource group
get_resource_group() {
    echo
    print_message $BLUE "=== Resource Group Selection ==="
    
    # List available resource groups
    print_message $YELLOW "Available resource groups:"
    az group list --query "[].name" -o table
    
    echo
    read -p "Enter resource group name (or press Enter to create new): " resource_group
    
    if [[ -z "$resource_group" ]]; then
        read -p "Enter new resource group name: " resource_group
        read -p "Enter location (e.g., eastus, westus2): " location
        
        print_message $YELLOW "Creating resource group: $resource_group"
        az group create --name "$resource_group" --location "$location"
        print_message $GREEN "Resource group created successfully!"
    fi
    
    echo "$resource_group"
}

# Function to get or create SQL server
get_sql_server() {
    local rg=$1
    
    echo
    print_message $BLUE "=== SQL Server Selection ==="
    
    # List available SQL servers in the resource group
    servers=$(az sql server list --resource-group "$rg" --query "[].name" -o tsv)
    
    if [[ -n "$servers" ]]; then
        print_message $YELLOW "Available SQL servers in $rg:"
        echo "$servers"
        echo
    fi
    
    read -p "Enter SQL server name (or press Enter to create new): " server_name
    
    if [[ -z "$server_name" ]]; then
        read -p "Enter new SQL server name: " server_name
        read -s -p "Enter admin username: " admin_user
        echo
        read -s -p "Enter admin password: " admin_password
        echo
        read -p "Enter location (e.g., eastus, westus2): " location
        
        print_message $YELLOW "Creating SQL server: $server_name"
        az sql server create \
            --name "$server_name" \
            --resource-group "$rg" \
            --location "$location" \
            --admin-user "$admin_user" \
            --admin-password "$admin_password"
        
        print_message $GREEN "SQL server created successfully!"
        
        # Configure firewall to allow Azure services
        print_message $YELLOW "Configuring firewall rules..."
        az sql server firewall-rule create \
            --resource-group "$rg" \
            --server "$server_name" \
            --name "AllowAzureServices" \
            --start-ip-address 0.0.0.0 \
            --end-ip-address 0.0.0.0
    fi
    
    echo "$server_name"
}

# Function to check if database exists
database_exists() {
    local server=$1
    local rg=$2
    local db_name=$3
    
    az sql db show --name "$db_name" --server "$server" --resource-group "$rg" &>/dev/null
}

# Function to create or update database
manage_database() {
    local server=$1
    local rg=$2
    
    echo
    print_message $BLUE "=== Database Management ==="
    
    # List existing databases
    print_message $YELLOW "Existing databases on server $server:"
    az sql db list --server "$server" --resource-group "$rg" --query "[].name" -o table
    
    echo
    read -p "Enter database name: " db_name
    
    if database_exists "$server" "$rg" "$db_name"; then
        print_message $YELLOW "Database '$db_name' already exists!"
        echo
        echo "1) Update database configuration"
        echo "2) View database details"
        echo "3) Delete and recreate database"
        echo "4) Skip database operations"
        
        read -p "Choose an option (1-4): " db_option
        
        case $db_option in
            1)
                print_message $YELLOW "Updating database configuration..."
                read -p "Enter new service tier (Basic/Standard/Premium) [current]: " service_tier
                read -p "Enter new compute size (e.g., S0, S1, P1) [current]: " compute_size
                
                update_cmd="az sql db update --name $db_name --server $server --resource-group $rg"
                
                if [[ -n "$service_tier" ]]; then
                    update_cmd="$update_cmd --tier $service_tier"
                fi
                
                if [[ -n "$compute_size" ]]; then
                    update_cmd="$update_cmd --compute-size $compute_size"
                fi
                
                eval $update_cmd
                print_message $GREEN "Database updated successfully!"
                ;;
            2)
                print_message $YELLOW "Database details:"
                az sql db show --name "$db_name" --server "$server" --resource-group "$rg" --output table
                ;;
            3)
                print_message $RED "WARNING: This will delete all data in the database!"
                read -p "Are you sure you want to delete and recreate? (yes/no): " confirm
                
                if [[ "$confirm" == "yes" ]]; then
                    az sql db delete --name "$db_name" --server "$server" --resource-group "$rg" --yes
                    create_new_database "$server" "$rg" "$db_name"
                else
                    print_message $YELLOW "Operation cancelled."
                fi
                ;;
            4)
                print_message $YELLOW "Skipping database operations."
                ;;
            *)
                print_message $RED "Invalid option selected."
                ;;
        esac
    else
        create_new_database "$server" "$rg" "$db_name"
    fi
}

# Function to create a new database
create_new_database() {
    local server=$1
    local rg=$2
    local db_name=$3
    
    print_message $YELLOW "Creating new database: $db_name"
    
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
            read -p "Enter compute size (S0, S1, S2, S3): " compute_size
            compute_size=${compute_size:-S0}
            ;;
        3)
            service_tier="Premium"
            read -p "Enter compute size (P1, P2, P4, P6, P11, P15): " compute_size
            compute_size=${compute_size:-P1}
            ;;
        *)
            print_message $YELLOW "Invalid choice, using Basic tier"
            service_tier="Basic"
            compute_size="Basic"
            ;;
    esac
    
    print_message $YELLOW "Creating database with $service_tier tier ($compute_size)..."
    
    az sql db create \
        --name "$db_name" \
        --server "$server" \
        --resource-group "$rg" \
        --service-objective "$compute_size"
    
    print_message $GREEN "Database '$db_name' created successfully!"
    
    # Display connection string
    echo
    print_message $BLUE "Connection Information:"
    print_message $YELLOW "Server: $server.database.windows.net"
    print_message $YELLOW "Database: $db_name"
    print_message $YELLOW "Connection String Template:"
    echo "Server=tcp:$server.database.windows.net,1433;Initial Catalog=$db_name;Persist Security Info=False;User ID={your_username};Password={your_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

# Main script execution
main() {
    print_message $GREEN "Azure Database Management Script"
    print_message $YELLOW "================================"
    
    # Check prerequisites
    check_azure_cli
    
    # Show menu and get user choice
    while true; do
        show_menu
        read -p "Please select an option (1-3): " choice
        
        case $choice in
            1)
                print_message $BLUE "Opening Azure account creation page..."
                if command -v xdg-open &> /dev/null; then
                    xdg-open "https://azure.microsoft.com/free/"
                elif command -v open &> /dev/null; then
                    open "https://azure.microsoft.com/free/"
                else
                    print_message $YELLOW "Please visit: https://azure.microsoft.com/free/"
                fi
                print_message $YELLOW "After creating your account, run this script again and choose option 2."
                exit 0
                ;;
            2)
                # Proceed with existing account
                break
                ;;
            3)
                print_message $YELLOW "Goodbye!"
                exit 0
                ;;
            *)
                print_message $RED "Invalid option. Please choose 1, 2, or 3."
                ;;
        esac
    done
    
    # Azure login
    azure_login
    
    # Get resource group
    resource_group=$(get_resource_group)
    
    # Get or create SQL server
    sql_server=$(get_sql_server "$resource_group")
    
    # Manage database
    manage_database "$sql_server" "$resource_group"
    
    print_message $GREEN "Script completed successfully!"
}

# Run main function
main "$@"