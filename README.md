# Docker TYPO3 CMS

[![](https://badge.imagelayers.io/hbokh/docker-typo3-cms.svg)](https://imagelayers.io/?images=hbokh/docker-typo3-cms:latest 'Get your own badge on imagelayers.io')


Container with the latest [TYPO3](http://typo3.org/typo3-cms/) CMS 6.2 LTS, served by nginx and PHP-FPM.  
Great for learning, testing and demo's. **Don't use in production!**

This little project was started to get some personal experience with multiple Docker-containers and TYPO3.   
There are **far better** alternatives to be found, for example the [TYPO3-docker-boilerplate](https://github.com/giminni/TYPO3-docker-boilerplate)!

Inspired by and borrowed from [paimpozhil/magento-docker](https://registry.hub.docker.com/u/paimpozhil/magento-docker/).

## Quick start

[Install docker-compose](http://docs.docker.com/compose/install/#install-compose) and run `docker-compose up`.  

File: docker-compose.yml:

```
mariadb:
  image: paintedfox/mariadb:latest
  environment:
    - USER=mariadb
    - PASS=p4ssw0rd
typo3cms:
  image: hbokh/docker-typo3-cms:latest
  links:
    - mariadb:db
  ports:
    - "80:80"
```

Use `mariadb/p4ssw0rd` for the database-credentials.  

Restart after the stack has been stopped, use `docker-compose up --no-recreate`.

## Manually

The TYPO3-container needs a MySQL-container to link to.  
I used [paintedfox/mariadb](https://registry.hub.docker.com/u/paintedfox/mariadb/) (which equals MySQL 5.5).

First install and start the database:  
`docker run -td --name mariadb -e USER=mariadb -e PASS=p4ssw0rd paintedfox/mariadb`

Followed by the webserver on port 80 and linked to the database:  
`docker run -td --name typo3-cms -p 80:80 --link mariadb:db hbokh/docker-typo3-cms`

## Configure TYPO3 CMS

Open a webbrowser to `http://<container IP>/` and configure TYPO3.  
First time startup takes a while, because extensions etc. are downloaded and installed.  

For the database-host use the name "db", with USER and PASS as set for the database-container (`mariadb/p4ssw0rd`).

You can install the TYPO3 Introduction Package for a start:

![image](https://github.com/hbokh/docker-typo3-cms/raw/master/TYPO3_introduction.png)

## Build the container from source

`git clone https://github.com/hbokh/docker-typo3-cms.git .`

`docker build --rm=true -t hbokh/docker-typo3-cms .`

`docker run -td -p 80:80 --link mariadb:db hbokh/docker-typo3-cms`

## TODO

- Mount external data inside the container.

## Issues

The issue with the *trustedHostsPattern* was fixed in `start.sh` with a suggestion by [Giovanni Minniti](https://github.com/giminni). (20151227)

### RealURL

To use RealURL in e.g. the official introduction package go to "Extension Manager" --> "Configure RealURL" and set "Enable automatic configuration". Clear both caches and reload the site. (20151227)

### Environment

When running the DB-instance and webserver in seperate containers on separate hosts (e.g. when using Rancher), these environment setting have to be set too: `DB_ENV_USER=mariadb` and `DB_ENV_PASS=p4ssw0rd`. If not, an error like this will be shown in the container-log of the DB:

    Access denied for user 'root'@'<IP-address>' (using password: NO)

For some reason this is not needed when running on the same Docker-host.
