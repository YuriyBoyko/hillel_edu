FROM ubuntu:22.04
RUN apt-get update -y && apt-get install nginx -y
COPY html /var/www/html/
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
