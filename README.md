# Helm Chart

This Helm chart deploys a scalable web application consisting of a frontend, a backend, and a PostgreSQL database.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Istio 1.5+ (for service mesh)

## Installation

1. Navigate to the Helm chart directory:

    ```bash
    cd ./helm
    ```

2. Deploy the Helm chart:

    ```bash
    ./deploy.sh --backend-namespace <backend-namespace> --database-namespace <database-namespace> --release-name <your-release>
    ```

Replace `backend-namespace` with the name of the Kubernetes namespace where you want to deploy the backend, `database-namespace` with the name of the Kubernetes namespace where you want to deploy the database, and `your-release` with the name you want to give to the Helm release.

## Components

The Helm chart includes the following components:

- **Frontend**: A Deployment and a Horizontal Pod Autoscaler. The Deployment specifies the Docker image to use for the frontend, the number of replicas, and the resource requests and limits. The Horizontal Pod Autoscaler automatically scales the number of frontend pods based on the observed CPU utilization.

- **Backend**: A Deployment and a Horizontal Pod Autoscaler. The Deployment specifies the Docker image to use for the backend, the number of replicas, and the resource requests and limits. The Horizontal Pod Autoscaler automatically scales the number of backend pods based on the observed CPU utilization.

- **Database**: A StatefulSet and a PersistentVolumeClaim. The StatefulSet specifies the Docker image to use for the PostgreSQL database. The PersistentVolumeClaim requests a PersistentVolume for database storage.

- **Networking**: An Ingress, a Service for each component, and Network Policies. The Ingress routes external traffic to the frontend Service. The Services route internal traffic to the Pods. The Network Policies restrict traffic to the backend and database to only allow connections from certain Pods.

- **Service Mesh**: Istio DestinationRules and Policies for the backend and database. These Istio resources configure mutual TLS (mTLS) for secure communication between the backend and database.

- **Secrets**: A Secret for the database credentials. The Secret is used to pass the database username and password to the database Pod.

## Configuration

The `values.yaml` file contains the configuration options for the Helm chart. You can specify the Docker image, the number of replicas, the resource requests and limits, the autoscaling configuration, and the database credentials.

## Autoscaling

The frontend and backend are configured to autoscale based on CPU utilization. The target CPU utilization percentage can be set in the `values.yaml` file. If the observed CPU utilization exceeds the target, the Horizontal Pod Autoscaler will create additional pods. If the observed CPU utilization is below the target, the Horizontal Pod Autoscaler will remove pods.

## Networking

The frontend is exposed to the internet via an Ingress, which routes external HTTPS traffic to the frontend Service. The Ingress is configured with a TLS certificate, which enables HTTPS. HTTP traffic automatically redirects to HTTPS. The backend and database are not directly exposed to the internet. They can be accessed by other components within the cluster via their Services. Network Policies are used to restrict traffic to the backend and database.
## Storage

The database uses a PersistentVolume for storage, which is provisioned by a PersistentVolumeClaim. The size of the PersistentVolume can be set in the `values.yaml` file.
