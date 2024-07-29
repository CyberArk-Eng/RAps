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
            'Method'     = 'Delete'
            'Uri'        = "https://$($Script:ApiURL)/v2-edge/groups/$GroupId"
            'WebSession' = $Script:WebSession
        }
        if ($PSCmdlet.ShouldProcess("GroupId: $GroupId", 'Remove the Remote Access group')) {
            $result = Invoke-RestMethod @restBody
        }
    }

    end {
        Write-Output -InputObject $result
    }
}