ARG SING_BOX_VERSION=v1.12.0

FROM ghcr.io/sagernet/sing-box:${SING_BOX_VERSION} AS sing-box

FROM alpine:3.21

RUN apk add --no-cache ca-certificates gettext

COPY --from=sing-box /usr/local/bin/sing-box /usr/local/bin/sing-box
COPY config.json.template /etc/sing-box/config.json.template
COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p /etc/sing-box /var/lib/sing-box \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
