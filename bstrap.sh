#!/bin/bash
service mysql start
service apache2 start
mysql < pyro.sql
mysql < change_pwd.sql
/bin/bash
