apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: cors
  namespace: ${namespace}
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: "true"
config:
  origins: 
    ${cors_origins}
  methods:
    - GET
    - POST
    - DELETE
    - PATCH
    - PUT
  headers:
    - Authorization
    - Accept
    - Accept-Version
    - Content-Length
    - Content-MD5
    - Content-Type
    - Date
    - X-Auth-Token
  exposed_headers:
    - X-Auth-Token
  credentials: true
  max_age: 3600
  preflight_continue: false
plugin: cors