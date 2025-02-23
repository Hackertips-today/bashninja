#!/bin/bash
# hackertips.today
# Check if a URL was provided
if [ -z "$1" ]; then
    echo "Usage: $0 https://example.com"
    exit 1
fi

# Base URL
URL="$1"

# build array of common ifles and Cloudflare-related Files
declare -a COMMON_FILES=(
    "/.well-known/ai-plugin.json"
    "/.well-known/assetlinks.json"
    "/.well-known/dnt-policy.txt"
    "/.well-known/gpc.json"
    "/.well-known/nodeinfo"
    "/.well-known/openid-configuration"
    "/.well-known/security.txt"
    "/.well-known/trust.txt"
    "/robots.txt"
    "/sitemap.xml"
    "/humans.txt"
    "/security.txt"
    "/.htaccess"
    "/cdn-cgi/trace"  # Cloudflare Trace
    "/cdn-cgi/l/chk_jschl"
    "/cdn-cgi/l/chk_captcha"
    "/cdn-cgi/l/email-protection"
    "/cdn-cgi/l/chk_privacy"
)

# Log File (with epoch timestamp)
LOG_FILE="curlcommon-$(date +%s).log"

echo "Scanning: $URL"
echo "Results will be saved in: $LOG_FILE"
echo "--------------------------------------------"

# Function to check each file
check_file() {
    local file="$1"
    local full_url="${URL}${file}"
    RESPONSE=$(curl -A "Trident" --connect-timeout 3 -s -o /tmp/curl_output.txt -w "%{http_code}" "$full_url")
    CONTENT=$(cat /tmp/curl_output.txt)


# output to console
    if [[ "$RESPONSE" == "200" ]]; then
        echo "FOUND: $full_url (HTTP $RESPONSE)"
        echo "---- FILE CONTENT ----"
        echo "$CONTENT"
        echo "----------------------"
    else
        echo "NOT FOUND: $full_url (HTTP $RESPONSE)"
    fi

    # Log result
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $full_url -> HTTP $RESPONSE" >> "$LOG_FILE"
    if [[ "$RESPONSE" == "200" ]]; then
        echo "$CONTENT" >> "$LOG_FILE"
        echo "----------------------" >> "$LOG_FILE"
    fi
}

# Loop through each file in the array
for file in "${COMMON_FILES[@]}"; do
    check_file "$file"
done

echo "Scan completed. Check $LOG_FILE for details."
