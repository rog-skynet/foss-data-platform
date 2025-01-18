### MinIO Setup Script: setup_minio.sh
#!/bin/bash

# Ensure MinIO data directory exists
echo "Setting up MinIO directories..."
mkdir -p /home/datauser/minio/data
chmod -R 1000:1000 /home/datauser/minio

# Pull and start MinIO container
echo "Pulling and starting MinIO Docker container..."
docker pull minio/minio
docker run -d --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -v /home/datauser/minio/data:/data \
  -e "MINIO_ROOT_USER=admin" \
  -e "MINIO_ROOT_PASSWORD=adminpassword" \
  minio/minio server /data --console-address ":9001"

# Install MinIO Client (mc)
echo "Installing MinIO client..."
curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/

# Configure MinIO client
echo "Configuring MinIO client..."
mc alias set myminio http://70.34.202.253:9000 admin adminpassword

# Create test bucket if it doesn't exist
if ! mc ls myminio/test-bucket &>/dev/null; then
  echo "Creating test bucket..."
  mc mb myminio/test-bucket
else
  echo "Test bucket already exists."
fi

echo "MinIO setup complete!"
