# SuiteCRM Installation Script - Backup Functionality Documentation

## Overview

This document describes the backup functionality implemented in the SuiteCRM installation script (`scripts/suite.sh`) to safely preserve Apache configuration files before making modifications.

## Purpose

The backup functionality ensures that critical Apache configuration files are preserved before the script makes any modifications. This provides a safety net for system administrators and allows for easy restoration if issues occur during the installation process.

## Files Backed Up

The script creates backups of two essential Apache configuration files:

1. **`httpd.conf`** - Main Apache configuration file
2. **`httpd-vhosts.conf`** - Virtual hosts configuration file

## Backup Naming Convention

Backup files are created by replacing the `.conf` extension with `.bkup`:

- `httpd.conf` → `httpd.conf.bkup`
- `httpd-vhosts.conf` → `httpd-vhosts.conf.bkup`

## Implementation Details

### New Functions Added

#### 1. `backup_config_files()`

**Purpose**: Creates backup copies of Apache configuration files

**Behavior**:
- Checks if backup files already exist
- Only creates new backups if `.bkup` files don't exist
- Provides clear console feedback about backup status
- Handles file permission issues gracefully

**Example Output**:
```
🔧 Creating backup of Apache configuration files...
✅ Created backup: /opt/homebrew/etc/httpd/httpd.conf.bkup
✅ Created backup: /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf.bkup
```

#### 2. `update_vhosts_paths()`

**Purpose**: Updates path references in `httpd-vhosts.conf` to use consistent variables

**Behavior**:
- Updates `DocumentRoot` directives to use the same path variables as `httpd.conf`
- Updates `<Directory>` blocks to match the path structure
- Ensures consistency across all Apache configuration files

## Cross-Platform Implementation

### macOS Section

**Configuration File Paths**:
- Primary: `/opt/homebrew/etc/httpd/` (Apple Silicon)
- Fallback: `/usr/local/etc/httpd/` (Intel Macs)

**Implementation**:
```bash
# Called after Apache path definition
backup_config_files "$HTTPD_CONF" "$HTTPD_VHOSTS"

# Called after VirtualHost configuration
update_vhosts_paths "$HTTPD_VHOSTS" "$CRM_PUBLIC_DIR"
```

### Linux Section

**Distribution Support**:
- **Ubuntu/Debian**: `/etc/apache2/`
- **CentOS/RHEL**: `/etc/httpd/`

**Implementation**:
```bash
# Detects Linux distribution and sets appropriate paths
if command -v apt-get >/dev/null 2>&1; then
    # Ubuntu/Debian paths
elif command -v yum >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
    # CentOS/RHEL paths
fi

backup_config_files "$HTTPD_CONF" "$HTTPD_VHOSTS"
update_vhosts_paths "$HTTPD_VHOSTS" "$CRM_PUBLIC_DIR"
```

### Windows Section

**Configuration File Paths**:
- Apache: `/c/tools/apache24/conf/`
- Uses Windows-compatible path conversion

**Implementation**:
```bash
# Windows-specific path handling with cygpath
backup_config_files "$APACHE_CONF" "$APACHE_VHOSTS"
update_vhosts_paths "$APACHE_VHOSTS" "$DOCUMENT_ROOT/$INSTANCE_FOLDER"
```

## Safety Features

### 1. Duplicate Backup Prevention

The script checks for existing backup files before creating new ones:

```bash
if [ ! -f "${config_file}.bkup" ]; then
    # Create backup
else
    echo "✅ Backup already exists: ${config_file}.bkup"
fi
```

### 2. Error Handling

Comprehensive error handling for common issues:

- File permission problems
- Missing source files
- Disk space issues
- Path accessibility

### 3. Verification

The script verifies that backups were created successfully:

```bash
if [ -f "${config_file}.bkup" ]; then
    echo "✅ Created backup: ${config_file}.bkup"
else
    echo "⚠️ Failed to create backup of ${config_file}"
fi
```

## Path Consistency Updates

### Problem Solved

Before the update, `httpd-vhosts.conf` might contain hardcoded paths that differed from the variables used in `httpd.conf`, leading to:

- Configuration inconsistencies
- Maintenance difficulties
- Potential security issues

### Solution Implemented

The `update_vhosts_paths()` function ensures:

1. **DocumentRoot Consistency**: All DocumentRoot directives use the same path variables
2. **Directory Block Alignment**: Directory permissions and settings are consistent
3. **Variable Reuse**: Same path variables used across all configuration files

### Example Path Updates

**Before**:
```apache
DocumentRoot "/var/www/html/account/public"
<Directory "/var/www/html/account/public">
```

**After**:
```apache
DocumentRoot "$CRM_PUBLIC_DIR"
<Directory "$CRM_PUBLIC_DIR">
```

## Usage Instructions

### For System Administrators

1. **Pre-Installation**: The backup functionality runs automatically during script execution
2. **Verification**: Check for `.bkup` files in your Apache configuration directory
3. **Restoration**: If needed, restore original files by copying `.bkup` files back to `.conf`

### Manual Restoration Example

```bash
# Restore httpd.conf
cp /opt/homebrew/etc/httpd/httpd.conf.bkup /opt/homebrew/etc/httpd/httpd.conf

# Restore httpd-vhosts.conf
cp /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf.bkup /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf

# Restart Apache
brew services restart httpd
```

## Benefits

### 1. Risk Mitigation

- **Safe Rollback**: Easy restoration of original configuration
- **Change Tracking**: Clear record of what was modified
- **System Stability**: Reduced risk of breaking existing Apache installations

### 2. Maintenance Improvements

- **Consistent Paths**: Easier to maintain and update configurations
- **Reduced Errors**: Less chance of path-related configuration mistakes
- **Better Documentation**: Clear understanding of configuration changes

### 3. Operational Excellence

- **Automated Safety**: No manual backup steps required
- **Cross-Platform**: Works consistently across all supported operating systems
- **Professional Standards**: Follows best practices for system configuration management

## Troubleshooting

### Common Issues and Solutions

#### Backup Creation Fails

**Symptoms**: Warning messages about failed backup creation

**Possible Causes**:
- Insufficient permissions
- Disk space issues
- Source file doesn't exist

**Solutions**:
1. Check file permissions: `ls -la /path/to/config/file`
2. Verify disk space: `df -h`
3. Ensure Apache is properly installed

#### Path Updates Don't Apply

**Symptoms**: VirtualHost still uses old paths

**Possible Causes**:
- File is read-only
- Syntax errors in configuration
- Incorrect path variables

**Solutions**:
1. Check file permissions: `chmod 644 httpd-vhosts.conf`
2. Validate Apache config: `httpd -t`
3. Review path variable definitions

## Best Practices

### 1. Regular Backups

While the script creates automatic backups, consider:
- Creating additional manual backups before major changes
- Implementing regular configuration backup schedules
- Storing backups in version control systems

### 2. Testing

After running the script:
- Test Apache configuration: `httpd -t`
- Verify web server functionality
- Check application accessibility

### 3. Documentation

- Keep records of when backups were created
- Document any manual configuration changes
- Maintain change logs for configuration modifications

## Conclusion

The backup functionality provides a robust safety net for Apache configuration management during SuiteCRM installation. By automatically preserving original configurations and ensuring path consistency, the script reduces risk while improving maintainability across all supported operating systems.

This implementation follows industry best practices for system configuration management and provides system administrators with the confidence to deploy SuiteCRM installations safely and efficiently.