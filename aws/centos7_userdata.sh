#!/bin/bash

# ################## ADD THE EPEL REPO ##################
yum install -y wget curl
wget -r --no-parent -A 'epel-release-*.rpm' http://dl.fedoraproject.org/pub/epel/7/x86_64/e/ 
rpm -Uvh dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-*.rpm

# ################## SET HOST VALUES ##################
PUBLIC_IP=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
PRIVATE_IP=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
echo "$PRIVATE_IP  kalekimo.sprint.local" >> /etc/hosts
echo "$PUBLIC_IP   kalekimo.sprint" >> /etc/hosts

# ################## DEVOP TOOLS/PYTHON/PIP ##################
yum install -y sshd sudo python-pip python-dev build-essential lynx elinks tmux
pip install -U pip
curl https://raw.githubusercontent.com/ssgeejr/config/master/.tmux.conf > /etc/tmux.conf


# ################## JDK ##################
# latest version: jdk-9.0.4_linux-x64_bin.tar.gz
cd /opt/
wget -c --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz"
tar -zxf jdk-8u60-linux-x64.tar.gz
update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_60/bin/java 1
echo "JAVA_HOME=/opt/jdk1.8.0_60" >> /etc/profile
echo "export JAVA_HOME" >> /etc/profile
. /etc/profile
rm -rf jdk-8u60-linux-x64.tar.gz

# ########### CREATE THE NEW USER ###########
adduser devops
cd /home/devops
mkdir .ssh

cat << EOF > /home/devops/.ssh/config
Host *
    StrictHostKeyChecking no
EOF

cat << EOF > /home/devops/.ssh/authorized_keys
_your_pub_key_
EOF

chown -R devops.devops /home/devops/.ssh
chmod 600 /home/devops/.ssh/*
chmod 700 /home/devops/.ssh

echo "%devops ALL=(ALL) NOPASSWD: LOG_INPUT: ALL"  > /etc/sudoers.d/scm-devops






















