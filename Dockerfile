# SeqWare 
#
# VERSION               1.1.0-alpha.6 
#
# Setup SeqWare with WhiteStar (no sge, no oozie, no metadata)
# Volume mount \datastore to persist the contents of your workflows
# ex: docker run --privileged  -h master --rm -t -i -v `pwd`/datastore:/datastore -v `pwd`/workflows/Workflow_Bundle_dockerHelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-rc.0:/workflow  seqware/seqware_whitestar

FROM ubuntu:12.04
MAINTAINER Denis Yuen <denis.yuen@oicr.on.ca>

# use ansible to create our dockerfile, see http://www.ansible.com/2014/02/12/installing-and-building-docker-with-ansible
RUN apt-get -y update ;\
    apt-get install -y python-yaml python-jinja2 git wget;\
    git clone http://github.com/ansible/ansible.git /tmp/ansible
WORKDIR /tmp/ansible
# get a specific version of ansible , add sudo to seqware, create a working directory
RUN git checkout v1.6.10 ;\
    adduser --gecos 'Ubuntu user' --shell /bin/bash --disabled-password --home /home/seqware seqware ;\
    apt-get install -y sudo vim;\
    adduser seqware sudo ;\
    sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers ;\
    mkdir /datastore && chown seqware /datastore
ENV PATH /tmp/ansible/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ANSIBLE_LIBRARY /tmp/ansible/library
ENV PYTHONPATH /tmp/ansible/lib:$PYTHON_PATH
ENV HOME /home/seqware
WORKDIR /home/seqware
USER seqware
# setup seqware white star
RUN git clone https://github.com/SeqWare/seqware-bag.git
WORKDIR /home/seqware/seqware-bag 
RUN git checkout 1.0-beta.0
ADD inventory /etc/ansible/hosts
RUN ansible-playbook mini-seqware-install.yml -c local --extra-vars "seqware_version=1.1.0-rc.1"
ENV PATH /home/seqware/bin:/tmp/ansible/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# at this point, seqware has been fully setup
USER root

# setup docker in docker functionality assuming socket binding, inspired by https://github.com/jpetazzo/dind and https://github.com/docker/docker/issues/7285
# example command: docker run --privileged  -h master --rm -t -i -v /var/run/docker.sock:/var/run/docker.sock seqware/seqware_whitestar
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables
# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh
# Add non-root access to docker
RUN sudo gpasswd -a seqware docker
USER seqware
WORKDIR /home/seqware
