function Remove-RAVendor {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            HelpMessage = 'The unique ID of the vendor'
        )]
        [string]$VendorId
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/vendors/$VendorId"
        if ($PSCmdlet.ShouldProcess("VendorId: $VendorId", 'Delete the Vendor')) {
            $result = Invoke-RestMethod -Method Delete -Uri $url -WebSession $Script:WebSession
        }
    }

    end {
        Write-Output -InputObject $result
    }
}