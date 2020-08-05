FROM cjrun/fedora-sc:0.1.0

ARG USER_NAME
ARG USER_ID
ARG GROUP_ID
ARG USER_PASSWORD
ARG GRANT_SUDO=TRUE

# modify user so that id and gid match with host
USER root
WORKDIR /opt/build-scripts
COPY usermod.sh ./usermod.sh
RUN chmod +x usermod.sh && ./usermod.sh

WORKDIR /home/$USER_NAME
USER $USER_NAME
ENTRYPOINT ["/bin/bash", "-lc"]