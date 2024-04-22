#!/bin/bash
pkg=$1
if [ ! -e /var/db/repos/gentoo/$pkg ]; then
    echo Missing in portage: $pkg
    exit 1
fi
mkdir -p /usr/local/portage/$pkg
cp -r /var/db/repos/gentoo/$pkg/* /usr/local/portage/$pkg 
