FROM tarantool/tarantool-nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
VOLUME ['/var/cache/nginx']

CMD ["nginx", "daemon off;"]
