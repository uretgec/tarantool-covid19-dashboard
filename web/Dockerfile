FROM tarantool/tarantool-nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
COPY ecdc.conf /etc/nginx/conf.d/ecdc.conf
COPY index.html /usr/share/nginx/html/index.html

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443
RUN rm -rf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
