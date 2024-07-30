function Get-RAActivity {
    [CmdletBinding()]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'List of Activity Types to retrieve'
        )]
        [ValidateSet('ApplicationCreated', 'ApplicationDeleted', 'ApplicationUpdated', 'ApplicationEnabled', 'ApplicationDisabled',
            'ApplicationUserLogin', 'ConnectorCreated', 'ConnectorDeleted', 'ConnectorInitializationExtended', 'ConnectorInitialized',
            'ConnectorUpdated', 'ConnectorLdapUpdated', 'ConnectorLdapInitialized', 'ConnectorLdapStopped', 'GroupsCreated',
            'GroupsDeleted', 'GroupsUpdated', 'SettingsUpdated', 'SiteCreated', 'SiteDeleted', 'SiteUpdated', 'TenantAliasUpdated',
            'TenantCreated', 'TenantLogin', 'UserActivated', 'UserDeactivated', 'VendorActivated', 'VendorDeactivated', 'VendorUpdated',
            'UserDeleteFromTenant', 'VendorDeleteFromTenant', 'UserJoinTenant', 'VendorJoinTenant', 'UserCreated', 'UserUpdated',
            'UserRoleChanged', 'ApplicationVendorLogin', 'AppCertificateCreated', 'AppCertificateDeleted', 'AppCertificateUpdated',
            'CompanyUserInvitationCreate', 'VendorInvitationCreate', 'ServiceAccountCreated', 'ServiceAccountDeleted',
            'ServiceAccountActivated', 'ServiceAccountDeactivated', 'ApplicationLoginBlocked', 'DirectAccessUserResponse',
            'DirectAccessConnectionDenied', 'OfflineAccessUserViewedPassword', 'IdaptiveVendorSync', 'IdaptiveRoleSync',
            'CompanyInviterUpdated')]
        [string[]]$activityTypes,

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

        $url = "https://$($Script:ApiURL)/v2-edge/activities"

        $query = [System.Collections.ArrayList]@()
        $query.Add("limit=$Limit") | Out-Null
        $query.Add("offset=$Offset") | Out-Null
        Switch ($PSBoundParameters.Keys) {
            'activityTypes' { $query.Add("activityTypes=$($activityTypes -join ',')") | Out-Null }
            'fromTime' { $query.Add("fromTime=$($FromTime.ToUnixTimeSeconds())") | Out-Null }
            'toTime' { $query.Add("toTime=$($toTime.ToUnixTimeSeconds())") | Out-Null }
        }

        $querystring = $query -join '&'
        if ($null -ne $querystring) {
            $url = -join ($url, '?', $querystring)
        }
        Write-Verbose $url

        $result = Invoke-RestMethod -Method Get -Uri $url -WebSession $Script:WebSession
    }

    end {
        Write-Output -InputObject $result | Select-Object -ExpandProperty activities
    }
}