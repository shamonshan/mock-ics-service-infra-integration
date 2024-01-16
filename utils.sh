#!/usr/bin/env zsh


set -o errexit
set -o nounset
set -o pipefail

OPTIONS=(login
          set_config sync_apps list_apps sync_with_labels apply_argo_config help
         )

help_exit() {
    echo "Usage: $ZSH_ARGZERO OPTION..."
    echo
    echo "Where OPTION is one of:"
    echo "${OPTIONS[@]}"
    echo
    exit 1
}
if [[ "$#" -eq 0 ]]; then
    help_exit
fi

declare -A selections=()
for option in "${OPTIONS[@]}"; do
    selections[$option]=n
done
for i in "$@"; do
    selections[$i]=y
done
unexpected_opts=(${(k)selections:|OPTIONS})
if [[ -n $unexpected_opts ]]; then
    echo "invalid option(s): ${unexpected_opts}\n"
    help_exit
fi
if [[ $selections[help] == 'y' ]]; then
    help_exit
fi

if [[ $selections[login] == 'y' ]]; then
    echo "Logging to ArgoCD CLI....."
    echo 
    export ARGOCD_USERNAME=admin
    export ARGOCD_PASSWORD=6EKMW7JMIGuyF7TG
    export ARGOCD_SERVER=localhost:8080
    argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD
fi

if [[ $selections[set_config] == 'y' ]]; then
   #In real implementation this must be in a loop and the parameters are from YAML/dynamically generated
   argocd app set app-common-org --values-literal-file helm-configs/values-org.yaml
   argocd app set app-common-ui --values-literal-file helm-configs/values-ui.yaml
   argocd app set az-de-fc --values-literal-file helm-configs/values-fc.yml
   argocd app set az-it-fc --values-literal-file helm-configs/values-fc.yml
 fi

if [[ $selections[sync_apps] == 'y' ]]; then
    #In real implementation this must be in a loop and the parameters are from YAML/dynamically generated
    # This can be grouped with labels also
    argocd app sync app-common-org
    argocd app sync app-common-ui
    argocd app sync az-de-fc
    argocd app sync az-it-fc
fi

if [[ $selections[sync_with_labels] == 'y' ]]; then
  argocd app sync -l name=common-children-apps
  argocd app sync -l name=multiorg-children-apps
  argocd app sync -l name=abs-children-apps
fi

if [[ $selections[list_apps] == 'y' ]]; then
   argocd app list 
fi

if [[ $selections[apply_argo_config] == 'y' ]]; then
    kubectl apply -f root-app.yml
fi

