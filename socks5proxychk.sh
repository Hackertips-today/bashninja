

#!/bin/bash

# Array of SOCKS5 proxies
proxies=(
    "163.172.162.184:16379"
    "50.63.12.101:58611"
    "103.143.88.9:1080"
    "162.240.209.28:59881"
    "188.165.220.50:62878"
    "92.205.28.132:25374"
    "67.213.210.62:30959"
    "207.180.204.122:28025"
    "103.160.12.147:8199"
    "149.248.32.102:10810"
    "94.26.248.61:1080"
    "99.107.240.88:1080"
)

# Target URL
target_url="https://ifconfig.me"

# Iterate over each proxy
for proxy in "${proxies[@]}"; do
    echo "Testing proxy: $proxy"
    curl -x socks5://"$proxy" --connect-timeout 3 -A "Mozilla" "$target_url"
    if [ $? -eq 0 ]; then
        echo "Proxy $proxy worked."
    else
        echo "Proxy $proxy failed."
    fi
    echo "-----------------------------------"
done

