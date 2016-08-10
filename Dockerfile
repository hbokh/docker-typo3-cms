FROM ubuntu:trusty

MAINTAINER bokh@xs4all.nl

# Set this to the latest TYPO3 CMS version:
ENV TYPO3_VERSION 6.2.21

ENV DB_ENV_USER=typo3 DB_ENV_PASS=p4ssw0rd

# Repo's for nginx and PHP PPA
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C && \
    echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/launchpad-ondrej-php.list

# Install packages required for TYPO3
RUN apt-get update -qq && \
    apt-get install -qqy wget nginx mysql-client && \
    apt-get install -qqy --no-install-recommends php-curl php7.0-fpm php-gd php7.0-soap php7.0-xml php7.0-zip php-imagick php-mcrypt php7.0-mysql ghostscript graphicsmagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install TYPO3 CMS and Opcache Control Panel (Bitly-link)
RUN mkdir -p /var/www/site/htdocs && \
    cd /var/www/site && \
    wget -q -O - http://prdownloads.sourceforge.net/typo3/typo3_src-${TYPO3_VERSION}.tar.gz | tar zxf - && \
    cd htdocs && \
    ln -s ../typo3_src-${TYPO3_VERSION} typo3_src && \
    ln -s typo3_src/index.php index.php && \
    ln -s typo3_src/typo3 typo3 && \
    wget -q http://bit.ly/1NoQoUo -O ocp.php && \
    chown -R www-data:www-data /var/www && \
    sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 10M/g' /etc/php/7.0/fpm/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/g' /etc/php/7.0/fpm/php.ini

COPY nginx.conf /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d/default.conf

COPY start.sh /start.sh

RUN chmod 0755 /start.sh

EXPOSE 80

CMD ["/start.sh"]
