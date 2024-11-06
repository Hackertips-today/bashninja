Usage:   ./revNS24.sh x.x.x.     # IE:  104.254.2.

#!/bin/bash

# Function to display the spinning [X] character
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
    local spinstr='â ‹â ™â ¹â ¸â ¼â ´â ¦â §â ‡â '
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

# Check if $1 is a valid /24 subnet
if ! [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.$ ]]; then
    echo "Invalid subnet format. Please provide a valid /24 subnet (e.g., 192.168.1.)"
    exit 1
fi

echo "Starting the rev scan on $1..."

show_spinner &
spinner_pid=$!

# Perform the reverse DNS lookup for the provided /24 subnet
reverse_dns_lookup "$1"

# Stop the spinner
kill $spinner_pid
wait $spinner_pid 2>/dev/null   # Suppress the "Terminated" message

echo "reverse dns scan stopped."



---
./revNS24.sh 142.250.176.
Starting the rev scan on 142.250.176....
{}⠋142.250.176.0: 0.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f0.1e100.net.
142.250.176.1: 1.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f1.1e100.net.
{}⠙142.250.176.2: 2.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f2.1e100.net.
142.250.176.3: 3.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f3.1e100.net.
142.250.176.4: 4.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f4.1e100.net.
142.250.176.5: 5.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f5.1e100.net.
{}⠹142.250.176.6: 6.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f6.1e100.net.
142.250.176.7: 7.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f7.1e100.net.
{}⠸142.250.176.8: 8.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f8.1e100.net.
142.250.176.9: 9.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f9.1e100.net.
{}⠼142.250.176.10: 10.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f10.1e100.net.
142.250.176.11: 11.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f11.1e100.net.
142.250.176.12: 12.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f12.1e100.net.
{}⠴142.250.176.13: 13.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f13.1e100.net.
142.250.176.14: 14.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f14.1e100.net.
{}⠦142.250.176.15: 15.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f15.1e100.net.
{}⠧142.250.176.16: 16.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f16.1e100.net.
142.250.176.17: 17.176.250.142.in-addr.arpa domain name pointer lax17s51-in-f17.1e100.net.

