function New-RAUserInvitation {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter a hashtable of users to invite. Name and emailaddress are required fields'
        )]
        [HashTable[]]$usersToInvite,

        [Parameter(
            HelpMessage = 'Set an initial status for the users'
        )]
        [ValidateSet("Deactivated")]
        $initialStatus = "Deactivated",

        [Parameter(
            HelpMessage = 'Set an expirationtime for the invitation'
        )]
        $invitationExpirationTime = 0


    )

    begin {

    }

    process {

        $InvitationBody = @{
            "usersToInvite" = $usersToInvite
            "initialStatus" = $initialStatus
            "invitationExpirationTime" = $invitationExpirationTime
          }

        $url = "https://$($Script:ApiURL)/v2-edge/invitations/user-invitations"

        $restCall = @{
            'Method'      = 'Post'
            'Uri'         = $url
            'Body'        = ($InvitationBody | ConvertTo-Json -Depth 3)
            'WebSession'  = $Script:WebSession
            'ContentType' = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess('Remote Access User Invitation', 'Creating a new invitation')) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}