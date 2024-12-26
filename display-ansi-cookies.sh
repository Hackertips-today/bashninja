function color_cookies() {
    # Define ANSI color codes
    local reset="\e[0m"
    local bright_green="\e[1;32m"
    local light_cyan="\e[1;36m"
    local light_purple="\e[1;35m"
    local purple="\e[0;35m"
    local grey="\e[1;30m"
    local white="\e[1;37m"
    local red="\e[1;31m"

    # Input file
    local input_file="cookies.txt"
    if [[ ! -f $input_file ]]; then
        echo -e "${red}Error: ${input_file} not found in the current directory.${reset}"
        return 1
    fi

    # Process each line in the file
    while IFS=$'\t' read -r name value domain path expires size secure httponly samesite priority; do
        # Skip invalid lines (e.g., headers or empty lines)
        [[ -z $name || -z $domain ]] && continue

        # Format output with colors
        printf "${bright_green}%s${reset}\t" "$name"         # Cookie name
        printf "${light_cyan}%s${reset}\t" "$value"         # Cookie value
        printf "${grey}%s${reset}\t" "$domain"             # Domain
        printf "${white}%s${reset}\t" "$path"              # Path
        printf "${red}%s${reset}\t" "${expires:-Session}"  # Expiry date
        printf "${light_purple}%s${reset}\t" "$size"       # Size
        printf "${purple}%s${reset}\t" "${secure:-No}"     # Secure
        printf "${light_purple}%s${reset}\t" "${httponly:-No}" # HttpOnly
        printf "${grey}%s${reset}\t" "${samesite:-None}"   # SameSite
        printf "${white}%s${reset}\n" "${priority:-Medium}"# Priority
    done < "$input_file"
}


[ ------ cookies.txt ------ ] Take an export of cookies from the cookiejar with curl
__Host-GMAIL_SCH	nsl	 mail.google.com	/	Session	19		✓				Medium
__Host-GMAIL_SCH_GML	1	= mail.google.com	/	2025-01-12T08:12:44.647Z	21	✓	✓	Lax			Medium
__Host-GMAIL_SCH_GMN	1	= mail.google.com	/	2025-01-12T08:12:44.646Z	21	✓	✓				Medium
__Host-GMAIL_SCH_GMS	1	 mail.google.com	/	2025-01-12T08:12:44.647Z	21	✓	✓	Strict			Medium
__Secure-1PAPISID	1LfiA60Uy19_43ju/AWlDvYvZJVss3UbFy	.google.com	/	2025-06-09T01:26:43.075Z	51		✓				High
__Secure-1PSID	g.a000rAjYxknHwbNP9TMgs34mO<snip>jfXutbQ1eVbTxy_kXXKXvfbFj03QqKcrM2XH_SZQ-v0076	.google.com	/	2025-06-09T01:26:43.074Z	167	✓	✓				High
__Secure-1PSIDCC	AKEyXzXGppHXgVsT9wAA4<snip>meV-NxIFGT-3PLCI2MqxIxHn7h1qMhGvjfGO5UwM	.google.com	/	2025-06-19T06:42:57.311Z	91	✓	✓			High
__Secure-1PSIDTS	sidts-CjIB7wV3sY4JH<snip>WTHt9snTd3mitwLXc1H_Bxa6yEi2BqqKZeWo7Ew3SFxAA	.google.com	/	2025-06-19T06:34:18.370Z	94	✓	✓			High


the function reads in cookies.txt from curljar output and shows it in ANSI




