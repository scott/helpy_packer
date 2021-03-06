#!/bin/bash 

# install helpy
su - deploy -c "source /home/deploy/.rvm/scripts/rvm"
su - deploy -c "git clone --single-branch --branch $HELPY_BRANCH https://github.com/helpyio/helpy.git /home/deploy/helpy"

# Ignore warnings from RVM and ruby version
su - deploy -c "cd /home/deploy/helpy && rvm rvmrc warning ignore /home/deploy/helpy/Gemfile"
su - deploy -c "cd /home/deploy/helpy && rvm rvmrc warning ignore allGemfiles"
sed -i "s/'>= 2.2', '< 3.0'/'$RUBY'/g" /home/deploy/helpy/Gemfile

su - deploy -c "rm /home/deploy/helpy/config/database.yml"
su - deploy -c "cp /tmp/database.yml /home/deploy/helpy/config/database.yml"
su - deploy -c "cp /tmp/seeds.rb /home/deploy/helpy/db/seeds.rb"

su - deploy -c "cd /home/deploy/helpy && bundle install"
su - deploy -c "touch /home/deploy/helpy/log/production.log"
su - deploy -c "chmod 0664 /home/deploy/helpy/log/production.log"

su - deploy -c "cd /home/deploy/helpy && RAILS_ENV=production bundle exec rake db:setup"
su - deploy -c "cd /home/deploy/helpy && RAILS_ENV=production bundle exec rake assets:precompile"

# Copy MOTD and First script
cp /tmp/99-helpy-readme /etc/update-motd.d/99-helpy-readme
chmod +x /etc/update-motd.d/99-helpy-readme
cp /tmp/01-firstrun.sh /var/lib/cloud/scripts/per-instance/01-firstrun.sh
chmod +x /var/lib/cloud/scripts/per-instance/01-firstrun.sh

# Copy NGINX vhost
rm /etc/nginx/sites-enabled/default
cp /tmp/default /etc/nginx/sites-enabled/default
