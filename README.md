# STOP & RM Container
docker stop alpinenginxtest && docker rm alpinenginxtest

# Build container
docker build -t test/apline-nginx .

# Deamon startup
docker run -d --name alpinenginxtest -v /mnt/docker-mnt/symfo-test/:/DATA -p 8090:80 test/apline-nginx

# INDOOR Test
# No run.sh in Dockerfile
docker run -ti --name alpinenginxtest -v /mnt/docker-mnt/symfo-test/:/DATA -p 8090:80 test/apline-nginx /bin/bash