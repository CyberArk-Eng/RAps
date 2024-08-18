function Edit-VendorManagerPermission {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'The users unique Id'
        )]
        [string]$UserId,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the access start date.'
        )]
        [datetime]$accessStartDate,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the access end date.'
        )]
        [datetime]$accessEndDate,

        [Parameter(
            HelpMessage = 'Provide a list of hashtables of application Id and Site Id, defined as id and siteId'
        )]
        [hashtable[]]$allowedApps,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the account activation type'
        )]
        [ValidateSet('AUTOMATIC', 'REQUIRES_ADMIN_CONFIRMATION', 'REQUIRES_INTERNAL_VENDOR_MANAGER_CONFIRMATION')]
        $accountActivation,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the maximum number of vendors to invite.'
        )]
        [int]$maxNumInvitedVendors,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the method of provisioning.'
        )]
        [ValidateSet('ProvisionedByAlero', 'ManagedByAdmin', 'None')]
        $userProvisioning = 'ProvisionedByAlero',

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify if the user should be able to invite vendors to use web apps.'
        )]
        [bool]$canInviteToWebApps = $false,

        [Parameter(
            HelpMessage = 'Specify the group ids the user should be a member of.'
        )]
        [string[]]$userGroups = $null,

        [Parameter(
            HelpMessage = 'Specify the idaptiveroles the user is a member of (only applies for ISPSS linked tenants).'
        )]
        $idaptiveRoles = $null,

        [Parameter(
            HelpMessage = 'Specify the username of the user.'
        )]
        $provisioningUsername = $null,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify the allowed email domains the user can invite vendors from.'
        )]
        [string[]]$allowedEmailDomains,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify if a user can delegate permissions to external managers.'
        )]
        [bool]$canDelegatePermissionsToExternalManagers = $false,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify if the user can create groups.'
        )]
        [bool]$canCreateGroups,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify if the user can invite to all groups.'
        )]
        [bool]$canInviteToAllGroups = $false,

        [Parameter(
            Mandatory,
            HelpMessage = 'Specify if the user can invite to all apps.'
        )]
        [bool]$canInviteToAllApps = $false
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/vendors/$userId/vendor-manager-permission"
    }

    process {

        $VendorPermissionRequest = [ordered]@{
            "accessStartDate"= ([DateTimeOffset]$accessStartDate).ToUnixTimeMilliseconds()
            "accessEndDate"= ([DateTimeOffset]$accessEndDate).ToUnixTimeMilliseconds()
            "allowedApps"= $allowedApps
            "accountActivation" = $accountActivation
            "maxNumInvitedVendors" = $maxNumInvitedVendors
            "userProvisioning" = $userProvisioning
            "canInviteToWebApps" = $canInviteToWebApps
            "idaptiveRoles" = $idaptiveRoles
            "provisioningUsername" = $provisioningUsername
            "allowedEmailDomains" = $allowedEmailDomains
            "canDelegatePermissionsToExternalVendorManagers" = $canDelegatePermissionsToExternalManagers
            "canCreateGroups" = $canCreateGroups
            "canInviteToAllGroups" = $canInviteToAllGroups
            "canInviteToAllApps" = $canInviteToAllApps
        }

        $restBody = @{
            'Method'         = 'Put'
            'Uri'            = $url
            'ContentType'    = $Script:ContentType
            'WebSession'     = $Script:WebSession
            'Body'           = $VendorPermissionRequest
        }
        if ($PSCmdlet.ShouldProcess("VendorId: $VendorId", 'Updating the vendor')) {
            $result = Invoke-RestMethod @restBody
        }
    }

    end {
        Write-Output -InputObject $result
    }
}