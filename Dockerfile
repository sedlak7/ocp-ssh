FROM registry.access.redhat.com/ubi9/ubi

RUN dnf install -y  openssh-server && dnf clean all && rm -rf /var/cache/yum.

# Using the SCC for anyuid we can set the default shell for the UID. Exmaple here is UID: 1000
#RUN echo "1000:x:1000:0:1000 user:/:/bin/bash" >> /etc/passwd
RUN useradd -m sftpuser -d /home/sftpuser -g 0 -u 1000 && echo "sftpuser:sftpuser" | chpasswd 

# When not using SCC anyuid, we MUST override the `/sbin/nologin` value to ensure the when CRIO sets the shell, it allows login
RUN rm /sbin/nologin && ln /bin/bash /sbin/nologin

COPY ./scripts/init.sh /init.sh

ENTRYPOINT ["/init.sh"]

