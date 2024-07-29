function Get-RAUser {
    [CmdletBinding(
        DefaultParameterSetName = 'BySearch'
    )]
    param (

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The name of the users to include in the returned list, or part of the name.')]
        [SupportsWildcards()]
        [string]$Name,

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The maximum number of entries to return'
        )]
        [int]$Limit = 100,

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The number of entries to skip'
        )]
        [int]$Offset = 0,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ById',
            HelpMessage = 'The unique ID of the user'
        )]
        [string]$UserId
    )

    begin {

    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'BySearch' {
                $url = "https://$($Script:ApiURL)/v2-edge/users/?limit=$Limit&name=$Name&offset=$Offset"
            }
            'ById' {
                $url = "https://$($Script:ApiURL)/v2-edge/users/$UserId"
            }
            Default {}
        }
        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        Write-Output -InputObject $result
    }
}