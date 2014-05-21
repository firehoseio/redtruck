FROM ubuntu:trusty
MAINTAINER Andy Shinn <andys@andyshinn.as>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get install -q -y haproxy supervisor unzip

ADD config/haproxy.enabled /etc/default/haproxy
ADD config/haproxy.cfg /etc/haproxy/haproxy.cfg
ADD config/supervisord-haproxy.conf /etc/supervisor/conf.d/haproxy.conf
ADD config/supervisord-serf.conf /etc/supervisor/conf.d/serf.conf
ADD scripts/handler /usr/local/bin/handler
ADD scripts/start_serf /usr/local/bin/start_serf
ADD scripts/logger /usr/local/bin/logger
ADD https://dl.bintray.com/mitchellh/serf/0.6.0_linux_amd64.zip serf.zip

RUN unzip serf.zip
RUN rm serf.zip
RUN mv serf /usr/local/bin/
RUN chmod +x /usr/local/bin/handler /usr/local/bin/start_serf

EXPOSE 8040/tcp 7946/tcp 7946/udp

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
