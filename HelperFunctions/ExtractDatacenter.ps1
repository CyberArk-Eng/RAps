Function Get-ApiUrl {
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$access_token
    )

    Begin {
        function Parse-JWTtoken {

            # Gotten from function here: https://www.michev.info/blog/post/2140/decode-jwt-access-and-id-tokens-via-powershell

            [cmdletbinding()]
            param([Parameter(Mandatory = $true)][string]$token)

            #Validate as per https://tools.ietf.org/html/rfc7519
            #Access and ID tokens are fine, Refresh tokens will not work
            if (!$token.Contains('.') -or !$token.StartsWith('eyJ')) { Write-Error 'Invalid token' -ErrorAction Stop }

            #Header
            $tokenheader = $token.Split('.')[0].Replace('-', '+').Replace('_', '/')
            #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
            while ($tokenheader.Length % 4) { Write-Verbose 'Invalid length for a Base-64 char array or string, adding ='; $tokenheader += '=' }
            Write-Verbose 'Base64 encoded (padded) header:'
            Write-Verbose $tokenheader
            #Convert from Base64 encoded string to PSObject all at once
            Write-Verbose 'Decoded header:'
            #[System.Text.Encoding]::ASCII.GetString([system.convert]::FromBase64String($tokenheader)) | ConvertFrom-Json | Format-List | Out-Default

            #Payload
            $tokenPayload = $token.Split('.')[1].Replace('-', '+').Replace('_', '/')
            #Fix padding as needed, keep adding "=" until string length modulus 4 reaches 0
            while ($tokenPayload.Length % 4) { Write-Verbose 'Invalid length for a Base-64 char array or string, adding ='; $tokenPayload += '=' }
            Write-Verbose 'Base64 encoded (padded) payload:'
            Write-Verbose $tokenPayload
            #Convert to Byte array
            $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
            #Convert to string array
            $tokenArray = [System.Text.Encoding]::ASCII.GetString($tokenByteArray)
            Write-Verbose 'Decoded array in JSON format:'
            Write-Verbose $tokenArray
            #Convert from JSON to PSObject
            $tokobj = $tokenArray | ConvertFrom-Json
            Write-Verbose 'Decoded Payload:'

            return $tokobj
        }
        function Extract-DomainFromToken {

            [cmdletbinding()]
            param([Parameter(Mandatory = $true)][string]$decodedDomain)

            $domain = $decodedDomain.split('/')[2]

            $apiURL = $domain.replace("auth","api")
            
            return $apiURL

        }
    }

    Process {
        $decodedDomain = Parse-JWTtoken -token $access_token | Select-Object -ExpandProperty iss

        $apiURL = Extract-DomainFromToken -decodedDomain $decodedDomain
    }

    End {
        return $apiURL
    }
}