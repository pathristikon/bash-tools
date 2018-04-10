#!/bin/sh

# Find SSH key and show it
# If not existing, generate a new SSH key

GREEN='\033[0;32m'
WHITE='\033[0m'
RED='\033[0;31m'

if [ "$(find ~/.ssh/id_rsa.pub | cat ~/.ssh/id_rsa.pub | grep 'ssh-rsa')" ];
then
   echo "${GREEN}Your ssh key is: "
   echo "=================${WHITE}"
   cat ~/.ssh/id_rsa.pub
else
   echo "${RED}SSH key not found. Generate one now."	
   echo "${WHITE}Enter your email address: "
   read email
   ssh-keygen -t rsa -C "$email"  
fi
