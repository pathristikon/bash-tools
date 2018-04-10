#!/bin/sh

# Find SSH key and show it
# If not existing, generate a new SSH key

if [ "$(find ~/.ssh/id_rsa.pub | cat ~/.ssh/id_rsa.pub | grep 'ssh-rsa')" ];
then
   echo "Your ssh key is: "
   echo "================="
   cat ~/.ssh/id_rsa.pub
else
   echo "SSH key not found. Generate one now."	
   echo "Enter your email address: "
   read email
   ssh-keygen -t rsa -C "$email"  
fi
