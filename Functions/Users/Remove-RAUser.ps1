function Remove-RAUser {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Medium'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'The unique ID of the user'
        )]
        [string]$UserId
    )

    begin {

    }

    process {
        $url = "https://$($Script:ApiURL)/v2-edge/users/$UserId"
        if ($PSCmdlet.ShouldProcess("UserId: $UserId", 'Remove Remote Access user')) {
            $result = Invoke-RestMethod -Method Delete -Uri $url -Authentication $Script:Authentication -Token $Script:token
        }
    }

    end {
        Write-Output -InputObject $result
    }
}