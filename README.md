![Apache NiFi logo](http://nifi.apache.org/images/niFi-logo-horizontal.png "Apache NiFi")
# Apache NiFi for Docker
## Version 1.7.1
		

## Getting started

1. Start Nifi

        $ VERSION=1.7.1
        $ docker run --rm -p 8080:8080 nifi:${VERSION}

2. Wait for the Nifi initialization
		
3. Access to Nifi interface
 	
	http://localhost:8080/nifi


## Build docker image from source

        $ VERSION=1.7.1
        $ FOLDER=1.x.x
        $ docker build --build-arg VERSION=${VERSION} -t z0beat/nifi:${VERSION} ./${FOLDER}

## Extract default configuration from docker image

        $ docker run --rm -v /path/to/nifi/conf:/opt/conf --entrypoint="" z0beat/nifi:1.7.1 cp -r /opt/nifi/conf/. /opt/conf/