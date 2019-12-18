role=$1
nodename=$(hostname)
rpm -Uvh https://yum.puppet.com/puppet6-release-el-7.noarch.rpm
yum install -y puppet-agent
cat << EOF >> /etc/puppetlabs/puppet/puppet.conf
[main]
certname = master01
server = puppet-master
EOF
sed -i "s/master01/${nodename}/g" /etc/puppetlabs/puppet/puppet.conf
source /etc/profile.d/puppet-agent.sh
puppet resource service puppet ensure=running enable=true
mkdir -p /etc/facter/facts.d
cat << EOF >> /etc/facter/facts.d/role.yaml
---
role: roleval
EOF
sed -i "s/roleval/${role}/g" /etc/facter/facts.d/role.yaml
puppet agent -t
systemctl start puppet
systemctl enable puppet
