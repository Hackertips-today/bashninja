
SPINNER ! in bash
----

#!/bin/bash

# Function to display the spinning [X] character
function show_spinner() {
    local delay=0.1;    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏';    local i=0
    while true; do
         printf "\r${spinstr:$i:1} ";        sleep $delay;        ((i = (i + 1) % ${#spinstr}));    
done
			}

# Function to check if the response contains "not found" and display [X]
function check_response() {
    if grep -q "not found" <<< "$1"; then
        tput el    # Clear the spinner line
        printf "\r[\033[31mX\033[0m] "
    fi
}

THREEOC="3.88.70."
export -f check_response

# Start the spinner in the background
show_spinner &
spinner_pid=$!

# Run the commands and check responses
seq 0 255 | parallel -j 5 "host $THREEOC{} | check_response"

# Stop the spinner
kill $spinner_pid
wait $spinner_pid 2>/dev/null   # Suppress the "Terminated" message

# Move cursor to the next line after the output
echo
