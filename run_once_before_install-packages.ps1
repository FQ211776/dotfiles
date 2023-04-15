# install scoop
#Set-ExecutionPolicy RemoteSigned -scope CurrentUser
#iwr -useb get.scoop.sh | iex
# scoop install git

# optional buckets
scoop bucket add extras
scoop bucket add java
scoop bucket add nerd-fonts

# install sudo to elevate privileges when needed
scoop install sudo

# install starship as a default prompt
scoop install starship

# Install Fzf - Fuzzy finder
scoop install fzf

# install VIFM
scoop install vifm

# install neovim and tools needed
scoop install neovim
scoop install gcc
scoop install mingw
scoop install extras/vcredist2022
scoop install winget

# Neovim GUI <optional>
scoop install goneovim
scoop install neovim-qt
scoop install fvim
scoop install neovide

# install VIFM
scoop install vifm

# Install gpg4win
sudo scoop install gpg4win

#
scoop install hub

# install diff-so-fancy
scoop install diff-so-fancy
scoop install peco


# install chezmoi
scoop install chezmoi

git clone https://github.com/wbthomason/packer.nvim $env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim
git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
git clone https://github.com/NvChad/NvChad $HOME\AppData\Local\nvim --depth 1

# to launch nvim the first time
#nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Install winget Packages
winget import --accept-source-agreements --accept-package-agreements $home\.local\share\chezmoi\winget.json

# Refresh Path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Install PowerShell Modules
pwsh -NoLogo -NoProfile -Command {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    install-Module posh-git  -Scope CurrentUser -Force
    Install-Module -Name PSFzf -Scope CurrentUser -Force
    Install-Module -Name PSReadLine -Scope CurrentUser -Force
#    Set-PSReadLineOption -PredictionSource History
#    Set-PSReadLineOption -PredictionViewStyle listView
}
sudo Install-Module -Name PowerShellGet -Force
sudo Install-Module -Name z -AllowClobber
sudo Install-Module -Name Terminal-Icons
sudo Install-Module -Name Terminal-Icons -Repository PSGallery -Force

# Setup Node/Yarn
nvs add lts
nvs use lts
nvs link lts
npm install --location=global yarn

# Install Font
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip" -OutFile ~/Downloads/CascadiaCode.zip
Expand-Archive -Path ~/Downloads/CascadiaCode.zip -DestinationPath ~/Downloads/CascadiaCode
& "~\Downloads\CascadiaCode\Caskaydia Cove Nerd Font Complete Mono Windows Compatible Regular.otf"
