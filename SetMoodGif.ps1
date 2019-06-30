param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    [Alias('Profile')]
    $Name,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]
    [Alias('Gif')]
    $Path
)
$ErrorActionPreference = "Stop"

# This script depends on MSTerminalSettings. Install it if it's not available.
if(-not (Get-Module -Name MSTerminalSettings -ListAvailable) )
{
    Install-Module MSTerminalSettings
}

# This hashtable will represent the parameters of Set-MSTerminalProfile.
$splat = @{
    useAcrylic = $false
    backgroundImage = $Path
    backgroundImageOpacity = 0.60
    backgroundImageStretchMode = "fill"
}

Get-MSTerminalProfile -Name $Name | Set-MSTerminalProfile @splat
