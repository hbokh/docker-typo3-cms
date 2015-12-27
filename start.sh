#!/bin/bash

if [[ -e /firstrun ]]; then
echo "Not first run so skipping initialization"
  else

  echo "Waiting 10 sec. for the DB to come up..."
  sleep 10
  echo "Creating the TYPO3 database..."
  echo "create database TYPO3 CHARACTER SET utf8 COLLATE utf8_general_ci" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT"

  while [ $? -ne 0 ]; do
      sleep 5
      echo "create database TYPO3 CHARACTER SET utf8 COLLATE utf8_general_ci" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT"
      echo "show tables" | mysql -u "$DB_ENV_USER" --password="$DB_ENV_PASS" -h "$DB_PORT_3306_TCP_ADDR" -P "$DB_PORT_3306_TCP_PORT" TYPO3
  done

# Insert trustedHostsPattern to allow a successful installation
# by Giovanni Minniti (https://github.com/giminni)
  mkdir -p /var/www/site/htdocs/typo3conf
  touch /var/www/site/htdocs/typo3conf/ENABLE_INSTALL_TOOL

cat << EOF > /var/www/site/htdocs/typo3conf/AdditionalConfiguration.php
<?php
\$GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern'] = '.*'
?>
EOF

  chown -R www-data:www-data /var/www/site/htdocs/typo3conf
  chmod -R 660 /var/www/site/htdocs/typo3conf/
  chmod 2770 /var/www/site/htdocs/typo3conf

  touch /var/www/site/htdocs/FIRST_INSTALL
  touch /firstrun
fi

service php5-fpm start
nginx 
