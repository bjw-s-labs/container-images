FROM ruby:3.3.4-alpine3.20

ARG VERSION
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETOS

LABEL dev.bjw-s.image.target_platform=$TARGETPLATFORM
LABEL dev.bjw-s.image.target_architecture=$TARGETARCH
LABEL dev.bjw-s.image.target_os=$TARGETOS
LABEL org.opencontainers.image.source="https://github.com/manyfold3d/manyfold"

ENV \
  NODE_ENV="production" \
  RACK_ENV="production" \
  RAILS_ENV="production" \
  RAILS_SERVE_STATIC_FILES="true" \
  RAILS_LOG_TO_STDOUT="1" \
  APP_VERSION="${VERSION}" \
  GIT_SHA="v${VERSION}"

USER root

WORKDIR /app

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apk add --no-cache \
    alpine-sdk \
    bash \
    git \
    glfw \
    libarchive \
    mariadb-dev \
    mesa-gl \
    postgresql-dev \
    nodejs \
    sqlite-dev \
    tzdata \
    valkey \
    yarn \
  && gem install foreman \
  # Install manyfold
  && git clone --branch "v${VERSION}" "https://github.com/manyfold3d/manyfold.git" /app \
  && echo "${RUBY_VERSION}" > "/app/.ruby-version" \
  && sed -i '/^end$/i \ \ config.active_record.sqlite3_production_warning=false' /app/config/environments/production.rb \
  # Workaround for https://github.com/sparklemotion/sqlite3-ruby/issues/434
  && sed -i '/sqlite3/ s/$/, force_ruby_platform: true/' "/app/Gemfile" \
  && yarn config set network-timeout 600000 -g \
  && yarn install --prod \
  && bundle config set --local deployment 'true' \
  && bundle config set --local without 'development test' \
  && bundle install -j $(nproc) \
  && \
  DATABASE_URL="nulldb://user:pass@localhost/db" \
  SECRET_KEY_BASE="placeholder" \
  bundle exec rake assets:precompile \
  # Cleanup
  && rm -rf \
    /app/.git \
    /app/tmp \
    /data \
    /root/.cache \
    /root/.cargo \
    /tmp/* \
  # Prepare folders
  && mkdir -p /tmp/manyfold \
  && chmod 777 /tmp/manyfold \
  && ln -s /tmp/manyfold /app/tmp

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]
