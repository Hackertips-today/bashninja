

          _   _   _ ___________        _               _             
         | | | | | |_   _|  _  \      | |             | |            
 ___  ___| |_| | | | | | | | | |   ___| |__   ___  ___| | _____ _ __ 
/ __|/ _ \ __| | | | | | | | | |  / __| '_ \ / _ \/ __| |/ / _ \ '__|
\__ \  __/ |_| |_| |_| |_| |/ /  | (__| | | |  __/ (__|   <  __/ |   
|___/\___|\__|\___/ \___/|___/    \___|_| |_|\___|\___|_|\_\___|_|   
          [ setUID binary checker for Linux ]                                                                     

What is the setuid Bit in Linux?
The setuid (set user ID) bit is a special file permission in Linux.
When applied to an executable file, it allows the file to run with
the privileges of the file's owner, rather than the user executing it.

For example:

If a program is owned by root and has the setuid bit set,
any user running that program executes it with root privileges.
                                                              
Key points:
Understand what this chmod flag does, and how to identify it, also regularly run:
chkrootkit and rkhunter to make sure these files have not been tampered with.

This script will help you find which files have this ability.

-----

#!/bin/bash

# Colors for ANSI styling
GREEN="\e[32m"
BLUE="\e[34m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

# Banner
echo -e "${CYAN}========================================="
echo -e "${YELLOW}  Searching for files with permissions"
echo -e "${GREEN}       -rwsr-xr-x (Set-UID) ${RESET}"
echo -e "${CYAN}=========================================${RESET}"

# Start the search
echo -e "${BLUE}Scanning...${RESET}\n"
find / -type f -perm -4000 2>/dev/null | while read -r file; do
    permissions=$(ls -l "$file" | awk '{print $1}')
    if [[ "$permissions" == "-rwsr-xr-x" ]]; then
        echo -e "${GREEN}[FOUND]${RESET} ${YELLOW}${file}${RESET} ${CYAN}($permissions)${RESET}"
    fi
done

echo -e "\n${GREEN}Search completed.${RESET}"
echo
