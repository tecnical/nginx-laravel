FROM nginx:alpine AS base

FROM base AS brotli-builder

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        git \
        linux-headers \
        openssl-dev \
        pcre2-dev \
        zlib-dev && \
    git clone --depth 1 --recurse-submodules --branch v1.0.0rc \
        https://github.com/google/ngx_brotli.git /tmp/ngx_brotli && \
    NGINX_VERSION="$(nginx -v 2>&1 | sed 's|.*/||')" && \
    wget -q "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O /tmp/nginx.tar.gz && \
    mkdir /tmp/nginx-source && \
    tar -xzf /tmp/nginx.tar.gz --strip-components=1 -C /tmp/nginx-source && \
    cd /tmp/nginx-source && \
    ./configure --with-compat \
        --with-cc-opt="-Wno-error=unterminated-string-initialization -Wno-error=vla-parameter" \
        --add-dynamic-module=/tmp/ngx_brotli && \
    make modules -j2

FROM base

COPY --from=brotli-builder /tmp/nginx-source/objs/ngx_http_brotli_filter_module.so /usr/lib/nginx/modules/

# nginx.conf global (worker, gzip, log format, include http.d)
COPY nginx.conf /etc/nginx/nginx.conf

# Virtual host do Laravel — deve ir para http.d, não para modules/
# O nginx.conf inclui /etc/nginx/http.d/*.conf
COPY nginx-laravel.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /run/nginx/ && \
    touch /run/nginx/nginx.pid && \
    # Redireciona logs para stdout/stderr do Docker
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log