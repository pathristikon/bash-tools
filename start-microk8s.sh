#!/bin/bash

microk8s.start

# config the ${HOME}/.kube folder & config
printf "\n\e[1;31;42m Config $HOME/.kube folder \e[0m \n"
mkdir -p $HOME/.kube
microk8s.kubectl config view > $HOME/.kube/config

# deploy the ingress-nginx pod
printf "\n\e[1;31;42m Applying ingress \e[0m \n"
microk8s.kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml > /dev/null

# get ingress ip
ingressIp=$(microk8s.kubectl get pods -o wide --all-namespaces | grep controller | awk '{print $7}')
printf "\n\e[1;31;42m Ingress public IP: ${ingressIp} \e[0m \n"

# setup the dashboard
printf "\n\e[1;31;42m Retriving dashboard token and port forwarding it \n https://127.0.0.1:10443/\e[0m \n\n"
token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s.kubectl -n kube-system describe secret $token | grep "token:"

nohup microk8s.kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 &
rm -rf nohup.out

printf "\n\n"

# get credentials for basic auth
printf "\n\e[1;31;42m Basic auth credentials \e[0m \n"
installFolder=$(sudo find /var/snap/microk8s/ -type d -regextype egrep -regex '.*/[0-9]{4}')
cat $installFolder/credentials/basic_auth.csv

printf "\n\n"
