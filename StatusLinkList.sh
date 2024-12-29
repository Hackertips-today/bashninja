

#!/bin/bash
check_urls() {
    local url_file="$1"

    # Check if file exists
    if [[ ! -f "$url_file" ]]; then
        echo "File not found: $url_file"
        return 1
    fi

    # Parse URLs: Remove anything after the hostname, check for duplicates, and sort
    local cleaned_urls
    cleaned_urls=$(awk -F/ '{print $1 "//" $3}' "$url_file" | sort -u)

    # Store cleaned URLs into an array
    local urls=()
    while IFS= read -r url; do
        [[ -n "$url" ]] && urls+=("$url")
    done <<< "$cleaned_urls"

    # Batch processing: 100 URLs per request
    local batch_size=100
    local total_urls=${#urls[@]}
    local start=0

    echo "Total URLs after cleaning and deduplication: $total_urls. Processing in batches of $batch_size..."

    while (( start < total_urls )); do
        # Extract batch
        local batch=("${urls[@]:start:batch_size}")
        start=$((start + batch_size))

        # Format batch as JSON array
        local batch_json
        batch_json=$(printf '%s\n' "${batch[@]}" | jq -R -s -c 'split("\n") | map(select(length > 0))')

        # Prepare the JSON payload
        local payload
        payload=$(cat <<EOF
{
    "urls": $batch_json,
    "userAgent": "browser",
    "userName": "",
    "passWord": "",
    "headerName": "",
    "headerValue": "",
    "strictSSL": true,
    "canonicalDomain": true,
    "additionalSubdomains": ["www"],
    "followRedirect": true,
    "throttleRequests": 100,
    "escapeCharacters": false
}
EOF
)

        # Send request using curl
        echo "Processing batch of ${#batch[@]} URLs..."
        curl -s 'https://backend-v2.httpstatus.io/api' \
            -H 'authority: backend-v2.httpstatus.io' \
            -H 'accept: application/json, text/plain, */*' \
            -H 'accept-language: en-US,en;q=0.9,sv;q=0.8,no;q=0.7,ru;q=0.6,ja;q=0.5' \
            -H 'cache-control: no-cache' \
            -H 'content-type: application/json;charset=UTF-8' \
            -H 'dnt: 1' \
            -H 'origin: https://httpstatus.io' \
            -H 'pragma: no-cache' \
            -H 'referer: https://httpstatus.io/' \
            -H 'sec-ch-ua: "Chromium";v="118", "Google Chrome";v="118", "Not=A?Brand";v="99"' \
            -H 'sec-ch-ua-mobile: ?0' \
            -H 'sec-ch-ua-platform: "macOS"' \
            -H 'sec-fetch-dest: empty' \
            -H 'sec-fetch-mode: cors' \
            -H 'sec-fetch-site: same-site' \
            -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \
            --data-raw "$payload" \
            --compressed | jq

        # Wait for 5 seconds before the next batch if there are more URLs
        if (( start < total_urls )); then
            echo "Waiting 5 seconds before processing the next batch..."
            sleep 5
        fi
    done

    echo "All batches processed successfully."
}

# Usage example: check_urls urls.txt


Total URLs after cleaning and deduplication: 21. Processing in batches of 100...
Processing batch of 21 URLs...
[
  {
    "requestedURL": "http://google.com",
    "numberOfRedirects": "2",
    "redirects": [
      {
        "statusCode": 301,
        "redirectUri": "http://www.google.com/"
      },
      {
        "statusCode": 302,
        "redirectUri": "https://www.google.com/?gws_rd=ssl"
      }
    ],
    "redirectChain": "301 − 302",
    "fullRedirectChain": [
      {
        "statusCode": 301,
        "url": "http://google.com",
        "parsedUrl": {
          "slashes": true,
          "protocol": "http:",
          "hash": "",
          "query": {},
          "pathname": "",
          "auth": "",
          "host": "google.com",
          "port": "",
          "hostname": "google.com",


