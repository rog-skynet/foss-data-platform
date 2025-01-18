#!/bin/bash

# Ensure MinIO data directory exists
echo "Setting up MinIO directories..."
mkdir -p /home/datauser/minio/data
chown -R 1000:1000 /home/datauser/minio

# Remove existing container if necessary
docker rm -f minio || echo "No existing MinIO container to remove."

# Pull and start MinIO container
docker pull minio/minio
docker run -d --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v /home/datauser/minio/data:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=adminpassword" \
  minio/minio server /data --console-address ":9001"

# Download and install MinIO client
curl -O https://dl.min.io/client/mc/release/linux-amd64/mc || { echo "Failed to download MinIO client. Exiting."; exit 1; }
chmod +x mc
mv mc /usr/local/bin/mc || { echo "Failed to move MinIO client. Exiting."; exit 1; }

# Configure MinIO client
mc alias set myminio http://70.34.202.253:9000 admin adminpassword || { echo "Failed to configure MinIO client. Exiting."; exit 1; }

# Create test bucket if it doesn't exist
if ! mc ls myminio/test-bucket &>/dev/null; then
  echo "Creating test bucket..."
  mc mb myminio/test-bucket || { echo "Failed to create test bucket. Exiting."; exit 1; }
else
  echo "Test bucket already exists."
fi

echo "MinIO setup complete!"
