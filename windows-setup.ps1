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

        Write-Host 
        Write-Host 'You need to restart your shell before you continue, otherwise Chocolatey may not be recognised correctly.'
        Write-Host 'This is Bad™ becuase you wont be able to run the rest of the script!'
        Write-Host
        return 1
    }


    Write-Host 'Pre-requesities installed!'

}

$preReqs = Install-Prerequesities

if ($preReqs -eq 1) {
    Write-Host 'Prerequisites failed to install correctly :('
    Write-Host '--------------------------------'
    return
}

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