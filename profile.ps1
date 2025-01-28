# Module imports
Import-Module -Name Terminal-Icons
Import-Module z

# Oh-my-posh configuration
$configFile = "$env:USERPROFILE\antosubash.omp.json"
$url = "https://raw.githubusercontent.com/antosubash/terminal/main/antosubash.omp.json"

try {
    if (-not (Test-Path $configFile)) {
        Invoke-WebRequest -Uri $url -OutFile $configFile
    }
    oh-my-posh init pwsh --config $configFile | Invoke-Expression
} catch {
    Write-Warning "Failed to configure oh-my-posh: $_"
}

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionViewStyle InlineView

# Directory Navigation Functions
# Move up one directory
function .. { Set-Location .. }
# Move up two directories
function .... { Set-Location ../.. }
# Move up three directories
function ...... { Set-Location ../../.. }
# Navigate to user's home directory
function home { Set-Location $HOME }
# Navigate to my development directory
function repos { Set-Location "D:\" }
# Navigate to my ssh directory
function ssh_home { Set-Location "$HOME\.ssh" }
# Open my ssh config file
function ssh_config { code "$HOME\.ssh\config" }

function profile { code $PROFILE }

# Docker Command Shortcuts
# List running containers
function dps { docker ps }
# Start docker-compose services
function dcu { docker-compose up }
# Stop and remove docker-compose services
function dcd { docker-compose down }
# Build docker-compose services
function dcb { docker-compose build }
# Execute interactive bash shell in a container
function dex { docker exec -it $args[0] bash }
# Clean up unused containers, images, and volumes
function dprune { 
    docker container prune -f
    docker image prune -f
    docker volume prune -f
}
# Docker stack deploy
function dsd { docker stack deploy -c $args[0] $args[1] }
# Docker stack remove
function dsr { docker stack rm $args[0] }
# Docker service logs
function dsl { docker service logs $args[0] }
# Docker stack services
function dss { docker stack services $args[0] }

# Git Command Shortcuts
# Create and checkout new branch
function gb {
    git checkout -b $args
}
 
# Create and checkout new task branch with prefix
function gbt ([string] $taskid) {
    git checkout -b "task/$taskid"
}
 
# Switch to branch and pull latest changes
function gs {
    git checkout $args
    git pull
}
 
# Switch to master branch and pull
function gmaster {
    gs 'master'
}
 
# Switch to main branch and pull
function gmain {
    gs 'main'
}
 
# Switch to develop branch and pull
function gdev {
    gs 'develop'
}
 
# Fetch and rebase on specified branch
function grb {
    git fetch
    git rebase origin/$args
}
 
# Stage all changes and commit with message
function gco {
    git add .
    git commit -m $args
}
 
# Conventional commits - feature
function gfeat {
    if($null -eq $args[1]) {
        gco "feat: $($args[0])"
    }else {
        gco "feat($($args[0])): $($args[1])"
    }
}
 
# Conventional commits - fix
function gfix {
    if($null -eq $args[1]) {
        gco "fix: $($args[0])"
    }else {
        gco "fix($($args[0])): $($args[1])"
    }
}
 
function gtest {
    if($null -eq $args[1]) {
        gco "test: $($args[0])"
    }else {
        gco "test($($args[0])): $($args[1])"
    }
}
 
function gdocs {
    if($null -eq $args[1]) {
        gco "docs: $($args[0])"
    }else {
        gco "docs($($args[0])): $($args[1])"
    }
}
 
function gstyle {
    if($null -eq $args[1]) {
        gco "style: $($args[0])"
    }else {
        gco "style($($args[0])): $($args[1])"
    }
}
 
function grefactor {
    if($null -eq $args[1]) {
        gco "refactor: $($args[0])"
    }else {
        gco "refactor($($args[0])): $($args[1])"
    }
}
 
function gperf {
    if($null -eq $args[1]) {
        gco "perf: $($args[0])"
    }else {
        gco "perf($($args[0])): $($args[1])"
    }
}
 
function gchore {
    if($null -eq $args[1]) {
        gco "chore: $($args[0])"
    }else {
        gco "chore($($args[0])): $($args[1])"
    }
}
 
# Pull latest changes
function gpu {
    git pull
}
 
# Amend last commit without changing message
function goops {
    git add .
    git commit --amend --no-edit
}
 
# Force push with lease (safer than force push)
function gfp {
    git push --force-with-lease
}
 
# Hard reset and clean working directory
function gr {
    git reset --hard
    git clean -f -d
}

# Checkout current branch (useful for scripts)
function gcb { git checkout $(git rev-parse --abbrev-ref HEAD) }
# Pull current branch from origin
function gpl { git pull origin $(git rev-parse --abbrev-ref HEAD) }
# Push current branch to origin
function gph { git push origin $(git rev-parse --abbrev-ref HEAD) }
# Sync current branch with main
function gsync {
    $branch = git rev-parse --abbrev-ref HEAD
    git checkout main
    git pull
    git checkout $branch
    git rebase main
}

# GitHub Command Shortcuts
# Open current repo in browser
function ghb {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo"
    }
}

# Open current repo's pull requests
function ghpr {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo/pulls"
    }
}

