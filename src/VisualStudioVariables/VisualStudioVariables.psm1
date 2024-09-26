$VisualStudioFolder = 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\'

function Set-Visual-Studio-Variables {
    Push-Location $VisualStudioFolder
    cmd /c "vcvars64.bat & set" |
    ForEach-Object {
        if ($_ -match "=") {
            $key, $value = $_ -split "=", 2
            Set-Item -Force -Path "ENV:\$key" -Value "$value"
        }
    }
    Pop-Location
    Write-Host "Visual Studio 2022 Command Prompt variables set." -ForegroundColor Yellow
}
