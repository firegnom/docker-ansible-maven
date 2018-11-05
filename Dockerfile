# Dockerfile for building Ansible image for Debian 9 (stretch), with as few additional software as possible.
#
# @see https://launchpad.net/~ansible/+archive/ubuntu/ansible
#
# Version  1.0
#


# pull base image
FROM maven:3.5-jdk-8

MAINTAINER Firegnom <mk@firegnom.com>


RUN echo "===> Installing python, sudo, and supporting tools..."  && \
    apt-get update -y  &&  apt-get install --fix-missing          && \
    DEBIAN_FRONTEND=noninteractive         \
    apt-get install -y                     \
        python python-yaml sudo            \
        curl gcc python-pip python-dev libffi-dev libssl-dev  && \
    apt-get -y --purge remove python-cffi          && \
    pip install --upgrade cffi pywinrm             && \
    \
    \
    \
    echo "===> Installing Ansible..."   && \
    pip install ansible                 && \
    \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    apt-get install -y sshpass openssh-client  && \
    \
    \
    echo "===> Removing unused APT resources..."                  && \
    apt-get -f -y --auto-remove remove \
                 gcc python-pip python-dev libffi-dev libssl-dev  && \
    apt-get clean                                                 && \
    rm -rf /var/lib/apt/lists/*  /tmp/*                           && \
    \
    \
    echo "===> Adding hosts for convenience..."        && \
    mkdir -p /etc/ansible                              && \
    echo 'localhost' > /etc/ansible/hosts
RUN echo "===> Installing docker"        && \
    apt-get -y update && \
    apt-get -y  install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \

    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive         \
    apt-get install -y docker-ce docker-compose

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
