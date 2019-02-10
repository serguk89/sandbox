#!/bin/bash

# variables
#
# default variables to create sites and directories and some other stuff.
domain=$1
site_escaped=`echo ${domain} | sed 's/\./\\\\./g'`
repo=$2
branch=$3
vm_dir=$4
skip_provisioning=$5
path_to_site=${vm_dir}
site_name=${domain}

# /vagrant/sandbox-custom.yml
#
# this allows you to grab information that are needed and use shyaml to read only,since
# shyaml is not writeable but read only.
SANDBOX_CONFIG=/vagrant/sandbox-custom.yml

# noroot
#
# noroot allows provision scripts to be run as the default user "vagrant" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "vagrant" "$@";
}

# Takes 2 values, a key to fetch a value for, and an optional default value
# e.g. echo `get_config_value 'key' 'defaultvalue'`
get_config_value() {
    local value=`cat ${SANDBOX_CONFIG} | shyaml get-value sites.${site_escaped}.custom.${1} 2> /dev/null`
    echo ${value:-$2}
}

if [[ false != "${repo}" ]]; then
  # Clone or pull the site repository
  if [[ ! -d ${vm_dir}/provision/.git ]]; then
    echo -e "\nDownloading ${domain}, see ${repo}"
    noroot git clone --recursive --branch ${branch} ${repo} ${vm_dir}/provision -q
  else
    echo -e "\nUpdating ${domain}..."
    cd ${vm_dir}/provision
    noroot git reset origin/${branch} --hard -q
    noroot git pull origin ${branch} -q
    noroot git checkout ${branch} -q
  fi
else
  echo "The site: '${domain}' does not have a site template, assuming provision/setup.sh"
  if [[ ! -d ${vm_dir} ]]; then
    echo "Error: The '${domain}' has no folder."
  fi
fi

if [[ -d ${vm_dir} ]]; then
    if [[ -f ${vm_dir}/provision/setup.sh ]]; then
      cd ${vm_dir}/provision && source setup.sh
    fi
fi