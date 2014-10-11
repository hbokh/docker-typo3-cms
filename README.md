# Docker TYPO3 CMS

[TYPO3 CMS](http://typo3.org/typo3-cms/) version 6.2 (LTS) on nginx and PHP-FPM.  
Inspired by and borrowed from [paimpozhil/magento-docker](https://registry.hub.docker.com/u/paimpozhil/magento-docker/).

Needs a MySQL-container to link to.
I used paintedfox/mariadb (which equals MySQL 5.5)

## Start the containers

First start the database:  
`docker run -td --name mariadb -e USER=user -e PASS=password paintedfox/mariadb`

Followed by the webserver on port 80 and linked to the database:  
`docker run -td --name typo3-cms -p 80:80 --link mariadb:db hbokh/docker-typo3-cms`

Next, open a webbrowser to *http://< container IP >/site/htdocs/* and configure TYPO3.  
For the database-host use the name "db", with USER and PASS as set for the database-container.

## Build the container

`git clone https://github.com/hbokh/docker-typo3-cms.git .`

`docker build --rm=true -t hbokh/docker-typo3-cms .`

`docker run -td -p 80:80 --link mariadb:db hbokh/docker-typo3-cms`

## TODO

- ~~Use deb.sury.org PPA (ondrej/php5)~~
- ~~Setup PHP parameters to pass the system environment check~~
- Mount external data inside the container.

## Issues

TYPO3 gives an error after installation:  

![image](https://github.com/hbokh/docker-typo3-cms/raw/master/TYPO3_error.png)

This is related to [TYPO3-CORE-SA-2014-001: Multiple Vulnerabilities in TYPO3 CMS](http://typo3.org/teams/security/security-bulletins/typo3-core/typo3-core-sa-2014-001/)

A fix is to login into the container and add a line to file `/var/www/site/htdocs/typo3conf/LocalConfiguration.php`:

	'SYS' => array(
                [ ... ];
		'trustedHostsPattern' => '.*',
	),

Bummer!! Because this is somewhat of a showstopper to use the container straight away...
