Clear-Host

# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

$Env:LF_ICONS = ((Get-Content -Path ($Env:USERPROFILE + '\AppData\Local\lf\icons') -Encoding utf8) -replace '\s*#.*', '' -replace '(?<File_Regex>[\S]+)\s+(?<Icon_String>\S)', '${File_Regex}=${Icon_String}') | ? { $_ -ne "" } | Join-string -Separator ':'
# esta en la carpeta powershell
#notepad.exe $Profile.CurrentUserCurrentHost

Import-Module posh-git
$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

Import-Module -Name Terminal-Icons

# # PSReadLine
# Set-PSReadLineOption -EditMode Emacs
# Set-PSReadLineOption -BellStyle None
# Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
# Set-PSReadLineOption -PredictionSource History

# PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

# Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

Import-Module z

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name ci -Value code-insiders.cmd
Set-Alias -Name chezmoi -Value ~/bin/chezmoi.exe
Set-Alias -Name cm -Value ~/bin/chezmoi.exe
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'

function gcl { git clone --depth 1 }
function gi { git init }
function glog { git log --oneline --decorate --all --graph }
function glf { git log --pretty=fuller }
# @args you can pass multi arguments for example
# ga fileName1 fileName2
function ga { git add @args }
function gc { git commit -m @args }
function gp { git push origin main }
function gs { git status -s -b }
function gd { git diff }
function gb { git branch @args }
function gch { git checkout @args }
function pull { git pull origin main }

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

nvs auto on | Out-Null

# script for lf
Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
  [Microsoft.PowerShell.PSConsoleReadLine]::Insert('lfcd.ps1')
  [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Invoke-Expression (&starship init powershell)
