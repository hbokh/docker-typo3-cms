##Docker TYPO3 CMS##

Inspired by and borrowed from [paimpozhil/magento-docker](https://registry.hub.docker.com/u/paimpozhil/magento-docker/).

Needs a MySQL-container to link to.
I used paintedfox/mariadb (equals MySQL 5.5)

**Start the containers**

```docker run -td --name mariadb -e USER=user -e PASS=password  paintedfox/mariadb```

```docker run --name typo3-cms -p 80:80 -link mariadb:db -td hbokh/docker-typo3-cms```

Find the IP address of the database-container:

```docker inspect --format '{{ .NetworkSettings.IPAddress }}' mariadb```

You will need it at first install.  
Open a browser to *http://< container IP >/site/htdocs/* to configure TYPO3.


**Build the container**

`git clone https://github.com/hbokh/docker-typo3-cms.git .`

`docker build --rm=true -t hbokh/docker-typo3-cms .`

`docker run -p 80:80 -link mariadb:db -td docker-typo3-cms`


###TODO###

- Mount external data inside the container.

###Issues###

TYPO3 gives an error after installation:


> Oops, an error occurred!
> 
> The current host header value does not match the configured trusted hosts pattern! Check the pattern defined in $GLOBALS['TYPO3_CONF_VARS']['SYS']['trustedHostsPattern'] and adapt it, if you want to allow the current host header 'boot2docker' for your installation.

This is related to [TYPO3-CORE-SA-2014-001: Multiple Vulnerabilities in TYPO3 CMS](http://typo3.org/teams/security/security-bulletins/typo3-core/typo3-core-sa-2014-001/)

A fix is to login into the container and add a line to file /var/www/site/htdocs/typo3conf/LocalConfiguration.php:

	'SYS' => array(
                [ ... ];
		'trustedHostsPattern' => '.*',
	),

Bummer!! Because this is somewhat of a showstopper to use the container straight away...
