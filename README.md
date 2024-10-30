
#                [....................  HACKERTIPS.TODAY .............................]



Distro: https://hackertips.today
Linkedin: https://linkedin.com/in/yoursystem

# bashninja

Create files: for i in {3..50}; do > tips/$i.txt; done


#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help display function
display_help() {
    echo -e "${GREEN}Usage:${NC} $0 [domain] [source_ip] [\"email_address\"]"
    echo -e "\n${YELLOW}Parameters:${NC}"
    echo -e "  \$1  : (Optional) Domain name of the web server (default: google.com)"
    echo -e "  \$2  : (Optional) Source IP for testing the SPF query (default: 127.0.0.1)"
    echo -e "  \$3  : (Optional) Target email address for SPF query (default: user@gmail.com)"
    echo -e "\n${YELLOW}Examples:${NC}"
    echo -e "  $0 google.com"
    echo -e "  $0 google.com 203.0.113.5"
    echo -e "  $0 google.com 203.0.113.5 \"user@example.com\""
    exit 0
}

# Set defaults if not provided
DOMAIN=${1:-"google.com"}
SOURCE_IP=${2:-"127.0.0.1"}
TARGET_EMAIL=${3:-"user@gmail.com"}
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

# Test SPF with spfquery for provided IP and email address
log_and_echo "${YELLOW}Running SPF queries...${NC}"

# Run 15 different combinations of SPF checks with commands printed
tests=(
    "spfquery --ip=\"$SOURCE_IP\" --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=192.0.2.10 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=127.0.0.1 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=203.0.113.5 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=224.0.0.8 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=10.0.0.1 --mfrom=\"$TARGET_EMAIL\" --helo=\"mail.$DOMAIN\""
    "spfquery --ip=8.8.8.8 --mfrom=\"$TARGET_EMAIL\" --helo=\"mx.$DOMAIN\""
    "spfquery --ip=10.1.1.1 --mfrom=\"admin@sub.$DOMAIN\" --helo=\"smtp.$DOMAIN\""
    "spfquery --ip=192.168.0.1 --mfrom=\"postmaster@$DOMAIN\" --helo=\"$DOMAIN\""
    "spfquery --ip=127.0.0.5 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
    "spfquery --ip=203.0.113.2 --mfrom=\"$TARGET_EMAIL\" --helo=\"mail2.$DOMAIN\""
    "spfquery --ip=192.0.2.20 --mfrom=\"$TARGET_EMAIL\" --helo=\"ns.$DOMAIN\""
    "spfquery --ip=203.0.113.1 --mfrom=\"$TARGET_EMAIL\" --helo=\"mx2.$DOMAIN\""
    "spfquery --ip=224.0.0.9 --mfrom=\"$TARGET_EMAIL\" --helo=\"mail3.$DOMAIN\""
    "spfquery --ip=10.1.2.3 --mfrom=\"$TARGET_EMAIL\" --helo=\"$DOMAIN\""
)

counter=1

for test_cmd in "${tests[@]}"; do
    log_and_echo "${YELLOW}Test $counter: Running Command...${NC}"
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



Usage:
./age6.sh "gmail.com" "127.0.0.1" "a@gmail.com





Usage
