FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
EXPOSE 80
EXPOSE 443

RUN apt-get update


# Install mysql
#RUN apt-get install -y mysql-server mysql-client mysqltuner 
RUN apt-get install -y mysql-server

# Install Apache and PHP
RUN apt-get install -y apache2 libapache2-mod-php5 php5-mysql apache2-utils 
RUN a2enmod rewrite
#TODO : change virtualhost configuration for rewrite (AllowOverride All)
RUN sed -r -i -e"s/^(\s*AllowOverride\s+)(.*)\s*$/\1All/mg" /etc/apache2/apache2.conf



RUN apt-get install -y wget unzip
RUN wget https://github.com/pyrocms/pyrocms/archive/2.2/master.zip
RUN unzip master.zip

RUN rm -rf /var/www/html/*
RUN cp -r pyrocms-2.2-master/* /var/www/html/
RUN rm -rf /var/www/html/installer/

ADD ./bstrap.sh /bstrap.sh


#MYSQL SETTINGS
ENV PYRO_MYSQL_HOST 'localhost'
ENV PYRO_MYSQL_USERNAME 'root'
ENV PYRO_MYSQL_PASSWORD 'root'
ENV PYRO_MYSQL_PORT 3306




# configure pyrocms for installation

RUN mv /var/www/html/system/cms/config/database.php.bak /var/www/html/system/cms/config/database.php


#MODIFY DATABASE CONFIGURATION FILE
RUN sed -r -i -e "s/^(\s*'hostname'\s*=>\s*)('.*')/\1$PYRO_MYSQL_HOST/mg"  /var/www/html/system/cms/config/database.php
RUN sed -r -i -e "s/^(\s*'username'\s*=>\s*)('.*')/\1$PYRO_MYSQL_USERNAME/mg"  /var/www/html/system/cms/config/database.php
RUN sed -r -i -e "s/^(\s*'password'\s*=>\s*)('.*')/\1$PYRO_MYSQL_PASSWORD/mg"  /var/www/html/system/cms/config/database.php
RUN sed -r -i -e "s/^(\s*'port'\s*=>\s*)([0-9]+)/\1$PYRO_MYSQL_PORT/mg"  /var/www/html/system/cms/config/database.php


ADD pyro.sql /pyro.sql



#need to modify mysql database to allow login with password as "root"
ADD change_pwd.sql /change_pwd.sql


ENV DEBIAN_FRONTEND interactive

