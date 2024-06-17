function Get-RAActivities {
    [CmdletBinding()]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'List of Activity Types to retrieve'
        )]
        [string[]]$ActivityType,

        [Parameter(
            HelpMessage = 'Start of the period'
        )]
        [System.DateTimeOffset]$FromTime = (Get-Date).AddDays(-1),

        [Parameter(
            HelpMessage = 'End of the period'
        )]
        [System.DateTimeOffset]$ToTime = (Get-Date),

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
        $activity = $ActivityType | ForEach-Object { "activityTypes=$_" }
        $url = [string]::Concat(
            "https://$($Script:ApiURL)/v2-edge/activities?$($activity -join '&')",
            "&fromTime=$($FromTime.ToUnixTimeMilliseconds())",
            "&limit=$Limit",
            "&offset=$Offset",
            "&toTime=$($ToTime.ToUnixTimeMilliseconds())"
        )
        $result = Invoke-RestMethod -Method Get -Uri $url -Authentication $Script:Authentication -Token $Script:token
    }

    end {
        Write-Output -InputObject $result
    }
}