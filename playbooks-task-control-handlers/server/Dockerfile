FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y

# Install OpenSSH Server
RUN apt-get install -y openssh-server

RUN echo "root:test123" | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]