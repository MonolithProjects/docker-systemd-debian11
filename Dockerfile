FROM debian:bullseye
LABEL maintainer="Michal Muransky"
ENV \
    container=docker \
    MY_USER=ansible \
    MY_GROUP=ansible \
    MY_UID=1000 \
    MY_GID=1000

# hadolint ignore=DL3046,DL3008,SC2039
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        locales \
        python-setuptools \
        python-pip \
        software-properties-common \
        rsyslog systemd systemd-cron sudo iproute2 \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/* \
    && rm -f /lib/systemd/system/plymouth* \
    && rm -f /lib/systemd/system/systemd-update-utmp* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && set -eux \
    && groupadd -g ${MY_GID} ${MY_GROUP} \
    && useradd -m -d /home/ansible -s /bin/bash -G ${MY_GROUP} -g ${MY_GID} -u ${MY_UID} ${MY_USER} \
    && echo "%${MY_USER}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers \
    \
    && mkdir /home/ansible/.gnupg \
    && chown ansible:ansible /home/ansible/.gnupg \
    && chmod 0700 /home/ansible/.gnupg \
    \
    && mkdir /home/ansible/.ssh \
    && chown ansible:ansible /home/ansible/.ssh \
    && chmod 0700 /home/ansible/.ssh \
    && locale-gen en_US.UTF-8 \
    && mkdir -p /etc/ansible \
    && echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
