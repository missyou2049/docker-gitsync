FROM alpine:latest
MAINTAINER missyou.2049@gmail.com

RUN apk update && apk add bash dcron ssh git curl ca-certificates && rm -rf /var/cache/apk/*

RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d

COPY /scripts/* /
COPY crontab /etc/cron.d/

CMD ["/docker-cmd.sh"]
