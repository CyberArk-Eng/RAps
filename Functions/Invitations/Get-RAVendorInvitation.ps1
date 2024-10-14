function Get-RAVendorInvitation {
    [CmdletBinding(DefaultParameterSetName = 'BySearch')]
    param (

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The ID of the Remote Access user who created the invitation'
        )]
        [string]$CreatedBy,

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
        [ValidateSet('ALL', 'FULLNAME', 'COMPANY', 'PHONE', 'EMAIL', 'GROUPS')]
        [string]$SearchIn = 'FULLNAME',

        [Parameter(
            ParameterSetName = 'BySearch',
            HelpMessage = 'The string to be searched'
        )]
        [string]$SearchString,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ByInvitationId',
            HelpMessage = 'The invitationId'
        )]
        [string]$InvitationId
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/invitations/vendor-invitations/"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ByInvitationId' {
                $url = "$url/$InvitationId"
            }
            'BySearch' {

                $query = [System.Collections.ArrayList]@()
                $query.Add("limit=$Limit") | Out-Null
                $query.Add("offset=$Offset") | Out-Null
                Switch ($PSBoundParameters.Keys) {
                    'searchIn' { $query.Add("searchIn=$SearchIn") | Out-Null }
                    'createdBy' { $query.Add("createdBy=$InvitedBy") | Out-Null }
                    'searchString' { $query.Add("searchString=$SearchString") | Out-Null }
                }

                $querystring = $query -join '&'
                if ($null -ne $querystring) {
                    $url = -join ($url, '?', $querystring)
                }
                Write-Verbose $url
                $returnProperty = 'invitations'

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
        Remove-Variable -Name result
    }
}