FROM bitsensor/elastalert:2.0.0

# Copyright (c) 2019 Battelle Energy Alliance, LLC.  All rights reserved.
LABEL maintainer="Seth.Grover@inl.gov"

USER root

RUN apk update && \
    apk add bash curl && \
    rm -rf /var/cache/apk/*

ADD elastalert/elastalert-start.sh /usr/local/bin/
ADD shared/bin/elastic_search_status.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/elastalert-start.sh && \
    mkdir -p /opt/elastalert/server_data/tests && \
    chown -R node:node /opt

VOLUME ["/opt/elastalert/server_data"]

USER node

ENTRYPOINT ["/usr/local/bin/elastalert-start.sh"]
