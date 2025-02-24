# Function name: ipChk() for bash


ipChk() (
echo "----- [LAN] -------"
OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
    # macOS Commands
    default_route=$(route -n get default | awk '/gateway:/ {print $2}')
    active_interface=$(route -n get default | awk '/interface:/ {print $2}')
    local_ip=$(ifconfig "$active_interface" 2>/dev/null | awk '/inet / {print $2}' | head -n 1)
elif [[ "$OS" == "Linux" ]]; then
    # Linux (Ubuntu, CentOS 7+, RHEL)
    if command -v ip &>/dev/null; then
        default_route=$(ip route | awk '/default/ {print $3}')
        active_interface=$(ip route | awk '/default/ {print $5}')
        local_ip=$(ip -4 addr show "$active_interface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1)
    else
        # Legacy CentOS (CentOS 6/RHEL 6)
        default_route=$(route -n | awk '/^0.0.0.0/ {print $2}')
        active_interface=$(route -n | awk '/^0.0.0.0/ {print $8}')
        local_ip=$(ifconfig "$active_interface" 2>/dev/null | awk '/inet addr:/ {print $2}' | cut -d: -f2)
    fi
else
    echo "Unsupported OS: $OS"
    exit 1
fi

hostname=$(host "$default_route" 2>/dev/null | awk '{print $NF}')
[[ "$hostname" == *"NXDOMAIN"* ]] && hostname="(unknown)"
echo "Default Route: ${default_route:-N/A} ${hostname:-N/A}"
echo ""
echo "Active Network Interfaces:"
ifconfig -a | grep 'UP\|inet' | grep -v inet6 | awk '
    /^[a-z]/ {iface=$1} 
    /inet / {print "  " iface " -> IP: " $2 ", Mask: " $4}
'

echo ""

# WAN Section
echo "----- [WAN] -------"
echo -n "[$(date '+%H:%M:%S')] " && 
curl -s ifconfig.me/all | grep -E 'ip_addr:|remote_host:|user_agent:|port:|language:|referer:|connection:|keep_alive:|method:|encoding:|mime:|charset:|via:|forwarded:' | awk -F': ' '$2 != "" {print $1 ": " $2}'
)

