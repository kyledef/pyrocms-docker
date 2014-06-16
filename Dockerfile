FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
EXPOSE 80
EXPOSE 443

RUN apt-get update

# Install mysql
RUN apt-get install -y mysql-server-5.6 mysql-client-5.6 mysqltuner 


# Install Apache and PHP
RUN apt-get install -y apache2 libapache2-mod-php5 php5-mysql apache2-utils 
RUN a2enmod rewrite
#TODO : change virtualhost configuration for rewrite (AllowOverride All)




RUN apt-get install -y wget unzip
RUN wget https://github.com/pyrocms/pyrocms/archive/2.2/master.zip
RUN unzip master.zip

RUN mv pyrocms-2.2-master /var/www/html/pyrocms
RUN rm -rf /var/www/html/pyrocms/installer/

ADD ./bstrap.sh /bstrap.sh

# configure pyrocms for installation


ADD database.php /var/www/html/system/cms/config/
ADD config.php /var/www/html/system/cms/config/
ADD pyro.sql /var/www/


RUN rm /var/www/pyro.sql

ENV DEBIAN_FRONTEND interactive
