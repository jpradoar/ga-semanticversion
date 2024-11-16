FROM alpine:3.20.3
RUN apk add bc bash
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
