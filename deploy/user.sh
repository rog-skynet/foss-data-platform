#!/bin/bash

# Create a dedicated user if it doesn't exist
echo "Setting up dedicated user: datauser"
if ! id "datauser" &>/dev/null; then
  useradd -m -s /bin/bash datauser
  echo "datauser:rog-skynet-foss" | chpasswd
  usermod -aG sudo datauser
else
  echo "User datauser already exists."
fi

# Ensure the home directory has appropriate permissions
chown -R datauser:datauser /home/datauser

# Add Docker group permissions
groupadd -f docker
usermod -aG docker datauser

# Install Miniconda for datauser
if [ ! -d "/home/datauser/miniconda" ]; then
  echo "Installing Miniconda for datauser..."
  sudo -u datauser wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
  chmod +x /tmp/miniconda.sh
  sudo -u datauser bash /tmp/miniconda.sh -b -p /home/datauser/miniconda
  echo 'export PATH="/home/datauser/miniconda/bin:$PATH"' >> /home/datauser/.bashrc
else
  echo "Miniconda already installed for datauser."
fi

# Ensure the Conda environment is created
WORK_DIR="/home/datauser"
cd $WORK_DIR
if ! sudo -u datauser /home/datauser/miniconda/bin/conda env list | grep -q "data_platform"; then
  echo "Creating Conda environment for data_platform..."
  sudo -u datauser /home/datauser/miniconda/bin/conda create -y -n data_platform python=3.9
else
  echo "Conda environment data_platform already exists."
fi

# Ensure permissions for the Conda directory
chown -R datauser:datauser /home/datauser/miniconda

echo "User setup complete!"
