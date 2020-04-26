FROM tarantool/tarantool:2/latest

COPY ecdc.lua /opt/tarantool
EXPOSE 3301
WORKDIR /opt/tarantool
CMD ["tarantool", "ecdc.lua"]