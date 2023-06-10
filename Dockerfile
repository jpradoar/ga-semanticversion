FROM alpine:3.18
RUN apk add bc bash
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
