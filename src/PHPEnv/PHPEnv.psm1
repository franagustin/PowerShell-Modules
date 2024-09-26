$PHPBinFolder = "$HOME\bin\PHP"
$PHPVersionGlobalFile = "$PHPBinFolder\.php-version"
$AVAILABLE_ACTIONS = @(
    "ls",
    "list",
    "invoke",
    "get",
    "set"
)

class Version {
    [int]$Major
    [int]$Minor
    [int]$Patch
    [string]$OriginalVersion

    Version([string]$version) {
        $parts = $version -split "\."
        $this.MAJOR = [int]$parts[0]
        $this.MINOR = [int]$parts[1]
        $this.PATCH = [int]$parts[2]
        $this.OriginalVersion = $version
    }
}


Function Get-PHPVersions {
    $PHPVersions = @()
    foreach ($item in (Get-ChildItem -Path $PHPBinFolder -Directory)) {
        $folderName = Split-Path $item -Leaf
        $PHPVersions += [Version]::new(($folderName -split "-")[-1])
    }
    return $PHPVersions | Sort-Object -Property Major, Minor, Patch
}


Function Get-DefaultPHPVersion {
    return (Get-PHPVersions)[-1]
}


Function Write-PHPVersions {
    foreach ($version in Get-PHPVersions) {
        Write-Output "* $($version.OriginalVersion)"
    }
}


Function Invoke-PHP {
    $version = Get-PHPVersion
    if (-Not $version) {
        Write-Error "PHP Version not set. Available versions are: "
        Write-PHPVersions | Write-Error
        return
    }

    $PHPPath = "$PHPBinFolder\php-$($version.OriginalVersion)\php.exe"
    if (-Not (Test-Path $PHPPath)) {
        Write-Error "PHP executable not found at $PHPPath. Available versions are: "
        Write-PHPVersions | Write-Error
        return
    }

    if ($args.Count -eq 0) {
        Write-Warning "No arguments provided for the PHP executable. Running interactive shell."
        $PHPArgs = @("-a")
    } else {
        $PHPArgs = $args
    }

    & $PHPPath @PHPArgs
}


Function Confirm-PHPVersionGlobalFile {
    if (-Not (Test-Path -Path $PHPVersionGlobalFile)) {
        New-Item -Path $PHPVersionGlobalFile -ItemType File -Force
    }
}


Function Get-PHPVersionFromGlobalFile {
    Confirm-PHPVersionGlobalFile
    $versionString = Get-Content "$PHPBinFolder\.php-version"
    if ($versionString) {
        return [Version]::new($versionString)
    }
    return $null
}


Function Set-PHPVersionInGlobalFile {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$true,
            HelpMessage="The desired version you want to set. Please, specify the number as X.Y.Z (i.e.: 8.3.1)",
            Position=0
        )]
        [string]$version
    )

    PROCESS {
        $version = $version ? $version : (Get-DefaultPHPVersion).OriginalVersion
        Confirm-PHPVersionGlobalFile
        Set-Content -Path $PHPVersionGlobalFile -Value $version
    }
}


Function Get-PHPVersion {
    if ($Env:PHP_VERSION) {
        $version =  [Version]::new($Env:PHP_VERSION)
    } else {
        $version = Get-PHPVersionFromGlobalFile
    }
    return $version
}


Function Write-PHPVersion {
    $version = Get-PHPVersion
    if (-Not $version) {
        Write-Output "PHP Version not set. Available versions are: "
        Write-PHPVersions
        return
    }
    Write-Output "Current PHP version is $($version.OriginalVersion)"
}


Function Set-PHPVersion {
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$true,
            HelpMessage="The desired version you want to set. Please, specify the number as X.Y.Z (i.e.: 8.3.1)",
            Position=0
        )]
        [string]$version
    )

    PROCESS {
        $version = $version ? $version : (Get-DefaultPHPVersion).OriginalVersion
        if (-Not (Test-Path "$PHPBinFolder\php-$version")) {
            Write-Error "$version was not found in your machine."
            Write-Error "Available versions are:"
            Write-PHPVersions | Write-Error
            return
        }

        Set-PHPVersionInGlobalFile $version
        $Env:PHP_VERSION = $version
        Write-Output "Successfully set PHP version to $version"
    }
}


Function Invoke-PHPEnv {
    if ($args[0] -in $AVAILABLE_ACTIONS) {
        $action = $args[0]
        $PHPArgs = $args[1..($args.Length - 1)]
    } else {
        $action = $args.Length -gt 0 ? "invoke" : "list"
        $PHPArgs = $args
    }
    switch ($action.toLower()) {
        {$_ -in @("ls", "list")} {
            Write-PHPVersions @PHPArgs
        }
        "get" {
            Write-PHPVersion @PHPArgs
        }
        "invoke" {
            Invoke-PHP @PHPArgs
        }
        "set" {
            Set-PHPVersion @PHPArgs
        }
    }
}
