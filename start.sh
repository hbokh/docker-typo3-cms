#!/bin/bash

if [[ -e /firstrun ]]; then
echo "Not first run so skipping initialization"
  else

  echo "Waiting 10 sec. for the DB to come up..."
  sleep 10

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

service php7.0-fpm start
nginx 
