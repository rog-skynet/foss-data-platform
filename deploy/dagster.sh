### Dagster Setup Script: setup_dagster.sh
#!/bin/bash

# Install Dagster and Dagit
echo "Installing Dagster and Dagit..."
/home/datauser/miniconda/bin/pip install dagster dagit --root-user-action=ignore

# Create a basic Dagster project directory
echo "Setting up Dagster project..."
DAGSTER_PROJECT_DIR="/home/datauser/dagster_project"
mkdir -p $DAGSTER_PROJECT_DIR

# Create a simple Dagster job
cat <<EOT > $DAGSTER_PROJECT_DIR/hello_dagster.py
from dagster import job, op

@op
def hello():
    return "Hello, Dagster!"

@job
def hello_job():
    hello()
EOT

# Create a systemd service for Dagster
echo "Configuring Dagster as a service..."
cat <<EOT > /lib/systemd/system/dagster.service
[Unit]
Description=Dagster Daemon
After=network.target

[Service]
ExecStart=/home/datauser/miniconda/envs/data_platform/bin/dagster-daemon run
WorkingDirectory=$DAGSTER_PROJECT_DIR
Restart=always
User=datauser

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and start the Dagster service
systemctl daemon-reload
systemctl enable dagster
systemctl start dagster

# Verify the Dagster service status
echo "Verifying Dagster service..."
systemctl status dagster | grep -q "active (running)"
if [ $? -eq 0 ]; then
  echo "Dagster is running!"
else
  echo "Dagster failed to start. Check the service logs with 'journalctl -u dagster'."
fi

echo "Dagster setup complete!"
