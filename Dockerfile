FROM ubuntu:trusty

MAINTAINER bokh@xs4all.nl

# Change this when a newer version is released:
ENV TYPO3_VERSION 6.2.6

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C  && \
    echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu $(lsb_release -cs) main" \
       > /etc/apt/sources.list.d/launchpad-ondrej-php5.list

RUN apt-get update -qq && \
    apt-get install -qqy wget unzip nginx mysql-client php5 php5-cli php5-common php5-curl php5-fpm php5-gd php5-imagick php5-mcrypt php5-memcache php5-mysql graphicsmagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD default.conf /etc/nginx/sites-available/default

RUN mkdir -p /var/www/site/htdocs && \
    cd /var/www/site && \
    wget -nv http://prdownloads.sourceforge.net/typo3/typo3_src-${TYPO3_VERSION}.tar.gz && \
    tar zxf typo3_src-${TYPO3_VERSION}.tar.gz && \
    rm typo3_src-${TYPO3_VERSION}.tar.gz && \
    cd htdocs && \
    ln -s ../typo3_src-${TYPO3_VERSION} typo3_src && \
    ln -s typo3_src/index.php index.php && \
    ln -s typo3_src/typo3 typo3 && \
    touch FIRST_INSTALL && \
    chown -R www-data:www-data /var/www && \
    sed -i 's/max_execution_time = 30/max_execution_time = 240/g' /etc/php5/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 10M/g' /etc/php5/fpm/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' /etc/php5/fpm/php.ini

ADD start.sh /start.sh

RUN chmod 0755 /start.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

CMD /start.sh
