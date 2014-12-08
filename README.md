# Dockerized Standalone LDAP Daemon run with supervisor.

Container includes vim and apache2 just for kicks, and sshd to log in update the LDAP database (you can also update from outside the container).

Yes, I know, sshd in a container is considered poor form,
[http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/][1]
and in principle I agree...but for dinking around and testing?
It's super convenient.

The root password both for the container and slapd are set to 'root_password' in
the Dockerfile.

The LDAP BASE and URI are set in config_files/ldap.conf.



To build the container:

  `docker build -t slapd .`

To run the container:
  
  `docker run -p 49222:22 -p 49980:80 -p 49389:389 -d --name slapd slapd`

To ssh into continer:

  `ssh root@localhost -p 49222`

To add testdata.ldif to the container, from WITHIN the container:

  `ldapadd -x -D cn=admin,dc=ldaptest,dc=local -W -f testdata.ldif`

To search the database from OUTSIDE the container:

  `ldapsearch -x -H ldap://localhost:49389 -b dc=ldaptest,dc=local`

To add othertestdata.ldif from OUTSIDE the container:

  `ldapadd -x -H ldap://localhost:49389 -W -f othertestdata.ldif -D cn=admin,dc=ldaptest,dc=local`


  [1]: http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/ "jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil"
