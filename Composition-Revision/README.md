# Composition revision

Composition Revisions are an alpha feature. They are not yet recommended for production use, and are disabled by default. Start Crossplane with the --enable-composition-revisions flag to enable Composition Revision support.

##### ***Note***: If you already have crossplane setup but without composition revisions enabled, delete the previous helm deployment.
```
helm delete crossplane --namespace crossplane-system
```
##### Further you can skip namespace creation and provider installation steps in setup.

<br>

## Setup

Following steps required for crossplane installation with composition revisions enabled in the management kubernetes cluster.

1. Use Helm to install stable crossplane release.
  ```
  kubectl create namespace crossplane-system

  helm repo add crossplane-stable https://charts.crossplane.io/stable

  helm repo update

  helm install crossplane --namespace crossplane-system crossplane-stable/crossplane --set args='{--enable-composition-revisions}'
  ```
2. Install crossplane provider-aws either using crossplane cli such as or use kubectl apply -f provider-aws.yaml
  ```
  kubectl crossplane install provider crossplane/provider-aws:master
  ```

<br>
Follow the below steps to configure your AWS account :

1. Create a secret with your AWS credentials
```
export AWS_ACCESS_KEY_ID=

export AWS_SECRET_ACCESS_KEY=

echo "[default] aws_access_key_id = $AWS_ACCESS_KEY_ID aws_secret_access_key = $AWS_SECRET_ACCESS_KEY " >aws-creds.conf

kubectl -n crossplane-system create secret generic aws-creds --from-file creds=./aws-creds.conf
```
2. Create Providerconfig with the secret
```
kubectl apply -f providerconfig-aws.yaml
```

<br>

### Folder files description

1. **providerconfig-aws.yaml** - Provider config
2. **ec2-definitions.yaml** - Composite resource definition
3. **ec2-compositions-v1.yaml** - Version 1 of composition , security group inbound rule port number set to 80
4. **ec2-compositions-v2.yaml** - Version 2 of composition , security group inbound rule port number set to 81
5. **ec2-claim-auto-update.yaml** - Composite resource claim with updation policy implicitly set to automatic
6. **ec2-claim-manual-update.yaml** - Composite resource claim with updation policy explicitly set to manual

<br>

## Composition revision example

In this example we will update the port number for a security group rule in a composition and check how it affects the claims with manual and automatic update policy.

Follow below steps to create and use composition revision.

1. Create composite resource definition.
```
kubectl apply -f ec2-definitions.yaml
```
2. Check your composite resource definition is ready.
```
kubectl get xrd
```
3. Create a composition. We will consider this as version v1 of our composition.
```
kubectl apply -f ec2-compositions-v1.yaml
```
4. Get the actual composition revision name.
```
kubectl get compositionrevision
```
5. Update the **compositionRevisionRef**'s name parameter in the ec2-claim-manual-update.yaml file and save it.
6. Create claims for the composite reource.
```
kubectl apply -f ec2-claim-auto-update.yaml

kubectl apply -f ec2-claim-manual-update.yaml
```
7. Check security groups starting with security group name as crossplane-sample-instance-manual-update and crossplane-sample-instance-auto-update in AWS console in selected region (us-east-2 i.e. Ohio if you don't update it in the claim). The inbound rule's port number for both should be port 80.
8. Update the composition. For purpose of simplicity we have a seperate file with the changes (port number updated to 81) but with same composition name. We will consider this as version v2 of our composition.
```
kubectl apply -f ec2-compositions-v2.yaml
```
9. Check for the new revision created.
```
kubectl get compositionrevision
```
10. Check both security groups again. Now the inbound rule's port number for crossplane-sample-instance-auto-update will be updated to port 81 but for crossplane-sample-instance-manual-update it would still remain the same port 80. This is because we have set the updationPolicy in the claim to manual in the later case and by default it is set to automatic which is the first case.

### Common Troubleshooting tips

1. Resource creation and updation may take some time.
2. Check if you are using the correct provider config in the composition's **providerConfigRef**'s name parameter for all managed resources.
3. Check if you are running the commands at the Composition-Revision folder level.