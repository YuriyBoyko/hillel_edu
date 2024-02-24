#docker pull nginx
#sleep 2s
mkdir -p ~/docker/nginx
mkdir -p ~/docker/nginx/html
echo "Hello. This is my Nginx started page" > ~/docker/nginx/html/index.html
echo "FROM nginx" > ~/docker/nginx/Dockerfile
echo "COPY html /usr/share/nginx/html" >> ~/docker/nginx/Dockerfile
docker build -t my_image_nginx $HOME/docker/nginx
sleep 3s
docker run -d --name nginx -p 80:80 my_image_nginx
sleep 3s
echo -e "\n"
curl 127.0.0.1