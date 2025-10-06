<!--
1. [Download SuiteCRM version 8.8.0](https://suitecrm.com/wpfd_file/suitecrm-8-8-0/) and unzip in your webroot.  
There may be [more recent versions](https://suitecrm.com/download/), but we're matching the version in our .sh file.

2. Rename the folder to **SuiteCRM**
-->

<!--
For MacOS 2020 and older, (above - but actually both turned out to be the same.)

If you are using a newer Mac (running Apple silcon) your Apache root might be somewhere at:

/opt/homebrew/etc/httpd
-->



    # Define document root and directories
    DOCUMENT_ROOT="/opt/homebrew/var/www"
    if [ ! -d "$DOCUMENT_ROOT" ]; then
        DOCUMENT_ROOT="/usr/local/var/www"
        if [ ! -d "$DOCUMENT_ROOT" ]; then
            echo "🔧 Creating document root directory..."
            mkdir -p "$DOCUMENT_ROOT"
        fi
    fi
    
    CRM_ROOT="$DOCUMENT_ROOT/$CRM_ROOT"

Instead:

	CRM_ROOT="$CRM_ROOT"

