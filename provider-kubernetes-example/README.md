# Provider kubernetes example

This provider from crossplane can be used to deploy application on worker cluster. It uses kubernetes-providerconfig 
similar to aws-providerconfig for storing credential reference of worker cluster.

Steps to use provider-kubernetes
1. Install this crossplane provider on the management cluster.
Either using "kubectl apply -f provider-kubernetes.yaml" OR 
using crossplane CLI "kubectl crossplane install provider crossplane/provider-kubernetes:main"

2. Create kubernetes-providerconfig object on management cluster .
"kubectl apply -f kubernetes-providerconfig.yaml"

3. Create kubernetes object XRD from provider-kubernetes by wrapping kubernetes native manifest file inside.
https://doc.crds.dev/github.com/crossplane-contrib/provider-kubernetes/kubernetes.crossplane.io/Object/v1alpha1@v0.3.0 
When we do object deployment in the management cluster a corresponding deployment will be done in worker cluster mentioned in providerConfigRef attribute of 
kubernetes object XRDs.