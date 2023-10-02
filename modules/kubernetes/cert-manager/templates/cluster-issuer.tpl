apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${name}
spec:
  acme:
    email: ${issuerEmail}
    privateKeySecretRef:
      name: ${name}
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          podTemplate:
             metadata:
               annotations:
                 kuma.io/sidecar-injection: 'false'   # If ingress is running in Kuma/Kong Mesh, disable sidecar injection
                 sidecar.istio.io/inject: 'false'  # If using Istio, disable sidecar injection
          class: kong