function Edit-RAUser {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'The unique ID of the user'
        )]
        [string]$UserId,

        [Parameter(
            Mandatory,
            HelpMessage = 'The updated status of the user account.'
        )]
        [ValidateSet('Deactivated', 'Activated')]
        [string]$Status
    )

    begin {

    }

    process {
        $restCall = @{
            'Method'         = 'Put'
            'ContentType'    = $Script:ContentType
            'Uri'            = "https://$($Script:ApiURL)/v2-edge/users/$UserId/status"
            'Body'           = ( $Status | ConvertTo-Json )
            'Authentication' = $Script:Authentication
            'Token'          = $Script:token
        }
        if ($PSCmdlet.ShouldProcess("UserId: $UserId", "Status change to $Status")) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}