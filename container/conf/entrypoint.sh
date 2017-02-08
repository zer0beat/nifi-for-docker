#!/bin/sh

configure_secure_cluster() {
    echo "Configure SECURE NiFi cluster"

    echo "Configure ${NIFI_HOME}/state/zookeeper/myid"
    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo "${ZOO_MY_ID}" > ${NIFI_HOME}/state/zookeeper/myid

    echo "Configure ${NIFI_HOME}/conf/zookeeper.properties"
    sed -i.backup -e "/^server.1/ d" ${NIFI_HOME}/conf/zookeeper.properties
    for server in $ZOO_SERVERS; do
        echo "$server" >> ${NIFI_HOME}/conf/zookeeper.properties
    done

    echo "Configure ${NIFI_HOME}/conf/nifi.properties"
    sed -i \
        -e "s \(nifi\.zookeeper\.connect\.string=\).*\$ \1${ZOO_CONNECT} " \
        -e "s \(nifi\.state\.management\.embedded\.zookeeper\.start=\).*\$ \1true " \
        -e "s \(nifi\.cluster\.is\.node=\).*\$ \1true " \
        -e "s \(nifi\.cluster\.node\.address=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.cluster\.node\.protocol\.port=\).*\$ \1${COORDINATION_PORT:-9999} " \
        -e "s \(nifi\.cluster\.protocol\.is\.secure=\).*\$ \1true " \
        ${NIFI_HOME}/conf/nifi.properties

    echo "Configure ${NIFI_HOME}/conf/authorizers.xml"
    OLD_IFS=${IFS}
    IFS="|"
    count=1
    for identity in $NODE_IDENTITIES; do
        sed -i -e "s#\(.*</authorizer>\)#\t<property name=\"Node Identity $count\">$identity</property>\n\1#" ${NIFI_HOME}/conf/authorizers.xml
        count=$(expr $count + 1)
    done 
    IFS=${OLD_IFS}
}

configure_secure_node() {
    echo "Configure SECURE NiFi node"

    : ${KEYSTORE_PATH:?"Must specify an absolute path to the keystore being used."}
    if [[ ! -f "${KEYSTORE_PATH}" ]]; then
        echo "Keystore file specified (${KEYSTORE_PATH}) does not exist."
        exit 1
    fi
    : ${KEYSTORE_TYPE:?"Must specify the type of keystore (JKS, PKCS12, PEM) of the keystore being used."}
    : ${KEYSTORE_PASSWORD:?"Must specify the password of the keystore being used."}

    : ${TRUSTSTORE_PATH:?"Must specify an absolute path to the truststore  being used."}
    if [[ ! -f "${TRUSTSTORE_PATH}" ]]; then
        echo "Keystore file specified (${TRUSTSTORE_PATH}) does not exist."
        exit 1
    fi
    : ${TRUSTSTORE_TYPE:?"Need to set DEST non-empty"}
    : ${TRUSTSTORE_PASSWORD:?"Need to set DEST non-empty"}

    echo "Configure ${NIFI_HOME}/conf/nifi.properties"
    sed -i \
        -e "s \(nifi\.security\.keystore=\).*\$ \1${KEYSTORE_PATH} " \
        -e "s \(nifi\.security\.keystoreType=\).*\$ \1${KEYSTORE_TYPE} " \
        -e "s \(nifi\.security\.keystorePasswd=\).*\$ \1${KEYSTORE_PASSWORD} " \
        -e "s \(nifi\.security\.keyPasswd=\).*\$ \1${KEYSTORE_PASSWORD} " \
        -e "s \(nifi\.security\.truststore=\).*\$ \1${TRUSTSTORE_PATH} " \
        -e "s \(nifi\.security\.truststoreType=\).*\$ \1${TRUSTSTORE_TYPE} " \
        -e "s \(nifi\.security\.truststorePasswd=\).*\$ \1${TRUSTSTORE_PASSWORD} " \
        -e "s \(nifi\.web\.http\.port=\).*\$ \1 " \
        -e "s \(nifi\.web\.https\.host=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.web\.https\.port=\).*\$ \18443 " \
        -e "s \(nifi\.remote\.input\.host=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.remote\.input\.secure=\).*\$ \1true " \
        -e "s \(nifi\.remote\.input\.socket\.port=\).*\$ \1${SITE2SITE_PORT:-9998} " \
        ${NIFI_HOME}/conf/nifi.properties
    
    echo "Configure ${NIFI_HOME}/conf/authorizers.xml"
    sed -i -e "s#\(<property name=\"Initial Admin Identity\">\).*\(</property>\)#\1${INIT_ADMIN_IDENTITY}\2#" ${NIFI_HOME}/conf/authorizers.xml
}

configure_unsecure_cluster() {
    echo "Configure UNSECURE NiFi cluster"

    echo "Configure ${NIFI_HOME}/state/zookeeper/myid"
    mkdir -p ${NIFI_HOME}/state/zookeeper
    echo "${ZOO_MY_ID}" > ${NIFI_HOME}/state/zookeeper/myid

    echo "Configure ${NIFI_HOME}/conf/zookeeper.properties"
    sed -i.backup -e "/^server.1/ d" ${NIFI_HOME}/conf/zookeeper.properties
    for server in $ZOO_SERVERS; do
        echo "$server" >> ${NIFI_HOME}/conf/zookeeper.properties
    done

    echo "Configure ${NIFI_HOME}/conf/nifi.properties"
    sed -i \
        -e "s \(nifi\.zookeeper\.connect\.string=\).*\$ \1${ZOO_CONNECT} " \
        -e "s \(nifi\.state\.management\.embedded\.zookeeper\.start=\).*\$ \1true " \
        -e "s \(nifi\.cluster\.is\.node=\).*\$ \1true " \
        -e "s \(nifi\.cluster\.node\.address=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.cluster\.node\.protocol\.port=\).*\$ \1${COORDINATION_PORT:-9999} " \
        -e "s \(nifi\.cluster\.protocol\.is\.secure=\).*\$ \1false " \
        ${NIFI_HOME}/conf/nifi.properties
}

configure_unsecure_node() {
    echo "Configure UNSECURE NiFi node"

    echo "Configure ${NIFI_HOME}/conf/nifi.properties"
    sed -i \
        -e "s \(nifi\.web\.http\.host=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.web\.http\.port=\).*\$ \18080 " \
        -e "s \(nifi\.remote\.input\.host=\).*\$ \1${NODE_HOSTNAME:-$HOSTNAME} " \
        -e "s \(nifi\.remote\.input\.secure=\).*\$ \1false " \
        -e "s \(nifi\.remote\.input\.socket\.port=\).*\$ \1${SITE2SITE_PORT:-9998} " \
        ${NIFI_HOME}/conf/nifi.properties
}

if [ "$ENABLE_SSL" == "true" ]; then
    configure_secure_node
    if [ -n "$ZOO_MY_ID" ]; then
        configure_secure_cluster
    fi
else
    configure_unsecure_node
    if [ -n "$ZOO_MY_ID" ]; then
        configure_unsecure_cluster
    fi
fi

exec "$@"

