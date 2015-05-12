# vagrant-bootstrap
Bootstrap vagrant project for rest-hapi-bootstrap and client-hapi-bootstrap.

# Instructions
1. Make sure you have vagrant (https://www.vagrantup.com/) installed
2. Clone this repo `git clone git@github.com:Olson3R/vagrant-bootstrap.git`
3. Change directories to `cd vagrant-bootstrap/www`
4. Clone the `rest-hapi-bootstrap` repo into the `vagrant-bootstrap/www` directory
 - `git clone git@github.com:Olson3R/rest-hapi-bootstrap.git`
5. Clone the `client-hapi-bootstrap` repo into the `vagrant-bootstrap/www` directory
 - `git clone git@github.com:Olson3R/client-hapi-bootstrap.git`
6. Change directories back to `vagrant-bootstrap`
7. Bring up the vagrant machine `vagrant up`
 * Note: If you do not already have the vm image downloaded, it can take a while since it is 500+ MB.
 * Note: Provisioning will take a while as well the first time the vm provisions
8. Ssh into the vm `vagrant ssh`
9. Run your node apps
