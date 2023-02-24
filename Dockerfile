FROM nginx:alpine

COPY nginx.conf /etc/nginx/
COPY nginx-laravel.conf /etc/nginx/modules/

RUN mkdir -p /run/nginx/
RUN touch /run/nginx/nginx.pid

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

#ADD php/nginx/nginx-laravel.conf /etc/nginx/conf.d/default.conf
