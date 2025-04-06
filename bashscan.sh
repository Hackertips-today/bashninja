
#!/bin/bash

# validation of the CLI params   $1 ip 1.1.1.   $2 port
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <base_ip_prefix> <port>"
  echo "Example: $0 192.168.1 80"
  exit 1
fi

base_ip="${1%.*}."  # Ensure trailing dot if user typed "1.2.3" or "1.2.3."
port="$2"

seq 1 254 | parallel -j50 "
  ip=${base_ip}{};
  resp=\$(curl -m 2 -s -D - -o /dev/null \"http://\$ip:$port\");
  code=\$(echo \"\$resp\" | grep HTTP | awk '{print \$2}');
  server=\$(echo \"\$resp\" | grep -i '^Server:' | cut -d' ' -f2-);
  if [[ \"\$code\" != \"000\" && -n \"\$code\" ]]; then
    if [[ -n \"\$server\" ]]; then
      echo \"[\$code] : \$ip : Server: \$server\"
    else
      echo \"[\$code] : \$ip\"
    fi
  fi
"



Example output:
./scan2.sh 1.1.1. 80
[301] : 1.1.1.1 : Server: cloudflare
[301] : 1.1.1.2 : Server: cloudflare
[403] : 1.1.1.4 : Server: cloudflare
[301] : 1.1.1.3 : Server: cloudflare
[403] : 1.1.1.5 : Server: cloudflare
[403] : 1.1.1.6 : Server: cloudflare
[403] : 1.1.1.7 : Server: cloudflare
[403] : 1.1.1.8 : Server: cloudflare

