#!/bin/bash

# Function to search for patterns in a specified file
function find_regex_matches() {
    local target_file="$1"
    local regex_file="${2:-regex.txt}"  # Default to regex.txt if $2 is not provided

    # Check if target file is provided
    if [[ -z "$target_file" || ! -f "$target_file" ]]; then
        echo -e "\033[31mError: Target file is missing or does not exist.\033[0m"
        echo "Usage: find_regex_matches <target_file> [regex_file]"
        return 1
    fi

    # Check if regex file exists
    if [[ ! -f "$regex_file" ]]; then
        echo -e "\033[31mError: Regex file ($regex_file) does not exist.\033[0m"
        return 1
    fi

    # Output file for matches
    local output_file="matches.txt"
    > "$output_file"  # Clear any previous output

    # Read each regex pattern from the regex file
    while IFS= read -r regex; do
        echo -e "\n\033[34mChecking for pattern:\033[0m $regex"

        # Search for matches in the target file
        local matches_found=false
        while IFS= read -r line; do
            # Check each line against the regex
            if echo "$line" | grep -Eo "$regex" >/dev/null 2>&1; then
                matches_found=true
                # Print matches to console and save to file
                matched_text=$(echo "$line" | grep -Eo "$regex")
                echo -e "\033[32m[POSSIBLE MATCH] $matched_text -> Pattern: $regex\033[0m"
                echo "Match found: $matched_text -> Pattern: $regex" >> "$output_file"
            fi
        done < "$target_file"

        # If no matches found, print in red
        if [[ "$matches_found" == false ]]; then
            echo -e "\033[31m$regex - NONE FOUND\033[0m"
        fi
    done < "$regex_file"

    echo -e "\n\033[33mProcessing complete. Results saved to $output_file\033[0m"
}

# find_regex_matches "$1" "$2"   $1 filename to search for    $2 lines of regex one per line



