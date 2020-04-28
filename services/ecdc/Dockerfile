FROM tarantool/tarantool:2.3.1

COPY app.lua /opt/tarantool
COPY api.lua /opt/tarantool
COPY updater.lua /opt/tarantool
COPY cron-stage /opt/tarantool

WORKDIR /opt/tarantool

RUN chmod +x /opt/tarantool/cron-stage && crontab /opt/tarantool/cron-stage

CMD ["tarantool", "app.lua"]