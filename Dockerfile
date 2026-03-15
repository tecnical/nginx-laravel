FROM nginx:alpine

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