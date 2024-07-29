function Get-RASites {
    [CmdletBinding()]
    param (

        [Parameter(
            HelpMessage = 'The maximum number of entries to return'
        )]
        [int]$Limit = 100,

        [Parameter(
            HelpMessage = 'The number of entries to skip'
        )]
        [int]$Offset
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/sites?limit=$Limit&offset=$Offset"
        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        Write-Output -InputObject $result
    }
}