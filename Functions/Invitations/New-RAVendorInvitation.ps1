function New-RAVendorInvitation {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors company name'
        )]
        $companyName,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors email address'
        )]
        $emailAddress,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors firstname'
        )]
        $firstName,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors lastname'
        )]
        $lastName,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors phone number'
        )]
        [string]$phoneNumber,

        [Parameter(
            HelpMessage = 'Select if the vendor should be activated automatically or not (default Activated)'
        )]
        [ValidateSet('Activated', 'RequiresAdminConfirmation')]
        $initialStatus = 'Activated',

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors start date'
        )]
        [datetime]$startDate,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors end date'
        )]
        [datetime]$endDate,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the vendors timezone'
        )]
        $timeZone,

        [Parameter(
            HelpMessage = 'Enter the vendors allowed days (default all week)'
        )]
        [Array]$allowedDays = @('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY'),

        [Parameter(
            ParameterSetName = 'allDay',
            Mandatory,
            HelpMessage = 'Enter the vendors allowed timeframe (default all day)'
        )]
        [ValidateSet('True','False')]
        $allDay = $true,

        [Parameter(
            Mandatory,
            HelpMessage = 'Select if the vendor should be able to invite other vendors or not.'
        )]
        [ValidateSet('True','False')]
        $canInvite = $false,

        [Parameter(
            HelpMessage = 'Enter a comment'
        )]
        $comment = $null,

        [Parameter(
            HelpMessage = 'Enter provisioningtype'
        )]
        [ValidateSet('ProvisionedByAlero', 'ManagedByAdmin', 'None')]
        $provisioningType = 'ProvisionedByAlero',

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the group IDs the vendor should be a member of'
        )]
        [string[]]$provisioningGroups,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter the site ID and application ID as a hashtable'
        )]
        [hashtable[]]$applications,

        [Parameter(
            HelpMessage = 'The name of a predefined invitation template added to the vendor invitation'
        )]
        $customText = $null,

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter a number of maximum number of vendors the vendor should be able to invite'
        )]
        [int]$maxNumOfInvitedVendors = 0,

        [Parameter(
            HelpMessage = 'Select whether the vendor should be able to authenticate with email and sms (default false)'
        )]
        [ValidateSet('True','False')]
        $phoneAndEmailAuth = $false,

        [Parameter(
            HelpMessage = 'Select whether the vendor should be allowed access to web apps or not (default false)'
        )]
        [ValidateSet('True','False')]
        $enableWebAppsAccess = $false

    )

    begin {

    }

    process {

        $InvitationBody = [ordered]@{

            'companyName'                 = $companyName
            'emailAddress'                = $emailAddress
            'firstName'                   = $firstName
            'lastName'                    = $lastName
            'phoneNumber'                 = $phoneNumber
            'initialStatus'               = $initialStatus
            'accessStartDate'             = ([DateTimeOffset]$startDate).ToUnixTimeMilliseconds()
            'accessEndDate'               = ([DateTimeOffset]$endDate).ToUnixTimeMilliseconds()
            'accessTimeDetails'           = @{
                'timeZone'                 = $timeZone
                'allowedDays'              = $allowedDays
                'allDay'                   = $allDay
                'workingHoursStartSeconds' = 0
                'workingHoursEndSeconds'   = 0
            }
            'canInvite'                   = $canInvite
            'comments'                    = $comment
            'provisioningType'            = $provisioningType
            'provisioningUsername'        = ("$firstname.$lastname.$($companyName.Replace(' ','-')).alero")
            'provisioningGroups'          = $provisioningGroups
            'applications'                = $applications
            'customText'                  = $customText
            'maxNumOfInvitedVendors'      = $maxNumOfInvitedVendors
            'phoneAndEmailAuth'           = $phoneAndEmailAuth
            'invitedVendorsInitialStatus' = $initialStatus
            'enableWebAppsAccess'         = $enableWebAppsAccess
        }

        $url = "https://$($Script:ApiURL)/v2-edge/invitations/vendor-invitations"

        $restCall = @{
            'Method'      = 'Post'
            'Uri'         = $url
            'Body'        = ($InvitationBody | ConvertTo-Json -Depth 3)
            'WebSession'  = $Script:WebSession
            'ContentType' = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess('Remote Access Vendor Invitation', 'Creating a new invitation')) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}