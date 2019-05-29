
FROM    ubuntu:16.04
LABEL   Name=acestream-nginx-proxy Version=1.0.0

RUN apt-get update -y
# General dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    monit \
    unzip \
    nginx \
    wget
# Acestream
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libpython2.7-dev \
    python-apsw \
    python-m2crypto \
    python-apsw

RUN cd /tmp/ && wget "http://dl.acestream.org/linux/acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz"
RUN cd /tmp/ && tar zxvf acestream_3.1.16_ubuntu_16.04_x86_64.tar.gz
RUN cd /tmp/ && mv acestream_3.1.16_ubuntu_16.04_x86_64 /opt/acestream

# ADD scripts into monit
COPY acestream.sh /opt/acestream
RUN chmod +x /opt/acestream/acestream.sh

COPY acestream.conf /etc/monit/conf-enabled
RUN service monit restart

# Replace nginx config
COPY default /etc/nginx/sites-available/default
RUN service nginx restart

#sshd user
RUN echo 'root:toor' |chpasswd

EXPOSE 22 80
