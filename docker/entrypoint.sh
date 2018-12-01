#!/bin/sh

[ -z "$CA_DATA" ] && echo 'Variable $CA_DATA not set.'
[ -z "$K8_IP" ] && echo 'Variable $K8_IP not set.'
[ -z "$NAMESPACE" ] && echo 'Variable $NAMESPACE not set.'
[ -z "$SERVICE_ACCOUNT_TOKEN" ] && echo 'Variable $SERVICE_ACCOUNT_TOKEN not set.'

[ -z "$CA_DATA" ] || [ -z "$K8_IP" ] || [ -z "$NAMESPACE" ] || [ -z "$SERVICE_ACCOUNT_TOKEN" ] && echo "Exiting..." && exit 1

export TILLER_NAMESPACE=$NAMESPACE

cat > ~/.kube/config << EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CA_DATA
    server: https://$K8_IP
  name: cluster
contexts:
- context:
    cluster: cluster
    namespace: $NAMESPACE
    user: svcacc
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: svcacc
  user:
    token: $SERVICE_ACCOUNT_TOKEN
EOT

echo "Using Kubernetes at https://$K8_IP"
echo "Using Namespace $NAMESPACE"

if [ "$SKIP_AUTH_CHECK" = true ]; then
    set -e
    echo -e "\n===> Testing Kubernetes access through 'kubectl version'"
    kubectl version
    echo "-> Success"
    set +e
fi

echo -e "\n===> Running Docker CMD"
exec "$@"