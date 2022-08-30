FROM quay.io/fedora/fedora:37

RUN dnf install -y  openssh-server && dnf clean all && rm -rf /var/cache/yum.

# Using the SCC for anyuid we can set the default shell for the UID. Exmaple here is UID: 1000
RUN echo "1000:x:1000:0:1000 user:/:/bin/bash" >> /etc/passwd

# When not using SCC anyuid, we MUST override the `/sbin/nologin` value to ensure the when CRIO sets the shell, it allows login
RUN rm /sbin/nologin && ln /bin/bash /sbin/nologin

COPY ./scripts/init.sh /init.sh

ENTRYPOINT ["/init.sh"]

