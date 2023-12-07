#!/usr/bin/env zsh

echo "Logging to ArgoCD ....."

export ARGOCD_USERNAME=admin
export ARGOCD_PASSWORD=jk2Ipx3lBEUvO8eN
export ARGOCD_SERVER=localhost:8080
argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD

