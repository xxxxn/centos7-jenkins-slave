FROM centos:centos7
MAINTAINER Alexander Naydenko "an@zeppelinen.com"  
  
RUN yum -y install epel-release.noarch
RUN rpm -Uhv --force http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

RUN yum -y update  
RUN yum -y install openssh-server  
RUN yum -y install supervisor  
RUN yum -y install java-1.7.0-openjdk  
RUN yum -y install rpm-build
RUN yum -y install redhat-rpm-config
RUN yum -y install make
  
RUN echo "root:password" | chpasswd  
RUN useradd jenkins -m -d /build
RUN echo "jenkins:jenkins" | chpasswd  
  
RUN mkdir -p /var/run/sshd  
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''  
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd  
  
RUN mkdir -p /var/run/supervisord  
ADD supervisord.conf /etc/supervisord.conf  

RUN mkdir -p /build/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN echo '%_topdir %(echo $HOME)/rpmbuild' > /build/.rpmmacros
RUN chown -R jenkins:jenkins /build 
 
EXPOSE 22  
CMD ["/usr/bin/supervisord"]  
