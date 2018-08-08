FROM openjdk:8-jdk-alpine

ARG VERSION

ENV DIST_MIRROR     https://archive.apache.org/dist/nifi
ENV NIFI_HOME       /opt/nifi
ENV VERSION         ${VERSION}

RUN set -x && \
    apk --no-cache add tar wget && \
	mkdir -p ${NIFI_HOME} && \
	wget -qO- ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1 && \
    addgroup nifi && \
    adduser -D -G nifi nifi && \
    chown -R nifi:nifi ${NIFI_HOME}
	
EXPOSE 8080 8443 10000
USER nifi
WORKDIR ${NIFI_HOME}

CMD ["bin/nifi.sh","run"]