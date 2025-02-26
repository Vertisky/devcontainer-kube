ARG KUBECTL_VERSION=1.32.2
ARG HELM_VERSION=3.17.1
ARG KUBECTX_VERSION=0.9.5
ARG MINIKUBE_VERSION=1.35.0
ARG KUSTOMIZE_VERSION=5.6.0
ARG K9S_VERSION=0.40.5
ARG KIND_VERSION=0.27.0
# kube capacity can't go above v0.7.0 until the plugin has been fixed.
ARG KUBE_CAPACITY_VERSION=v0.7.0
ARG FLUX2_VERSION=2.5.1
ARG OIDC_LOGIN_VERSION=v1.32.2
ARG KUBESPY_VERSION=0.6.3
ARG KUBECONFORM_VERSION=0.6.7
ARG POPEYE_VERSION=0.22.1
ARG KUBE_SCORE_VERSION=1.19.0
ARG KUBE_LINTER_VERSION=v0.7.2

FROM etma/devcontainer-base:debian-v2.0.3
ARG VERSION
ARG COMMIT
ARG BUILD_DATE
ARG SHELL
ARG KUBECTL_VERSION
ARG HELM_VERSION
ARG KUBECTX_VERSION
ARG MINIKUBE_VERSION
ARG KUSTOMIZE_VERSION
ARG K9S_VERSION
ARG KIND_VERSION
ARG KUBE_CAPACITY_VERSION
ARG FLUX2_VERSION
ARG OIDC_LOGIN_VERSION
ARG KUBESPY_VERSION
ARG KUBECONFORM_VERSION
ARG POPEYE_VERSION
ARG KUBE_SCORE_VERSION
ARG KUBE_LINTER_VERSION

LABEL \
    org.opencontainers.image.title="Kube DevContainer" \
    org.opencontainers.image.description="Base Debian image for dev containers working with kubernetes" \
    org.opencontainers.image.url="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.documentation="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.source="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.vendor="vertisky" \
    org.opencontainers.image.authors="etma@vertisky.com" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.created=$BUILD_DATE

# Install asdf base plugins
RUN asdf plugin add kubectl && asdf install kubectl ${KUBECTL_VERSION} && asdf set -u kubectl ${KUBECTL_VERSION}
RUN asdf plugin add helm && asdf install helm ${HELM_VERSION} && asdf set -u helm ${HELM_VERSION}
RUN asdf plugin add kubectx && asdf install kubectx ${KUBECTX_VERSION} && asdf set -u kubectx ${KUBECTX_VERSION}
RUN asdf plugin add minikube && asdf install minikube ${MINIKUBE_VERSION} && asdf set -u minikube ${MINIKUBE_VERSION}
RUN asdf plugin add kustomize && asdf install kustomize ${KUSTOMIZE_VERSION} && asdf set -u kustomize ${KUSTOMIZE_VERSION}
RUN asdf plugin add k9s && asdf install k9s ${K9S_VERSION} && asdf set -u k9s ${K9S_VERSION}
RUN asdf plugin add kind && asdf install kind ${KIND_VERSION} && asdf set -u kind ${KIND_VERSION}
RUN asdf plugin add kube-capacity && asdf install kube-capacity ${KUBE_CAPACITY_VERSION} && asdf set -u kube-capacity ${KUBE_CAPACITY_VERSION}
RUN asdf plugin add flux2 && asdf install flux2 ${FLUX2_VERSION} && asdf set -u flux2 ${FLUX2_VERSION}
RUN asdf plugin add kubespy && asdf install kubespy ${KUBESPY_VERSION} && asdf set -u kubespy ${KUBESPY_VERSION}
RUN asdf plugin add kubeconform && asdf install kubeconform ${KUBECONFORM_VERSION} && asdf set -u kubeconform ${KUBECONFORM_VERSION}
RUN asdf plugin add popeye && asdf install popeye ${POPEYE_VERSION} && asdf set -u popeye ${POPEYE_VERSION}
RUN asdf plugin add kube-score && asdf install kube-score ${KUBE_SCORE_VERSION} && asdf set -u kube-score ${KUBE_SCORE_VERSION}
RUN asdf plugin add kube-linter && asdf install kube-linter ${KUBE_LINTER_VERSION} && asdf set -u kube-linter ${KUBE_LINTER_VERSION}

RUN if [ -z "$PLATFORM" ]; then PLATFORM=$(uname -m); fi && \
    if [ "$PLATFORM" = "x86_64" ]; then PLATFORM="amd64"; fi && \
    if [ "$PLATFORM" = "aarch64" ]; then PLATFORM="arm64"; fi && \
    if [ "$PLATFORM" = "armv7l" ]; then PLATFORM="arm"; fi && \
    if [ "$PLATFORM" = "armv6l" ]; then PLATFORM="arm"; fi && \
    echo "PLATFORM=$PLATFORM" && \
            curl -L -o /tmp/kubelogin.zip https://github.com/int128/kubelogin/releases/download/${OIDC_LOGIN_VERSION}/kubelogin_linux_${PLATFORM}.zip && \
    unzip /tmp/kubelogin.zip -d /tmp && \
    mv /tmp/kubelogin /usr/local/bin/kubectl-oidc_login && \
    chmod +x /usr/local/bin/kubectl-oidc_login

# cleanup
RUN rm -r /tmp/*
