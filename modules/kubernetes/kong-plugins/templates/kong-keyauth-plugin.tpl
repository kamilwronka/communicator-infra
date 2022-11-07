apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: key-auth
  namespace: ${namespace}
config:
  key_names:
    - apikey
  key_in_body: false
  key_in_header: true
  key_in_query: true
  hide_credentials: false
  run_on_preflight: true
plugin: key-auth
