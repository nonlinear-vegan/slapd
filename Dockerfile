## apache server

FROM  ubuntu:14.04

RUN apt-get update && apt-get install -y openssh-server apache2 supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor

## get GitLab
#COPY gitlab_7.4.1-omnibus-1_amd64.deb /root/gitlab_7.4.1-omnibus-1_amd64.deb
## newer version:
COPY gitlab_7.4.3-omnibus.1-1_amd64.deb /root/gitlab_7.4.3-omnibus.1-1_amd64.deb
#RUN wget https://downloads-packages.s3.amazonaws.com/debian-7.6/gitlab_7.4.1-omnibus-1_amd64.deb

## some other things I like to have:
RUN apt-get update && apt-get install -y vim

## set root password to something seriously challenging...
RUN echo 'root:apple' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


#RUN apt-get update && apt-get install ca-certificates

## some more gitlab stuff:
#RUN cd /root && dpkg -i gitlab_7.4.3-omnibus-1_amd64.deb

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .vimrc           /root/.vimrc
COPY .alias           /root/.alias
COPY .bashrc          /root/.bashrc

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

## configuration for gitlab:
COPY gitlab.rb      /etc/gitlab/gitlab.rb


EXPOSE 22 80 
CMD ["/usr/bin/supervisord"]
