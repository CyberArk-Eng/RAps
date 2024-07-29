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
            ParameterSetName = 'Vendor',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Hashtable]$VendorUpdateRequest,

        [Parameter(
            ParameterSetName = 'Status',
            HelpMessage = 'The updated status of the vendors account.'
        )]
        [ValidateSet('Deactivated', 'Activated')]
        [string]$Status
    )

    begin {

    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Status' {
                $url = "https://$($Script:ApiURL)/v2-edge/vendors/$VendorId/status"
                $body = $Status | ConvertTo-Json
            }
            'Vendor' {
                $url = "https://$($Script:ApiURL)/v2-edge/vendors/$VendorId"
                $body = $VendorUpdateRequest | ConvertTo-Json -Depth 3
            }
            Default {}
        }
        $restBody = @{
            'Method'         = 'Put'
            'Uri'            = $url
            'ContentType'    = $Script:ContentType
            'WebSession' =  $Script:WebSession
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