Filename: proxyscan.sh
Purpose: Scan thru list of <host>:<port> (proxy.txt) against ifconfig.me/all identifying open proxys
Prereq's: none/ just curl

#!/bin/bash



# Check if proxy.txt exists

if [ ! -f proxy.txt ]; then

  echo "proxy.txt not found!"

  exit 1

fi



# Read the file line by line

while IFS= read -r proxy

do  

  echo "Attempting to connect through proxy: $proxy"

  echo "---  [ $proxy ] -----------------------"
  # Use curl with the specified proxy
timeout 3  curl -sLkv -A 'goog' --proxy "https://$proxy" https://ifconfig.me/all --max-time 10
  echo ""
  echo "--------------------------------------------------"
  echo ""
done < proxy.txt
----------------------------------

- What is going on here:
This prox.sh script is looping through the ip's listed in proxy.txt (it should be ip:port on each line or hostname:port)
it attempts to use that proxy and visit https://ifconfig[dot]me/all - if it is successful, you will see an IP returned
(it might be the proxy ip it might not) you will notice due to the /all .. it should return at least 15 lines.  
add a sleep 3 after each loop or .. to capture all output
run:


script proxypossible.txt
 ^ Once you run the script cmd, bash will log all output shown on stdout to that filename, type exit to stop saving, 
 this is a good way to capture all output (incase you miss a working proxy)



[ proxylists ]
start with these lists, note the protocol) 
http://
https://
socks5://

https://spys[dot]me/socks.txt <- 

https://raw.githubusercontent[dot]com/clarketm/proxy-list/refs/heads/master/proxy-list.txt 


----------
bash$ ./prox.sh 

Attempting to connect through proxy: 113.176.118.150:1080
---  [ 113.176.118.150:1080 ] -----------------------
* processing: https://ifconfig.me/all
*  Trying 113.176.118.150:1080...

look for an ip not yours in the responses!


