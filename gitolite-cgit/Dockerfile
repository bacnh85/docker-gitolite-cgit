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

# Add users
#RUN adduser -u ${PUID} -h /home/git -D -s /usr/bin/git-shell git users

# Setup gitolite admin
COPY ${UNAME}.pub /var/lib/git/
RUN su git -c "gitolite setup -pk /var/lib/git/${UNAME}.pub"

VOLUME [ "/var/lib/git/" ]

# Port 80 for cgit
# Port 20 for git
EXPOSE 80 22

WORKDIR /app
COPY entrypoint.sh ./

ENTRYPOINT ["sh","/app/entrypoint.sh"]
CMD [ "/bin/sh" ]