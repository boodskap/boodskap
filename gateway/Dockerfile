ARG CONFIG
FROM nginx
ARG CONFIG
ENV CTYPE=$CONFIG
RUN rm -f /etc/nginx/conf.d/default.conf
COPY ./${CTYPE}.conf /etc/nginx/conf.d/${CTYPE}.conf
