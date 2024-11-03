Purpose: Specify $1 (domain name of target)   [opt] <ip>  [opt] <user@target.com>
Prereqs: sqpquery


./spfRelaytest.sh gmodules.com 1.1.1.1 "a@gmodules.com"

Expected output either fail:
SPF record for gmodules.com: "v=spf1 -all"
Running SPF queries...
fail
Please see http://www.openspf.org/Why?s=helo;id=gmodules.com;ip=1.1.1.1;r=localhost
gmodules.com: Sender is not authorized by default to use 'gmodules.com' in 'helo' identity (mechanism '-all' matched)
Received-SPF: fail (gmodules.com: Sender is not authorized by default to use 'gmodules.com' in 'helo' identity (mechanism '-all' matched)) receiver=localhost; identity=helo; helo=gmodules.com; client-ip=1.1.1.1

------------------------------------------

or pass  (relaying possible) 



#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help display function
display_help() {
    echo -e "${GREEN}Usage:${NC} $0 [domain] [source_ip] [\"email_address\"] [-all]"
    echo -e "\n${YELLOW}Parameters:${NC}"
    echo -e "  \$1  : (Optional) Domain name of the web server (default: google.com)"
    echo -e "  \$2  : (Optional) Source IP for testing the SPF query (default: 127.0.0.1)"
    echo -e "  \$3  : (Optional) Target email address for SPF query (default: user@gmail.com)"
    echo -e "  -all : (Optional) Run each test 5 times with different IPs:"
    echo -e "         1) Normal"
    echo -e "         2) With IP 0.0.0.0"
    echo -e "         3) With IP 255.255.255.255"
    echo -e "         4) Valid IP in SPF range"
    echo -e "         5) Valid IP with email from a valid domain"
    echo -e "\n${YELLOW}Examples:${NC}"
    echo -e "  $0 google.com"
    echo -e "  $0 google.com 203.0.113.5"
    echo -e "  $0 google.com 203.0.113.5 \"user@example.com\""
    echo -e "  $0 google.com 203.0.113.5 \"user@example.com\" -all"
    exit 0
}

# Set defaults if not provided
DOMAIN=${1:-"google.com"}
SOURCE_IP=${2:-"127.0.0.1"}
TARGET_EMAIL=${3:-"user@gmail.com"}
ALL_MODE=false

# Check for -all option
if [ "$4" == "-all" ]; then
    ALL_MODE=true
fi

EPOCH_TIME=$(date +%s)  # Current epoch time
LOG_FILE="/tmp/mailchk${EPOCH_TIME}.log"  # Log file

# Function to log and echo output
log_and_echo() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Fetch SPF records with dig and put it into a variable
SPF_RECORD=$(dig txt $DOMAIN +short | grep -i "v=spf1")
if [ -z "$SPF_RECORD" ]; then
    log_and_echo "${RED}No SPF record found for domain: $DOMAIN${NC}"
    exit 1
else
    log_and_echo "${GREEN}SPF record for $DOMAIN:${NC} $SPF_RECORD"
fi

# Spacer for clarity
add_spacer() {
    echo -e "\n${GREEN}------------------------------------------${NC}\n" | tee -a "$LOG_FILE"
}

# Function to check result and color output accordingly
check_result() {
    local result="$1"
    if [[ "$result" == *"pass"* ]]; then
        log_and_echo "${GREEN}$result${NC}"
        sleep 1
    elif [[ "$result" == *"fail"* || "$result" == *"softfail"* ]]; then
        log_and_echo "${RED}$result${NC}"
        sleep 1
    else
        log_and_echo "$result"
    fi
}

# Get the first valid IP from the SPF record (if any)
VALID_IP=$(dig +short _spf.google.com | head -n 1)
VALID_DOMAIN="example.com"

# Test SPF with spfquery for provided IP and email address
log_and_echo "${YELLOW}Running SPF queries...${NC}"

# Run 15 different combinations of SPF checks with commands printed
tests=(
    "spfquery --ip=\"$SOURCE_IP\" --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=192.0.2.10 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=127.0.0.1 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=203.0.113.5 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=224.0.0.8 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
)

counter=1

run_test() {
    local ip="$1"
    local email="$2"
    local helo="$3"
    log_and_echo "${YELLOW}Test $counter: Running Command...${NC}"
    local test_cmd="spfquery --ip=\"$ip\" --mfrom=\"$email\" --helo=\"$helo\""
    log_and_echo "$test_cmd"
    
    # Execute the command and capture the result
    result=$(eval "$test_cmd")
    
    # Check and display the result with color coding
    check_result "$result"
    
    # Add a spacer after each test
    add_spacer
    
    # Add a small delay to slow down execution
    sleep 2
    ((counter++))
}

# Run the test normally or with -all mode
for test_cmd in "${tests[@]}"; do
    # Normal test
    eval "$test_cmd" | tee -a "$LOG_FILE"
    
    # If -all is set, run multiple variations of the test
    if [ "$ALL_MODE" = true ]; then
        run_test "$SOURCE_IP" "$TARGET_EMAIL" "$DOMAIN"
        run_test "0.0.0.0" "$TARGET_EMAIL" "$DOMAIN"
        run_test "255.255.255.255" "$TARGET_EMAIL" "$DOMAIN"
        run_test "$VALID_IP" "$TARGET_EMAIL" "$DOMAIN"
        run_test "$VALID_IP" "user@$VALID_DOMAIN" "$DOMAIN"
    fi
    add_spacer
done

# Additional SPF queries based on _netblocks if present
NETBLOCKS=$(echo "$SPF_RECORD" | grep -o "include:[^ ]*")
if [ -n "$NETBLOCKS" ]; then
    log_and_echo "${YELLOW}Checking SPF for included netblocks...${NC}"
    for block in $NETBLOCKS; do
        BLOCK_DOMAIN=$(echo $block | cut -d: -f2)
        log_and_echo "${GREEN}Querying netblock: $BLOCK_DOMAIN${NC}"
        dig txt $BLOCK_DOMAIN +short | tee -a "$LOG_FILE"
        add_spacer
    done
else
    log_and_echo "${RED}No included netblocks found in SPF record.${NC}"
fi

# Finish
log_and_echo "${GREEN}SPF checks completed. Logs saved to: $LOG_FILE${NC}"




