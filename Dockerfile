# Starchup Dashboard Rails
#
# VERSION 0.1
#
# Cudos to Nicolas BERNARD for ideas

# Usage
#
# # assume /tmp/root is your shared directory with this docker
# # assume 20022 is your ssh port for this docker, password: root
# docker run -d -v /tmp/root:/root -p 20022:22 glesage/13.10-apache /usr/sbin/sshd -D
# ssh -p 20022 root@localhost

FROM ubuntu:12.04
MAINTAINER Geoffroy Lesage <gefthefrench@gmail.com>
 
# Ruby
RUN echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu precise main > /etc/apt/sources.list.d/brightbox.list
 
# NodeJS (Assets pipeline)
RUN echo deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main > /etc/apt/sources.list.d/nodejs.list
 
# Dependencies
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ruby2.0 ruby2.0-dev nodejs build-essential git libssl-dev libxslt-dev libxml2-dev libsqlite3-dev
# We need --pre for bundler 1.5 which brings parallels jobs
RUN gem2.0 install bundler --pre --no-rdoc --no-ri
 
RUN mkdir -p /var/webapp
ADD . /var/webapp
RUN cd /var/webapp && bundle install --deployment --jobs 4
 
WORKDIR /var/webapp
EXPOSE 3000
ENTRYPOINT ["bin/bundle", "exec"]
CMD ["rails", "server"]