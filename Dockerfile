# ssr-with-net-speeder
FROM ubuntu:14.04
MAINTAINER https://github.com/WinstonH

ENV ssr_key 123456780

RUN apt-get update && \
apt-get clean  

RUN apt-get install -y openssh-server python python-pip python-m2crypto libnet1-dev libpcap0.8-dev git gcc supervisor vim && \
apt-get clean

COPY supervisord.conf /etc/supervisord.conf

RUN echo "root:root"|chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN git clone -b manyuser https://github.com/shadowsocksr/shadowsocksr.git ssr
RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh

RUN mv net_speeder /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/net_speeder

EXPOSE 22 80 443 8080 8989

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
