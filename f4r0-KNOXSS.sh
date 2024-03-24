#!/bin/bash

echo -e "\e[1;31m"
cat << "EOF"
  █████▒▄▄▄       ██▀███   ▒█████  ▒██   ██▒  ██████   ██████ 
▓██   ▒▒████▄    ▓██ ▒ ██▒▒██▒  ██▒▒▒ █ █ ▒░▒██    ▒ ▒██    ▒ 
▒████ ░▒██  ▀█▄  ▓██ ░▄█ ▒▒██░  ██▒░░  █   ░░ ▓██▄   ░ ▓██▄   
░▓█▒  ░░██▄▄▄▄██ ▒██▀▀█▄  ▒██   ██░ ░ █ █ ▒   ▒   ██▒  ▒   ██▒
░▒█░    ▓█   ▓██▒░██▓ ▒██▒░ ████▓▒░▒██▒ ▒██▒▒██████▒▒▒██████▒▒
 ▒ ░    ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒▒ ░ ░▓ ░▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░
 ░       ▒   ▒▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░ ░░   ░▒ ░░ ░▒  ░ ░░ ░▒  ░ ░
 ░ ░     ░   ▒     ░░   ░ ░ ░ ░ ▒   ░    ░  ░  ░  ░  ░  ░  ░  
             ░  ░   ░         ░ ░   ░    ░        ░        ░  
                                                              
EOF
echo -e "\e[0m"
echo -e "\e[1;32m Welcome to f4r0-KNOXSS - Make Your XSS Hunting Faster & Easy!🔍🔍🔍 \e[0m"

 RESET="\e[0m"
 YELLOW="\e[1;33m"


if [ $# -ne 1 ]; then
    echo "Usage: $0 <subdomains_file>"
    exit 1
fi
subdomains_file=$1

# API key
api_key="<KNOXSS API KEY>"

if [ ! -f "$subdomains_file" ]; then
    echo -e "[+] Error: File $subdomains_file not found."
    exit 1
fi

# Iterate over the list of URLs from urls.txt
while IFS= read -r url; do
    echo "$YELLOW [+] Testing URL: $url ...$RESET"
    
    # Make curl request for each URL
    curl https://api.knoxss.pro -d "target=$url" -H "X-API-KEY: $api_key" -s | grep PoC
done < "$subdomains_file"
