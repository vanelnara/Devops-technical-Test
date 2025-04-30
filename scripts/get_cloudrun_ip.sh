#!/bin/bash
SERVICE_NAME=$1
REGION=$2
if [ -z "$SERVICE_NAME" ] || [ -z "$REGION" ]; then
  echo "Usage: $0 <service-name> <region>"
  exit 1
fi
gcloud run services describe $SERVICE_NAME --region=$REGION --platform managed --format='value(status.url)'
