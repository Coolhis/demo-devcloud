#!/bin/bash

if [ ! -d /vagrant ]; then
	echo Cannot run outside vagrant!
	exit 2
fi

install_packages() {
	DEBIAN_FRONTEND='noninteractive' DEBCONF_FRONTEND='noninteractive' apt-get install -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' -y --force-yes --allow-unauthenticated \
		"$@"
}

if [ ! -x /usr/bin/ansible ]; then
	apt-get update
	install_packages python-software-properties
	add-apt-repository ppa:ansible/ansible
	apt-get update
	install_packages ansible
fi

cd /vagrant/ansible
export PYTHONUNBUFFERED=1

ansible-playbook $1.yml

echo
echo "All done. Happy hacking with $1!"
