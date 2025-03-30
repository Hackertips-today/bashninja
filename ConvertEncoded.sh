# usage ./ConvertEncoded.sh <script.js>  <optional output filename converted.js>

#!/bin/bash

input_file="$1"
output_file="$2"

if [[ -z "$input_file" || ! -f "$input_file" ]]; then
  echo "Usage: $0 input.js [output.js]"
  exit 1
fi

# Decode function: url + html decode
decode_string() {
  local encoded="$1"
  decoded=$(printf '%b' "${encoded//%/\\x}")
  decoded=$(python3 -c "import html; print(html.unescape('''$decoded'''))")

  echo "$decoded"
}

# Use awk to process strings line-by-line
process_file() {
  awk -v OFS="" '
  {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^".*%.*"$/) {
        gsub(/"/, "", $i);
        cmd = "bash -c '\''printf \"%b\" \"" $i "\"'\''";
        cmd | getline decoded;
        close(cmd);
        gsub(/"/, "\\\"", decoded);  # escape quotes
        $i = "\"" decoded "\"";
      }
    }
    print $0
  }' "$1"
}

# Decode and output
if [[ -n "$output_file" ]]; then
  process_file "$input_file" > "$output_file"
  echo "Decoded output written to $output_file"
else
  process_file "$input_file"
fi
