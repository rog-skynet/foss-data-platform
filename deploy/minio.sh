#!/bin/bash

# Ensure MinIO data directory exists
echo "Setting up MinIO directories..."
MINIO_DIR="/home/datauser/minio"
sudo mkdir -p $MINIO_DIR/data
sudo chown -R datauser:datauser $MINIO_DIR

# Pull and start MinIO container
echo "Pulling and starting MinIO Docker container..."
docker pull minio/minio
docker run -d --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v $MINIO_DIR/data:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=adminpassword" \
  minio/minio server /data --console-address ":9001" || echo "Container already running."

# Download MinIO client
echo "Downloading MinIO client..."
cd /home/datauser || exit 1
curl -O https://dl.min.io/client/mc/release/linux-amd64/mc || { echo "Failed to download MinIO client. Exiting."; exit 1; }
chmod +x mc
sudo mv mc /usr/local/bin/

# Configure MinIO client
echo "Configuring MinIO client..."
mc alias set myminio http://70.34.202.253:9000 admin adminpassword || { echo "Failed to configure MinIO client."; exit 1; }

# Create test bucket if it doesn't exist
if ! mc ls myminio/test-bucket &>/dev/null; then
  echo "Creating test bucket..."
  mc mb myminio/test-bucket || { echo "Failed to create test bucket."; exit 1; }
else
  echo "Test bucket already exists."
fi

echo "MinIO setup complete!"
