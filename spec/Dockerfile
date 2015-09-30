FROM ubuntu:14.04
EXPOSE 9200
ENV JAVA_HOME=/usr/local/jre

# Copy over stuff
COPY jre-8u60-linux-x64.gz /tmp/
RUN mkdir /usr/local/jre
RUN tar xzf /tmp/jre-8u60-linux-x64.gz -C /usr/local/jre --strip-components 1
COPY elasticsearch-1.7.2.tar.gz /tmp/
RUN mkdir /usr/local/elasticsearch
RUN tar xzf /tmp/elasticsearch-1.7.2.tar.gz -C /usr/local/elasticsearch --strip-components 1

COPY elasticsearch.yml /usr/local/elasticsearch/config/

# Persistent data
VOLUME /usr/local/elasticsearch

# Symlink to more standard locations.
RUN mkdir /var/data
RUN ln -s /usr/local/elasticsearch/data/ /var/data/elasticsearch
RUN ln -s /usr/local/elasticsearch/logs/ /var/log/elasticsearch

ENTRYPOINT ["/usr/local/elasticsearch/bin/elasticsearch"]
