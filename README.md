# Redtruck

Redtruck is a [HAProxy][haproxy] load balancer that is dynamically configured using [Serf][serf]. It looks for other instances running Serf in the same discovery cluster name and adds them to the [HAProxy][haproxy] configuration. It is designed to be run on each Docker host to provide a frontend to multiple instances of your application running on the same host.

## Configuration

Configuration happens through environment variables. The following are available:

* `SERF_CLUSTER=myapp` - The [Serf][serf] cluster to join using mDNS.
* `SERF_ROLE=balancer` - The [Serf][serf] role to assign your balancers. Nodes in this role are ignored by the [Serf][serf] event handler scripts.
* `MATCH_NODE_ROLE=appserv` - The [Serf][serf] role to match for when adding nodes to [HAProxy][haproxy].
* `SYSLOG_SERVER=logs.papertrailapp.com` - A UDP syslog host to send event logs to.
* `SYSLOG_PORT=37923` - The syslog server UDP port.
* `SYSLOG_TAG=redtruck` - The syslog application name.
* `NODE_PORT=7474` - Port that [HAProxy][haproxy] will connect to for your backend application when a node is added.

An example environment file named `redtruck.env` might look like:

    SERF_CLUSTER=myapp
    SERF_ROLE=balancer
    MATCH_NODE_ROLE=appserv
    SYSLOG_SERVER=logs.papertrailapp.com
    SYSLOG_PORT=37923
    SYSLOG_TAG=redtruck
    NODE_PORT=7474

Which can be passed at container run time with `--env-file`.

## Running

Only one Redtruck instance should be run one a given Docker host per `SERF_CLUSTER`. If you have multiple applications per host, you should set `SERF_CLUSTER` per application and run one Redtruck instance for each application.

The quickest way to get started is by pulling the image already built from this repository:

    docker pull andyshinn/redtruck

Then run with your environment file (see [Configuration](#Configuration) section above):

    docker run -d -p 8040:8040 --env-file redtruck.env andyshinn/redtruck

You will likely want to customize the [HAProxy][haproxy] configuration file. Backend nodes will be added to the bottom of the file:

    docker run -d -p 8040:8040 --env-file redtruck.env -v /path/to/my/haproxy.cfg:/etc/haproxy/haproxy.cfg andyshinn/redtruck


[serf]: http://www.serfdom.io/
[haproxy]: http://haproxy.1wt.eu/
