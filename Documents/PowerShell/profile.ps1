$poshTheme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\zash.omp.json"
oh-my-posh init pwsh --config $poshTheme | Invoke-Expression

# PSFzf has undocumented option to use fd executable for
# file and directory searching. This enables that option.
Set-PsFzfOption -EnableFd:$true -EnableAliasFuzzyEdit `
  -EnableAliasFuzzyZLocation `
  -EnableAliasFuzzyGitStatus `
  -EnableAliasFuzzyKillProcess `
  -PSReadlineChordProvider 'Ctrl+t' `
  -PSReadlineChordReverseHistory 'Ctrl+r'

set-PSReadLineOption -PredictionViewStyle ListView
   
# Override default tab completion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert('lfcd.ps1')
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Chord Ctrl+i -ScriptBlock {
  Import-Module Terminal-Icons
  Import-Module posh-git
}

function Get-ChildItem-Hidden
{
  Get-ChildItem -Force | Sort-Object -Property LastWriteTime
}
# Alias
Set-Alias -Name fcd -Value Invoke-FuzzySetLocation
Set-Alias -Name rg -Value Invoke-PsFzfRipgrep
Set-Alias -Name v -Value nvim
Set-Alias -Name la -Value Get-ChildItem-Hidden

$env:PATH += ";C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client;C:\Program Files\AutoHotkey\v2"
$env:SHELL = "pwsh"

function keypress_wait
{
  param (
    [int]$seconds = 10
  )
  $loops = $seconds*10
  Write-Host "Connect to VPN? (y/n). After $seconds seconds vpn connection starts automatically.." -ForegroundColor Green
  for ($i = 0; $i -le $loops; $i++)
  {
    if ([Console]::KeyAvailable)
    { break; 
    }
    Start-Sleep -Milliseconds 100
  }
  if ([Console]::KeyAvailable)
  { return [Console]::ReadKey($true); 
  } else
  { return $null ;
  }
}

function get-cred
{
  $PathToCredential = "$env:USERPROFILE\vpn-automation\encrypted-cred.txt"
  if(!(Test-Path $PathToCredential))
  {
    Write-Host "Enter username: " 
    read-host | Add-Content $env:USERPROFILE\vpn-automation\encrypted-cred.txt
    Write-Host "Enter password: "
    read-host -assecurestring | convertfrom-securestring | Add-Content $env:USERPROFILE\vpn-automation\encrypted-cred.txt
  }
  $username = Get-Content $PathToCredential | Select-Object -First 1 
  $pwdTxt = Get-Content $PathToCredential | Select-Object -Last 1 | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText
  return $username, $pwdTxt
}

function connect-vpn
{
  $username, $password = get-cred
  autohotkey /script "$env:USERPROFILE\vpn-automation\lenovo-otp-automation.ahk"
  Write-Host "copying"
  Start-Sleep -seconds 2
  autohotkey /script "$env:USERPROFILE\vpn-automation\copy-otp.ahk"
  Start-Sleep -Milliseconds 3000
  Write-Host "getting it from clipboard"
  $otp = Get-Clipboard
  Write-Output $username`n$password`n$otp | vpncli -s connect webvpnauto.lenovo.com
  Start-Sleep -Seconds 3
  vpnui
}

if( vpncli state | Select-string "Disconnected" )
{
  Get-Process LenovoOTP64 -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
  Get-Process vpnui -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
  $result = keypress_wait
  if($null -eq $result -or $result.keychar.ToString().ToLower() -eq 'y' )
  {
    connect-vpn
  }
  Get-Process LenovoOTP64 -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
} 

