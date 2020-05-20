FROM alpine:edge

RUN apk add --no-cache git fish rsync tree && rm -rf /tmp/* /etc/apk/cache/*

ENV SHELL /usr/bin/fish

COPY \
    LICENSE \
    entrypoint.fish \
    /root/

ENTRYPOINT ["fish", "/root/entrypoint.fish"]