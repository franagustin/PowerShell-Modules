# PowerShell-Modules
A collection of PowerShell modules developed by me to extend my terminal functionality.

## Installing

### Including the scripts
Just copy-paste any item you'd like from the `src` folder into `~/Documents/WindowsPowerShell/Modules`:

```powershell
# All scripts
Copy-Item .\src\* $HOME\Documents\WindowsPowerShell\Modules

# A specific one
Copy-Item .\src\Base64 $HOME\Documents\WindowsPowerShell\Modules

# Using alias
cp ./src/Base64 $HOME/Documents/WindowsPowerShell/Modules
```

### Changes in profile
You can add aliases by editing your profile file (hint: `code $PROFILE`). For example:

```powershell
Set-Alias base64 Switch-Base64
Set-Alias enbase64 ConvertTo-Base64
Set-Alias debase64 ConvertFrom-Base64

Set-Alias phpenv Invoke-PHPEnv
Set-Alias php Invoke-PHP
```
