FROM java:8-jre
LABEL maintainer="Jonathon Leight <jonathon.leight@jleight.com>"

ENV JAVA_HOME     /usr/lib/jvm/java-8-openjdk-amd64

ENV HBASE_VERSION 1.2.6
ENV HBASE_BASEURL http://apache.org/dist/hbase/stable
ENV HBASE_PACKAGE hbase-${HBASE_VERSION}-bin.tar.gz
ENV HBASE_URL     ${HBASE_BASEURL}/${HBASE_PACKAGE}
ENV HBASE_HOME    /opt/hbase
ENV HBASE_DATA    /var/opt/hbase

ENV OTSDB_VERSION 2.4.0RC1
ENV OTSDB_GITHUB  https://github.com/OpenTSDB/opentsdb
ENV OTSDB_BASEURL ${OTSDB_GITHUB}/releases/download/v${OTSDB_VERSION}
ENV OTSDB_PACKAGE opentsdb-${OTSDB_VERSION}_all.deb
ENV OTSDB_URL     ${OTSDB_BASEURL}/${OTSDB_PACKAGE}
ENV COMPRESSION   NONE

RUN echo ${OTSDB_URL}
RUN echo ${HBASE_URL}
RUN curl -kL -O "https://github.com/OpenTSDB/opentsdb/releases/download/v2.4.0RC1/opentsdb-2.4.0RC1_all.deb"

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    gnuplot \ 
    curl \
    supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* 
  
RUN mkdir -p "${HBASE_HOME}" "${HBASE_DATA}" 
RUN curl -kL "${HBASE_URL}" | tar -xz -C "${HBASE_HOME}" --strip-components=1 

RUN dpkg -i "${OTSDB_PACKAGE}" \
  && rm "${OTSDB_PACKAGE}"

ADD supervisor.conf /etc/supervisor/conf.d/supervisord.conf
ADD hbase-service.sh /opt/hbase-service.sh
ADD opentsdb-service.sh /opt/opentsdb-service.sh

EXPOSE 4242
EXPOSE 8070
EXPOSE 60000
EXPOSE 60010
EXPOSE 60020
EXPOSE 60030

VOLUME ["${HBASE_DATA}"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
