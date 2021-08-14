Write-Host 
Write-Host '--------------------------------'
Write-Host 'Welcome to the Installerifier!'
Write-Host '--------------------------------'
Write-Host 
Write-Host 'We are going to install a bunch of things.'
Write-Host

function Find-Package {
    param([string] $executable)
    $result = choco list --local-only | Select-String -Pattern $executable

    return ![string]::IsNullOrWhiteSpace($result)
}

function Find-Exe {
    param([string] $executable)

    $result = ($null -eq (Get-Command $executable -ErrorAction SilentlyContinue))

    return $result
}

function Install-Prerequesities {
    Write-Host 'Check we''re running as an Administrator!' # https://superuser.com/questions/749243/detect-if-powershell-is-running-as-administrator
    $isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

    if (!$isAdmin) {
        Write-Host '--------------------------------'
        Write-Host "Please re-launch this script in a terminal with Administrator privileges"
        Write-Host '--------------------------------'
        return 1
    }

    Write-Host 'Installing pre-requesites for this script...'
    Write-Host

    Write-Host 'Installing Nuget Provider...'
    Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force 
    Write-Host 'NuGet package provider install!'

    Write-Host 'Trusting the main PSGallery so we can install things...'
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    if (Find-Exe -executable 'choco.exe') {
        Write-Host 'Chocolatey not found... installing it now!'

        Set-ExecutionPolicy Bypass -Scope Process -Force; 
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        refreshenv
    }


    Write-Host 'Pre-requesities installed!'

}

Install-Prerequesities

# Git

if (!(Find-Package -executable 'git')) {    
    Write-Host 'Installing Git...'
    choco install git -y
    Write-Host 'Done!'
}

# VSCode
if (!(Find-Package -executable 'vscode')) {
    Write-Host 'Installing VSCode...'
    choco install vscode -y
    Write-Host 'Done!'
}

# Android Studio
if (!(Find-Package -executable 'androidstudio')) {
    Write-Host 'Installing Android Studio...'
    choco install androidstudio
    Write-Host 'Done!'
}

# Flutter
if (!(Find-Package -executable 'flutter.bat')) {
    Write-Host 'Installing Flutter...'
    choco install flutter
    Write-Host 'Done!'
}
# Chocolately helper function to renew the terminal session and reload things!
refreshenv 

# Set JAVA_HOME to C:\Program Files\Android\jdk\microsoft_dist_openjdk_1.8.0.25, which is installed with Android Studio
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Android\jdk\microsoft_dist_openjdk_1.8.0.25", "Machine")

# Set Android Studio directory specifically, as sometimes flutter wont pick it up correctly. DO NOT have a trailing slash on the end of the path. Bad things happen :(
flutter config --android-studio-dir "C:\Program Files\Android\Android Studio"

refreshenv