#!/bin/bash
pkg=$1
if [ ! -e /usr/portage/$pkg ]; then
    echo Missing in portage: $pkg
    exit 1
fi
mkdir -p /usr/local/portage/$pkg
cp -r /usr/portage/$pkg/* /usr/local/portage/$pkg 
