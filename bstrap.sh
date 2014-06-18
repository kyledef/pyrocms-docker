#!/bin/bash
service mysql start
service apache2 start
mysql < pyro.sql
/bin/bash
