#!/bin/bash

# COLORS
red='\e[31m'
grn='\e[32m'
ylw='\e[33m'
res='\e[0m'

clear
echo -e "${grn}======================================="
echo -e "        MY TERMUX TOOL"
echo -e "=======================================${res}"

echo "1) Update Termux"
echo "2) Install Packages"
echo "3) Run Web UI (index.html)"
echo "4) Exit"

read -p "Choose option: " opt

if [[ $opt == 1 ]]; then
    echo -e "${ylw}Updating Termux...${res}"
    apt update -y && apt upgrade -y

elif [[ $opt == 2 ]]; then
    echo -e "${ylw}Installing tools...${res}"
    pkg install python git curl openssh nano -y

elif [[ $opt == 3 ]]; then
    echo -e "${ylw}Opening index.html...${res}"
    termux-open index.html

elif [[ $opt == 4 ]]; then
    exit

else
    echo -e "${red}Invalid Option!${res}"
fi
