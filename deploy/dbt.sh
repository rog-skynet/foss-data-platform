### DBT Setup Script: setup_dbt.sh
#!/bin/bash

# Install DBT
echo "Installing DBT..."
/home/datauser/miniconda/bin/pip install dbt-core dbt-trino --root-user-action=ignore

# Create a basic DBT project directory
echo "Setting up DBT project..."
DBT_PROJECT_DIR="/home/datauser/dbt_project"
mkdir -p $DBT_PROJECT_DIR

# Configure DBT profiles
echo "Configuring DBT profiles..."
mkdir -p /home/datauser/.dbt
cat <<EOT > /home/datauser/.dbt/profiles.yml
default:
  outputs:
    dev:
      type: trino
      method: none
      schema: "test-bucket"
      catalog: "minio"
      host: "70.34.202.253"
      port: 8080
  target: dev
EOT

# Configure DBT project
echo "Creating DBT project configuration..."
cat <<EOT > $DBT_PROJECT_DIR/dbt_project.yml
name: "my_dbt_project"
version: "1.0"
config-version: 2
profile: "default"
target-path: "target"
EOT

# Create a simple DBT model
echo "Creating example DBT model..."
mkdir -p $DBT_PROJECT_DIR/models
cat <<EOT > $DBT_PROJECT_DIR/models/example.sql
SELECT * FROM "test-bucket"."test_data.csv"
EOT

# Set permissions
echo "Setting permissions for DBT project..."
chown -R datauser:datauser $DBT_PROJECT_DIR /home/datauser/.dbt

# Verify DBT installation
echo "Verifying DBT installation..."
/home/datauser/miniconda/envs/data_platform/bin/dbt --version

if [ $? -eq 0 ]; then
  echo "DBT setup complete!"
else
  echo "DBT installation failed. Check the logs and retry."
fi
