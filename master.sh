### Master Setup Script: master.sh
#!/bin/bash

# Run the setup scripts as root for initial configuration
bash setup/setup_user.sh

# Switch to datauser for subsequent setup steps
sudo -u datauser bash -c "bash deploy/minio.sh"
sudo -u datauser bash -c "bash deploy/user.sh"
sudo -u datauser bash -c "bash deploy/trino.sh"
sudo -u datauser bash -c "bash deploy/dagster.sh"
sudo -u datauser bash -c "bash deploy/dbt.sh"
sudo -u datauser bash -c "bash deploy/jupyterlab.sh"

echo "Data platform setup complete!"
