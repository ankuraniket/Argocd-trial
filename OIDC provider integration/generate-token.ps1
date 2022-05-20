# Script to generate id_token to be used as user/group claims
# Its generate a html file with require id_token


# replace require values from your okta domain
$okta_domain = ""
$client_id = ""
$user = 'test-user@sample.com'
$user_password = '*******'

# Get session token from user credentials
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")
$body = @{
    username = $user;
    password = $user_password
}|convertTo-json
$authNurl = "https://$okta_domain/api/v1/authn"
$response = Invoke-RestMethod $authNurl  -Method 'POST' -Headers $headers -Body $body
$sessionToken = $response.sessionToken

# get Id_token from sessionToken generated from user creds
$guid = (New-Guid).guid
$url = "https://$okta_domain/oauth2/v1/authorize?client_id=$client_id&response_type=id_token&response_mode=form_post&sessionToken=$sessionToken&redirect_uri=http://localhost:8000&scope=openid email groups&state=mystate&nonce=$guid"

Invoke-WebRequest $url -OutFile .\id_token.html

# TODO Add line of codes to copy id_token from generated html to clipboard using |clip operator