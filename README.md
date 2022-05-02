# Argocd-trial

Repository contains crossplane XRDs for creating EKS kubernetes cluster and provisioning application using 
provider-kubernetes on the cluster

Follow the below steps to configure your AWS account for EKS and application deployment:
1. Create a secret with your AWS credentials
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
echo "[default] aws_access_key_id = $AWS_ACCESS_KEY_ID aws_secret_access_key = $AWS_SECRET_ACCESS_KEY " >aws-creds.conf
kubectl -n crossplane-system create secret generic aws-creds --from-file creds=./aws-creds.conf
2. Create Providerconfig with the secret
kubectl apply -f providerconfig-aws.yaml

Prerequisite for running crossplane XRDs on management cluster using Argo CD

1. create a separate namespace for argocd
kubectl create namespace argocd
2. Install argocd application using manifest file
"kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
3. It runs various pods and services. Get list of services running for argocd
kubectl get svc -n argocd
4. To run/login to argocd UI services to local use kubectl port-forward command
kubectl port-forward svc/argocd-server 8080:443 -n argocd
5. grep password for admin user for logging into argocd UI
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
6. Once you are into argocd UI you can create argoCD application on the UI or it can be created using Kubernetes custom resouce defintion from argoCD
 i.e. kubectl apply -f argocd-application.yaml
