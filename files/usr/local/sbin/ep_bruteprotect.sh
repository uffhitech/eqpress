#!/bin/bash
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

if [ -z $1 ]; then
        echo  -n "Site you want to install BruteProtect for: "
        read site
else   
        site=$1
fi

docroot=/var/www/${site}/wordpress

if [ ! -d ${docroot}/wp-content/mu-plugins ]; then
	echo ${site} is bunk
	exit 1
fi

if [ -f ${docroot}/wp-content/mu-plugins/bruteprotect.php ]; then
	echo bruteprotect plugin already installed for ${site}
else
    cp -a /var/www/easypress.ca/bruteprotect/* ${docroot}/wp-content/mu-plugins
fi

wp --allow-root --path=${docroot} option get bruteprotect_api_key || \
    wp --allow-root --path=${docroot} option add bruteprotect_api_key c8d34d4da6a03ef38d1d917bdc2b03e4af102cff
exit 0
