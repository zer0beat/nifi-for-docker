![Apache NiFi logo](http://nifi.apache.org/images/niFi-logo-horizontal.png "Apache NiFi")
# Apache NiFi for Docker
## Version 1.3.0

Provides a Dockerfile and associated scripts for configuring an instance of [Apache NiFi](http://nifi.apache.org) to run in diferent modes:
1. Unsecure Nifi node
2. Secure Nifi node
3. Unsecure NiFi cluster
4. Secure NiFi cluster  

## Sample Usage:

From your checkout directory:
		
1. Build the image
        
        docker build -f ./container/Dockerfile -t jllacer/nifi:1.3.0 -t jllacer/nifi:latest .
		
2. Run the image (mode 1)

		docker run --rm -p 8080:8080 jllacer/nifi:1.3.0

3. Wait for the image to initalize
		
4. Access through your Docker host system
 	
		http://localhost:8080/nifi


## Volumes
- The following directories are exposed as volumes which may optionally be mounted to a specified location
	- `${NIFI_HOME}/flowfile_repository`
	- `${NIFI_HOME}/content_repository`
	- `${NIFI_HOME}/database_repository`
	- `${NIFI_HOME}/provenance_repository`

## Supported environment variables
- **ZOO_MY_ID**: Used to configure ${NIFI_HOME}/state/zookeeper/myid

        p.e. [docker run ...] -e ZOO_MY_ID=1 [...]

- **ZOO_SERVERS**: Used to populate ${NIFI_HOME}/conf/zookeeper.properties

        p.e. [docker run ...] -e ZOO_SERVERS=server.1=nifi1:2888:3888 server.2=nifi2:2888:3888 server.3=nifi3:2888:3888 [...]

- **ZOO_CONNECT**: nifi.zookeeper.connect.string in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e ZOO_CONNECT=nifi1:2181,nifi2:2181,nifi3:2181 [...]

- **ENABLE_SSL**: Used to enable SSL support in cluster

        p.e. [docker run ...] -e ENABLE_SSL="true" [...]

- **KEYSTORE_PATH**: nifi.security.keystore in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e KEYSTORE_PATH=/opt/certs/keystore.jks [...]

- **KEYSTORE_TYPE**: nifi.security.keystoreType in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e KEYSTORE_TYPE=JKS [...]

- **KEYSTORE_PASSWORD**: nifi.security.keystorePasswd and nifi.security.keyPasswd in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e KEYSTORE_PASSWORD=yourKeystorePasswordHere [...]

- **TRUSTSTORE_PATH**: nifi.security.truststore in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e TRUSTSTORE_PATH=/opt/certs/truststore.jks [...]

- **TRUSTSTORE_TYPE**: nifi.security.truststoreType in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e TRUSTSTORE_TYPE=JKS [...]

- **TRUSTSTORE_PASSWORD**: nifi.security.truststorePasswd in ${NIFI_HOME}/conf/nifi.properties

        p.e. [docker run ...] -e TRUSTSTORE_PASSWORD=yourKeystorePasswordHere [...]

- **INIT_ADMIN_IDENTITY**: Used to configure "Initial Admin Identity" property in ${NIFI_HOME}/conf/authorizers.xml

        p.e. [docker run ...] -e INIT_ADMIN_IDENTITY="CN=jllacer, OU=NIFI" [...]

- **NODE_IDENTITIES**: Used to populate "Node Identity X" properties in ${NIFI_HOME}/conf/authorizers.xml

        p.e. [docker run ...] -e NODE_IDENTITIES="CN=nifi1, OU=NIFI|CN=nifi2, OU=NIFI|CN=nifi3, OU=NIFI" [...]

- **NODE_HOSTNAME**: Used to configure some host related properties in ${NIFI_HOME}/conf/nifi.properties (defaults to $HOSTNAME)

        p.e. [docker run ...] -e NODE_HOSTNAME=nifi1 [...]

- **SITE2SITE_PORT**: nifi.remote.input.socket.port in ${NIFI_HOME}/conf/nifi.properties (defaults to 9998)

        p.e. [docker run ...] -e SITE2SITE_PORT=11443 [...]

- **COORDINATION_PORT**: nifi.cluster.node.protocol.port in ${NIFI_HOME}/conf/nifi.properties (defaults to 9999)

        p.e. [docker run ...] -e COORDINATION_PORT=11444 [...]

- **INTERFACES**: nifi.web.http.network.interface* in ${NIFI_HOME}/conf/nifi.properties (defaults to all network interfaces - without lo -)

        p.e. [docker run ...] -e INTERFACES="eth0 eth1" [...]

## Extras

### [NiFi Toolkit](https://nifi.apache.org/download.html) usage to generate sample certificates

        ./bin/tls-toolkit.sh standalone -n 'nifi[1-3]' -C 'CN=jllacer, OU=NIFI' -O -o ../security_output

### Sample Docker compose files that create 3 nodes clusters

In container folder are sample Compose files that create secured and unsecured clusters. You need docker-compose to run that compose files.

        docker-compose -f container/docker-compose_secure.yml up -d

NOTE: You have to reconfigure that file with your own generated sample certificates to test it.

## Useful links

* [Apache NiFi 1.1.0 – Secured cluster setup](https://pierrevillard.com/tag/tls-toolkit/)
* [apiri/docker-apache-nifi](https://github.com/apiri/dockerfile-apache-nifi)
* [mkobit/docker-nifi](https://github.com/mkobit/docker-nifi)