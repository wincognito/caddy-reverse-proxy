FROM caddy:2-builder AS builder

# https://caddyserver.com/docs/modules/layer4.handlers.proxy_protocol
RUN xcaddy build \
--with github.com/mholt/caddy-l4/modules/l4proxyprotocol

FROM caddy:2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy