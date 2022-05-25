# Creating ClusterClaims via curl

**To Create Cluster via API**

Ensure your User/Service Account has the permission to perform the action

1. Get the Service Account token 
export TOKEN=$(kubectl get secret <ServiceAccount-secret> -o jsonpath={.data.token} | base64 -d)
2. Convert the claim.yaml file to .json format
3. Make API calls via curl

```
curl -k -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://<kubernetes-api-server>/apis/<group>/v1alpha1/namespaces/<NamespaceName>/<claimName>
```

Example:

``` 
-- TO LIST CLAIMS----
curl -k -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://34.145.196.74/apis/prodready.cluster/v1alpha1/namespaces/default/clusterclaims
-- TO DELETE CLAIM---- 
curl -k -v -XDELETE -H "Authorization: Bearer $TOKEN" https://34.145.196.74/apis/prodready.cluster/v1alpha1/namespaces/default/clusterclaims/team-c-eks
-- TO CREATE CLAIM----
curl -k -v -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://34.145.196.74/apis/prodready.cluster/v1alpha1/namespaces/default/clusterclaims -d@eks-claim.json
```

**For OIDC user**
1. Use generate-token.ps1 powershell script to generate id_token 
2. Get OIDC requests endpoint.
```
   kubectl get services -n anthos-identity-service gke-oidc-envoy
```
3. Make API calls to the GKE 
```
Example: curl -k -v -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" https://<gke-oidc-envoy-external-IP>:443/apis/prodready.cluster/v1alpha1/namespaces/demo1/clusterclaims -d@eks-claim.json
```
