function Edit-RAVendor {
    [CmdletBinding(
        DefaultParameterSetName = 'Vendor',
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            ParameterSetName = 'Status',
            HelpMessage = 'The vendors unique Id'
        )]
        [Parameter(
            ParameterSetName = 'Vendor',
            HelpMessage = 'The vendors unique Id'
        )]
        [string]$VendorId,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        $accessStartDate,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        $accessEndDate,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [bool]$canInvite = $false,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [ValidateSet('Activated', 'RequiresAdminConfirmation')]
        $invitedVendorsInitialStatus,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [int]$maxNumInvitedVendors,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [ValidateSet('ProvisionedByAlero', 'ManagedByAdmin', 'None')]
        $provisioningType = 'ProvisionedByAlero',

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'Specify the username.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Specify the username.'
        )]
        $userName,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'Specify the groups the vendor should be a member of.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Specify the groups the vendor should be a member of.'
        )]
        [string[]]$groups,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'Add a comment.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Add a comment.'
        )]
        $comments = "",

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'Specify the applications the vendor should have access to.'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Specify the applications the vendor should have access to.'
        )]
        [hashtable[]]$applications,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Vendor',
            HelpMessage = 'Specify if the vendor should have access to PVWA applications.'
        )]
        [Parameter(
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Specify if the vendor should have access to PVWA applications.'
        )]
        [bool]$pvwaApplications = $true,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Status',
            HelpMessage = 'The updated status of the vendors account.'
        )]
        [ValidateSet('Deactivated', 'Activated')]
        [string]$Status,

        [Parameter(
            Mandatory,
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'Specify the vendors phonenumber.'
        )]
        [string]$phoneNumber
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/vendors"
        if ($phoneNumber) {
            $phoneNumber = $phoneNumber.Replace("+","%2B")
        }
    }

    process {

        $VendorUpdateRequest = [ordered]@{
            "accessStartDate"= ([DateTimeOffset]$accessStartDate).ToUnixTimeMilliseconds()
            "accessEndDate"= ([DateTimeOffset]$accessEndDate).ToUnixTimeMilliseconds()
            "canInvite"= $canInvite
            "invitedVendorsInitialStatus" = $invitedVendorsInitialStatus
            "maxNumInvitedVendors" = $maxNumInvitedVendors
            "provisioningType" = $provisioningType
            "username" = $userName
            "groups" = $groups
            "comments" = $comments
            "applications" = $applications
            "pvwaApplications" = $pvwaApplications
        }

        switch ($PSCmdlet.ParameterSetName) {

            'Status' {
                $url = "$url/$VendorId/status"
                $body = $Status | ConvertTo-Json
            }
            'Vendor' {
                $url = "$url/$VendorId"
                $body = $VendorUpdateRequest | ConvertTo-Json -Depth 3
            }
            'ByPhonenumber' {
                $url = "$url/phone/$phoneNumber"
                $body = $VendorUpdateRequest | ConvertTo-Json -Depth 3
            }
            Default {}
        }
        $restBody = @{
            'Method'         = 'Put'
            'Uri'            = $url
            'ContentType'    = $Script:ContentType
            'WebSession'     = $Script:WebSession
            'Body'           = $body
        }
        if ($PSCmdlet.ShouldProcess("VendorId: $VendorId", 'Updating the vendor')) {
            $result = Invoke-RestMethod @restBody
        }
    }

    end {
        Write-Output -InputObject $result
    }
}