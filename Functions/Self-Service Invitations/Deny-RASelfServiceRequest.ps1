function Deny-RASelfServiceRequest {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            HelpMessage = 'The unique ID of the request.'
        )]
        [string]$RequestId
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/selfServiceRequests/$RequestId"
        if ($PSCmdlet.ShouldProcess("RequestId: $RequestId", 'Reject the pending request')) {
            $result = Invoke-RestMethod -Method Delete -Uri $url -WebSession $Script:WebSession
        }
    }

    end {
        Write-Output -InputObject $result
    }
}