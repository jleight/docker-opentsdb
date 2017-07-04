docker build -t kamir/opentsdb_2.4.0_on_hbase_1.2.6 -t kamir/opentsdb . 

export T=$(date +%I_%M_%S)
echo $T

docker create \
    --name opentsdb-data_$T \
    kamir/opentsdb

docker run \
    --name opentsdb-app-stack_$T \
    --volumes-from opentsdb-data_$T \
    -p 4242:4242 \
    kamir/opentsdb

