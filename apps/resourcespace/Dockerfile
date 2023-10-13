ARG VERSION

FROM ghcr.io/onedr0p/alpine:3.18.4@sha256:b0b6f6f42bf9649ccaf0e98cd74d5e123471e2c4a4db4a5ee417b18dde9973a9 as build

ARG VERSION

RUN \
 \
    apk add --no-cache --virtual=build-dependencies \
        subversion \
    && svn co "http://svn.resourcespace.com/svn/rs/releases/${VERSION}/" /src

FROM ghcr.io/onedr0p/alpine:3.18.4@sha256:b0b6f6f42bf9649ccaf0e98cd74d5e123471e2c4a4db4a5ee417b18dde9973a9

ARG VERSION
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

ENV PHP_INI_DIR /etc/php82

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="http://svn.resourcespace.com/svn/rs/releases/${VERSION}"

# Configure supervisord
COPY config/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Configure PHP-FPM
COPY config/php/fpm-pool.conf ${PHP_INI_DIR}/php-fpm.d/www.conf
COPY config/php/php.ini ${PHP_INI_DIR}/conf.d/custom.ini
# Configure nginx - http
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/default.conf /etc/nginx/conf.d/default.conf

# Add application
COPY --from=build --chown=nobody /src/ /var/www/html/

#hadolint ignore=DL3018,DL3013
RUN \
    apk add --no-cache \
        exiftool \
        ffmpeg \
        imagemagick \
        nginx \
        php82 \
        php82-fpm \
        php82-gd \
        php82-mbstring \
        php82-mysqli \
        supervisor \
    && ln -s /usr/bin/php82 /usr/bin/php \
    && chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
