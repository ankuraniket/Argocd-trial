Follow the below steps to configure your AWS account for EKS and application deployment:

Create a secret with your AWS credentials
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
echo "[default] aws_access_key_id = $AWS_ACCESS_KEY_ID aws_secret_access_key = $AWS_SECRET_ACCESS_KEY " >aws-creds.conf
kubectl -n crossplane-system create secret generic aws-creds --from-file creds=./aws-creds.conf
Create Providerconfig with the secret kubectl apply -f providerconfig-aws.yaml