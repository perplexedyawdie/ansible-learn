FROM python:3.9.18-slim-bullseye

RUN apt update && apt upgrade -y

# Install OpenSSH Server
RUN apt install -y openssh-server && apt install -y sshpass && apt install -y nano && apt install -y git

RUN pip install ansible

RUN pip install ansible-lint

RUN echo "root:test123" | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

WORKDIR /root/ansible_learn

COPY init_script.sh .

COPY inventory.yaml .

RUN chmod +x ./init_script.sh

EXPOSE 22

CMD /root/ansible_learn/init_script.sh && /usr/sbin/sshd -D
