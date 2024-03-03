#!/bin/bash

docker build -t edu_image_nginx .
sleep 3s
docker run -d --name nginx -p 80:80 edu_image_nginx
sleep 3s
echo -e "\n"
curl 127.0.0.1
