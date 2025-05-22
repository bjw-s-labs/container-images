FROM ruby:3.4.4-alpine3.21

ARG VERSION

ENV \
  NODE_ENV="production" \
  RACK_ENV="production" \
  RAILS_ENV="production" \
  RAILS_SERVE_STATIC_FILES="true" \
  RAILS_ASSETS_PRECOMPILE=1 \
  # RAILS_LOG_TO_STDOUT="1" \
  APP_VERSION="${VERSION}" \
  GIT_SHA="v${VERSION}"

USER root

WORKDIR /app

# hadolint ignore=DL3018,DL3028,DL3015,SC2086
RUN apk add --no-cache \
        alpine-sdk \
        bash \
        bzip2 \
        git \
        glfw \
        libarchive \
        libffi-dev \
        linux-headers \
        mariadb-dev \
        mesa-gl \
        postgresql-dev \
        nodejs=~22.13 \
        npm \
        sqlite-dev \
        tzdata \
        valkey \
        yaml-dev \
        zlib-dev \
  && gem install foreman \
  && npm install -g corepack@latest \
  # Install manyfold
  && git clone --branch "v${VERSION}" --single-branch "https://github.com/manyfold3d/manyfold.git" /app \
  && echo "${RUBY_VERSION}" > "/app/.ruby-version" \
  && sed -i '/^end$/i \ \ config.active_record.sqlite3_production_warning=false' /app/config/environments/production.rb \
  # Workaround for https://github.com/sparklemotion/sqlite3-ruby/issues/434
  && sed -i '/sqlite3/ s/$/, force_ruby_platform: true/' "/app/Gemfile" \
  && corepack enable yarn \
  && yarn install \
  && bundle config set --local deployment 'true' \
  && bundle config set --local without 'development test' \
  && bundle install -j "$(nproc)" \
  && \
  DATABASE_URL="nulldb://user:pass@localhost/db" \
  SECRET_KEY_BASE="placeholder" \
  bundle exec rake assets:precompile \
  # Cleanup
  && yarn cache clean \
  && rm -rf \
    /app/.git \
    /app/log/* \
    /app/tmp/* \
    /data \
    /root/.cache \
    /root/.cargo \
    /tmp/* \
  # Prepare folders
  && chmod 777 /app/tmp \
  && chmod 777 /app/log

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL org.opencontainers.image.source="https://github.com/manyfold3d/manyfold"
