FROM ubuntu:20.04

MAINTAINER Alex Guedes <aguedes@vmware.con>

ARG KUBECTL_VERSION=
ARG YQ_VERSION=
ARG PIVNET_VERSION=
ARG KP_VERSION=

COPY tbs-update-deps.sh /usr/local/bin/tbs-update-deps
RUN set -x && \
    apt-get update && \
    apt-get install -y jq curl docker.io && \
    # Download kubectl
    [ -z "$KUBECTL_VERSION" ] && KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) ||: && \
    curl -s -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    kubectl version --client && \
    # Download yq
    [ -z "$YQ_VERSION" ] && YQ_VERSION=$(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest | jq .tag_name -r) ||: && \
    curl -s -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o yq && \
    chmod +x ./yq && \
    mv ./yq /usr/local/bin/yq && \
    yq --version && \
    # Download PivNet CLI
    [ -z "$PIVNET_VERSION" ] && PIVNET_VERSION=$(curl -s https://api.github.com/repos/pivotal-cf/pivnet-cli/releases/latest | jq .tag_name -r | cut -c2-) ||: && \
    curl -s -L https://github.com/pivotal-cf/pivnet-cli/releases/download/v${PIVNET_VERSION}/pivnet-linux-amd64-${PIVNET_VERSION} -o pivnet && \
    chmod +x ./pivnet && \
    mv ./pivnet /usr/local/bin/pivnet && \
    pivnet --version &&\
    # Download kp
    [ -z "$KP_VERSION" ] && KP_VERSION=$(curl -s https://api.github.com/repos/vmware-tanzu/kpack-cli/releases/latest | jq .tag_name -r | cut -c2-) ||: && \
    curl -s -L https://github.com/vmware-tanzu/kpack-cli/releases/download/v${KP_VERSION}/kp-linux-${KP_VERSION} -o kp && \
    chmod +x ./kp && \
    mv ./kp /usr/local/bin/kp && \
    kp version && \
    chmod +x /usr/local/bin/tbs-update-deps