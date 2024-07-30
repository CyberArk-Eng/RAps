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
        $url = "https://$($Script:ApiURL)/v2-edge/users"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'BySearch' {

                $query = [System.Collections.ArrayList]@()
                $query.Add("limit=$Limit") | Out-Null
                $query.Add("offset=$Offset") | Out-Null
                Switch ($PSBoundParameters.Keys) {
                    'Name' { $query.Add("Name=$Name") | Out-Null }
                }

                $querystring = $query -join '&'
                if ($null -ne $querystring) {
                    $url = -join ($url, '/?', $querystring)
                }
                Write-Verbose $url
                $returnProperty = 'users'

            }
            'ById' {
                $url = "$url/$UserId"
            }
            Default {}
        }
        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        if ($null -ne $returnProperty) {
            Write-Output -InputObject $result | Select-Object -ExpandProperty $returnProperty
        } else {
            Write-Output -InputObject $result
        }
    }
}