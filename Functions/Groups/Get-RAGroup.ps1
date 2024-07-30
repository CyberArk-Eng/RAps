function Get-RAGroup {
    [CmdletBinding(DefaultParameterSetName = 'BySearch')]
    param (
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
            ParameterSetName = 'BySearch',
            HelpMessage = 'The field in which to perform the search'
        )]
        [ValidateSet('ALL', 'NAME', 'DESCRIPTION')]
        [string]$SearchIn = 'ALL',

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The string to use in the search'
        )]
        [SupportsWildcards()]
        [string]$searchString,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ByGroupId',
            HelpMessage = 'The unique ID of the VendorLDAP group'
        )]
        [string]$GroupId
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/groups"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'BySearch' {

                $query = [System.Collections.ArrayList]@()
                $query.Add("limit=$Limit") | Out-Null
                $query.Add("offset=$Offset") | Out-Null
                Switch ($PSBoundParameters.Keys) {
                    'searchIn' { $query.Add("searchIn=$SearchIn") | Out-Null }
                    'searchString' { $query.Add("searchString=$SearchString") | Out-Null }
                }

                $querystring = $query -join '&'
                if ($null -ne $querystring) {
                    $url = -join ($url, '?', $querystring)
                }
                Write-Verbose $url
                $returnProperty = 'groups'
            }
            'ByGroupId' {
                $url = "$url/$GroupId"
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