#!/usr/bin/env bash


echo "----"
echo "Firewall rules"
echo "----"
gcloud compute firewall-rules list --filter "network: kubernetes-the-soft-way"

echo "----"
echo "External IP"
echo "----"
gcloud compute addresses list --filter="name=('kubernetes-the-soft-way')"

echo "----"
echo "Compute instances"
echo "----"
gcloud compute instances list

