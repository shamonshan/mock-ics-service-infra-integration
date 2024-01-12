#!/usr/bin/env zsh

echo "Logging to ArgoCD CLI....."

export ARGOCD_USERNAME=admin
export ARGOCD_PASSWORD=6EKMW7JMIGuyF7TG
export ARGOCD_SERVER=localhost:8080
argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD

