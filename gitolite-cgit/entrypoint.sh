#!/usr/bin/env sh

# Validate environment variables

# Create ssh host key if not present
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -A

fi

# Setup gitolite at volume /var/lib/git
if [ ! -f "/var/lib/git/.ssh/authorized_keys" ]; then
  # Configure gitolite
  echo "$SSH_KEY" > "/tmp/$SSH_KEY_NAME.pub"
  su git -c "gitolite setup -pk \"/tmp/$SSH_KEY_NAME.pub\""
  rm "/tmp/$SSH_KEY_NAME.pub"
fi

# Init container
if [ ! -f /etc/nginx/conf.d/cgit.conf ]; then
  # enable random git password
  GIT_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
  echo git:$GIT_PASSWORD | chpasswd

  # add web user (nginx) to gitolite group (git)
  adduser nginx git

  ## Config cgit interface
  cat > /etc/cgitrc <<- EOF
	# Use a virtual-root
	virtual-root=/

	# Enable caching of up to 1000 output entries
	cache-size=1000

	# Specify the css url
	css=/cgit.css

	# Show extra links for each repository on the index page
	enable-index-links=1

	# Enable ASCII art commit history graph on the log pages
	enable-commit-graph=1

	# Show number of affected files per commit on the log pages
	enable-log-filecount=1

	# Show number of added/removed lines per commit on the log pages
	enable-log-linecount=1

	# Use a custom logo
	logo=/cgit.png

	# Enable statistics per week, month and quarter
	max-stats=quarter

	# Allow download of tar.gz, tar.bz2, and tar.xz formats
	snapshots=tar.gz tar.bz2 tar.xz

	##
	## List of common mimetypes
	##

	mimetype.gif=image/gif
	mimetype.html=text/html
	mimetype.jpg=image/jpeg
	mimetype.jpeg=image/jpeg
	mimetype.pdf=application/pdf
	mimetype.png=image/png
	mimetype.svg=image/svg+xml

	# Enable syntax highlighting and about formatting
	source-filter=/usr/lib/cgit/filters/syntax-highlighting.py
	about-filter=/usr/lib/cgit/filters/about-formatting.sh

	##
	## List of common readmes
	##
	readme=:README.md
	readme=:readme.md
	readme=:README.mkd
	readme=:readme.mkd
	readme=:README.rst
	readme=:readme.rst
	readme=:README.html
	readme=:readme.html
	readme=:README.htm
	readme=:readme.htm
	readme=:README.txt
	readme=:readme.txt
	readme=:README
	readme=:readme
	readme=:INSTALL.md
	readme=:install.md
	readme=:INSTALL.mkd
	readme=:install.mkd
	readme=:INSTALL.rst
	readme=:install.rst
	readme=:INSTALL.html
	readme=:install.html
	readme=:INSTALL.htm
	readme=:install.htm
	readme=:INSTALL.txt
	readme=:install.txt
	readme=:INSTALL
	readme=:install

	# Direct cgit to repository location managed by gitolite
	remove-suffix=0
	project-list=/var/lib/git/projects.list
	section-from-path=3
	scan-path=/var/lib/git/repositories
	EOF

	# Apend clone-prefix
	if [[ ! -z "$CGIT_CLONE_PREFIX" ]]; then
		echo "# Specify some default clone prefixes" >> /etc/cgitrc
		echo "clone-prefix=$CGIT_CLONE_PREFIX" >> /etc/cgitrc
	fi

	if [[ ! -z "$CGIT_ROOT_TITLE" ]]; then
		echo "# Set the title and heading of the repository index page" >> /etc/cgitrc
		echo "root-title=$CGIT_ROOT_TITLE" >> /etc/cgitrc
	fi

	# Using highlight syntax
	#sed -i.bak \
  #  -e "s#exec highlight --force -f -I -X -S #\#&#g" \
  #  -e "s#\#exec highlight --force -f -I -O xhtml#exec highlight --force --inline-css -f -I -O xhtml#g" \
  #  /usr/lib/cgit/filters/syntax-highlighting.sh

  # Nginx configuration
	rm /etc/nginx/conf.d/default.conf

  cat > /etc/nginx/conf.d/cgit.conf <<- EOF
  server {
    listen 80 default_server;
    server_name localhost;
		
    root /usr/share/webapps/cgit;
		try_files \$uri @cgit;

		location ~* ^.+\.(css|png|ico)$ {
    	expires 30d;
    }

    location / {
      index cgit.cgi;
      fastcgi_param SCRIPT_FILENAME \$document_root/cgit.cgi;
      fastcgi_pass unix:/run/fcgiwrap/fcgiwrap.socket;
      fastcgi_param HTTP_HOST \$server_name;
      fastcgi_param PATH_INFO \$uri;
      fastcgi_param QUERY_INFO \$uri;
      include "fastcgi_params";
    }
  }
	EOF

fi

# Start sshd as detach, log to stderr (-e)
/usr/sbin/sshd -e

# launch fcgiwrap via spawn-fcgi, port 1234
spawn-fcgi -s /run/fcgiwrap/fcgiwrap.socket -f /usr/bin/fcgiwrap
chmod 660 /run/fcgiwrap/fcgiwrap.socket

# Start git-daemon
git daemon --detach --reuseaddr --base-path=/var/lib/git/repositories /var/lib/git/repositories

# Start nginx
exec nginx -g "daemon off;"
