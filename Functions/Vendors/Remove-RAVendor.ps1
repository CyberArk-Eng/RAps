function Remove-RAVendor {
    [CmdletBinding(
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            ParameterSetName = 'ByVendorId',
            HelpMessage = 'The unique ID of the vendor'
        )]
        [string]$VendorId,

        [Parameter(
            ParameterSetName = 'ByPhonenumber',
            HelpMessage = 'The unique phonenumber of the vendor'
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
            "ByVendorId" {
                $url = "$url/$VendorId"
            }

            'ByPhonenumber' {
                $url = "$url/phones/$phoneNumber"
            }   
        }

    $result = Invoke-RestMethod -Method Delete -Uri $url -WebSession $Script:WebSession

    }

    end {
        Write-Output -InputObject $result
    }
}