#!/bin/bash

# Set Trino version
echo "Setting up Trino..."
TRINO_VERSION="417"
TRINO_TMP_DIR="/home/datauser/tmp"
TRINO_DIR="/home/datauser/trino"

# Create necessary directories
mkdir -p $TRINO_TMP_DIR
mkdir -p $TRINO_DIR

# Download and extract Trino
if [ ! -d "$TRINO_DIR/bin" ]; then
  echo "Downloading Trino version $TRINO_VERSION..."
  wget https://repo1.maven.org/maven2/io/trino/trino-server/$TRINO_VERSION/trino-server-$TRINO_VERSION.tar.gz -O $TRINO_TMP_DIR/trino-server-$TRINO_VERSION.tar.gz || { echo "Failed to download Trino. Exiting."; exit 1; }
  tar -xzf $TRINO_TMP_DIR/trino-server-$TRINO_VERSION.tar.gz -C $TRINO_DIR --strip-components=1 || { echo "Failed to extract Trino. Exiting."; exit 1; }
  rm -f $TRINO_TMP_DIR/trino-server-$TRINO_VERSION.tar.gz
else
  echo "Trino is already downloaded."
fi

# Create configuration files
echo "Creating Trino configuration files..."
mkdir -p $TRINO_DIR/etc/catalog

cat <<EOT > $TRINO_DIR/etc/node.properties
node.environment=production
node.id=trino-1
node.data-dir=$TRINO_DIR/data
EOT

cat <<EOT > $TRINO_DIR/etc/jvm.config
-server
-Xmx512M
-XX:+UseG1GC
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=$TRINO_DIR/heapdump
-Djdk.attach.allowAttachSelf=true
-Dlog.enable-console=true
EOT

cat <<EOT > $TRINO_DIR/etc/config.properties
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
query.max-memory=512MB
query.max-memory-per-node=256MB
discovery-server.enabled=true
discovery.uri=http://70.34.202.253:8080
EOT

cat <<EOT > $TRINO_DIR/etc/catalog/minio.properties
connector.name=hive
hive.s3.aws-access-key=admin
hive.s3.aws-secret-key=adminpassword
hive.s3.endpoint=http://70.34.202.253:9000
hive.s3.path-style-access=true
EOT

# Set permissions for Trino directory
chown -R datauser:datauser $TRINO_DIR
chmod -R 755 $TRINO_DIR

# Start Trino
echo "Starting Trino..."
$TRINO_DIR/bin/launcher start || { echo "Failed to start Trino. Check logs at $TRINO_DIR/var/log/server.log"; exit 1; }

# Verify Trino installation
if curl -s http://70.34.202.253:8080 | grep -q "Trino"; then
  echo "Trino is running! Access it at http://70.34.202.253:8080"
else
  echo "Trino failed to start. Check the logs in $TRINO_DIR/var/log/server.log"
fi

echo "Trino setup complete!"
