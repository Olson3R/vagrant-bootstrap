#!/usr/bin/env bash

function die {
  >&2 echo $1
  exit 1
}

function install_nodejs {
  # Setup the repo
  curl -sL https://deb.nodesource.com/setup | sudo bash - || die "Failed to setup nodejs repo"

  # Install nodejs
  sudo apt-get install -y nodejs || die "Failed to install nodejs"
}

function install_postgresql {
  APP_DB_USER=vagrant
  APP_DB_PASS=secret
  APP_DB_NAME=vagrant

  echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list

  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

  sudo apt-get update
  sudo apt-get install -y \
    postgresql \
    libpq-dev

  cat << EOF | su - postgres -c psql
  -- Create the database user:
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

  -- Create the database:
  CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                    LC_COLLATE='en_US.utf8'
                                    LC_CTYPE='en_US.utf8'
                                    ENCODING='UTF8'
                                    TEMPLATE=template0;
EOF
}

if [ -e "/etc/vagrant-provisioned" ];
then
    echo "Vagrant provisioning already completed. Skipping..."
    exit 0
else
    echo "Starting Vagrant provisioning process..."
fi

# Install core components
sudo apt-get install -y curl || die "Failed to install curl"

install_nodejs
install_postgresql

touch /etc/vagrant-provisioned

echo "--------------------------------------------------"
echo "Your vagrant instance is running"
