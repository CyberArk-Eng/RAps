function Get-RAApplications {
    [CmdletBinding()]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the Site Id'
        )]
        [string]$SiteId,

        [Parameter(
            HelpMessage = 'The maximum number of entries to return'
        )]
        [int]$Limit = 100,


        [Parameter(
            HelpMessage = 'The number of entries to skip'
        )]
        [int]$Offset = 0
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/sites/$SiteId/applications?limit=$Limit&offset=$Offset"
        $result = Invoke-RestMethod -Method Get -Uri $url -Authentication $Script:Authentication -Token $Script:token
    }

    end {
        Write-Output -InputObject $result
    }
}