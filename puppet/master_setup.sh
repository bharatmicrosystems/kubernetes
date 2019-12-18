rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
yum install -y puppetserver
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
[master]
dns_alt_names = puppet-master
vardir = /opt/puppetlabs/server/data/puppetserver
logdir = /var/log/puppetlabs/puppetserver
rundir = /var/run/puppetlabs/puppetserver
pidfile = /var/run/puppetlabs/puppetserver/puppetserver.pid
codedir = /etc/puppetlabs/code
[main]
dns_alt_names = puppet-master
server = puppet-master
EOF
source /etc/profile.d/puppet-agent.sh
puppetserver ca setup
systemctl start puppetserver
systemctl enable puppetserver
usermod -aG wheel puppet
echo 'puppet ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
cd /etc/puppetlabs/code/environments/production/
git clone https://github.com/bharatmicrosystems/kubernetes-puppet.git .
cp -a /etc/puppetlabs/code/environments/production/modules/profile/files/* /usr/bin/.
