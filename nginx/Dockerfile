FROM alpine

MAINTAINER "Raúl Pedroche"

RUN apk add --no-cache nginx

ADD nginx.conf about.site /etc/nginx/

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
