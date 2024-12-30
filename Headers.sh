
   ________                    __  __               __              
  / ____/ /__  ____ _____     / / / /__  ____ _____/ /__  __________
 / /   / / _ \/ __ `/ __ \   / /_/ / _ \/ __ `/ __  / _ \/ ___/ ___/
/ /___/ /  __/ /_/ / / / /  / __  /  __/ /_/ / /_/ /  __/ /  (__  ) 
\____/_/\___/\__,_/_/ /_/  /_/ /_/\___/\__,_/\__,_/\___/_/  /____/  
          [ Clean up response headers with jq ]
          


headers.sh:
------------
#!/bin/bash

# Check if the user provided an argument (URL)
if [ -z "$1" ]; then
  echo "Usage: ./headers.sh \"https://example.com\""
  exit 1
fi

# Validate that the URL starts with "http://" or "https://"
if [[ "$1" != http://* ]] && [[ "$1" != https://* ]]; then
  echo "Error: Please enter a valid URL starting with http:// or https://"
  exit 1
fi

# Fetch redirect information using curl
response=$(curl -sL --user-agent 'moz' 'https://redirectchecker.com/api/redirect' \
  -H 'authority: redirectchecker.com' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.9,sv;q=0.8,no;q=0.7,ru;q=0.6,ja;q=0.5' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'cookie: _ga=GA1.1.1526346099.1710273304; _ga_85FMB7HHLC=GS1.1.1710279221.2.0.1710279221.60.0.0' \
  -H 'dnt: 1' \
  -H 'origin: https://redirectchecker.com' \
  -H 'pragma: no-cache' \
  -H 'referer: https://redirectchecker.com/' \
  -H 'sec-ch-ua: "Chromium";v="118", "Google Chrome";v="118", "Not=A?Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Kona' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw "url=$1&canonical=0&domainchk=www&useragent=browser&strictssl=0&schemeless=0&password=&username=&Header_name=&Header_value=&dataType=json")

# Debug: Print full response to verify structure
echo "$response"

# Extract the status code using jq
status_code=$(echo "$response" | jq '.code' -r)

# Check if the status code is a 3xx redirect
if [[ "$status_code" =~ ^3[0-9][0-9]$ ]]; then
  echo "Redirect detected with status code: $status_code"
  echo "URL redirects to: $(echo "$response" | jq '.final_url' -r)"
  
  # Prompt the user to continue after detecting a redirect
  read -p "Hit Enter to continue..."
else
  echo "No redirect detected. Status code: $status_code"
fi



#[EOF]
--------------
apt-get install jq -y 

To show to default headers in JSON from *not* your IP:

Usage:
./headers.sh  "https://cloudflare.com/cdn-cgi/"| jq # Pick any URI 


Output Example:
{
  "web": [
    {
      "headers": {},
      "original": {
        "site_header": {
          "https://cloudflare.com/cdn-cgi/": [
            {
              "domain": "https://cloudflare.com/cdn-cgi/",
              "uid": "<>",
              "message": "Not Found",
              "redirect": "https://cloudflare.com/cdn-cgi/",
              "code": 404,
              "color": "#ff0000",
              "header": {
                "code": 404,
                "Date": "Mon, 30 Dec 2024 06:52:54 GMT",
                "Connection": "keep-alive",<>-XO7rL31jzEy3Zdo9abWiCuiA57AQIv24rtENG0lUOGI-1735541574-1.0.1.1-Z.t<>; path=/; expires=Mon, 30-Dec-24 
                                           07:22:54 GMT; domain=.cloudflare.com; HttpOnly; Secure; SameSite=None",
                "Report-To": "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4? s=I%2FPOs5hJsya7bUdkmglS<>%2FmsUQ8MRMDcEjLNGMuMcx2uESENqqIef\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
                "NEL": "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
                "Strict-Transport-Security": "max-age=15780000; includeSubDomains",
                "Server": "cloudflare",
                "CF-RAY": "",
                "alt-svc": "h3=\":443\"; ma=86400"
              }
            }
          ]
        }
      },
      "exception": null
    }
  ]
}


---------------------------------------------------------------------------------------------------------------------------------------------
