FROM alpine

MAINTAINER "Raúl Pedroche"

RUN apk add --no-cache nginx

ADD nginx.conf about.site certificate.crt privateKey.key /etc/nginx/

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
