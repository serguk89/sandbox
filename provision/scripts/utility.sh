#!/bin/bash

# /var/log/provision/${date}/resources/${2}/${2}.log
#
# This will generate a ${2}.log during provision, if it exists then it will generate
# a log to tell if it is suceeded or failed.
date=`cat /vagrant/provisioning_at`
folder="/var/log/provision/${date}/resources/${2}"
file="${folder}/${2}.log"
mkdir -p ${folder}
touch ${file}
exec > >(tee -a "${file}" )
exec 2> >(tee -a "${file}" >&2 )


# provision.sh
#
# this is where the utitilies comes in to play, when a feature is enabled then
# it find  specific core feature and use this to run  provision to install or 
# update a feature.
provisioner="/srv/provision/resources/${1}/${2}/provision.sh"
if [[ -f $provisioner ]]; then
    ${provisioner}
fi