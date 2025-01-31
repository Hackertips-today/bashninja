#!/bin/bash

# File containing failed SSH authentication log
LOG_FILE="/var/log/ssh_FAIL_auth.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file $LOG_FILE not found!"
  exit 1
fi

# Extract IP addresses, count occurrences, sort by frequency, and display the top 50
echo "Top 50 IPs with most failed SSH authentication attempts:"
cat "$LOG_FILE" | cut -d " " -f 8 | sort | uniq -c | sort -nr | head -50 | awk '{printf "[%d] - %s\n", $1, $2}'



Example:
Top 50 IPs with most failed SSH authentication attempts:
[22524] - 218.92.0.163
[9599] - 180.101.88.246
[9003] - 218.92.0.184
[3829] - 218.92.0.48
[3248] - 218.92.0.164
[2449] - 218.92.0.181
[2378] - 218.92.0.166
[1984] - 202.4.115.170
[1756] - 62.121.224.104
[1200] - 218.92.0.248
[1200] - 218.92.0.185
[1141] - 218.92.0.165
[1053] - 218.92.0.187
[914] - 218.92.0.186
[585] - 92.255.85.188
[577] - 92.255.85.189
[542] - 154.213.187.41
[483] - 156.238.99.155
[475] - 218.92.0.39
[468] - 218.92.0.209
[456] - 218.92.0.225
[455] - 218.92.0.112
[448] - 218.92.0.232
[448] - 218.92.0.231
[448] - 218.92.0.223
[446] - 218.92.0.237
[442] - 181.113.114.115
[441] - 218.92.0.228
[436] - 43.248.185.124
[432] - 218.92.0.222
[430] - 218.92.0.215
[429] - 218.92.0.252
[427] - 94.188.60.5
