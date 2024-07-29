function Get-RAVendor {
    [CmdletBinding(DefaultParameterSetName = 'ByString')]
    param (

        [Parameter(
            ParameterSetName = 'ByString',
            HelpMessage = 'The ID of the Remote Access user who invited this vendor'
        )]
        [string]$InvitedBy,

        [Parameter(
            ParameterSetName = 'ByString',
            HelpMessage = 'The maximum number of entries to return'
        )]
        [int]$Limit = 100,

        [Parameter(
            ParameterSetName = 'ByString',
            HelpMessage = 'The number of entries to skip'
        )]
        [int]$Offset = 0,

        [Parameter(
            ParameterSetName = 'ByString',
            HelpMessage = 'The field in which to perform the search'
        )]
        [ValidateSet('ALL', 'GROUPS', 'COMPANY', 'FULLNAME')]
        [string]$SearchIn = 'FULLNAME',

        [Parameter(
            ParameterSetName = 'ByString',
            HelpMessage = 'The field in which to perform the search'
        )]
        [string]$SearchString,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ByVendorId',
            HelpMessage = 'The unique ID of the vendor'
        )]
        [string]$VendorId,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhoneNumber',
            HelpMessage = 'The phone number that the user set when they registered for Alero, in international format'
        )]
        [string]$PhoneNumber
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/vendors"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ByString' {

                $query = [System.Collections.ArrayList]@()
                $query.Add("limit=$Limit") | Out-Null
                $query.Add("offset=$Offset") | Out-Null
                Switch ($PSBoundParameters.Keys) {
                    'searchIn' { $query.Add("searchIn=$SearchIn") | Out-Null }
                    'invitedBy' { $query.Add("invitedBy=$InvitedBy") | Out-Null }
                    'searchString' { $query.Add("searchString=$SearchString") | Out-Null }
                }

                $querystring = $query -join '&'
                if ($null -ne $querystring) {
                    $url = -join ($url, '?', $querystring)
                }
                Write-Verbose $url
            }
            'ByVendorId' {
                $url = "$url/$VendorId"
            }
            'ByPhoneNumber' {
                $url = "$url/$PhoneNumber"
            }
            Default {}
        }
        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession

    }

    end {
        Write-Output -InputObject $result | Select-Object -ExpandProperty vendors
    }
}