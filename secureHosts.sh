# Secure hosts.allow on the fly
# updates hosts.allow to log to /var/log custom files
# updates hosts.deny to all:all

#!/bin/bash

# Path to the hosts.allow and hosts.deny files
hosts_allow="/etc/hosts.allow"
hosts_deny="/etc/hosts.deny"

# Backup the existing files
cp $hosts_allow "${hosts_allow}.bak"
cp $hosts_deny "${hosts_deny}.bak"

# Define an associative array to hold IP, Comment, and Log file name
declare -A ip_rules
ip_rules=(
    ["172.10."]="personone"
    ["66.249.83.32"]="GoogleProxy"
    ["34.117.118.44"]="GoogleLB"
    ["100.100."]="mom"
    ["100.4."]="dad"
    ["172.100.111."]="john"
    ["67.207."]="paul"
    ["104.248.12.135"]="frank"
    ["10.8."]="vpn"
)

# Populate hosts.allow with dynamic entries
echo "" > $hosts_allow
for ip in "${!ip_rules[@]}"; do
    comment=${ip_rules[$ip]}
    echo "ALL: $ip : spawn /bin/echo \`date\` %c %d >> /var/log/allowed_ssh_${comment}.log" >> $hosts_allow
done

# Populate hosts.deny
cat > $hosts_deny << EOF
ALL:ALL : spawn /bin/echo \`date\` %c %d >> /var/log/ssh_FAIL_auth.log
EOF

echo "hosts.allow and hosts.deny have been updated."
sleep 1
echo "Verifying /etc/hosts.allow and deny have been written"
echo "sudo stat /etc/hosts.allow"
sudo stat /etc/hosts.allow
echo
echo "sudo stat /etc/hosts.deny"
sudo stat /etc/hosts.deny
sleep 1
ls -altr /etc/hosts.*
echo


