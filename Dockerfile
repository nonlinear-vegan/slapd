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
RUN apt-get update && apt-get install -y build-essential    \
    && apt-get install -y erlang-base erlang-dev erlang-nox erlang-eunit \
    && apt-get install -y libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool

## get the source:
RUN cd /usr/local/src && curl -O http://apache.mirrors.tds.net/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz \
    && tar xvzf apache-couchdb-1.6.1.tar.gz   && cd apache-couchdb-1.6.1   \
    && ./configure && make && make install


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .vimrc           /root/.vimrc
COPY .alias           /root/.alias
COPY .bashrc          /root/.bashrc

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf


EXPOSE 22 80 
CMD ["/usr/bin/supervisord"]
