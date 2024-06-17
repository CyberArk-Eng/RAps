function Remove-RAGroup {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            ValueFromPipeline,
            HelpMessage = 'The unique ID of the VendorLDAP group.'
        )]
        [string]$GroupId
    )

    begin {

    }

    process {
        $restBody = @{
            'Method'         = 'Delete'
            'Uri'            = "https://$($Script:ApiURL)/v2-edge/groups/$GroupId"
            'Authentication' = $Script:Authentication
            'Token'          = $Script:token
        }
        if ($PSCmdlet.ShouldProcess("GroupId: $GroupId", 'Remove the Remote Access group')) {
            $result = Invoke-RestMethod @restBody
        }
    }

    end {
        Write-Output -InputObject $result
    }
}