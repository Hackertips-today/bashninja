#!/bin/bash
# Visit hackertips.today or https://github.com/orgs/Hackertips-today/repositories for more cool code


# Function to display help menu
show_help() {
    echo "Usage: $0 [OPTION] [VALUE]"
    echo ""
    echo "Options:"
    echo "  --input [filename]   Read from stdin or a file and count characters."
    echo "  -hex, --HeX [value]      Convert a hexadecimal value to decimal."
    echo "  -10, --base10 [value]    Convert a decimal value (1-1,000,000) to hexadecimal."
    echo ""
    echo "Examples:"
    echo "  $0 -i                    (Interactive mode, press CTRL+K to stop)"
    echo "  $0 --input myfile.txt         (Read from 'myfile.txt' and count characters)"
    echo "  $0 -hex D46E             (Convert hex 'D46E' to decimal)"
    echo "  $0 -10 54382         (Convert decimal '54382' to hex)"
    exit 1
}

# Function to count characters (both for STDIN and file)
count_chars() {
    local char_count=0
    local input_mode="$1"

    if [[ "$input_mode" == "stdin" ]]; then
        echo "Start typing (Press CTRL+K to stop):"
        while IFS= read -r line; do
            if [[ "$line" == $'\x0B' ]]; then  # CTRL+K detected
                break
            fi
            char_count=$((char_count + ${#line} + 1))
        done
    else
        if [[ ! -f "$input_mode" ]]; then
            echo "Error: File '$input_mode' not found."
            exit 1
        fi
        char_count=$(wc -c < "$input_mode")  # Get character count including newlines
    fi

    hex_count=$(printf "%X" "$char_count")
    octal_count=$(printf "%o" "$char_count")
    binary_count=$(echo "obase=2; $char_count" | bc)
    base36_count=$(echo "obase=36; $char_count" | bc)

    echo -e "\nTotal characters:"
    echo "Decimal (Base 10)   : $char_count"
    echo "Hexadecimal (Base 16): 0x$hex_count"
    echo "Octal (Base 8)       : 0$octal_count"
    echo "Binary (Base 2)      : $binary_count"
    echo "Base 36              : $base36_count"
    echo -e "\n(For Base64 encoding, use:  echo -n '<value>' | base64)"
    exit 0
}

# Function to convert hex to decimal
hex_to_decimal() {
    local hex_value=$(echo "$1" | tr '[:lower:]' '[:upper:]')  # Normalize to uppercase
    if [[ ! "$hex_value" =~ ^[0-9A-F]+$ ]]; then
        echo "Error: Invalid hexadecimal value '$1'. Use only [0-9A-F]."
        exit 1
    fi

    decimal_value=$((16#$hex_value))  # Convert hex to decimal
    echo "Hexadecimal: $hex_value"
    echo "Decimal    : $decimal_value"
    exit 0
}

# Function to convert decimal to hex
decimal_to_hex() {
    if [[ ! "$1" =~ ^[0-9]+$ ]] || (( $1 < 1 || $1 > 1000000 )); then
        echo "Error: Enter a valid decimal number between 1 and 1,000,000."
        exit 1
    fi

    hex_value=$(printf "%X" "$1")  # Convert decimal to hex
    echo "Decimal    : $1"
    echo "Hexadecimal: 0x$hex_value"
    exit 0
}

# Check for CLI arguments
if [[ $# -eq 0 ]]; then
    show_help
fi

# Process CLI options
case "$1" in
    -i|--input)
        if [[ -z "$2" ]]; then
            count_chars "stdin"  # Read from STDIN
        else
            count_chars "$2"  # Read from file
        fi
        ;;
    -hex|--HeX)
        if [[ -z "$2" ]]; then
            echo "Error: Missing hex value. Example: $0 -hex D46E"
            exit 1
        fi
        hex_to_decimal "$2"
        ;;
    -10|--base10)
        if [[ -z "$2" ]]; then
            echo "Error: Missing decimal value. Example: $0 -base10 54382"
            exit 1
        fi
        decimal_to_hex "$2"
        ;;
    *)
        echo "Error: Invalid option '$1'"
        show_help
        ;;
esac


Example output:
bash$ ./charCount.sh -i    #interactive
# paste in payload
<snip>
F
AAAAAAAAAAAAAAA
F
AAAAAAAAAAAAAAA

^K

// IMPORTANT - End input with CTRL K


Total characters:
Decimal (Base 10)   : 54010
Hexadecimal (Base 16): 0xD2FA
Octal (Base 8)       : 0151372
Binary (Base 2)      : 1101001011111010
Base 36              :  01 05 24 10

(For Base64 encoding, use:  echo -n '<value>' | base64)

---- Counting from a file
[ls -altr payload3.txt 
-rw-r--r--  1 user  staff  54010 Mar 12 17:12 payload3.txt
# file is 54k

bash$ ./charCount.sh --input ./payload3.txt 

Total characters:
Decimal (Base 10)   :    54010
Hexadecimal (Base 16): 0xD2FA
Octal (Base 8)       : 0151372
Binary (Base 2)      : 1101001011111010
Base 36              :  01 05 24 10

(For Base64 encoding, use:  echo -n '<value>' | base64)


