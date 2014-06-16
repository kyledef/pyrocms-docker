FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
EXPOSE 80
EXPOSE 443

RUN apt-get update

# Install mysql
RUN apt-get install -y mysql-server mysql-client mysqltuner 


# Install Apache and PHP
RUN apt-get install -y apache2 libapache2-mod-php5 php5-mysql apache2-utils 
RUN a2enmod rewrite
#TODO : change virtualhost configuration for rewrite (AllowOverride All)
RUN sed -r -i -e's/^\s(*AllowOverride\s+)(.*)\s*$/\1All/mg' /etc/apache2/apache2.conf



RUN apt-get install -y wget unzip
RUN wget https://github.com/pyrocms/pyrocms/archive/2.2/master.zip
RUN unzip master.zip

RUN rm -rf /var/www/html/*
RUN cp -r pyrocms-2.2-master/* /var/www/html/
RUN rm -rf /var/www/html/installer/

ADD ./bstrap.sh /bstrap.sh

# configure pyrocms for installation



RUN mv /var/www/html/system/cms/config/database.php.bak /var/www/html/system/cms/config/database.php

ADD pyro.sql /var/www/


RUN rm /var/www/pyro.sql

ENV DEBIAN_FRONTEND interactive
