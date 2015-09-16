#!/bin/bash

mkernelurl=http://links.puppetlabs.com/razor-microkernel-latest.tar
mkerneltar=`basename $mkernelurl`
repodir=/var/lib/razor/repo-store

# Setup the postgres DB if it hasnt been.
if [[ ! -x /etc/init.d/postgresql-9.2 ]]; then
  mkdir -p /var/lib/pgsql/9.2 2>/dev/null
  puppet apply /root/install.pp
  sed -i -e 's/razor_prd/razor/' -e 's/mypass/ef1aiSh8/g' /etc/razor/config.yaml
  cd /opt/razor
  jruby bin/razor-admin -e production migrate-database
  torquebox deploy --env production
fi

# Install the Razor Microkernel, if it hasnt yet.
if [[ ! -e $repodir/microkernel/vmlinuz0 ]]; then
  cd $repodir
  curl -LO $mkernelurl
  tar xfva $mkerneltar
fi

/etc/init.d/postgresql-9.2 start && \
  torquebox run --bind-address=0.0.0.0
