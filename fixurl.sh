# Bash function to clean up a url encoded html encoded etc url .. 
# set  $url="https://encodedurl.com"

#run  fixurl "$url"


fixurl() {
    local url="$1"
    local decoded_url

    while :; do
        # 1. Decode URL-encoded characters (%XX → ASCII)
        decoded_url=$(echo -e "$(printf '%b' "${url//%/\\x}")")

        # 2. Decode Unicode escaped sequences (\u0026 → &), fix slashes (\/ → /)
        decoded_url=$(echo "$decoded_url" | sed -E \
            -e 's/\\u0026/\&/g' -e 's/\\u003d/=/g' \
            -e 's/\\u([0-9A-Fa-f]{4})/$(printf "\x\1")/g' \
            -e 's/\\x([0-9A-Fa-f]{2})/$(printf "\x\1")/g' \
            -e 's/\\\//\//g' )  # Remove escaped forward slashes

        # 3. Decode HTML entities (&amp; → &, &lt; → <, etc.)
        decoded_url=$(echo "$decoded_url" | sed -E \
            -e 's/&amp;/\&/g' \
            -e 's/&lt;/</g' \
            -e 's/&gt;/>/g' \
            -e 's/&quot;/"/g' \
            -e "s/&#39;/'/g" \
            -e 's/&#x([0-9A-Fa-f]+);/$(printf "\x\1")/g' )  # Hex-based HTML encoding

        # 4. Stop looping if no further decoding is needed
        if [[ "$decoded_url" == "$url" ]]; then
            break
        fi
        url="$decoded_url"
    done

    # Export the fixed URL for reuse
    export fixedurl="$decoded_url"

    # Output result
    echo
    echo "Fixed URL:"
    echo "$fixedurl"
    echo
    echo "✅ Exported as \$fixedurl"
    echo
}
