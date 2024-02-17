#!/bin/bash

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --backend-namespace) BACKEND_NAMESPACE="$2"; shift ;;
        --database-namespace) DATABASE_NAMESPACE="$2"; shift ;;
        --release-name) RELEASE_NAME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Set the path to the directory containing the Helm chart
CHART_PATH="./helm"

# Create the namespaces if they don't exist
kubectl create namespace "$BACKEND_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace "$DATABASE_NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# Label the namespaces
kubectl label namespace "$BACKEND_NAMESPACE" name=backend
kubectl label namespace "$DATABASE_NAMESPACE" name=database

# Deploy the Helm chart
helm upgrade --install "$RELEASE_NAME-backend" $CHART_PATH/backend --namespace "$BACKEND_NAMESPACE"
helm upgrade --install "$RELEASE_NAME-database" $CHART_PATH/database --namespace "$DATABASE_NAMESPACE"
