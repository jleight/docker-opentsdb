opentsdb
========

The opentsdb container runs [OpenTSDB](http://opentsdb.net/) along with
[HBase](http://hbase.apache.org/).

Version 
-------
This branch provides version 2.4.0RC1 We load the package from:
https://github.com/OpenTSDB/opentsdb/releases/download/v2.4.0RC1/opentsdb-2.4.0RC1_all.deb

Version 2.3.0 can be loaded from:
https://github.com/OpenTSDB/opentsdb/releases/download/v2.3.0/opentsdb-2.3.0_all.deb



Quick Start
-----------

To quickly spin up an instance of OpenTSDB, simply specify a port forwarding
rule and run the container:

    $ docker run \
        -p 4242:4242 \
        jleight/opentsdb

Usage
-----

OpenTSDB relies on HBase to store its data. HBase has been configured to store
its data in the `/var/opt/hbase` directory, which has been defined as a volume.
As such, it is recommended to either map this volume to a host directory, or to
create a data container for the volume. This way, the container can be upgraded
without losing all of your data.

A data container can be created by running the following command:

    $ docker create \
        --name opentsdb-data \
        jleight/opentsdb

The application container can then be started by running:

    $ docker run \
        --name confluence \
        --volumes-from opentsdb-data \
        -p 4242:4242 \
        jleight/opentsdb
