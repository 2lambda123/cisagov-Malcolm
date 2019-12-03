FROM alpine:3.10

# Copyright (c) 2019 Battelle Energy Alliance, LLC.  All rights reserved.
LABEL maintainer="Seth.Grover@inl.gov"
LABEL org.opencontainers.image.authors='Seth.Grover@inl.gov'
LABEL org.opencontainers.image.url='https://github.com/idaholab/Malcolm'
LABEL org.opencontainers.image.documentation='https://github.com/idaholab/Malcolm/blob/master/README.md'
LABEL org.opencontainers.image.source='https://github.com/idaholab/Malcolm'
LABEL org.opencontainers.image.vendor='Idaho National Laboratory'
LABEL org.opencontainers.image.title='malcolmnetsec/nginx-proxy'
LABEL org.opencontainers.image.description='Malcolm container providing an NGINX reverse proxy for the other services'

# authentication method: encrypted HTTP basic authentication ('true') vs nginx-auth-ldap ('false')
ARG NGINX_BASIC_AUTH=true
ENV NGINX_BASIC_AUTH $NGINX_BASIC_AUTH

# build latest nginx with nginx-auth-ldap
# thanks to:  nginx                       -  https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
#             kvspb/nginx-auth-ldap       -  https://github.com/kvspb/nginx-auth-ldap
#             tiredofit/docker-nginx-ldap -  https://github.com/tiredofit/docker-nginx-ldap/blob/master/Dockerfile
#             jwilder/nginx-proxy         -  https://github.com/jwilder/nginx-proxy/blob/master/Dockerfile.alpine
ENV NGINX_VERSION=1.17.6
ENV DOCKER_GEN_VERSION=0.7.4
ENV FOREGO_STABLE_VERSION=ekMN3bCZFUn
ENV NGINX_AUTH_LDAP_BRANCH=master
ENV NGINX_AUTH_PAM_BRANCH=master

ADD https://bin.equinox.io/c/$FOREGO_STABLE_VERSION/forego-stable-linux-amd64.tgz /forego-stable-linux-amd64.tgz
ADD https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz
ADD https://codeload.github.com/kvspb/nginx-auth-ldap/tar.gz/$NGINX_AUTH_LDAP_BRANCH /nginx-auth-ldap.tar.gz
ADD https://codeload.github.com/sto/ngx_http_auth_pam_module/tar.gz/$NGINX_AUTH_PAM_BRANCH /ngx_http_auth_pam_module.tar.gz
ADD http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz /nginx.tar.gz

