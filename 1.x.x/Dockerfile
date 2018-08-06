FROM openjdk:8-jdk-alpine

ARG VERSION

ENV DIST_MIRROR     https://archive.apache.org/dist/nifi
ENV NIFI_HOME       /opt/nifi
ENV VERSION         ${VERSION}

RUN set -x && \
    apk --no-cache add tar wget && \
	mkdir -p ${NIFI_HOME} && \
	wget -qO- ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1 && \
    mkdir -p ${NIFI_HOME}/database_repository ${NIFI_HOME}/flowfile_repository ${NIFI_HOME}/content_repository ${NIFI_HOME}/provenance_repository && \
    addgroup nifi && \
    adduser -D -G nifi nifi && \
    chown -R nifi:nifi ${NIFI_HOME}
	
EXPOSE 8080 8443
USER nifi
WORKDIR ${NIFI_HOME}

ADD ./conf/ /opt/conf
ENTRYPOINT ["/opt/conf/entrypoint.sh"]
CMD ["bin/nifi.sh","run"]