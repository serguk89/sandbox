#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# /vagrant/database/backups
#
# database will be backup to this location when you vagrant halt or vagrant destroy, this
# allows you to be able to restore database if you do  vagrant destroy and kept all existing
# files and folders exactly the way it is or else it will fail, so be creative and be careful.
if [[ -d /vagrant/database/backups ]]; then
    /vagrant/config/bin/db_restores
fi