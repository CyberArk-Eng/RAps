function Get-RASelfServiceRequest {
    [CmdletBinding()]
    param (

        [Parameter(
            HelpMessage = 'Period to start including requests in the query'
        )]
        [System.DateTimeOffset]$FromTime,

        [Parameter(
            HelpMessage = 'Period when the query ends.'
        )]
        [System.DateTimeOffset]$ToTime,

        [Parameter(
            HelpMessage = 'The maximum number of entries to return'
        )]
        [int]$Limit = 100,

        [Parameter(
            HelpMessage = 'The number of entries to skip'
        )]
        [int]$Offset = 0,

        [Parameter(
            HelpMessage = 'The field in which to perform the search'
        )]
        [ValidateSet('ALL', 'VENDOR_EMAIL_DOMAIN', 'VENDOR_EMAIL', 'VENDOR_NAME')]
        [string]$SearchIn = 'ALL',

        [Parameter(
            HelpMessage = 'The query string'
        )]
        [string]$SearchString
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/selfServiceRequests"

        $query = [System.Collections.ArrayList]@()
        $query.Add("limit=$Limit") | Out-Null
        $query.Add("offset=$Offset") | Out-Null
        Switch ($PSBoundParameters.Keys) {
            'fromTime' { $query.Add("fromTime=$($FromTime.ToUnixTimeSeconds())") | Out-Null }
            'searchIn' { $query.Add("searchIn=$searchIn") | Out-Null }
            'searchString' { $query.Add("searchString=$SearchString") | Out-Null }
            'toTime' { $query.Add("toTime=$($toTime.ToUnixTimeSeconds())") | Out-Null }
        }

        $querystring = $query -join '&'
        if ($null -ne $querystring) {
            $url = -join ($url, '/?', $querystring)
        }
        Write-Verbose $url

        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        Write-Output -InputObject $result | Select-Object -ExpandProperty requests
    }
}