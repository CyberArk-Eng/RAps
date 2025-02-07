function New-RAGroup {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'The name of the VendorLDAP group that will be added as a member to CyberArk Safes.'
        )]
        [string]$Name,

        [Parameter(
            HelpMessage = 'The description of the VendorLDAP group.'
        )]
        [string]$Description
    )

    begin {
        $result = [System.Collections.ArrayList]@()
    }

    process {
        $restCall = @{
            'Method'         = 'POST'
            'Uri'            = "https://$($Script:ApiURL)/v2-edge/groups"
            'Body'           = ( @{
                    'name'        = $Name
                    'description' = $Description
                } | ConvertTo-Json )
            'WebSession' =  $Script:WebSession
            'ContentType'    = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess($Name, 'Create the Remote Access group.')) {
            [void]$result.Add((Invoke-RestMethod @restCall))
        }
    }

    end {
        Write-Output -InputObject $result
    }
}