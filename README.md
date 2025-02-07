# simple-python-pyinstaller-app

This repository is for the
[Build a Python app with PyInstaller](https://jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/)
tutorial in the [Jenkins User Documentation](https://jenkins.io/doc/).

The repository contains a simple Python application which is a command line tool "add2vals" that outputs the addition of two values. If at least one of the
values is a string, "add2vals" treats both values as a string and instead
concatenates the values. The "add2" function in the "calc" library (which
"add2vals" imports) is accompanied by a set of unit tests. These are tested with pytest to check that this function works as expected and the results are saved
to a JUnit XML report.

The delivery of the "add2vals" tool through PyInstaller converts this tool into
a standalone executable file for Linux, which you can download through Jenkins
and execute at the command line on Linux machines without Python.

The `jenkins` directory contains an example of the `Jenkinsfile` (i.e. Pipeline)
you'll be creating yourself during the tutorial.

- [https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/](https://www.jenkins.io/doc/tutorials/build-a-python-app-with-pyinstaller/)
- [https://www.jenkins.io/doc/pipeline/examples/](https://www.jenkins.io/doc/pipeline/examples/)

# jenkins
## setup jenkins with docker (1)
### setup container
```bash
docker network create jenkins

docker run \
  --name jenkins-docker \
  --detach \
  --privileged \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  --publish 3000:3000 --publish 5000:5000 \
  --restart always \
  docker:dind \
  --storage-driver overlay2

docker build -t myjenkins-blueocean:2.426.2-1 .

docker run \
  --name jenkins-blueocean \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 49000:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --volume "$HOME":/home \
  --restart=on-failure \
  --env JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" \
  myjenkins-blueocean:2.426.2-1 
```

## setup all with docker compose
```bash
# start
docker-compose up -d

# stop
docker-compose down
```

### Menyiapkan Jenkins Wizard
- Buka browser Anda dan jalankan http://localhost:8080. Tunggu hingga halaman Unlock Jenkins muncul.
- salin password di docker logs
  ```bash
  docker logs jenkins-blueocean
  # Jenkins initial setup is required. An admin user has been created and a password generated.
  # Please use the following password to proceed to installation:
  
  1fb5e900d96a41b6a8028dcb943a512a

  # This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
  ```
- Install suggested plugins
- create user
- save and finish

# Grafana dan Prometheus
## setup
```bash
docker rm -fv prometheus grafana

docker run -d --name prometheus -p 9091:9090 --add-host=host.docker.internal:host-gateway prom/prometheus
docker run -d --name grafana -p 3031:3031 -e "GF_SERVER_HTTP_PORT=3031" --add-host=host.docker.internal:host-gateway grafana/grafana

# docker exec -it prometheus sh
# ---
# cat >> /etc/prometheus/prometheus.yml << EOF
#   - job_name: "jenkins"                                                        
#     metrics_path: /prom                                             
#     static_configs:                                                            
#       - targets: ["host.docker.internal:49000"]
# EOF

docker exec -it prometheus sh -c 'cat >> /etc/prometheus/prometheus.yml << EOF
  - job_name: "jenkins"
    metrics_path: /prom
    static_configs:
      - targets: ["host.docker.internal:49000"]
EOF'

docker restart prometheus
```