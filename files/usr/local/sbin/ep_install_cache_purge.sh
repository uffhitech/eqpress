#!/bin/sh
#
# ep_install_cache_purge.sh
#
# Installation script for nginx cache purge.
# Specify the domain to install in as first argument.
#
export PATH=/usr/local/sbin:/bin:/usr/bin

mu_install() {
	SITE=$1
	MU_DIR=/var/www/${SITE}/wordpress/wp-content/mu-plugins
	if [ ! -d ${MU_DIR} ]; then
		echo mu-plugins directory DOES NOT exist for ${SITE} therefore creating it.
		mkdir ${MU_DIR}
	fi
	cp -a /var/www/easypress.ca/cache-purge/* ${MU_DIR}/
	chwebown /var/www/${SITE}/wordpress/wp-content/mu-plugins
}

get_site() {
	for f in `ls -1 /var/www`; do
		site=`basename $f`
		if [ -d /var/www/${site} ]; then
			mu_install ${site}
			echo $site - Success!
		else
			echo $site - Not a directory. Installation failed.
		fi
	done
}

if [ -n "$1" ]; then
	if [ "$1" = "all" ]; then
		get_site
		exit
	fi

	if [ -d /var/www/$1 ]; then
		site=$1
		mu_install ${site}
		exit 0
	else
		echo "$1 not a valid domain (e.g. example.com). Should exist under /var/www."
		exit 1
	fi
else
	echo "No site specified. Should be a domain name like example.com and exist under /var/www"
fi

echo -n "About to install cache-purge for every site. You sure? [y/n] "
read ask
if [ $ask = 'y' ]; then
	get_site
fi
exit 0
