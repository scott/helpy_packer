#!/bin/bash 
home=/home/deploy/helpy

# Set up scret
secret=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128| head -n 1)
rm $home/config/secrets.yml
cat > $home/config/secrets.yml <<EOL
production:
  secret_key_base: $secret
EOL

dbpw=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32| head -n 1)

sudo -u postgres psql -U postgres -d postgres -c "alter user helpy with password '$dbpw';"

rm $home/config/database.yml
cat > $home/config/database.yml <<EOL
production:
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: localhost
  port: 5432
  database: helpy_production
  username: helpy
  password: $dbpw
EOL

touch $home/tmp/restart.txt
