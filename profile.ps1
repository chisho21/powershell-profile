function Update-Powershell {

	iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

}


Write-Host "Loading Pshell Prompt.." -ForegroundColor White -BackgroundColor DarkGreen
function prompt {
# .Description
# This custom version of the PowerShell prompt will present a colorized location value based on the current provider. It will also display the PS prefix in red if the current user is running as administrator.    
# .Link
# https://go.microsoft.com/fwlink/?LinkID=225750
# .ExternalHelp System.Management.Automation.dll-help.xml
$user = [Security.Principal.WindowsIdentity]::GetCurrent()
if ( (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    $adminfg = "Red"
}
else {
    $adminfg = $host.ui.rawui.ForegroundColor
}

Switch ((get-location).provider.name) {
    "FileSystem" { $fg = "green"}
    "Registry" { $fg = "magenta"}
    "wsman" { $fg = "cyan"}
    "Environment" { $fg = "yellow"}
    "Certificate" { $fg = "darkcyan"}
    "Function" { $fg = "gray"}
    "alias" { $fg = "darkgray"}
    "variable" { $fg = "darkgreen"}
    Default { $fg = $host.ui.rawui.ForegroundColor}
} 

##Posh-Git stuff
Import-Module posh-git

## PSReadlinesettings for fsh like prediections
Import-Module psreadline 
Set-PSReadLineOption -PredictionSource History

##Output to host
    Write-Host "[$((Get-Date).timeofday.tostring().substring(0,8))] " -NoNewline
    Write-Host "PS " -nonewline -ForegroundColor $adminfg
    Write-Host "$($executionContext.SessionState.Path.CurrentLocation)" -foregroundcolor $fg -nonewline
Write-VcsStatus
    Write-Output "$('>' * ($nestedPromptLevel + 1)) "

}#end prompt


# Set-Global Output variable

Write-Host 'Setting global catch variable $__' -ForegroundColor White -BackgroundColor DarkGreen
$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'
# Can be retrived by calling $__


#  Set Useful aliases

Write-Host "Setting time saver functions..." -ForegroundColor White -BackgroundColor DarkGreen

# Useful shortcuts for traversing directories
function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n      { notepad $args }
function npp { start-process -filepath 'C:\Program Files (x86)\Notepad++\notepad++.exe' -argumentlist $args }
function vi { start-process -filepath 'C:\Program Files (x86)\Vim\vim82\vim.exe' -argumentlist $args }

# Drive shortcuts
function HKLM:  { Set-Location HKLM: }
function HKCU:  { Set-Location HKCU: }
function Env:   { Set-Location Env: }


# Get-List
function Get-List {

	Write-Host "Paste your list below with each item on it's own line"
        $data = @(While($l=(Read-Host).Trim()){$l}) 
        $global:list = $data -split '\r\n' | % { $_.trim() | Where-object {$_ -ne $null} }
        $count = $global:list.count 
        Write-Host "$count items have been added to variable `$list"
    }

#Get-Table
function Get-Table {
   param (
        $Delimiter = "`t"
   )
       
       Write-Host "Paste your list below with each item on it's own line"
       $data = @(While($l=(Read-Host).Trim()){$l}) 
       $global:table = $data | Convertfrom-CSV -delimiter $Delimiter
       $count = $global:table.count 
       Write-Host "$count items have been added to variable `$table"
   }


  

