function New-RAToken {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'CredentialFile',
            HelpMessage = 'Enter the path to your service account JSON file.'
        )]
        [System.IO.FileInfo]$Path,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ClientCredentials',
            HelpMessage = 'Enter the Datacenter URL (alero.io, alero.eu etc)'
        )]
        [string]$Datacenter,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ClientCredentials',
            HelpMessage = 'Enter the ClientID'
        )]
        [string]$ClientID,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ClientCredentials',
            HelpMessage = 'Enter the Client Secret as a secure string'
        )]
        [System.Security.SecureString]$ClientSecret
    )

    begin {
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'ClientCredentials') {
            Write-Verbose -Message 'Creating token using Client Credentials flow.'

            $url = "https://auth.$Datacenter/auth/realms/serviceaccounts/protocol/openid-connect/token"
            $body = @{
                grant_type              = 'client_credentials'
                client_assertion_type   = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_id               = $ClientID
                client_secret           = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ClientSecret))
            }
            $TenantID = $ClientID.Split(".")[0]
        }

        if ($PSCmdlet.ParameterSetName -eq 'CredentialFile') {
            Write-Verbose -Message 'Creating token using Service Account JSON file.'

            $authenticationFile = Get-Content -Path $Path | ConvertFrom-Json
            Write-Verbose -Message 'Extracting datacenter from JSON file'
            $Datacenter = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth.","")

            Write-Verbose -Message 'Sending the API call.'
            $url = "https://auth.$Datacenter/auth/realms/serviceaccounts/protocol/openid-connect/token"

            if ($authenticationFile.TokenEndpoint -in "",$null) {
                
                Write-Warning "The RAps module does no longer support using private keys for JWT signing. Use the Client ID and secret option for the service account instead."
                Write-Verbose "The reason behing ended support is that the JWT signing issues the JWT 2550 years into the future."
                #Write-Verbose -Message 'Extracting datacenter from JSON file'
                #$Datacenter = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth.","")
                #Write-Verbose -Message 'Creating the JWT Header.'
                #$jwtHeader = [JwtHeader]::new().Create()
                #Write-Verbose -Message 'Creating the JWT claim set.'
                #$jwtClaimSet = [JwtClaimSet]::new($authenticationFile.serviceAccountId, $TenantID, $Datacenter).Create()
                #Write-Verbose -Message 'Creating the JWT signature.'
                #$jwtSignature = [JwtSignature]::new($authenticationFile.privateKey, "$jwtHeader.$jwtClaimSet").Create()
                
                #$body = @{
                    #grant_type            = 'client_credentials'
                    #client_assertion_type = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer'
                    #client_assertion      = $jwtSignature
                #}
                #$Script:ApiURL = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth","api") #$response.access_token | Get-ApiUrl
                return
            }

            else {

                $body = @{
                    grant_type            = 'client_credentials'
                    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                    client_id             = $authenticationFile.ClientID
                    client_secret         = $authenticationFile.ClientSecret
                }
                
                #$Script:ApiURL = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth","api") #$response.access_token | Get-ApiUrl
                $TenantID = $authenticationFile.ClientID.Split(".")[0]
            }
        }

        if ($PSCmdlet.ShouldProcess($Datacenter, 'Creating JWT token.')) {

            $response = Invoke-RestMethod -Method Post -Uri $url -Body $body -ContentType 'application/x-www-form-urlencoded' -SessionVariable RAPsSession

            if ($null -ne $response) {
                Write-Verbose -Message 'Returning the access token.'
                $Script:WebSession = $RAPsSession
                $token = $response.access_token
                $Authentication = 'Bearer'
                $Script:ApiURL = "api.$Datacenter"
                $Script:ContentType = 'application/json'
                $Script:WebSession.Headers.Add('Authorization', "$Authentication $token")

                #Write-Output -InputObject $response.access_token
                Write-Host "Authentication Success [Tenant: $TenantID]" -ForegroundColor Green
            }

        }
    }

    end {

    }
}