FROM openjdk:8-jdk-alpine

ENV             DIST_MIRROR             http://mirror.cc.columbia.edu/pub/software/apache/nifi
ENV             NIFI_HOME               /opt/nifi
ENV             VERSION                 1.1.1

RUN apk --no-cache add tar && \
	mkdir -p ${NIFI_HOME} && \
	wget -qO- ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} --strip-components=1
	
EXPOSE 80 443

ADD ./conf/ /opt/conf

ENTRYPOINT ["/opt/conf/entrypoint.sh"]

CMD ["/opt/nifi/bin/nifi.sh","run"]