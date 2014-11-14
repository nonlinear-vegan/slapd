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


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY .vimrc           /root/.vimrc
COPY .alias           /root/.alias
COPY .bashrc          /root/.bashrc

#RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf


EXPOSE 22 80 
CMD ["/usr/bin/supervisord"]
