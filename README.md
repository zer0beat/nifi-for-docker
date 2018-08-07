![Apache NiFi logo](http://nifi.apache.org/images/niFi-logo-horizontal.png "Apache NiFi")
# Apache NiFi for Docker
## Version 1.7.1

## Sample Usage:

From your checkout directory:
		
1. Build the image

        $ VERSION=1.7.1
        $ FOLDER=1.x.x
        $ cd ${FOLDER}
        $ docker build --build-arg VERSION=${VERSION} -t nifi:${VERSION} .
		
2. Run the image

        $ VERSION=1.7.1
        $ docker run --rm -p 8080:8080 nifi:${VERSION}

3. Wait for the Nifi initialization
		
4. Access to Nifi interface
 	
	http://localhost:8080/nifi

## Extract default configuration from docker image

        $ docker run --rm -v E:/tmp/nifi/conf:/opt/conf --entrypoint="" nifi:1.7.1 cp -r /opt/nifi/conf/. /opt/conf/