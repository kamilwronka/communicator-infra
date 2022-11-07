apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: jwt
  namespace: ${namespace}
config:
  secret_is_base64: false
  run_on_preflight: true
plugin: jwt
