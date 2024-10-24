 sysctl -a | grep icmp hashtag#this only works as root
 ^ System Kernel tweaks (-a lists the current settings) 
 ^ only display entries with icmp in it

Output:
---------
net.ipv4.icmp_echo_enable_probe = 0
net.ipv4.icmp_echo_ignore_all = 0 # *******************
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_msgs_burst = 50
net.ipv4.icmp_msgs_per_sec = 1000
net.ipv4.icmp_ratelimit = 1000
net.ipv4.icmp_ratemask = 6168
net.ipv6.icmp.echo_ignore_all = 0 # ********************
net.ipv6.icmp.echo_ignore_anycast = 0
net.ipv6.icmp.echo_ignore_multicast = 0
net.ipv6.icmp.ratelimit = 1000
net.ipv6.icmp.ratemask = 0-1,3-127


If you want to block ICMP - 
sysctl net.ipv4.icmp_echo_ignore_all=1

highly recommended

https://hackertips.today
