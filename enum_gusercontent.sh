
#!/bin/bash

# Spinner animation
spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}

# Main script logic
try_urls() {
  local seq_range=$(seq 1 99)
  
  for i in $seq_range; do
    # Determine the URL(s) to check
    if [[ $1 == "-2" ]]; then
      for j in $(seq 1 254); do
        url1="https://184.75.${j}.${i}.b"
        status_code=$(curl -I -k -s "$url1" | grep -oP '^HTTP/[0-9.]+\s+\K[0-9]+')
        if [[ "$status_code" == "200" || "$status_code" == "301" ]]; then
          echo "$url1 returned status code $status_code"
        fi
      done
    else
      url2="https://184.75.149.${i}.bc.googleusercontent.com/"
      status_code=$(curl -I -k -s "$url2" | grep -oP '^HTTP/[0-9.]+\s+\K[0-9]+')
      if [[ "$status_code" == "200" || "$status_code" == "301" ]]; then
        echo "$url2 returned status code $status_code"
      fi
    fi
  done
}

# Start the spinner in the background
echo "Processing, please wait..."
try_urls "$@" &
spinner_pid=$!
spinner $spinner_pid
wait $spinner_pid

echo "Done."


output
 ./gusercontent.sh 
Processing, please wait...
https://184.75.149.34.bc.googleusercontent.com/ returned status code 200
Done. 



