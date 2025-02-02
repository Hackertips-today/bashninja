

    ____                  __             _           __          _               __           _ 
   / __ \  ___    _____  / /_   _____   (_)  _____  / /_        ( ) _      __   / /_   ____  ( )
  / /_/ / / _ \  / ___/ / __/  / ___/  / /  / ___/ / __/        |/ | | /| / /  / __ \ / __ \ |/ 
 / _, _/ /  __/ (__  ) / /_   / /     / /  / /__  / /_             | |/ |/ /  / / / // /_/ /    
/_/ |_|  \___/ /____/  \__/  /_/     /_/   \___/  \__/             |__/|__/  /_/ /_/ \____/     

[ This script must be run as root, it will prevent any non root user from viewing who is logged in ]
  

#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

echo "Restricting users from seeing other users..."

# Step 1: Restrict access to /var/run/utmp
chmod 600 /var/run/utmp
chown root:root /var/run/utmp
echo "Restricted /var/run/utmp"

# Step 2: Restrict access to /var/log/wtmp
chmod 600 /var/log/wtmp
chown root:root /var/log/wtmp
echo "Restricted /var/log/wtmp"

# Step 3: Restrict access to /proc using hidepid
if ! grep -q "proc /proc proc defaults,hidepid=2" /etc/fstab; then
    echo "proc /proc proc defaults,hidepid=2 0 0" >> /etc/fstab
    mount -o remount /proc
    echo "Restricted /proc with hidepid=2"
else
    echo "/proc is already restricted"
fi

echo "Restrictions applied successfully."
