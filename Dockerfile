ARG IMAGE=ubuntu
ARG VERSION=20.04

FROM ${IMAGE}:${VERSION}

ARG DISTRO=ubuntu
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive
ARG NODE_VERSION=16
ARG PHP_VERSION=8.1

ENV MC_HOST_local=http://minio:minioadmin@minioadmin:9000
ENV LC_ALL=C.UTF-8

LABEL description="Development environment for running AnimeSite"

ADD unminimize /tmp/unminimize
RUN chmod 700 /tmp/unminimize \
    && /tmp/unminimize

ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod 755 /usr/local/bin/wp

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --create-home --shell /bin/bash --uid ${USER_UID} --gid ${USER_GID} ${USERNAME}

ADD .editorconfig /home/${USERNAME}

RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.editorconfig

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release \
      openssl \
      software-properties-common
      
RUN curl 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - \
    && echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x $(lsb_release -cs) main" > /etc/apt/sources.list.d/nodesource.list

RUN add-apt-repository -n ppa:ondrej/php

RUN apt update \
    && apt-get install -y \
      bash-completion \
      build-essential \
      ffmpeg \
      git \
      htop \
      jq \
      language-pack-en \
      less \
      lsof \
      man-db \
      manpages \
      mc \
      nano \
      net-tools \
      nodejs \
      openssh-client \
      procps \
      psmisc \
      rsync \
      sudo \
      time \
      unzip \
      wget \
      whois \
      zip

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN mkdir -p /projects/workspace \
    && chown -R ${USER_UID}:${USER_GID} /projects

RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/projects/.bash_history" \
    && echo $SNIPPET >> "/home/${USERNAME}/.bashrc"
    
COPY bashprompt /home/${USERNAME}/.bashrc    
COPY aliases /home/${USERNAME}/.bash_aliases
RUN chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bash_aliases \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bash_aliases

RUN mkdir -p /home/${USERNAME}/.config \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.config

RUN mkdir -p /home/${USERNAME}/.ssh \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh \
    && chmod 700 /home/${USERNAME}/.ssh


VOLUME /projects
VOLUME /home/${USERNAME}/.config
VOLUME /home/${USERNAME}/.ssh

WORKDIR /projects/workspace

# COPY src/* /projects/workspace/
# This one here above is the problem, need to figure out at what point and how evaxctly the write it

HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
