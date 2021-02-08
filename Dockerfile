FROM jerryhopper/apache-php:latest

MAINTAINER Jerryhopper "hopper.jerry@gmail.com"

ENV APACHE_EVENT_START_SERVERS             2
ENV APACHE_EVENT_MIN_SPARE_THREADS         25
ENV APACHE_EVENT_MAX_SPARE_THREADS         75
ENV APACHE_EVENT_THREAD_LIMIT              64
ENV APACHE_EVENT_THREADS_PER_CHILD         25
ENV APACHE_EVENT_MAX_REQUEST_WORKERS       150
ENV APACHE_EVENT_MAX_CONNECTIONS_PER_CHILD 0

ENV PHP_FPM_PM                             ondemand
ENV PHP_FPM_MAX_CHILDREN                   10
ENV PHP_FPM_START_SERVERS                  1 
ENV PHP_FPM_SPARE_SERVERS                  1
ENV PHP_FPM_MAX_SPARE_SERVERS              10
ENV PHP_FPM_PROCESS_IDLE_TIMEOUT           25s
ENV PHP_FPM_MAX_REQUESTS                   500

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository multiverse 
    
#RUN apt-get update && \
#    apt-get -y install \
#      libapache2-mod-fastcgi
      
RUN apt-get -y install \
      php-fpm && \
      apt-get clean && \
      rm -f /var/www/html/index.html && \
      echo '<?php // silence is golden ?>' > /var/www/html/index.php

ADD rootfs /

RUN a2dismod mpm_prefork
RUN a2dismod mpm_worker
RUN a2dismod php
RUN a2enmod mpm_event
RUN a2enmod actions
RUN a2enmod fastcgi
RUN a2enmod alias 
RUN a2enconf php-fpm


