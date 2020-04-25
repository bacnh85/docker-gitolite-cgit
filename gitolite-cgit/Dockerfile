FROM alpine:latest
LABEL MAINTAINER="mail@bacnh.com"

# Variables
ARG PUID=1000
ARG PGID=1000
ARG UNAME=bacnh

# UID, PID of the user
# Install needed packages
RUN set -xe \
  && apk add --no-cache --purge -uU \
    # Install gitolite
    gitolite git \
    # Install SSH Server
    openssh-server curl \ 
  # Clean up
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

# Volume to store SSH host keys
VOLUME /etc/ssh/keys

# Volume to store Gitolite data, used for Gitolite setup
VOLUME [ "/var/lib/git/" ]

# Expose port 22: SSH, 80: cgit web
EXPOSE 80 22

COPY entrypoint.sh /
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "/bin/sh" ]