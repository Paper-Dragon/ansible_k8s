#!/usr/bin/env bash
SCRIPT=$(basename $0)

function usage(){
    echo -e "\nUSAGE: $SCRIPT master_vip master_port\n"
    exit 1
}

if [ $# -lt 2 ] ; then
    usage
fi

master_vip=$1
master_port=$2

kubectl config  set-cluster kubernetes \
    --embed-certs=true \
    --server="https://${master_vip}:${master_port}" \
    --certificate-authority=ca.pem \
    --kubeconfig=admin.conf

kubectl config  set-credentials admin \
    --embed-certs=true \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --kubeconfig=admin.conf

kubectl config set-context kubernetes \
    --user=admin \
    --namespace=default \
    --cluster=kubernetes \
    --kubeconfig=admin.conf

kubectl config use-context kubernetes --kubeconfig=admin.conf
