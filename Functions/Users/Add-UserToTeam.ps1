function Add-UserToTeam {
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
            HelpMessage = 'The unique team ID.'
        )]
        [string]$TeamId
    )

    begin {
        $url = "https://$($Script:ApiURL)/v2-edge/users/$UserId/teams/$TeamId"
    }

    process {
        $restCall = @{
            'Method'         = 'Post'
            'ContentType'    = $Script:ContentType
            'Uri'            = "$url"
            'WebSession'     =  $Script:WebSession
        }

        if ($PSCmdlet.ShouldProcess("UserId: $UserId and TeamId: $TeamId", 'Adding Remote Access user to team')) {
            $result = Invoke-RestMethod @restCall
        }
    }
    
    end {
        Write-Output -InputObject $result
    }
}