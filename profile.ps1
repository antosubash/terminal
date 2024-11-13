Import-Module -Name Terminal-Icons
Import-Module z

$url = "https://raw.githubusercontent.com/antosubash/terminal/main/antosubash.omp.json"

## Download the config file
Invoke-WebRequest -Uri $url -OutFile $env:USERPROFILE\antosubash.omp.json

## Initialize oh-my-posh
oh-my-posh init pwsh --config $env:USERPROFILE\antosubash.omp.json | Invoke-Expression

Import-Module PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -PredictionViewStyle InlineView