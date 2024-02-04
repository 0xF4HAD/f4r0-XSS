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
echo -e "\e[1;32m Find XSS Vulnerable  Parameter...  \e[0m"



   url=$1 
   RESET="\e[0m"
   YELLOW="\e[1;33m"


# Making Dir

    if [ ! -d "$url" ];then
        mkdir $url
    fi
    if [ ! -d "$url/recon" ];then
        mkdir $url/recon
    fi
    if [ ! -f "$url/recon/final.txt" ];then
        touch $url/recon/final.txt
    fi
    if [ ! -f "$url/recon/final_urls.txt" ];then
        touch $url/recon/final_urls.txt
    fi
    if [ ! -f "$url/recon/final_urls1.txt" ];then
        touch $url/recon/final_urls1.txt.txt
    fi
    if [ ! -f "$url/recon/200_urls.txt" ];then
        touch $url/recon/200_urls.txt
    fi
    if [ ! -f "$url/recon/ParamSpider_urls.txt" ];then
        touch $url/recon/ParamSpider_urls.txt
    fi
    
   


# Harvesting subdomains (assetfinder & Sublist3r & subfinder & Crt.sh & amass)

    echo -e "$YELLOW[++] Harvesting subdomains with assetfinder... $RESET"
    assetfinder --subs-only $url | grep '.$url'  >> $url/recon/final1.txt

    echo -e "$YELLOW[++] Harvesting subdomains with Sublist3r...$RESET"
    sublist3r  -d $url | grep '.$url'  >> $url/recon/final1.txt

    echo -e "$YELLOW[++] Harvesting subdomains with subfinder...$RESET"
    subfinder -d $url | grep '.$url'  >> $url/recon/final1.txt
    
    echo -e "$YELLOW[++] Double checking for subdomains with Amass an& Crt.sh ...$RESET"
    #amass enum -d $url | tee -a $url/recon/final1.txt
    curl -s https://crt.sh/\?q\=%25.$url\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' >> $url/recon/final1.txt
    sort -u $url/recon/final1.txt >> $url/recon/final.txt
    rm $url/recon/final1.txt



#Harvesting all subdomians with assetfinder
   echo -e "$YELLOW[++] Harvesting subdomains with assetfinder...$RESET"
   cat $url/recon/final.txt | assetfinder --subs-only  | grep '.$url'  >> $url/recon/final_urls1.txt
   sort -u $url/recon/final_urls1.txt >> $url/recon/final_urls.txt
   rm $url/recon/final_urls1.txt

#We need to use HTTPX to quickly identify URLs that return 200 Status code 
  echo -e "$YELLOW[++] Identify URLs that return 200 Status code...$RESET"
  cat $url/recon/final_urls.txt | httpx -mc 200 > $url/recon/200_urls.txt


#Running ParamSpider for crawling all the paramaters 
  echo -e "$YELLOW[++] ParamSpider for crawling all the paramaters ...$RESET"
  paramspider -l $url/recon/200_urls.txt >> $url/recon/ParamSpider_urls.txt
  

# Running KXSS for indentfying the filtered , unfiltered Sympols 
   echo -e "$YELLOW[++] Running KXSS for indentfying the filtered... $RESET"
   cat $url/recon/ParamSpider_urls.txt | kxss