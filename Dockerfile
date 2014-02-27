# Starchup Dashboard Rails
#
# VERSION 0.1
#
# Cudos to Nicolas BERNARD and gemnasium for ideas

# Usage
#
# # assume /tmp/root is your shared directory with this docker
# # assume 20022 is your ssh port for this docker, password: root
# docker run -d -v /tmp/root:/root -p 20022:22 glesage/13.10-apache /usr/sbin/sshd -D
# ssh -p 20022 root@localhost

FROM ubuntu:12.04
MAINTAINER Geoffroy Lesage <gefthefrench@gmail.com>
 
# NodeJS (Assets pipeline)
RUN apt-get update
RUN apt-get install -y python-software-properties python g++ make
RUN add-apt-repository ppa:chris-lea/node.js
 
# Dependencies
RUN apt-get update
RUN apt-get -y install curl git-core nodejs

# RVN
RUN apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN curl -L https://get.rvm.io | bash -s stable
RUN source ~/.rvm/scripts/rvm
RUN echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc

# Ruby
RUN rvm install 2.1.1
RUN rvm use 2.1.1 --default
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Rails
RUN gem install rails

# MySQL
RUN apt-get install mysql-server mysql-client libmysqlclient-dev
 
# Final Configs
RUN mkdir -p /var/webapp
ADD . /var/webapp
WORKDIR /var/webapp
EXPOSE 8080
CMD ["rails", "server"]