Function Switch-Base64 {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="String you want to encode in base64"
        )]
        [Alias("string")]
        [string]$StringToHandle,
        [Parameter(
            Mandatory=$false,
            HelpMessage="Do you want to decode?"
        )]
        [Alias("decode")]
        [switch]$d
    )

    PROCESS {
        if ($d) { ConvertFrom-Base64($StringToHandle) }
        else { ConvertTo-Base64($StringToHandle) }
    }
}


Function ConvertTo-Base64 {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="String you want to encode in base64"
        )]
        [Alias("string")]
        [string]$StringToEncode
    )

    PROCESS {
        Write-Output $([System.Convert]::ToBase64String(
            [System.Text.Encoding]::UTF8.GetBytes($StringToEncode)
        ))
    }
}


Function ConvertFrom-Base64 {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="Base64-encoded string that you want to decode."
        )]
        [Alias("string")]
        [string]$StringToDecode
    )

    PROCESS {
        Write-Output $([System.Text.Encoding]::UTF8.GetString(
            [System.Convert]::FromBase64String($StringToDecode)
        ))
    }
}
