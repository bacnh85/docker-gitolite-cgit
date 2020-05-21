# docker build . -t bacnh85/gitolite-cgit
FROM alpine:latest
LABEL MAINTAINER="mail@bacnh.com"

# Install needed packages
RUN set -xe \
  && apk add --no-cache --purge -uU \
    # Install gitolite
    gitolite git openssh \
    # install git-daemon
    git-daemon \
    # add nginx and cgit
    cgit nginx fcgiwrap spawn-fcgi \
    # python 3 pkg for highlight, about page
    py3-markdown py3-pygments \
  # Create nginx folder
  && mkdir -p /run/nginx \
  # Clean up
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

# Volume to store all ssh host key
VOLUME [ "/etc/ssh/" ]

# Volume to store Gitolite data, used for Gitolite setup
VOLUME [ "/var/lib/git/" ]

EXPOSE 22 80 9418
WORKDIR /var/lib/git

COPY entrypoint.sh /
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
