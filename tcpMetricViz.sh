

tcpmetric() {
    local use_ansi=0
    local num_lines=""

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -ansi) use_ansi=1 ;;
            -n|-num) num_lines="$2"; shift ;;
            *) echo "Usage: tcpmetric [-ansi] [-n <number>]"; return 1 ;;
        esac
        shift
    done

    # Define ANSI color codes only if -ansi is used
    if [[ "$use_ansi" -eq 1 ]]; then
        BOLD="\033[1m"
        GREEN="\033[92m"
        CYAN="\033[96m"
        RED="\033[91m"
        YELLOW="\033[93m"
        PURPLE="\033[95m"
        RESET="\033[0m"
    else
        BOLD=""
        GREEN=""
        CYAN=""
        RED=""
        YELLOW=""
        PURPLE=""
        RESET=""
    fi

    # Print table header
    echo -e "${BOLD}${CYAN}Destination IP      | Age (sec)      | CWND  | RTT (ms)   | RTTVar (ms) | Source IP${RESET}"
    echo -e "${BOLD}${PURPLE}---------------------------------------------------------------------------------${RESET}"

    # Process and format output
    sudo ip tcpmetrics | awk -v use_ansi="$use_ansi" -v BOLD="$BOLD" -v GREEN="$GREEN" -v CYAN="$CYAN" -v RED="$RED" -v YELLOW="$YELLOW" -v PURPLE="$PURPLE" -v RESET="$RESET" '
    {
        dest_ip = $1;
        for (i=2; i<=NF; i++) {
            if ($i == "age") age = sprintf("%.0f", $(i+1));  # Fixes scientific notation
            if ($i == "cwnd") cwnd = $(i+1);
            if ($i == "rtt") rtt = sprintf("%.3f", $(i+1) / 1000);
            if ($i == "rttvar") rttvar = sprintf("%.3f", $(i+1) / 1000);
            if ($i == "source") source = $(i+1);
        }

        # Apply ANSI colors if enabled
        if (use_ansi == 1) {
            printf "%s%-18s%s | %s%-13s%s | %s%-5s%s | %s%-9s%s | %s%-11s%s | %s%s%s\n", 
                GREEN, dest_ip, RESET,
                YELLOW, age, RESET,
                CYAN, cwnd, RESET,
                RED, rtt, RESET,
                PURPLE, rttvar, RESET,
                GREEN, source, RESET;
        } else {
            printf "%-18s | %-13s | %-5s | %-9s | %-11s | %s\n", dest_ip, age, cwnd, rtt, rttvar, source;
        }
    }' | { [[ -n "$num_lines" ]] && head -n "$num_lines" || cat; }
}


Example:
bash# tcpmetrics

Destination IP      | Age (sec)      | CWND  | RTT (ms)   | RTTVar (ms) | Source IP
---------------------------------------------------------------------------------
181.89.67.218      | 2597479       | 10    | 2281.638  | 1725.909    | 104.x.191.232
205.210.31.181     | 1530119       | 10    | 183.877   | 183.877     | 104.x.191.232
185.208.159.217    | 424665        | 10    | 152.313   | 152.313     | 104.x.191.232
103.69.226.3       | 2063153       | 10    | 269.568   | 86.566      | 104.x.191.232
165.227.109.79     | 2173500       | 10    | 82.518    | 28.227      | 104.x.191.232
39.155.191.166     | 1408103       | 10    | 199.451   | 199.451     | 104.x.191.232
147.185.132.55     | 172721        | 10    | 199.451   | 199.451     | 104.x.191.232
142.223.221.81     | 40421         | 10    | 145.618   | 145.618     | 104.x.191.232
175.205.2.214      | 2438593       | 10    | 137.298   | 137.298     | 104.x.191.232
113.88.69.144      | 257318        | 10    | 168.900   | 168.900     | 104.x.191.232
108.235.203.63     | 723026        | 10    | 80.256    | 80.256      | 104.x.191.232
207.90.244.18      | 2411085       | 10    | 43.117    | 26.158      | 104.x.191.232
144.126.229.234    | 2444788       | 10    | 169.368   | 169.368     | 104.x.191.232
186.31.95.163      | 210664        | 10    | 169.368   | 169.368     | 104.x.191.232
47.236.71.14       | 4227668       | 10    | 181.953   | 83.650      | 104.x.191.232
151.153.40.223     | 2870532       | 10    | 1.269     | 0.938       | 104.x.191.232
140.246.198.58     | 2172012       | 10    | 212.605   | 129.989     | 104.x.191.232
80.66.76.134       | 681969        | 10    | 212.605   | 129.989     | 104.x.191.232
18.173.121.54      | 574740        | 10    | 2.087     | 2.087       | 104.x.191.232
193.69.50.127      | 928129        | 10    | 165.442   | 41.434      | 104.x.191.232



