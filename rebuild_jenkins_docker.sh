docker rm -fv jenkins-docker
docker-compose up -d
sleep 2
docker-comppose restart
