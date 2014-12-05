## apache server

FROM  ubuntu:14.04

#RUN apt-get update && apt-get install -y openssh-server apache2 supervisor
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p  /var/run/sshd /var/log/supervisor

## some other things I like to have:
RUN apt-get update && apt-get install -y vim curl

## set root password to something seriously challenging...
RUN echo 'root:apple' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


COPY config_files/vimrc           /root/.vimrc
COPY config_files/alias           /root/.alias
COPY config_files/bashrc          /root/.bashrc


EXPOSE 22 80 

RUN apt-get update && apt-get install -y apache2
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf



CMD ["/usr/bin/supervisord"]
