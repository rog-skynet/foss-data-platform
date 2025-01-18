#!/bin/bash

# Run the user-specific setup script as root (datauser doesn't exist yet)
bash deploy/user.sh

# Switch to datauser for subsequent setup steps
sudo -u datauser bash -c "bash deploy/minio.sh"
sudo -u datauser bash -c "bash deploy/trino.sh"
sudo -u datauser bash -c "bash deploy/dagster.sh"
sudo -u datauser bash -c "bash deploy/dbt.sh"
sudo -u datauser bash -c "bash deploy/jupyterlab.sh"

echo "Data platform setup complete!"
