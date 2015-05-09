#!/usr/bin/env bash

# postgresql configs
APP_DB_USER=vagrant
APP_DB_PASS=secret
APP_DB_NAME=vagrant

function die {
  >&2 echo $1
  exit 1
}

function add_apt_get_repos {
  sudo apt-get install -y python-software-properties software-properties-common
  sudo add-apt-repository -y ppa:pi-rho/dev

  # Setup nodejs repo
  curl -sL https://deb.nodesource.com/setup | sudo bash - || die "Failed to setup nodejs repo"

  # Setup postgresql repo
  echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' | sudo tee /etc/apt/sources.list.d/pgdg.list || die "Failed to add postgresql repo"
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add - || die "Failed to add postgresql repo key"

  sudo apt-get update || die "Failed to update apt-get"
}

function install_core_pkgs {
  sudo apt-get install -y curl || die "Failed to install curl"
  sudo apt-get install -y git || die "Failed to install git"
  sudo apt-get install -y tmux || die "Failed to install tmux"
}

function install_nodejs {
  # Install nodejs
  sudo apt-get install -y nodejs || die "Failed to install nodejs"

  # Install globals
  sudo npm install -g nodemon || die "Failed to install nodemon"
  sudo npm install -g gulp || die "Failed to install gulp"
  sudo npm install -g sequelize-cli || die "Failed to install sequelize-cli"
}

function install_postgresql {
  # Install postgresql
  sudo apt-get install -y postgresql libpq-dev || die "Failed to install postgresql"

  # Create user and database
  cat << EOF | su - postgres -c psql || die "Failed add postgresql user/database"
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

function setup_restapi {
  cd /home/vagrant/www || die "Failed to change to ~/www for the rest api"
  # git clone git@github.com:Olson3R/rest-hapi-bootstrap.git || die "Failed to clone the rest api repo"

  cd /home/vagrant/www/rest-hapi-bootstrap || die "Failed to change to ~/www/rest-hapi-bootstrap"
  npm install || die "Failed to npm install for the rest api"
  sequelize --options-path=/home/vagrant/www/rest-hapi-bootstrap/config/database.json db:migrate || die "Failed to migrate the db for the rest api"
}

function setup_client {
  # cd /home/vagrant/www || die "Failed to change to ~/www for the client"
  # git clone git@github.com:Olson3R/client-hapi-bootsrap.git || die "Failed to clone the client repo"

  # cd /home/vagrant/www/client-hapi-bootsrap || die "Failed to change to ~/www/client-hapi-bootsrap"
  # npm install || die "Failed to npm install for the client"
  echo "TODO"
}

if [ -e "/etc/vagrant-provisioned" ];
then
    echo "Vagrant provisioning already completed. Skipping..."
    exit 0
else
    echo "Starting Vagrant provisioning process..."
fi

add_apt_get_repos

install_core_pkgs
install_nodejs
install_postgresql

setup_restapi
setup_client

touch /etc/vagrant-provisioned

echo "--------------------------------------------------"
echo "Your vagrant instance is running"
