function Remove-RAVendorInvitation {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'The invitation to be removed'
        )]
        [string]$InvitationId
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/invitations/vendor-invitations/$InvitationId"
        if ($PSCmdlet.ShouldProcess("VendorId: $VendorId", 'Removing vendor')) {
            $result = Invoke-RestMethod -Method Delete -Uri $url -WebSession $Script:WebSession
        }
    }

    end {
        Write-Output -InputObject $result
    }
}