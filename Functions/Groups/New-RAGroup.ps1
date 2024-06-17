function New-RAGroup {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'The name of the AleroLDAP group that will be added as a member to CyberArk Safes.'
        )]
        [string]$Name,

        [Parameter(
            HelpMessage = 'The description of the AleroLDAP group.'
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
            'Authentication' = $Script:Authentication
            'Token'          = $Script:token
            'ContentType'    = $Script:ContentType
        }
        if ($PSCmdlet.ShouldProcess($Name, 'Create the Alero group.')) {
            [void]$result.Add((Invoke-RestMethod @restCall))
        }
    }

    end {
        Write-Output -InputObject $result
    }
}