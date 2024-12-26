#!/bin/bash

# Read input piped to the script
while IFS= read -r line; do
    # Extract values from key-value pairs using regex
    echo "$line" | grep -oE '"[^"]+":\s*"[^"]+"' | while IFS= read -r pair; do
        # Extract the value part (remove quotes around it)
        value=$(echo "$pair" | sed -E 's/^"[^"]+":\s*"([^"]+)"/\1/')
        
        # Attempt to decode the value as Base64
        decoded=$(echo "$value" | base64 -d 2>/dev/null)

        # Check if the decoding succeeded
        if [[ $? -eq 0 ]]; then
            # Output valid decodes in green ANSI
            echo -e "\e[32mDecoded:\e[0m $decoded"
        else
            # Output invalid values in normal text
            echo "Invalid Base64: $value"
        fi
    done
done




