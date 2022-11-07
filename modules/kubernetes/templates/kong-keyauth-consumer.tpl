apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: key-auth
  namespace: ${namespace}
  annotations:
    kubernetes.io/ingress.class: kong
username: "auth0|hooks"
credentials:
  - key-auth