RUN set -x ; \
    CONFIG="\
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-stream_geoip_module=dynamic \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-compat \
    --with-file-aio \
    --with-http_v2_module \
    --add-module=/usr/src/nginx-auth-ldap \
    --add-module=/usr/src/ngx_http_auth_pam_module \
  " ; \
  addgroup -g 101 -S nginx ; \
  adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx ; \
  addgroup nginx shadow ; \
  mkdir -p /var/cache/nginx ; \
  chown nginx:nginx /var/cache/nginx ; \
  apk add --no-cache curl; \
  apk add --no-cache --virtual .nginx-build-deps \
    gcc \
    gd-dev \
    geoip-dev \
    gnupg \
    libc-dev \
    libressl-dev \
    libxslt-dev \
    linux-headers \
    make \
    openldap-dev \
    linux-pam-dev \
    pcre-dev \
    perl-dev \
    tar \
    zlib-dev \
    ; \
    \
  mkdir -p /usr/src/nginx-auth-ldap /usr/src/ngx_http_auth_pam_module /www /www/logs/nginx ; \
  tar -zxC /usr/src -f /nginx.tar.gz ; \
  tar -zxC /usr/src/nginx-auth-ldap --strip=1 -f /nginx-auth-ldap.tar.gz ; \
  tar -zxC /usr/src/ngx_http_auth_pam_module --strip=1 -f /ngx_http_auth_pam_module.tar.gz ; \
  cd /usr/src/nginx-$NGINX_VERSION ; \
  ./configure $CONFIG --with-debug ; \
  make -j$(getconf _NPROCESSORS_ONLN) ; \
  mv objs/nginx objs/nginx-debug ; \
  mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so ; \
  mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so ; \
  mv objs/ngx_http_geoip_module.so objs/ngx_http_geoip_module-debug.so ; \
  mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so ; \
  mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so ; \
  ./configure $CONFIG ; \
  make -j$(getconf _NPROCESSORS_ONLN) ; \
  make install ; \
  rm -rf /etc/nginx/html/ ; \
  mkdir -p /etc/nginx/conf.d/ ; \
  mkdir -p /usr/share/nginx/html/ ; \
  install -m644 html/index.html /usr/share/nginx/html/ ; \
  install -m644 html/50x.html /usr/share/nginx/html/ ; \
  install -m755 objs/nginx-debug /usr/sbin/nginx-debug ; \
  install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so ; \
  install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so ; \
  install -m755 objs/ngx_http_geoip_module-debug.so /usr/lib/nginx/modules/ngx_http_geoip_module-debug.so ; \
  install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so ; \
  install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so ; \
  ln -s ../../usr/lib/nginx/modules /etc/nginx/modules ; \
  strip /usr/sbin/nginx* ; \
  strip /usr/lib/nginx/modules/*.so ; \
  rm -rf /usr/src/nginx-$NGINX_VERSION ; \
  \
  # Bring in gettext so we can get `envsubst`, then throw
  # the rest away. To do this, we need to install `gettext`
  # then move `envsubst` out of the way so `gettext` can
  # be deleted completely, then move `envsubst` back.
  apk add --no-cache --virtual .gettext gettext ; \
  mv /usr/bin/envsubst /tmp/ ; \
  \
  runDeps="$( \
    scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r apk info --installed \
      | sort -u \
  )" ; \
  apk add --no-cache --virtual .nginx-rundeps $runDeps ca-certificates bash wget openssl apache2-utils openldap linux-pam nss-pam-ldapd stunnel tzdata; \
  update-ca-certificates; \
  tar -zxC /usr/local/bin -f /forego-stable-linux-amd64.tgz; \
  tar -C /usr/local/bin -xzf /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz; \
  chown root:root /usr/local/bin/forego /usr/local/bin/docker-gen; \
  chmod u+x /usr/local/bin/forego /usr/local/bin/docker-gen; \
  apk del .nginx-build-deps ; \
  apk del .gettext ; \
  mv /tmp/envsubst /usr/local/bin/ ; \
  rm -rf /usr/src/* /var/tmp/* /var/cache/apk/* /forego-stable-linux-amd64.tgz /nginx.tar.gz /nginx-auth-ldap.tar.gz /ngx_http_auth_pam_module.tar.gz /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz; \
  ln -sf /dev/stdout /var/log/nginx/access.log; \
  ln -sf /dev/stderr /var/log/nginx/error.log;

COPY --from=jwilder/nginx-proxy:alpine /etc/nginx/network_internal.conf /etc/nginx/
COPY --from=jwilder/nginx-proxy:alpine /app/ /app/

ADD nginx/*.conf /etc/nginx/
ADD docs/images/icon/favicon.ico /etc/nginx/favicon.ico

# based on the NGINX_BASIC_AUTH environment variable (true|false), create symlinks for basic/ldap auth settings to be included in main nginx.conf
RUN sed -i '/^exec[[:space:]]/i [[ "$NGINX_BASIC_AUTH" == "true" ]] && (ln -sf /etc/nginx/nginx_blank.conf /etc/nginx/nginx_ldap_rt.conf ; ln -sf /etc/nginx/nginx_auth_basic.conf /etc/nginx/nginx_auth_rt.conf) || (ln -sf /etc/nginx/nginx_ldap.conf /etc/nginx/nginx_ldap_rt.conf ; ln -sf /etc/nginx/nginx_auth_ldap.conf /etc/nginx/nginx_auth_rt.conf)' /app/docker-entrypoint.sh && \
  touch /etc/nginx/nginx_ldap.conf /etc/nginx/nginx_blank.conf

EXPOSE 80

WORKDIR /app/

ENV DOCKER_HOST unix:///tmp/docker.sock

VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]

# to be populated at build-time:
ARG BUILD_DATE
ARG MALCOLM_VERSION
ARG VCS_REVISION

LABEL org.opencontainers.image.created=$BUILD_DATE
LABEL org.opencontainers.image.version=$MALCOLM_VERSION
LABEL org.opencontainers.image.revision=$VCS_REVISION
