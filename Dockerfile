FROM phusion/baseimage:latest

MAINTAINER bokh@xs4all.nl

ENV TYPO3_VERSION 6.2.5

RUN apt-get update -qq && \
    apt-get install -qqy wget nginx mysql-client php5 php5-cli php5-common php5-curl php5-fpm php5-gd php5-imagick php5-mcrypt php5-memcache php5-mysql graphicsmagick

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
    chown -R www-data:www-data /var/www

ADD start.sh /start.sh

RUN chmod 0755 /start.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

CMD /start.sh
