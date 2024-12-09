
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
     _______ _____ _____              _____            _        _     _____                        
    |__   __/ ____|  __ \            / ____|          | |      | |   |  __ \                       
   __ _| | | |    | |__) |  ______  | (___   ___   ___| | _____| |_  | |  | |_   _ _ __ ___  _ __  
  / _` | | | |    |  ___/  |______|  \___ \ / _ \ / __| |/ / _ \ __| | |  | | | | | '_ ` _ \| '_ \ 
 | (_| | | | |____| |                ____) | (_) | (__|   <  __/ |_  | |__| | |_| | | | | | | |_) |
  \__, |_|  \_____|_|               |_____/ \___/ \___|_|\_\___|\__| |_____/ \__,_|_| |_| |_| .__/ 
   __/ |                                                                                    | |    
  |___/                                                                                     |_|    
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-[ gTCP - SocketDump ] =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

gTCP() (
grep -v "rem_address" /proc/net/tcp  | awk 'function hextodec(str,ret,n,i,k,c){
    ret = 0
    n = length(str)
    for (i = 1; i <= n; i++) {
        c = tolower(substr(str, i, 1))
        k = index("123456789abcdef", c)
        ret = ret * 16 + k
    }    return ret} {x=hextodec(substr($2,index($2,":")-2,2)); for (i=5; i>0; i-=2) x = x"."hextodec(substr($2,i,2))}{print x":"hextodec(substr($2,index($2,":")+1,4))}') # | json_pp | grep http| cut -d "\"" -f 3)

scrape() (
curl -sL "https://web.scraper.workers.dev/?url=https%3A%2F%2F$1&selector=div&scrape=text&pretty=true"
)

alias gIP="grep -oP '\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'"

PS1="\e[1;30m[\e[1;37m9x\e[1;30m]\e[1;37m::\e[0;37m\][\[\e[1;30m\]\@\[\e[0;37m\]]\e[0;35m:\e[0;37m[\[\e[0;37m\]\e[1;37m\w\[\e[0;37;40m\]]\n\[\e[0;37m\][\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[1;36m\]\h-DAICE\[\e[0;37m\]]\[\e[0m\]\$"

alias ww="cd /web/stage.hackertips.today"
#urlencode() { local string="${1}"; local strlen=${#string}; local encoded=""; local pos c o; for (( pos=0 ; pos<strlen ; pos++ ));  }


# ----- Example Output -----

10.0.2.1:46356
10.0.2.1:22
10.0.2.1:35996
10.0.2.1:59542
10.0.2.1:48258
10.0.2.1:39446
10.0.2.1:41152
10.0.2.1:22
10.0.2.1:54662
10.0.2.1:54238
10.0.2.1:53066
10.0.2.1:53708
