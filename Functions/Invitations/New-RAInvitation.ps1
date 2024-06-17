function New-RAInvitation {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'Enter all properties of the Invitation Request'
        )]
        [HashTable]$InvitationRequest,

        [Parameter(
            HelpMessage = 'Select this flag if you invite an Alero user'
        )]
        [switch]$UserInvitation
    )

    begin {

    }

    process {
        if ($UserInvitation) {
            $url = "https://$($Script:ApiURL)/v2-edge/invitations/user-invitations"
        } else {
            $url = "https://$($Script:ApiURL)/v2-edge/invitations/vendor-invitations"
        }
        $restCall = @{
            'Method'         = 'Post'
            'Uri'            = $url
            'Body'           = ($InvitationRequest | ConvertTo-Json -Depth 3)
            'Authentication' = $Script:Authentication
            'Token'          = $Script:token
            'ContentType'    = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess('Alero Invitation', 'Creating a new invitation')) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}