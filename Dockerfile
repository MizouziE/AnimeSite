FROM node:current-alpine3.15

VOLUME /projects
VOLUME /home/${USERNAME}/.config
VOLUME /home/${USERNAME}/.ssh

WORKDIR /projects/workspace

HEALTHCHECK NONE

ENV LANG en_US.utf8

USER ${USERNAME}
