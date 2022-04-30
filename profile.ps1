function Update-Powershell {

	iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI"

}


Write-Host "Loading Pshell Prompt.." -ForegroundColor White -BackgroundColor DarkGreen
Set-PoshPrompt -Theme remk

##Posh-Git stuff
Import-Module posh-git
Import-Module PSCredVault
Import-PSCredVault
Import-Module tzwinops

## PSReadlinesettings for fsh like prediections
Import-Module psreadline 
Set-PSReadLineOption -PredictionSource History


# Set-Global Output variable

Write-Host 'Setting global catch variable $__ and other command defaults.' -ForegroundColor White -BackgroundColor DarkGreen

# Default Pwsh Parameters
$PSDefaultParameterValues = @{
	'Export-Csv:NoTypeInformation' = $true
	'ConvertTo-Csv:NoTypeInformation' = $true
	'Out-Default:OutVariable'  = '__'
	'Out-Default:ErrorVariable'  = 'lasterror'
	'Enter-PSSession:Credential' = $admincred
	'Get-ChildItem:Force' = $true
	'Out-File:Encoding' = 'utf8'
	'Receive-Job:Keep' = $true
	'Format-Table:AutoSize' = $true
	'Invoke-Command:Credential' = $admincred
}


#  Set Useful aliases

Write-Host "Setting time saver functions..." -ForegroundColor White -BackgroundColor DarkGreen

# Useful shortcuts for traversing directories
function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }
function hashme ($string , $Algorithm = "md5"){
$mystream = [IO.MemoryStream]::new([byte[]][char[]]$string)
Get-FileHash -InputStream $mystream -Algorithm $Algorithm
}

# Quick shortcut to start notepad
function n      { notepad $args }
function npp { start-process -filepath 'C:\Program Files\Notepad++\notepad++.exe' -argumentlist $args }
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

function Keep-Awake {
$wsh = New-Object -ComObject WScript.Shell
while (1) {
  # Send Shift+F15 - this is the least intrusive key combination I can think of and is also used as default by:
  # http://www.zhornsoftware.co.uk/caffeine/
  # Unfortunately the above triggers a malware alert on Sophos so I needed to find a native solution - hence this script...
  $wsh.SendKeys('+{F15}')
  Start-Sleep -seconds 59
}


}
