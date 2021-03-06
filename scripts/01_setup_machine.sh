#!/bin/bash 
export DEBIAN_FRONTEND=noninteractive

echo $RUBY
echo $RAILS
echo $HELPY_BRANCH

# Set vars used by script
home=/home/deploy/helpy

# add swap space
sudo dd if=/dev/zero of=/swap bs=1M count=1024
sudo mkswap /swap 
sudo swapon /swap

# update system
apt-get update -y -qq
apt-get upgrade -y -qq

# Install extra libraries for Helpy/rails
apt-get install -y -qq git-core imagemagick postgresql postgresql-contrib libpq-dev curl build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libcurl4-openssl-dev libxml2-dev libxslt1-dev software-properties-common nodejs gnupg2

# Install Certbot
add-apt-repository ppa:certbot/certbot
apt install python-certbot-nginx

# add deploy user
adduser --disabled-password deploy
usermod -aG sudo deploy
cp /etc/sudoers /etc/sudoers.orig
sed -i -e "\$adeploy ALL=(ALL) NOPASSWD: ALL" /etc/sudoers

# Install docker
#sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
# sudo apt update -y
# sudo apt install -y docker-ce docker-compose

# One click install
# bash -c "$(wget -O - https://helpy.io/assets/launch.sh)"


# Install Passenger
# ===============================
# Install PGP Key and add https support
apt-get install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates

# Add Phusion APT repository
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
apt-get update

# Install Passenger + Nginx
apt-get install -y libnginx-mod-http-passenger nginx-extras

# config postgres
sudo -u postgres createuser -s helpy
sudo -u postgres psql -U postgres -d postgres -c "alter user helpy with password 'temp';"

# install ruby/rails
runuser -l deploy -c "gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
runuser -l deploy -c "\curl -sSL https://get.rvm.io | bash -s stable"
su - deploy -c 'source /home/deploy/.rvm/scripts/rvm'
su - deploy -c "rvm install $RUBY"
su - deploy -c "rvm alias create default ruby-$RUBY"
su - deploy -c "rvm gemset create helpy"
su - deploy -c "rvm $RUBY@helpy"
su - deploy -c "gem install rails --no-ri --no-rdoc -v $RAILS"
su - deploy -c "gem install bundler"