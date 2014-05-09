FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get install -q -y haproxy supervisor unzip

ADD config/haproxy.enabled /etc/default/haproxy
ADD config/haproxy.cfg /etc/haproxy/haproxy.cfg
ADD config/supervisord-haproxy.conf /etc/supervisor/conf.d/haproxy.conf
ADD config/supervisord-serf.conf /etc/supervisor/conf.d/serf.conf
ADD scripts/leave.sh /usr/local/bin/leave.sh
ADD scripts/join.sh /usr/local/bin/join.sh
ADD scripts/start_serf.sh /usr/local/bin/start_serf.sh
ADD https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip serf.zip

RUN unzip serf.zip
RUN rm serf.zip
RUN mv serf /usr/local/bin/
RUN chmod +x /usr/local/bin/leave.sh /usr/local/bin/join.sh /usr/local/bin/start_serf.sh

EXPOSE 8040/tcp 7946/tcp 7946/udp

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]

