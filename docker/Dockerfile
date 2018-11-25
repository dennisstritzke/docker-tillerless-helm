FROM alpine:3.8

ENV KUBECTL_VERSION=1.12.2 \
    HELM_VERSION=2.11.0 \
    HELM_HOST=localhost:44134

RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
  wget -q https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz.sha256 && \
  cat helm-v$HELM_VERSION-linux-amd64.tar.gz.sha256 | awk 1 ORS='' > SHASUMS && \
  echo "  helm-v$HELM_VERSION-linux-amd64.tar.gz" >> SHASUMS && sha256sum -c SHASUMS && \
  tar -xzvf helm-v$HELM_VERSION-linux-amd64.tar.gz linux-amd64/helm --strip-components=1 -C /usr/local/bin/ && \
  tar -xzvf helm-v$HELM_VERSION-linux-amd64.tar.gz linux-amd64/tiller --strip-components=1 -C /usr/local/bin/ && \
  rm helm-v$HELM_VERSION-linux-amd64*

RUN wget -P /usr/local/bin http://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  mkdir -p ~/.kube

COPY entrypoint.sh /

EXPOSE 44134

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/helm"]