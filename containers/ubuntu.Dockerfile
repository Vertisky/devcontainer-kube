ARG KUBECTL_VERSION=1.26.0
ARG HELM_VERSION=3.11.0
ARG KUBECTX_VERSION=0.9.4
ARG MINIKUBE_VERSION=1.29.0
ARG KUSTOMIZE_VERSION=4.5.7
ARG K9S_VERSION=0.27.2
ARG KIND_VERSION=0.17.0
ARG KUBE_CAPACITY_VERSION=v0.7.3
ARG FLUX2_VERSION=0.38.3
ARG OIDC_LOGIN_VERSION=v1.26.0
ARG KUBESPY_VERSION=0.6.1
ARG KUBECONFORM_VERSION=0.5.0
ARG POPEYE_VERSION=v0.10.1
ARG KUBE_SCORE_VERSION=1.16.1
ARG KUBE_LINTER_VERSION=0.6.0

FROM etma/devcontainer-base:ubuntu-v1.2.0
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
    org.opencontainers.image.description="Base Ubuntu image for dev containers working with kubernetes" \
    org.opencontainers.image.url="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.documentation="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.source="https://github.com/vertisky/devcontainers-kube" \
    org.opencontainers.image.vendor="vertisky" \
    org.opencontainers.image.authors="etma@vertisky.com" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$COMMIT \
    org.opencontainers.image.created=$BUILD_DATE

# COPY ./containers/shell/*.sh /root/

# RUN chmod +x /root/*.sh

COPY ./containers/shell/.zsh-plugins.txt /tmp/.new-zsh-plugins.txt

# append the content of /tmp/.new-zsh-plugins.txt to /root/.zsh-plugins.txt
RUN cat /tmp/.new-zsh-plugins.txt >> /root/.zsh-plugins.txt


# Install asdf base plugins
RUN touch /root/.tool-versions
# RUN /root/.asdf/bin/asdf plugin add docker-compose-v1 && /root/.asdf/bin/asdf install docker-compose-v1 ${DOCKER_COMPOSE_VERSION} && /root/.asdf/bin/asdf global docker-compose-v1 ${DOCKER_COMPOSE_VERSION}
RUN /root/.asdf/bin/asdf plugin add kubectl && /root/.asdf/bin/asdf install kubectl ${KUBECTL_VERSION} && /root/.asdf/bin/asdf global kubectl ${KUBECTL_VERSION}
RUN /root/.asdf/bin/asdf plugin add helm && /root/.asdf/bin/asdf install helm ${HELM_VERSION} && /root/.asdf/bin/asdf global helm ${HELM_VERSION}
RUN /root/.asdf/bin/asdf plugin add kubectx && /root/.asdf/bin/asdf install kubectx ${KUBECTX_VERSION} && /root/.asdf/bin/asdf global kubectx ${KUBECTX_VERSION}
RUN /root/.asdf/bin/asdf plugin add minikube && /root/.asdf/bin/asdf install minikube ${MINIKUBE_VERSION} && /root/.asdf/bin/asdf global minikube ${MINIKUBE_VERSION}
RUN /root/.asdf/bin/asdf plugin add kustomize && /root/.asdf/bin/asdf install kustomize ${KUSTOMIZE_VERSION} && /root/.asdf/bin/asdf global kustomize ${KUSTOMIZE_VERSION}
RUN /root/.asdf/bin/asdf plugin add k9s && /root/.asdf/bin/asdf install k9s ${K9S_VERSION} && /root/.asdf/bin/asdf global k9s ${K9S_VERSION}
RUN /root/.asdf/bin/asdf plugin add kind && /root/.asdf/bin/asdf install kind ${KIND_VERSION} && /root/.asdf/bin/asdf global kind ${KIND_VERSION}
RUN /root/.asdf/bin/asdf plugin add kube-capacity && /root/.asdf/bin/asdf install kube-capacity ${KUBE_CAPACITY_VERSION} && /root/.asdf/bin/asdf global kube-capacity ${KUBE_CAPACITY_VERSION}
RUN /root/.asdf/bin/asdf plugin add flux2 && /root/.asdf/bin/asdf install flux2 ${FLUX2_VERSION} && /root/.asdf/bin/asdf global flux2 ${FLUX2_VERSION}
RUN /root/.asdf/bin/asdf plugin add kubespy && /root/.asdf/bin/asdf install kubespy ${KUBESPY_VERSION} && /root/.asdf/bin/asdf global kubespy ${KUBESPY_VERSION}
RUN /root/.asdf/bin/asdf plugin add kubeconform && /root/.asdf/bin/asdf install kubeconform ${KUBECONFORM_VERSION} && /root/.asdf/bin/asdf global kubeconform ${KUBECONFORM_VERSION}
RUN /root/.asdf/bin/asdf plugin add popeye && /root/.asdf/bin/asdf install popeye ${POPEYE_VERSION} && /root/.asdf/bin/asdf global popeye ${POPEYE_VERSION}
RUN /root/.asdf/bin/asdf plugin add kube-score && /root/.asdf/bin/asdf install kube-score ${KUBE_SCORE_VERSION} && /root/.asdf/bin/asdf global kube-score ${KUBE_SCORE_VERSION}
RUN /root/.asdf/bin/asdf plugin add kube-linter && /root/.asdf/bin/asdf install kube-linter ${KUBE_LINTER_VERSION} && /root/.asdf/bin/asdf global kube-linter ${KUBE_LINTER_VERSION}

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
