#!/bin/bash

kubectl get ns 
read -p "請輸入 K8S Namespace: " NAMESPACE
read -p "請輸入 Ingress 名稱: " INGRESS
read -p "請輸入網址 (e.g. test.gosu.bar): " DOMAIN
kubectl -n ${NAMESPACE} get svc
read -p "請輸入對應的 Service 名稱: " SERVICE
read -p "請輸入對應的 Port : " PORT

echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${INGRESS}
  namespace: ${NAMESPACE}
spec:
  ingressClassName: nginx
  rules:
    - host: ${DOMAIN}
      http:
        paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: ${SERVICE}
                port:
                  number: ${PORT}
  " | kubectl apply -f - 