# Supported tags and respective Dockerfile links
- `2.11.0`, `latest` [\(2.11.0/Dockerfile\)](https://github.com/dennisstritzke/docker-tillerless-helm/blob/2.11.0/docker/Dockerfile)

# Tillerless Helm Docker Image
Use this Docker Image to run Helm operations without having to install Tiller in the target Kubernetes cluster.

Installing, upgrading and managing Helm charts required Tiller to be installed in the Kubernetes cluster, which can get
cumbersome if RBAC is involved. Also, why should you have a service running in your cluster that is essentially only
doing work, if you execute some CLI commands? By starting Tiller locally, you can leverage the benefits of Helm, without
having to run Tiller permanently in you cluster.

## How it works
This Docker Image consist out of three components: kubectl, Helm and an entrypoint script. While kubectl and Helm are
just the ordinary binaries you expect. The entrypoint script is a tiny bit more involved.

The entrypoint script consumes environment variables to create a Kube config file. Find the list below for the available
variables, although the script will inform you which ones are missing.
- `K8_IP`: HTTPS API endpoint IP of your Kubernetes cluster.
- `CA_DATA`: base64 encoded HTTPS Certificate Authority for the before mentioned Kubernetes API endpoint.
- `NAMESPACE`: Kubernetes namespace to be used for the Kube config.
- `SERVICE_ACCOUNT_TOKEN`: Authentication token to be used within the Kube config

## GitLab CI example
Using this Docker Image you are able to deploy your projects out of GitLab CI. To do so, create the GitLab CI project
variables `K8_IP`, `CA_DATA`, `NAMESPACE` and `SERVICE_ACCOUNT_TOKEN` fill them with the respective values as described
in [How it works](#how-it-works).

Find below an exemplary `.gitlab-ci.yml` file, which deploys a Helm chart located in the same repository and uses the
environment variables for authentication.
```
deployTag:
  services:
    - name: dstritzke/tillerless-helm:2.11.0
      alias: tiller
      command: ["tiller", "--storage=secret"]
  image: dstritzke/tillerless-helm:2.11.0
  variables:
    CA_DATA: $CA_DATA
    K8_IP: $K8_IP
    NAMESPACE: $NAMESPACE
    SERVICE_ACCOUNT_TOKEN: $SERVICE_ACCOUNT_TOKEN
    HELM_HOST: "tiller:44134"
  script:
    - helm upgrade --install --set dockerImage.tag=$CI_COMMIT_REF_NAME website ./charts/private-website
  only:
    - tags
```
Unfortunately, the variable section is necessary as only the variables in the Job itself are passed to the service.