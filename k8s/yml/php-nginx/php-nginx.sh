#!/bin/bash

docker build -t oneforma.azurecr.io/php-nginx:latest .
docker push oneforma.azurecr.io/php-nginx:latest
kubectl rollout restart deployment php-nginx -n demo


#docker stop php-nginx 
#docker rm php-nginx 

#docker run --name php-nginx -p 80:80 -d oneforma.azurecr.io/php-nginx:latest