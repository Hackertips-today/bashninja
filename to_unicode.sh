
# Display all unicode chars and codes


#!/bin/bash

# Starting Unicode point
start_point=0x0000

# Function to URL encode the character
url_encode() {
  local char=$1
  printf "%%%02X" "'$char"
}

# Function to print 500 Unicode characters
print_chars() {
  local start=$1
  local count=0

  echo -e "\nDisplaying Unicode characters from $(printf 'U+%04X' "$start")"

  # Loop through Unicode points, 500 at a time
  for (( i=$start; count<500; i++ )); do
    # Get the string name (hex) and character
    char=$(printf '\\U%08X' "$i")
    hex_name=$(printf 'U+%04X' "$i")
    
    # Extract actual character (avoiding escape sequences)
    real_char=$(printf "%b" "$char")
    
    # URL encode the character
    url_encoded=$(url_encode "$real_char")
    
    # Check if the character is printable or replace with placeholder
    if [[ "$real_char" =~ [[:print:]] ]]; then
      printf "%-12s %-2s %-12s " "$hex_name" "$real_char" "$url_encoded"
    else
      printf "%-12s %-2s %-12s " "$hex_name" "�" "$url_encoded"  # Replacement character for missing glyphs
    fi

    # Print 4 characters per row
    if (( (count+1) % 4 == 0 )); then
      echo ""
    fi

    ((count++))
  done
}

# Pagination loop for displaying 500 characters at a time
while true; do
  clear
  print_chars "$start_point"

  # Increment the start point by 500 for the next page
  start_point=$((start_point + 500))

  # Prompt for next page or exit
  read -p "Press Enter to see the next 500 characters or type 'q' to quit: " input
  [[ $input == "q" ]] && break
done

