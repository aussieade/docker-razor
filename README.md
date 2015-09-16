## docker-razor

Create a storage container before running this:

```
docker run --name razor-store -v /var/lib/razor/repo-store -v /var/lib/pgsql -v /var/logs busybox true
```

Start docker-razor and attach storage and link ports, mount tasks locally for review/edit

```
docker run --name razor-server --hostname razor-server -d -p 8080:8080 \
  -v /some/path:/opt/razor/tasks --volumes-from razor-store docker-razor
```

The first time this is run the /start.sh script will set up the db if it has
not been yet.  It will also check for the razor microkernel and grab and unpack it.

You will then need a DHCP and TFTP server to point to this container, and a
razor-client installed somewhere to interact with this container. Details are
available at the [razor wiki](https://github.com/puppetlabs/razor-server/wiki)


Based off [sedlund's](https://hub.docker.com/r/sedlund/centos-razor-server/) container but using package for
razor-server so we get a working version of jruby.
