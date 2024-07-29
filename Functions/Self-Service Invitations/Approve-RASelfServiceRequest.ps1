function Approve-RASelfServiceRequest {
    [CmdletBinding(
        SupportsShouldProcess,
        ConfirmImpact = 'Low'
    )]
    [OutputType([string])]
    param (

        [Parameter(
            Mandatory,
            HelpMessage = 'Unique identifier of the request.'
        )]
        [string]$RequestId,

        [Parameter(
            Mandatory,
            HelpMessage = 'Self Service Invitation body. Fill out all properties'
        )]
        [HashTable]$RequestBody
    )

    begin {

    }

    process {
        $restCall = @{
            'Method'         = 'Post'
            'Uri'            = "https://$($Script:ApiURL)/v2-edge/selfServiceRequests/$RequestId"
            'Body'           = ($RequestBody | ConvertTo-Json -Depth 3)
            'ContentType'    = $Script:ContentType
            'WebSession' =  $Script:WebSession
        }
        if ($PSCmdlet.ShouldProcess("RequestId: $RequestId", 'Approve the pending request')) {
            $result = Invoke-RestMethod @restCall
        }
    }

    end {
        Write-Output -InputObject $result
    }
}