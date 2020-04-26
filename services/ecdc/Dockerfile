FROM tarantool/tarantool:2/latest

RUN apt-get install -y cron

COPY app.lua /opt/tarantool/ecdc
COPY updater.lua /opt/tarantool/ecdc
COPY .cron-stage.env /opt/tarantool/ecdc/cron-stage

WORKDIR /opt/tarantool

RUN chmod +x /opt/tarantool/ecdc/cron-stage \
    && crontab /opt/tarantool/ecdc/cron-stage

CMD ["tarantool", "app.lua"]