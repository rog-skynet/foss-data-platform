# FOSS Data Platform

## **Purpose**
The FOSS Data Platform is a lightweight, modular, and cost-effective solution for modern data engineering. Designed to serve small-to-medium businesses (SMBs) and developers, it enables seamless orchestration, transformation, and analysis of data using fully or partially open-source technologies. It emphasizes freedom from vendor lock-in, scalability, and ease of deployment, while being cost-efficient compared to proprietary solutions like Microsoft Fabric or Databricks.

---

## **Philosophy**
- **Lean and Modular**: Each component serves a focused purpose, adhering to the Unix philosophy of simplicity.
- **Open Source First**: While open-source technologies are prioritized, pragmatic choices may occasionally incorporate non-FOSS solutions where they offer significant benefits.
- **Scalable and Flexible**: Designed for growth, the platform supports multi-tenancy and decoupled compute and storage layers.
- **Cost-Effective**: Reduces infrastructure and licensing costs by leveraging open technologies and efficient configurations.

---

## **Key Features**
- **Multi-Tenancy**: Supports multiple clients with isolated data and resource management.
- **Medallion Architecture**: Implements a Bronze-Silver-Gold layered data architecture for structured and efficient data processing.
- **Interactive Development**: Includes JupyterLab for prototyping and analysis.
- **Seamless Integration**: Compatible with Power BI and other visualization tools.
- **Automated Orchestration**: Leverages Dagster for robust pipeline management.

---

## **Tech Stack**
### **Core Components**
- **Storage**: MinIO (self-hosted, S3-compatible object storage)
- **Data Lakehouse**: Apache Iceberg (or Delta Lake, based on deployment preference)
- **Query Engine**: Apache Trino
- **Orchestration**: Dagster
- **Transformations**: DBT (Data Build Tool)
- **Development Environment**: JupyterLab

### **Supporting Tools**
- **Secrets Management**: Sops + Age
- **Monitoring**: Prometheus + Grafana
- **Infrastructure as Code**: Terraform
- **Containerization**: Docker Compose

---

## **Deployment**
The platform can be deployed quickly on a VPS (e.g., Debian 12) using Docker Compose.

### **Steps**
1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo-name.git
   cd your-repo-name
   ```

2. Ensure Docker and Docker Compose are installed on your system.

3. Update configuration files as needed (e.g., `docker-compose.yml`, Trino catalog settings).

4. Start the platform:
   ```bash
   docker-compose up -d
   ```

5. Access services:
   - **MinIO**: `http://<VPS-IP>:9000` (credentials: `minioadmin:minioadmin`)
   - **Trino**: `http://<VPS-IP>:8080`
   - **Dagster**: `http://<VPS-IP>:3000`
   - **JupyterLab**: `http://<VPS-IP>:8888`

---

## **Architecture Overview**
1. **Bronze Layer**: Stores raw data in MinIO (e.g., CSV, JSON, Parquet).
2. **Silver Layer**: Cleansed and transformed data stored in Iceberg/Delta Lake.
3. **Gold Layer**: Aggregated, business-ready datasets for analytics and reporting.

### **Workflow**
1. **Data Ingestion**: Source data is ingested into the Bronze layer via pipelines managed by Dagster.
2. **Transformation**: DBT transforms data from Bronze to Silver and Silver to Gold.
3. **Query and Analysis**: Trino enables querying across all layers for business intelligence or reporting.

---

## **Comparison to Proprietary Solutions**
- **Cost**: ~50% cheaper than platforms like Microsoft Fabric or Databricks.
- **Flexibility**: No vendor lock-in and fully customizable.
- **Scalability**: Scales horizontally with Kubernetes or additional VPS nodes.

---

## **Future Enhancements**
- Add managed external storage integration for larger-scale production workloads.
- Expand monitoring and alerting capabilities.
- Implement more advanced multi-tenant RBAC.
- Explore support for additional visualization tools.

---

## **Contributing**
Contributions are welcome! Please open an issue or submit a pull request to discuss improvements or new features.

---

## **License**
This project is licensed under the MIT License. See the `LICENSE` file for details.
