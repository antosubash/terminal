# Set error action preference and create log file
$ErrorActionPreference = "Stop"
$logFile = "$(Get-Date -Format 'yyyy-MM-dd')-installation-log.txt"
Start-Transcript -Path $logFile -Append

if (-not ([bool](New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "This script must be run as an administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define installation groups
$browserApps = @(
    "Google.Chrome",
    "Mozilla.Firefox",
    "Mozilla.Firefox.DeveloperEdition"
)

$developmentApps = @(
    "Microsoft.DotNet.SDK.9",
    "Microsoft.DotNet.SDK.8",
    "Microsoft.DotNet.SDK.7",
    "Microsoft.DotNet.SDK.6",
    "Microsoft.DotNet.SDK.5",
    "Microsoft.DotNet.SDK.3_1",
    "Microsoft.VisualStudio.2022.Community",
    "Microsoft.VisualStudioCode",
    "Microsoft.VisualStudioCode.Insiders",
    "Microsoft.VisualStudio.2022.BuildTools",
    "Microsoft.SQLServer.2022.Developer",
    "Microsoft.SQLServerManagementStudio",
    "Microsoft.AzureDataStudio"
)

$jetbrainsApps = @(
    "JetBrains.ReSharper",
    "JetBrains.Rider",
    "JetBrains.WebStorm",
    "JetBrains.DataGrip"
)

$nodeTools = @(
    "OpenJS.NodeJS",
    "Yarn.Yarn",
    "Schniz.fnm",
    "pnpm.pnpm"
)

$gitTools = @(
    "Git.Git",
    "GitHub.cli",
    "GitHub.GitHubDesktop"
)

$windowsTools = @(
    "Microsoft.PowerToys",
    "Microsoft.WindowsTerminal",
    "Microsoft.PowerShell",
    "JanDeDobbeleer.OhMyPosh",
    "7zip.7zip",
    "Microsoft.Office"
)

$communicationApps = @(
    "Microsoft.Teams",
    "Discord.Discord",
    "Zoom.Zoom",
    "WhatsApp.WhatsApp",
    "SlackTechnologies.Slack"
)

# Installation function
function Install-Apps {
    param (
        [string[]]$apps,
        [string]$category,
        [int]$ThrottleLimit = 3
    )
    
    Write-Host "`nInstalling $category..." -ForegroundColor Cyan
    $apps | ForEach-Object {
        $app = $_
        Write-Host "Installing $app..." -ForegroundColor Cyan
        try {
            winget install -e --id $app --accept-source-agreements --accept-package-agreements
        }
        catch {
            Write-Error "Error installing $app"
        }
    }
    Write-Host "Finished installing $category." -ForegroundColor Green
}

# Install all application groups
$installGroups = @{
    "Browsers"           = $browserApps
    "Development Tools"  = $developmentApps
    "JetBrains Tools"    = $jetbrainsApps
    "Node.js Tools"      = $nodeTools
    "Git Tools"          = $gitTools
    "Windows Tools"      = $windowsTools
    "Communication Apps" = $communicationApps
}

foreach ($group in $installGroups.GetEnumerator()) {
    Install-Apps -apps $group.Value -category $group.Name
}

# Ask for WSL installation permission
$wslConfirm = Read-Host "Do you want to enable WSL? (y/n)"
if ($wslConfirm.ToLower() -eq "y") {
    Write-Host "`nEnabling WSL..." -ForegroundColor Cyan
    try {
        dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
        dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
        Write-Host "WSL features enabled successfully. Please restart your computer to complete the installation." -ForegroundColor Green
    }
    catch {
        Write-Error "Error enabling WSL: $_"
    }
}
else {
    Write-Host "Skipping WSL installation." -ForegroundColor Yellow
}

Stop-Transcript