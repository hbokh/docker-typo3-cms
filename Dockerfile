FROM ubuntu:trusty

MAINTAINER bokh@xs4all.nl

# Set this to the latest TYPO3 CMS version:
ENV TYPO3_VERSION 6.2.15

ENV DB_ENV_USER=mariadb DB_ENV_PASS=p4ssw0rd

# Repo's for nginx and PHP5 PPA
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C && \
    echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/launchpad-ondrej-php5.list

# Install packages required for TYPO3
RUN apt-get update -qq && \
    apt-get install -qqy wget nginx mysql-client && \
    apt-get install -qqy --no-install-recommends php5-curl php5-fpm php5-gd php5-imagick php5-mcrypt php5-memcache php5-mysql graphicsmagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install TYPO3 CMS
RUN mkdir -p /var/www/site/htdocs && \
    cd /var/www/site && \
    wget -O - http://prdownloads.sourceforge.net/typo3/typo3_src-${TYPO3_VERSION}.tar.gz | tar zxf - && \
    cd htdocs && \
    ln -s ../typo3_src-${TYPO3_VERSION} typo3_src && \
    ln -s typo3_src/index.php index.php && \
    ln -s typo3_src/typo3 typo3 && \
    chown -R www-data:www-data /var/www && \
    sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php5/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 10M/g' /etc/php5/fpm/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' /etc/php5/fpm/php.ini

COPY nginx.conf /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d/default.conf

COPY start.sh /start.sh

RUN chmod 0755 /start.sh

EXPOSE 80

CMD ["/start.sh"]
