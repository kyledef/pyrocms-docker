FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
EXPOSE 80
EXPOSE 443
RUN apt-get install -y apache2 libapache2-mod-php5 php5-mysql apache2-utils
RUN a2enmod rewrite
RUN apt-get install -y wget unzip
RUN wget https://github.com/pyrocms/pyrocms/archive/2.2/master.zip
RUN unzip master.zip

RUN mv pyrocms-2.2-master /var/www/html/pyrocms

ADD ./bstrap.sh /bstrap.sh

ENV DEBIAN_FRONTEND interactive
