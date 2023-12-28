cfssl genkey cert-signing-request.json | cfssljson -bare created-certs/server

cat created-certs/server.csr | base64 | tr -d '\n'

kubectl apply -f cert-signing-request.yaml 

kubectl describe csr argocd-server-ingress.argocd

kubectl certificate approve argocd-server-ingress.argocd

cfssl gencert -initca cert-authority.json | cfssljson -bare created-certs/ca

kubectl get csr argocd-server-ingress.argocd -o jsonpath='{.spec.request}' | \
  base64 --decode | \
  cfssl sign -ca created-certs/ca.pem -ca-key created-certs/ca-key.pem -config server-signing-config.json - | \
  cfssljson -bare created-certs/ca-signed-server

kubectl get csr argocd-server-ingress.argocd -o json | \
  jq '.status.certificate = "'$(base64 created-certs/ca-signed-server.pem | tr -d '\n')'"' | \
  kubectl replace --raw /apis/certificates.k8s.io/v1/certificatesigningrequests/argocd-server-ingress.argocd/status -f -

kubectl get csr argocd-server-ingress.argocd -o jsonpath='{.status.certificate}' \
    | base64 --decode > created-certs/server.crt

kubectl create secret tls -n argocd argocd-tls-secret --cert created-certs/server.crt --key created-certs/server-key.pem