## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami/bitnami-docker-javaplay .
##
## RUNNING
##   $ docker run -p 9000:9000 bitnami/bitnaxmi-docker-javaplay
##

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=java-play \
    BITNAMI_APP_VERSION=1.3.10-0 \
    PATH=/opt/bitnami/activator/bin:/opt/bitnami/node/bin:$PATH \
    TERM=xterm

# Install related packages
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && apt-get -y install openjdk-8-jdk && \
    apt-get clean

# Install Play dependencies
RUN bitnami-pkg install node-6.4.0-0 --checksum 41d5a7b17ac1f175c02faef28d44eae0d158890d4fa9893ab24b5cc5f551486f

# Install Java/Play (Activator) module
RUN bitnami-pkg install activator-1.3.10-0 --checksum 0e517c719ffcaaeaf234df845b69cfe561f722c5344a1821706bd269900ba9f4

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 9000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["activator", "-Doffline=true", "-Dhttp.address=0.0.0.0 -Dhttp.port=9000", "~run"] 
