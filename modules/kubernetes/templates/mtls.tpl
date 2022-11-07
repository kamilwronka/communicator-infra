apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
  namespace: ${namespace}
spec:
  mtls:
    mode: ${mode}
