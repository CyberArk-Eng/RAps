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
            ParameterSetName = 'Status', 
            HelpMessage = 'The updated status of the user account.'
        )]
        [ValidateSet('Deactivated', 'Activated')]
        [string]$Status,
        [Parameter(
            Mandatory,
            ParameterSetName = 'Role', 
            HelpMessage = 'The updated role of the user account.'
        )]
        [ValidateSet('TenantAdmin, User, VendorManager')]
        [string]$Role
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/users/$UserId"
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {

            'Status' {
                $restCall = @{
                    'Method'         = 'Put'
                    'ContentType'    = $Script:ContentType
                    'Uri'            = "$url/status"
                    'Body'           = ( $Status | ConvertTo-Json )
                    'WebSession'     =  $Script:WebSession
                }
                $result = Invoke-RestMethod @restCall
            }

            'Role' {
                $restCall = @{
                    'Method'         = 'Put'
                    'ContentType'    = $Script:ContentType
                    'Uri'            = "$url/role"
                    'Body'           = ( $Role | ConvertTo-Json )
                    'WebSession'     = $Script:WebSession
                }
                $result = Invoke-RestMethod @restCall
            }
        }
    }

    end {
        Write-Output -InputObject $result
    }
}