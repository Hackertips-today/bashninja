
                             ____  _____    ______                                       
                            |_   \|_   _| .' ____ \                                      
 _ .--.   .---.   _   __      |   \ | |   | (___ \_|    .--.    .---.   ,--.    _ .--.   
[ `/'`\] / /__\\ [ \ [  ]     | |\ \| |    _.____`.    ( (`\]  / /'`\] `'_\ :  [ `.-. |  
 | |     | \__.,  \ \/ /     _| |_\   |_  | \____) |    `'.'.  | \__.  // | |,  | | | |  
[___]     '.__.'   \__/     |_____|\____|  \______.'   [\__) ) '.___.' \'-;__/ [___||__] 
                                                                                         
                                                                                         
                         [ ./rev NS scanner for Bash ] 


Usage: ./revNSansi.sh 104.104.1.       # Must end with .  will rev DNS scan /24

#!/bin/bash

# Function to display the spinning [X] character  / not necessary
function show_spinner() {
# Text colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold text colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Reset color
RESET_COLOR='\033[0m'

    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    while true; do
        printf "\r{$BOLD_CYAN}${spinstr:$i:1}"
        sleep $delay
        ((i = (i + 1) % ${#spinstr}))
    done
}

# Function to perform a reverse DNS lookup for the /24 subnet
function reverse_dns_lookup() {
    local subnet="$1"

    for i in $(seq 0 255); do
        ip_address="${subnet}${i}"
        reverse_dns=$(host "$ip_address")

        if grep -q "domain name pointer" <<< "$reverse_dns"; then
            echo "$ip_address: $reverse_dns"
        fi
    done
}

if [ -z "$1" ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi


if ! [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.$ ]]; then
    echo "Invalid subnet format. Please provide a valid /24 subnet (e.g., 192.168.1.)"
    exit 1
fi

echo "Starting the rev scan on $1..."

show_spinner &
spinner_pid=$!

reverse_dns_lookup "$1"

# Stop the spinner
kill $spinner_pid
wait $spinner_pid 2>/dev/null   # Suppress the "Terminated" message

echo "reverse dns scan stopped."

