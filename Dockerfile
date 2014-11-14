## apache server

FROM  ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server apache2 supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor

## some other things I like to have:
RUN apt-get update && apt-get install -y vim curl

## set root password to something seriously challenging...
RUN echo 'root:apple' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


#RUN apt-get update && apt-get install ca-certificates

## install tools to compile (build-essential),
## erlang and related dependencies
## and a few needed libraries
#RUN apt-get update && apt-get install -y build-essential    \
#    && apt-get install -y erlang-base erlang-dev erlang-nox erlang-eunit \
#    && apt-get install -y libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

### get the source:
#RUN cd /usr/local/src && curl -O http://apache.mirrors.tds.net/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
#    && tar xvzf apache-couchdb-1.6.1.tar.gz   && cd apache-couchdb-1.6.1   \
#    && ./configure && make && make install


COPY .vimrc           /root/.vimrc
COPY .alias           /root/.alias
COPY .bashrc          /root/.bashrc


EXPOSE 22 80 

###############################################################
##   COUCHDB
################################################################
##
# Install instructions from here
#  https://www.digitalocean.com/community/tutorials/how-to-install-couchdb-from-source-on-an-ubuntu-13-04-x64-vps
# but not installing as a linux service, because I can't figure out how to get 
# the permissions to work that way

## install tools to compile (build-essential),
## erlang and related dependencies
## and a few needed libraries
RUN apt-get update && apt-get install -y build-essential    \
    && apt-get install -y erlang-base erlang-dev erlang-nox erlang-eunit \
    && apt-get install -y libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

## get the source:
ENV COUCHDB_VERSION 1.6.1
RUN cd /usr/local/src \
    && curl -O http://apache.mirrors.tds.net/couchdb/source/${COUCHDB_VERSION}/apache-couchdb-${COUCHDB_VERSION}.tar.gz \
    && tar xvzf apache-couchdb-${COUCHDB_VERSION}.tar.gz   && cd apache-couchdb-${COUCHDB_VERSION}   \
    && ./configure && make && make install

### set up user to run couchdb and set permissions for new user to access couchdb files:
RUN useradd -d /var/lib/couchdb couchdb
# permissions
RUN chown -R couchdb:couchdb \
  /usr/local/lib/couchdb /usr/local/etc/couchdb \
  /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb \
  && chmod -R g+rw \
  /usr/local/lib/couchdb /usr/local/etc/couchdb \
  /usr/local/var/lib/couchdb /usr/local/var/log/couchdb /usr/local/var/run/couchdb


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
## setup for apache server...has LDAP configs and proxy pass
COPY apache2.conf     /etc/apache2/apache2.conf


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf



CMD ["/usr/bin/supervisord"]
