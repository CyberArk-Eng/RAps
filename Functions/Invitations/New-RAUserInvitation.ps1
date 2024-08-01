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
        [HashTable]$InvitationRequest

    )

    begin {

    }

    process {
        
        $url = "https://$($Script:ApiURL)/v2-edge/invitations/user-invitations"
        
        $restCall = @{
            'Method'         = 'Post'
            'Uri'            = $url
            'Body'           = ($InvitationRequest | ConvertTo-Json -Depth 3)
            'WebSession'     = $Script:WebSession
            'ContentType'    = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess('Remote Access User Invitation', 'Creating a new invitation')) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}