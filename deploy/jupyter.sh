### JupyterLab Setup Script: setup_jupyterlab.sh
#!/bin/bash

# Install JupyterLab
echo "Installing JupyterLab..."
/home/datauser/miniconda/bin/conda install -y -n data_platform jupyterlab

# Create a directory for Jupyter notebooks
NOTEBOOK_DIR="/home/datauser/jupyter_notebooks"
mkdir -p $NOTEBOOK_DIR

# Generate JupyterLab configuration
echo "Generating JupyterLab configuration..."
sudo -u datauser /home/datauser/miniconda/envs/data_platform/bin/jupyter lab --generate-config

# Update the configuration to allow remote access
echo "Updating JupyterLab configuration for remote access..."
cat <<EOT >> /home/datauser/.jupyter/jupyter_notebook_config.py
c.ServerApp.ip = '0.0.0.0'
c.ServerApp.open_browser = False
c.ServerApp.port = 8888
EOT

# Create a systemd service for JupyterLab
echo "Configuring JupyterLab as a systemd service..."
cat <<EOT > /lib/systemd/system/jupyterlab.service
[Unit]
Description=JupyterLab Server
After=network.target

[Service]
Type=simple
PIDFile=/run/jupyter.pid
ExecStart=/home/datauser/miniconda/envs/data_platform/bin/jupyter lab --config=/home/datauser/.jupyter/jupyter_notebook_config.py
WorkingDirectory=$NOTEBOOK_DIR
Restart=always
User=datauser
Group=datauser
Environment="PATH=/home/datauser/miniconda/envs/data_platform/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd daemon and start JupyterLab service
echo "Starting JupyterLab service..."
systemctl daemon-reload
systemctl enable jupyterlab
systemctl start jupyterlab

# Retrieve the JupyterLab token
echo "Retrieving JupyterLab token..."
JUPYTER_TOKEN=$(/home/datauser/miniconda/envs/data_platform/bin/jupyter lab list | grep -oP '(?<=token=)[a-z0-9]+')

if [ -z "$JUPYTER_TOKEN" ]; then
  echo "Failed to retrieve JupyterLab token. Check the service logs with 'journalctl -u jupyterlab'."
else
  echo "JupyterLab is running! Access it at http://70.34.202.253:8888?token=$JUPYTER_TOKEN"
  echo "Token: $JUPYTER_TOKEN" > $NOTEBOOK_DIR/jupyter_token.txt
fi

echo "JupyterLab setup complete!"
