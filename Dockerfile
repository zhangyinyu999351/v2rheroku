FROM alpine:edge
ENV UUID 243c23bc-6cd0-44aa-b5ca-b44fb41f63e5
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx unzip \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /usr/bin/v2ray/ \
&& cd /usr/bin/v2ray/ \
&& wget -O v2ray-linux-64.zip https://github.com/zhangyinyu999351/v2rapp/archive/master.zip \
&& unzip v2ray-linux-64.zip \
&& rm -rf v2ray-linux-64.zip \
&& cd v2rapp-master \
&& chmod +x v2ray v2ctl \
&& mkdir /var/log/v2ray/  \
&& adduser -D myuser \
&& mkdir /run/nginx

ENV PATH /usr/bin/v2ray/v2rapp-master:$PATH
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /entrypoint.sh
COPY index.html /var/lib/nginx/html/index.html

USER myuser
CMD ["/entrypoint.sh"]
