#!/bin/bash

echo "Create pod"
IP_ADDR=$(bx cs workers $CLUSTER_NAME | grep deployed | awk '{ print $2 }')
if [ -z $IP_ADDR ]; then
  echo "$CLUSTER_NAME not created or workers not ready"
  exit 1
fi

echo -e "Configuring vars"
exp=$(bx cs cluster-config $CLUSTER_NAME | grep export)
if [ $? -ne 0 ]; then
  echo "Cluster $CLUSTER_NAME not created or not ready."
  exit 1
fi
eval "$exp"

echo -e "Deleting previous version if it exists"
kubectl delete --ignore-not-found=true   -f car-dashboard-pod.yml

echo -e "Creating pods"
kubectl create -f car-dashboard-pod.yml

PORT=$(kubectl get services | grep bot-son | sed 's/.*://g' | sed 's/\/.*//g')

echo ""
echo "View the app at http://$IP_ADDR:$PORT"
