# This safe bash script will take one param $1 in the format of the unigen.sh script

Script - 
unicodeformats.sh - chmod +x unicodeformats.sh 

#!/bin/bash

unicode_to_percent() {
    local unicode_hex="${1/U+/}"
    local utf8_bytes=$(echo -ne "\U$unicode_hex" | hexdump -v -e '/1 "%02X"')
    local percent_encoded=$(echo "$utf8_bytes" | sed 's/../%&/g')
    echo "$percent_encoded"
}

percent_to_unicode() {
    local percent_encoded="$1"
    local utf8_bytes=$(echo "$percent_encoded" | sed 's/%//g')
    local unicode_code=$(echo "$utf8_bytes" | xxd -r -p | iconv -f UTF-8 -t UTF-32BE | hexdump -v -e '/4 "U+%08X"')
    unicode_code=$(echo "$unicode_code" | sed 's/U+0*\([0-9A-Fa-f]\+\)$/U+\1/')
    echo "$unicode_code"
}

input="$1"

if [[ "$input" =~ ^U\+[0-9A-Fa-f]+$ ]]; then
    unicode_to_percent "$input"
elif [[ "$input" =~ ^(%[0-9A-Fa-f]{2})+$ ]]; then
    percent_to_unicode "$input"
else
    echo "Invalid input format. Provide either 'U+XXXX' or '%XX%XX'."
    exit 1
fi




Example Output:
./unicodeformats.sh "U+01C1"
output: %C7%81

or in reverse:
./unicodeformats.sh "%C7%81"
output: U+C101

