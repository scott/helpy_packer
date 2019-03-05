echo "This installer will help you install the latest version of Helpy Cloud (with license purchase)."

echo "what is your Helpy Cloud username?"
read clouduser
echo "what is your Helpy Cloud secret password?"
read cloudpw

echo "stopping nginx..."

#authorize addition of cloud script
bundle config gems.helpy.io $clouduser:$cloudpw

sed -i '128i\gem \"helpy_cloud\", source: \"https://gems.helpy.io\"' /home/deploy/helpy/Gemfile
cd /home/deploy/helpy

RAILS_ENV=production bundle install
RAILS_ENV=production bundle exec rake railties:install:migrations
RAILS_ENV=production bundle exec rake db:migrate
RAILS_ENV=production rails g helpy_cloud:install

echo "restarting nginx..."

sudo service nginx restart

echo "installation completed successfully"