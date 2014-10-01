## apache server

FROM debian:wheezy

RUN apt-get update && apt-get install -y openssh-server apache2 supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

## some other things I like to have:
RUN apt-get update && apt-get install -y vim

## set root password to something seriously challenging...
RUN echo 'root:apple' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


## set some things for the apache server:
#RUN a2enmod authnz_ldap

## install openldap
#ENV LDAP_ROOTPASS apple
#ENV LDAP_ORGANIZATION mda
#ENV LDAP_DOMAIN mda.org
#RUN apt-get update && apt-get install -y slapd  ldap-utils
#RUN mkdir /etc/service/slapd
#RUN mdkir /etc/service/slapd/run
#ADD slapd.sh /etc/service/slapd/run

#RUN apt-get update && apt-get install ca-certificates

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .vimrc           /root/.vimrc
COPY .alias           /root/.alias
COPY .bashrc          /root/.bashrc
COPY apache2.conf     /etc/apache2/apache2.conf
#COPY ldap.conf        /etc/ldap/ldap.conf
#COPY slapd.sh         /root/slapd.sh

EXPOSE 22 80 
CMD ["/usr/bin/supervisord"]
