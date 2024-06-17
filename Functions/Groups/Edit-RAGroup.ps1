function Edit-RAGroup {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'The unique ID of the AleroLDAP group.'
        )]
        [string]$GroupId,

        [Parameter(
            Mandatory,
            HelpMessage = 'The description of the AleroLDAP group'
        )]
        [string]$Description
    )

    begin {

    }

    process {
        $restBody = @{
            'Uri'            = "https://$($Script:ApiURL)/v2-edge/groups/$GroupId"
            'Body'           = $Description
            'ContentType'    = $Script:ContentType
            'Method'         = 'Put'
            'Authentication' = $Script:Authentication
            'Token'          = $Script:token
        }
        if ($PSCmdlet.ShouldProcess("GroupId: $GroupId", 'Change description')) {
            $result = Invoke-RestMethod @restBody
        }
    }

    end {
        Write-Output -InputObject $result
    }
}