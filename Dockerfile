# ssr-with-net-speeder
FROM ubuntu:14.04
MAINTAINER https://github.com/WinstonH

RUN apt-get update && \
    apt-get clean && \
    apt-get install -y openssh-server python python-pip python-m2crypto libnet1-dev libpcap0.8-dev git supervisor vim && \
    apt-get clean

COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN echo "root:root"|chpasswd && \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh && mv net_speeder /usr/local/bin/ && \
    chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/net_speeder

WORKDIR /root
EXPOSE 22 80 443 3306 8080 8989

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
