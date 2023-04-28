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

$env:SHELL = "pwsh"
