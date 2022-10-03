FROM alpine:3.16

ARG VERSION="1.4.3"
ARG DIST_URL="https://github.com/alextselegidis/easyappointments/releases/download/${VERSION}/easyappointments-${VERSION}.zip"
ARG BUILD_DATE
ARG VCS_REF

COPY --from=botsudo/docker-openldap /usr/bin/horust /usr/bin/horust

# Set user and group
ARG user=deploy
ARG group=deploy

RUN apk add --no-cache --update nginx curl unzip \
    # https://github.com/mischov/meeseeks/issues/98#issuecomment-636615680
    # For Horust
    openssl libgcc \
    php8-fpm php8 php8-pdo_mysql php8-session \
    php8-json php8-curl php8-mbstring php8-gd && \
    horust --version && nginx -v && php-fpm8 -v && php -v && \
    mkdir -p /var/log/php8 && \
    mkdir /run/phpfpm && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stderr /var/log/php8/error.log && \
    date -R > /build_date && \
    printf '{"build_date": "%s", "timestamp": %i}' "$(date -R)" "$(date +%s)" > /build_date.json && \
    addgroup -S ${group} && \
    adduser -G ${group} -G nginx -s /bin/sh -h /var/www/easyappointments -S ${user} && \
    id deploy && \
    chown -R deploy:deploy /var/log/php8 /var/lib/nginx /run/nginx /run/phpfpm && \
    chmod -R 770 /var/log/php8 /var/lib/nginx /run/nginx /run/phpfpm

WORKDIR /var/www/easyappointments

COPY docker-entrypoint.sh /
COPY horust/ /etc/horust/
COPY nginx-default.conf /etc/nginx/http.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm-www-pool.conf /etc/php8/php-fpm.d/www.conf

# Switch to user
USER deploy:deploy

RUN curl -# -L -o easyappointments.zip ${DIST_URL} && \
    unzip -q easyappointments.zip && \
    rm easyappointments.zip

# Metadata
LABEL org.label-schema.vendor="Sudo-Bot" \
    org.label-schema.url="https://github.com/sudo-bot/docker-easyappointments#readme" \
    org.label-schema.name="docker-easyappointments" \
    org.label-schema.description="An EasyAppointments image" \
    org.label-schema.version=${RELEASE_VERSION} \
    org.label-schema.vcs-url="https://github.com/sudo-bot/docker-easyappointments.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.schema-version="1.0" \
    \
    com.docker.extension.publisher-url="https://github.com/sudo-bot" \
    \
    org.opencontainers.image.title="Docker EasyAppointments server" \
    org.opencontainers.image.authors="williamdes@wdes.fr" \
    org.opencontainers.image.url="https://github.com/sudo-bot/docker-easyappointments#readme" \
    org.opencontainers.image.documentation="https://github.com/sudo-bot/docker-easyappointments#readme" \
    org.opencontainers.image.source="https://github.com/sudo-bot/docker-easyappointments" \
    org.opencontainers.image.vendor="Sudo-Bot" \
    org.opencontainers.image.licenses="MPL-2.0" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.version=${RELEASE_VERSION} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.ref.name="${VERSION}"

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
