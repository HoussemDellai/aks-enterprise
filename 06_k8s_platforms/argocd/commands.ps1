
# install Nginx ingress controller with custom ingress class name
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

$NAMESPACE_INGRESS="ingress-nginx"
$INGRESS_CLASS_NAME="nginx"

@"
controller:
  ingressClassResource:
    name: $INGRESS_CLASS_NAME
    enabled: true
    default: false
    controllerValue: "k8s.io/ingress-$INGRESS_CLASS_NAME"
"@ > ingress-nginx-values.yaml

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx `
     --create-namespace --namespace $NAMESPACE_INGRESS `
     --set controller.replicaCount=2 `
     --set controller.nodeSelector."kubernetes\.io/os"=linux `
     --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz `
     -f ingress-nginx-values.yaml

kubectl get pods,services --namespace $NAMESPACE_INGRESS



kubectl create namespace argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/ha/install.yaml

kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'

kubectl get pods,svc -n argocd

kubectl port-forward svc/argocd-server -n argocd 8080:443

$password_encoded=(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}')

echo $password_encoded
# bmhIcnFoTVAyWnFCNC1ETg==

$password=[Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($password)) # powershell
echo $password
# nhHrqhMP2ZqB4-DN




$DNS_NAME="argocd01"

$CERT_NAME="tls-ingress-argocd-secret"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
    -out aks-ingress-tls.crt `
    -keyout aks-ingress-tls.key `
    -subj "/CN=$DNS_NAME.westeurope.cloudapp.azure.com/O=aks-ingress-tls" `
    -addext "subjectAltName = DNS:$DNS_NAME.westeurope.cloudapp.azure.com"

openssl pkcs12 -export -in aks-ingress-tls.crt -inkey aks-ingress-tls.key -out "$CERT_NAME.pfx"


$TLS_SECRET="tls-ingress-argocd-secret"

kubectl create secret tls $TLS_SECRET --cert=aks-ingress-tls.crt --key=aks-ingress-tls.key -n argocd

kubectl describe secret $TLS_SECRET -n argocd
