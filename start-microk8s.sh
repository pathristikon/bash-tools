#!/bin/bash

arguments="$1"

getIngressIp() {
    # get ingress ip
    ingressIp=$(microk8s.kubectl get pods -o wide --all-namespaces | grep controller | awk '{print $7}')
    printf "\n\e[1;31;42m Ingress public IP: ${ingressIp} \e[0m \n\n"
}

getDashboardToken() {
    printf "\n"
    token=$(microk8s.kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
    microk8s.kubectl -n kube-system describe secret $token | grep "token:"
    printf "\n\n"
}

getBasicAuth() {
    # get credentials for basic auth
    printf "\n\e[1;31;42m Basic auth credentials \e[0m \n\n"
    installFolder=$(sudo find /var/snap/microk8s/ -type d -regextype egrep -regex '.*/[0-9]{4}')
    cat $installFolder/credentials/basic_auth.csv
    printf "\n"
}

start() {
    microk8s.start

    # config the ${HOME}/.kube folder & config
    printf "\n\e[1;31;42m Config $HOME/.kube folder \e[0m \n"
    mkdir -p $HOME/.kube
    microk8s.kubectl config view > $HOME/.kube/config

    # deploy the ingress-nginx pod
    printf "\n\e[1;31;42m Applying ingress \e[0m \n"
    microk8s.kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml > /dev/null

    getIngressIp

    # setup the dashboard
    printf "\n\e[1;31;42m Retriving dashboard token and port forwarding it \n https://127.0.0.1:10443/\e[0m \n\n"
    getDashboardToken

    printf "\n\n"

    getBasicAuth

    printf "\n\n"
    nohup microk8s.kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443 > /dev/null &
}

if [[ "$1" == "" ]]
then
    echo "Parameter required: start | ip | dashboard-token | basic-auth"
    exit 0
elif [[ "$1" == "start" ]]
then
    start
    exit 0
elif [[ "$1" == "ip" ]]
then
    getIngressIp
    exit 0
elif [[ "$1" == "dashboard-token" ]]
then
    getDashboardToken
    exit 0
elif [[ "$1" == "basic-auth" ]]
then
    getBasicAuth
fi
