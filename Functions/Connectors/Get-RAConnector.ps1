function Get-RAConnector {
    [CmdletBinding()]
    param (

        [Parameter(
            Helpmessage = 'The site ID you want to check the connectors in',
            Mandatory = $true
        )]
        [string]$siteID
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/connectors/$siteID"
        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        Write-Output -InputObject $result
    }
}