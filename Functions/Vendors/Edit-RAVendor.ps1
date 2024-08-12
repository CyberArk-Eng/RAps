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
        [Parameter(
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'All vendor properties must be provided.'
        )]
        [Hashtable]$VendorUpdateRequest,

        [Parameter(
            ParameterSetName = 'Status',
            HelpMessage = 'The updated status of the vendors account.'
        )]
        [ValidateSet('Deactivated', 'Activated')]
        [string]$Status,

        [Parameter(
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'The updated status of the vendors account.'
        )]
        [string]$phoneNumber
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/vendors"
        if ($phoneNumber) {
            $phoneNumber = $phoneNumber.Replace("+","%2B")
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Status' {
                $url = "$url/$VendorId/status"
                $body = $Status | ConvertTo-Json
            }
            'Vendor' {
                $url = "$url/$VendorId"
                $body = $VendorUpdateRequest | ConvertTo-Json -Depth 3
            }
            'ByPhonenumber' {
                $url = "$url/phone/$phoneNumber"
                $body = $VendorUpdateRequest | ConvertTo-Json -Depth 3
            }
            Default {}
        }
        $restBody = @{
            'Method'         = 'Put'
            'Uri'            = $url
            'ContentType'    = $Script:ContentType
            'WebSession'     = $Script:WebSession
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