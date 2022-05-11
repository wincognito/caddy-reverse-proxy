FROM docker.io/library/caddy:2-builder AS builder

# https://github.com/abiosoft/caddy-json-schema
# https://caddyserver.com/docs/modules/layer4.handlers.proxy_protocol
RUN xcaddy build \
--with github.com/abiosoft/caddy-json-schema \
--with github.com/mholt/caddy-l4

FROM docker.io/library/caddy:2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy