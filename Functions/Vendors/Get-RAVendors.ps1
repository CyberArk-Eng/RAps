function Get-RAVendors {
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

    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ByString' {
                $url = "https://$($Script:ApiURL)/v2-edge/vendors?`
                &searchIn=$SearchIn`
                &offset=$Offset`
                &limit=$Limit"
                #&invitedBy=$InvitedBy`
                #&searchString=$SearchString"           
                                
                
            }
            'ByVendorId' {
                $url = "https://$($Script:ApiURL)/v2-edge/vendors/$VendorId"
            }
            'ByPhoneNumber' {
                $url = "https://$($Script:ApiURL)/v2-edge/vendors/phone/$PhoneNumber"
            }
            Default {}
        }
        $result = Invoke-RestMethod -Method Get -Uri $url -Authentication $Script:Authentication -Token $Script:token
        
    }

    end {
        Write-Output -InputObject $result
    }
}