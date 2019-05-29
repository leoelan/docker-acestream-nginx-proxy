
FROM    ubuntu:16.04
LABEL   Name=acestream-nginx-proxy Version=1.0.0

RUN apt-get update -y
# General dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    monit \
    unzip \
    nginx \
    wget \
    net-tools
# Acestream
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libpython2.7-dev \
    python-apsw \
    python-m2crypto \
    python-apsw \
    python-setuptools

RUN cd /tmp/ && wget "http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
RUN cd /tmp/ && tar zxvf acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz
RUN cd /tmp/ && mv acestream_3.1.16_ubuntu_16.04_x86_64 /opt/acestream

# ADD scripts into monit
COPY acestream.sh /opt/acestream
RUN chmod 777 /opt/acestream/acestream.sh
RUN service monit stop
COPY acestream.conf /etc/monit/conf.d
RUN chmod 777 /etc/monit/monitrc
COPY monitrc /etc/monit/monitrc
RUN chmod 600 /etc/monit/monitrc
#RUN service monit start

# Replace nginx config
COPY default /etc/nginx/sites-available/default
#RUN service nginx restart

#sshd user
RUN echo 'root:toor' |chpasswd

EXPOSE 80

#COPY start.sh /start.sh
#RUN chmod 777 /start.sh
CMD nginx && /opt/acestream/start-engine --client-console
