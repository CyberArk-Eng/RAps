function New-RAToken {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    param (
        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the path to your service account JSON file.'
        )]
        [System.IO.FileInfo]$Path,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the ID your company in Alero.'
        )]
        [string]$TenantID
    )

    begin {
    }

    process {
        Write-Verbose -Message 'Retrieving content from the Remote Access JSON file.'
        $authenticationFile = Get-Content -Path $Path | ConvertFrom-Json
        Write-Verbose -Message 'Extracting datacenter from JSON file'
        #$Datacenter = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth.","")
        $Datacenter = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth.","")
        Write-Verbose -Message 'Creating the JWT Header.'
        $jwtHeader = [JwtHeader]::new().Create()
        Write-Verbose -Message 'Creating the JWT claim set.'
        $jwtClaimSet = [JwtClaimSet]::new($authenticationFile.serviceAccountId, $TenantID, $Datacenter).Create()
        Write-Verbose -Message 'Creating the JWT signature.'
        $jwtSignature = [JwtSignature]::new($authenticationFile.privateKey, "$jwtHeader.$jwtClaimSet").Create()

        Write-Verbose -Message 'Sending the API call.'
        $url = "https://auth.$Datacenter/auth/realms/serviceaccounts/protocol/openid-connect/token"
        $body = @{
            grant_type            = 'client_credentials'
            client_assertion_type = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer'
            client_assertion      = $jwtSignature
        }
        if ($PSCmdlet.ShouldProcess($Datacenter, 'Creating JWT token.')) {

            $response = Invoke-RestMethod -Method Post -Uri $url -Body $body -ContentType 'application/x-www-form-urlencoded' -SessionVariable RAPsSession

            if ($null -ne $response) {
                Write-Verbose -Message 'Returning the access token.'
                $Script:WebSession = $RAPsSession
                $Script:ApiURL = (($authenticationFile.discoveryURI.Split("/"))[2]).replace("auth","api") #$response.access_token | Get-ApiUrl
                $token = $response.access_token
                $Authentication = 'Bearer'
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