apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: jwt-auth
  namespace: ${namespace}
  annotations:
    kubernetes.io/ingress.class: kong
username: "auth0|user"
credentials:
  - jwt-auth
