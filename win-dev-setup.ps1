$wsl_url="https://aka.ms/wsl-ubuntu-1804"
$powerline_font_url="https://github.com/powerline/fonts/raw/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.ttf"
$dev_folder="C:/Users/wilmaro/Development"

# Remove all win10 default apps except some usefull ones
Get-AppxPackage -User $env:UserName | Where{ $_.Name -notin ('DellInc.DellUpdate','Microsoft.WindowsCalculator','WavesAudio.WavesMaxxAudioProforDell','Microsoft.SkypeApp','Microsoft.WindowsStore','c5e2524a-ea46-4f67-841f-6a9465d9d515','c5e2524a-ea46-4f67-841f-6a9465d9d515')} | Remove-AppxPackage

# Remove all apps from start menu
(New-Object -Com Shell.Application).
    NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
    Items() |
  %{ $_.Verbs() } |
  ?{$_.Name -match 'Un.*pin from Start'} |
  %{$_.DoIt()}

# Install chocoletey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install WSL
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux

# Install needed packages with choco
choco install -y docker-desktop firefox vscode spotify mattermost-desktop logitech-options git postman winrar microsoft-teams python3

# Install ubuntu WSL
Invoke-WebRequest -Uri $wsl_url -OutFile wsl.appx
Add-AppxPackage -Path wsl.appx
Remove-Item -Path wsl.appx

function ShowFileExtensions()
{
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty . HideFileExt "0"
    Pop-Location
}

# Setup vscode
code --install-extension vscoss.vscode-ansible
code --install-extension ms-azuretools.vscode-docker
code --install-extension k--kato.intellij-idea-keybindings
code --install-extension ms-vscode.powershell
code --install-extension ms-python.python
code --install-extension shardulm94.trailing-spaces
code --install-extension vscode-icons-team.vscode-icons

# Setup powerline fonts for ohmyzsh (needs tuning)
Invoke-WebRequest -Uri $powerline_font_url -OutFile DejaVuSansMono.ttf
$fonts_folder = (New-Object -ComObject Shell.Application).Namespace(0x14)
$fonts_folder.CopyHere((Resolve-Path -Path "DejaVuSansMono.ttf"))
New-ItemProperty -Name $File.fullname -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $File
Remove-Item -Path font.ttf

#TODO: fix this Pin to Quick Access
$o = New-Object -com shell.application
$o.Namespace($dev_folder).Self.InvokeVerb("pintohome")
