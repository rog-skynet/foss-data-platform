#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Validating required scripts..."
# Ensure all deploy scripts exist before running
for script in deploy/user.sh deploy/minio.sh deploy/trino.sh deploy/dagster.sh deploy/dbt.sh deploy/jupyterlab.sh; do
  if [ ! -f "$script" ]; then
    echo "Error: Script $script not found. Exiting."
    exit 1
  fi
done

echo "Running user setup script as root (datauser creation)..."
# Run the user-specific setup script as root (datauser doesn't exist yet)
bash setup/user.sh

echo "Switching to datauser for platform deployment..."
# Switch to datauser for subsequent setup steps
sudo -u datauser bash -c "bash deploy/minio.sh"
sudo -u datauser bash -c "bash deploy/trino.sh"
sudo -u datauser bash -c "bash deploy/dagster.sh"
sudo -u datauser bash -c "bash deploy/dbt.sh"
sudo -u datauser bash -c "bash deploy/jupyterlab.sh"

echo "Data platform setup complete!"
