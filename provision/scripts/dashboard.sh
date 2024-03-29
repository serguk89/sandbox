#!/usr/bin/env bash
repo=$1
branch=${2:-master}
dir="/srv/www/dashboard/public_html"

# /var/log/provision/${date}/dashboard/dashboard.log
#
# This will generate a dashboard.log during provision, if it exists then it will generate
# a log to tell if it is suceeded or failed.
date=`cat /vagrant/provisioning_at`
folder="/var/log/provision/${date}/dashboard"
file="${folder}/dashboard.log"
mkdir -p ${folder}
touch ${file}
exec > >(tee -a "${file}" )
exec 2> >(tee -a "${file}" >&2 )

# noroot
#
# noroot allows provision scripts to be run as the default user "vagrant" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "vagrant" "$@";
}

# dashboard
#
# this will install a dashboard specifically under the following directory so that it can be
# served as a site. 
if [[ ! -d ${dir} ]]; then
  cp "/srv/config/nginx/nginx.conf" "/etc/nginx/conf.d/dashboard.conf"
  sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/nginx/conf.d/dashboard.conf"
fi

if [[ false != "dashboard" && false != "${repo}" ]]; then
  if [[ ! -d ${dir}/.git ]]; then
    echo "Downloading: Dashboard"
    git clone ${repo} --branch ${branch} ${dir} -q
    cd ${dir}
    git checkout ${branch} -q
  else
    echo "Updating: Dashboard"
    cd ${dir}
    git pull origin ${branch} -q
  fi
fi
exit 0