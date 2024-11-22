
[------------------------------------------------------------------------------------------]
██████╗  █████╗ ██████╗ ███████╗███████╗    ██╗  ██╗███████╗ █████╗ ██████╗ ███████╗██████╗ 
██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝    ██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗
██████╔╝███████║██████╔╝███████╗█████╗      ███████║█████╗  ███████║██║  ██║█████╗  ██████╔╝
██╔═══╝ ██╔══██║██╔══██╗╚════██║██╔══╝      ██╔══██║██╔══╝  ██╔══██║██║  ██║██╔══╝  ██╔══██╗
██║     ██║  ██║██║  ██║███████║███████╗    ██║  ██║███████╗██║  ██║██████╔╝███████╗██║  ██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
-========================= [ P A R S E   H E A D E R ] ==================================-
                                                                                          
#!/bin/bash

# ANSI color codes
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BRIGHT_BLACK='\033[1;30m'
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_MAGENTA='\033[1;35m'
BRIGHT_CYAN='\033[1;36m'
BRIGHT_WHITE='\033[1;37m'

NC='\033[0m' # No Color

# Function to display a red line for redirects
display_redirect() {
    echo -e "${BRIGHT_RED}--------------------- [ 30x Redirect ] ---------------------${NC}"
}

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

# Modified curl command
curl -sLIk --user-agent 'mozilla' --connect-timeout 3 "$1" | {
    redirect=false
    while IFS= read -r line; do
        # Check for redirects
        if [[ $line =~ ^HTTP.*30[0-9] ]]; then
            redirect=true
        fi

        # Display a red line for redirects
        if $redirect && [[ $line == Location:* ]]; then
            display_redirect
            redirect=false
        fi

        # Process the headers
        if [[ $line == HTTP* ]]; then
            printf "${MAGENTA}%s${NC}\n" "$line"
        elif [[ $line =~ Content-Security-Policy(-Report-Only)? ]]; then
            key=$(echo "$line" | cut -d ':' -f 1)
            value=$(echo "$line" | cut -d ':' -f 2- | sed 's/; /;\n\t/g')
            printf "${RED}%s${NC}:\n\t${MAGENTA}%s${NC}\n" "$key" "$value"
        elif [[ $line =~ Report-To|NEL ]]; then
            key=$(echo "$line" | cut -d ':' -f 1)
            value=$(echo "$line" | cut -d ':' -f 2- | sed 's/,/,\n\t/g')
            printf "${YELLOW}%s${NC}:\n\t${CYAN}%s${NC}\n" "$key" "$value"
        else
            key=$(echo "$line" | cut -d ':' -f 1)
            value=$(echo "$line" | cut -d ':' -f 2-)
            printf "${CYAN}%s${NC}: ${BRIGHT_WHITE}%s${NC}\n" "$key" "$value"
        fi
    done
} | perl -MURI::Escape -nle 'print uri_unescape($_)'


Example output - 
./parseHeader.sh google.com/maps
HTTP/1.1 301 Moved Permanently
--------------------- [ 30x Redirect ] ---------------------
Location:  http://www.google.com/maps
Content-Type:  text/html; charset=UTF-8
Content-Security-Policy-Report-Only:
         object-src 'none';base-uri 'self';script-src 'nonce-iuW1Xx1hOaA0CTvz68ifDg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/maps-tactile
Date:  Fri, 22 Nov 2024 03:27:51 GMT
Expires:  Sun, 22 Dec 2024 03:27:51 GMT
Cache-Control:  public, max-age=2592000
Server:  gws
Content-Length:  223
X-XSS-Protection:  0
X-Frame-Options:  SAMEORIGIN


HTTP/1.1 200 OK
Content-Type:  text/html; charset=ISO-8859-1
Content-Security-Policy-Report-Only:
         object-src 'none';base-uri 'self';script-src 'nonce-4v49J-EQ9gVTyKc4CUK2aw' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/maps-tactile
P3P:  CP="This is not a P3P policy! See g.co/p3phelp for more info."
Date:  Fri, 22 Nov 2024 03:27:51 GMT
Server:  gws
X-XSS-Protection:  0
X-Frame-Options:  SAMEORIGIN
Transfer-Encoding:  chunked
Expires:  Fri, 22 Nov 2024 03:27:51 GMT
Cache-Control:  private
Set-Cookie:  NID=519=bbG3Fzs-pQF3lSTIrZBDr9Fj<snip>RhVsHow5lLGA34WyqWUcf0cokxNPBP-fLx9lw-RSR_3vJzZQYTT9Y-pe1441UEl-4smeYMMuFV0jUaPEPPZ2jgl88vZ5JIdcZZb1NtP2qn6dx87YXaZgJe5ijVgHWEFKPHvzSZDzCx6zw; expires=Sat, 24-May-2025 03:27:51 GMT; path=/; domain=.google.com; HttpOnly



