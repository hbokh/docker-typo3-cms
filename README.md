# Docker TYPO3 CMS

[![](https://images.microbadger.com/badges/image/hbokh/docker-typo3-cms.svg)](https://microbadger.com/images/hbokh/docker-typo3-cms "Get your own image badge on microbadger.com")

Container with [TYPO3](http://typo3.org/typo3-cms/) CMS, served by nginx and PHP-FPM. As of January 2016 on PHP7.  
Great for learning, testing and demo's. **Don't use in production!**

This little project was started to get some personal experience with multiple Docker-containers and TYPO3.   
Keep in mind there are **far better** alternatives to be found, for example the [TYPO3-docker-boilerplate](https://github.com/webdevops/TYPO3-docker-boilerplate)!

The TYPO3-container needs a MySQL-container to link to.  
I started out in 2014 with "[paintedfox/mariadb](https://registry.hub.docker.com/u/paintedfox/mariadb/)", but swapped to the official Docker image "[percona:56](https://hub.docker.com/_/percona/)" by the end of January 2016.

I was inspired by and have borrowed from [paimpozhil/magento-docker](https://registry.hub.docker.com/u/paimpozhil/magento-docker/).

## Quick start

- Install [Docker](https://docs.docker.com/engine/installation/) and [docker-compose](http://docs.docker.com/compose/install/#install-compose)
- Clone this repository: `git clone https://github.com/hbokh/docker-typo3-cms.git .`  
- `cd docker-typo3-cms`
- Run `docker-compose -p typo3 up` ("typo3" is the `projectname`)
- In a browser connect to the IP address of the Docker host. Most of the time this is localhost or  192.168.99.100. `http://<$DOCKER_HOST_IP>/`
- Step [1] needs no extra input
- In step "[2] Database connection", use `typo3 / p4ssw0rd` for Username / Password and `db` for Host.
- In step "[3] Select database", select "Use an existing empty database: TYPO3"
- In step "[4] Create user and import base data" add an admin-user with any password
- In step [5], if you want a pre-configured site, select "Yes"
- Login with the admin-account and the password you just set. Done!

If you need to restart after the stack has been stopped, use `docker-compose up --no-recreate`. This will prevent the containers from being recreated.

## Manually

First install and start the database:  
`docker run -td --name db -e MYSQL_ROOT_PASSWORD=p4ssw0rd -e MYSQL_USER=typo3 -e MYSQL_PASSWORD=p4ssw0rd -e MYSQL_DATABASE=TYPO3 percona:latest`

Followed by the webserver on port 80 and linked to the database:  
`docker run -td --name typo3-cms -p 80:80 --link db:db hbokh/docker-typo3-cms`

Next go through the same steps as mentioned in the Quick start.

## TYPO3 Introduction Package

I suggest you install the TYPO3 Introduction Package to get started:

![image](https://github.com/hbokh/docker-typo3-cms/raw/master/TYPO3_introduction.png)

## Opcache Control Panel

To check and control the Zend OPcache, *Opcache Control Panel* is installed in the webroot.  
Source on Github Gist: [ck-on/ocp.php](https://gist.github.com/ck-on/4959032/?ocp.php)  
Connect to OCP:`http://<DOCKER_HOST_IP>/ocp.php`  

![image](https://github.com/hbokh/docker-typo3-cms/raw/master/Opcache_Control_Panel.png)


## Build the container from source

`git clone https://github.com/hbokh/docker-typo3-cms.git .`  
`cd docker-typo3-cms`  
`docker build --rm=true -t hbokh/docker-typo3-cms .`  
`docker pull percona:latest`  
`docker run -td -p 80:80 --link db:db hbokh/docker-typo3-cms`

### RealURL extension

Unless you prefer URLs like `http://localhost/index.php?id=34`, you might want to install the RealURL extension: "Speaking URLs for TYPO3 / realurl / v2.1.4 (stable)".  
Cleaning the caches afterward might be needed.

## Issues

* The issue with the *trustedHostsPattern* was fixed in `start.sh` with a suggestion by [Giovanni Minniti](https://github.com/giminni). (20151227)

* When running the DB-instance and webserver in seperate containers on separate hosts (e.g. when using Rancher), these environment setting have to be set too: `DB_ENV_USER=typo3` and `DB_ENV_PASS=p4ssw0rd`. If not, an error like this will be shown in the container-log of the DB:

    `Access denied for user 'root'@'<IP-address>' (using password: NO)`

For some reason this is not needed when running on the same Docker-host.

## TODO

- Mount external data inside the container.
