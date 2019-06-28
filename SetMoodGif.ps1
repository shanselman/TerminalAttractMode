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

#if(!(Get-Module -Name MSTerminalSettings -ListAvailable) )
if(-not (Get-Module -Name MSTerminalSettings -ListAvailable) )
{
    Install-Module MSTerminalSettings
}

$terminalProfile = Get-MSTerminalProfile -Name $Name

$terminalProfile.useAcrylic = $false

if(!$terminalProfile.backgroundImage){
    $terminalProfile | Add-Member -NotePropertyName backgroundImage -NotePropertyValue ""
}
$terminalProfile.backgroundImage = $path

if(!$terminalProfile.backgroundImageOpacity){
    $terminalProfile | Add-Member -NotePropertyName backgroundImageOpacity -NotePropertyValue 1
}
$terminalProfile.backgroundImageOpacity = 0.60

if(!$terminalProfile.backgroundImageStretchMode){
    $terminalProfile | Add-Member -NotePropertyName backgroundImageStretchMode -NotePropertyValue ""
}
$terminalProfile.backgroundImageStretchMode = "stretchToFill"

$terminalProfile | Set-MSTerminalProfile 