# Create new pull request for current branch
function ghnpr {
    $remoteUrl = git config --get remote.origin.url
    $branch = git rev-parse --abbrev-ref HEAD
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo/compare/$branch`?expand=1"
    }
}

# Open current repo's issues
function ghi {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo/issues"
    }
}

# Create new issue
function ghni {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo/issues/new"
    }
}

# Open current repo's actions
function gha {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        Start-Process "https://github.com/$owner/$repo/actions"
    }
}

# Clone repository using HTTPS
function ghc([string]$repo) {
    if ($repo -match "^([^/]+)/([^/]+)$") {
        $owner = $matches[1]
        $repoName = $matches[2]
        git clone "https://github.com/$owner/$repoName.git"
    }
}

# Open current file on GitHub
function ghf {
    $remoteUrl = git config --get remote.origin.url
    if ($remoteUrl -match "github\.com[:/]([^/]+)/([^/]+)\.git$") {
        $owner = $matches[1]
        $repo = $matches[2]
        $branch = git rev-parse --abbrev-ref HEAD
        $relativePath = git ls-files --full-name (Get-Location)
        Start-Process "https://github.com/$owner/$repo/blob/$branch/$relativePath"
    }
}

# GitHub CLI Shortcuts
# List pull requests
function ghpl { gh pr list }
# Create pull request
function ghnp { gh pr create --web }
# View pull request in browser
function ghpv([string]$number) { gh pr view $number --web }
# Checkout pull request
function ghpc([string]$number) { gh pr checkout $number }
# Merge pull request
function ghpm([string]$number) { gh pr merge $number }
# Review pull request
function ghpr([string]$number) { gh pr review $number }

# Issue management
function ghil { gh issue list }
# Create issue
function ghin { gh issue create --web }
# View issue
function ghiv([string]$number) { gh issue view $number --web }
# Close issue
function ghic([string]$number) { gh issue close $number }
# Reopen issue
function ghir([string]$number) { gh issue reopen $number }

# Repository management
function ghrl { gh repo list }
# Clone repository
function ghrc([string]$repo) { gh repo clone $repo }
# Create repository
function ghrn { gh repo create --public --source=. }
# Fork repository
function ghrf { gh repo fork --remote }

# Gist management
function ghgl { gh gist list }
# Create gist
function ghgc([string]$file) { gh gist create $file }
# View gist
function ghgv([string]$id) { gh gist view $id --web }

# GitHub Actions
function ghal { gh run list }
# View workflow
function ghav([string]$id) { gh run view $id }
# Watch workflow
function ghaw([string]$id) { gh run watch $id }

# VS Code Shortcuts
# Open current directory in VS Code
function c { code . }
# Open current directory in new VS Code window
function cr { code -r . }

# Development Shortcuts
# Smart restore for .NET or Node.js projects
function restore {
    if (Test-Path "*.sln") {
        dotnet restore
    } elseif (Test-Path "*.csproj") {
        dotnet restore
    } elseif (Test-Path "package.json") {
        pnpm i
    } else {
        Write-Warning "No recognized project files found (*.sln, *.csproj, package.json)"
    }
}

# Macros
Set-PSReadLineKeyHandler -Key Ctrl+Shift+b `
    -BriefDescription BuildCurrentDirectory `
    -LongDescription "Build the current directory" `
    -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        
        $command = if (Test-Path ".\package.json") {
            $packageJson = Get-Content ".\package.json" -Raw | ConvertFrom-Json
            if ($packageJson.scripts.build) {
                "pnpm run build"
            } else {
                Write-Warning "No build script found in package.json"
                return
            }
        } elseif (Test-Path "*.sln") {
            "dotnet build"
        } elseif (Test-Path "*.csproj") {
            "dotnet build"
        } else {
            Write-Warning "No recognized build files found"
            return
        }

        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
Set-PSReadLineKeyHandler -Key Ctrl+Shift+t `
    -BriefDescription TestCurrentDirectory `
    -LongDescription "Run tests in current directory" `
    -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        
        $command = if (Test-Path ".\package.json") {
            $packageJson = Get-Content ".\package.json" -Raw | ConvertFrom-Json
            if ($packageJson.scripts.test) {
                "pnpm test"
            } else {
                Write-Warning "No test script found in package.json"
                return
            }
        } elseif (Test-Path "*.sln") {
            "dotnet test"
        } elseif (Test-Path "*.csproj") {
            "dotnet test"
        } else {
            Write-Warning "No recognized test configuration found"
            return
        }

        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
 
Set-PSReadLineKeyHandler -Key Ctrl+Shift+s `
    -BriefDescription StartCurrentDirectory `
    -LongDescription "Start the current directory" `
    -ScriptBlock {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        if(Test-Path -Path ".\package.json") {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("pnpm start")
        }else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet run")
        }
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }

# Add completion for git commands
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    git help -a | Where-Object { $_ -like "$wordToComplete*" }
}

# Add completion for docker commands

Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    docker help | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
     param($commandName, $wordToComplete, $cursorPosition)
         dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
         }
}

# Add gh CLI completion
Register-ArgumentCompleter -Native -CommandName gh -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $completions = gh completion --shell powershell | Out-String
    if ($wordToComplete) {
        $completions.Split("`n") | Where-Object { $_ -like "$wordToComplete*" }
    } else {
        $completions.Split("`n")
    }
}