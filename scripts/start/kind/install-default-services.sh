#!/bin/bash

# fix local-path-storage configmap
kubectl patch configmap local-path-config -n local-path-storage --type merge -p '{"data": {"config.json": "{\n  \"sharedFileSystemPath\": \"/opt/local-path-provisioner\"\n}"}}'
kubectl -n local-path-storage rollout restart deployment local-path-provisioner
kubectl wait --for=condition=ready pod -l app=local-path-provisioner -n local-path-storage --timeout=300s

# Install local-path storage class
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
parameters:
  archiveOnDelete: 'false'
  pathPattern: "{{ .PVC.Namespace }}/{{ .PVC.Name }}"
reclaimPolicy: Retain
volumeBindingMode: Immediate
EOF


# Install ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx --create-namespace \
    --hide-notes \
    --set controller.service.type=NodePort \
    --set controller.config.enable-access-log=true \
    --set controller.service.nodePorts.http=30080 \
    --set controller.service.nodePorts.https=30443

