param(
    # The `Name` of the MicrosoftTerminal Profile
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    [Alias('Profile')]
    $Name,

    # The `Path` of the your awesome gifs that are clearly not copyrighted an totally appropriate to use in an OSS project
    [Parameter(Mandatory = $true, Position = 1)]
    [string]
    [Alias('GifFolderPath')]
    $Path,

    [Parameter(Mandatory = $false, Position = 2)]
    [int]
    [Alias('Secs')]
    $seconds = 5

)
$ErrorActionPreference = "Stop"

#if(!(Get-Module -Name MSTerminalSettings -ListAvailable) )
if(-not (Get-Module -Name MSTerminalSettings -ListAvailable) )
{
    Install-Module MSTerminalSettings
}

while ($true) {
    #forloop over the path
    Get-ChildItem $Path -Filter "*.gif" | ForEach-Object {

        $terminalProfile = Get-MSTerminalProfile -Name $Name

        $terminalProfile.useAcrylic = $false

        if(!$terminalProfile.backgroundImage){
            $terminalProfile | Add-Member -NotePropertyName backgroundImage -NotePropertyValue ""
        }
        $terminalProfile.backgroundImage = $_.FullName

        if(!$terminalProfile.backgroundImageOpacity){
            $terminalProfile | Add-Member -NotePropertyName backgroundImageOpacity -NotePropertyValue 1
        }
        $terminalProfile.backgroundImageOpacity = 0.40

        if(!$terminalProfile.backgroundImageStretchMode){
            $terminalProfile | Add-Member -NotePropertyName backgroundImageStretchMode -NotePropertyValue ""
        }
        $terminalProfile.backgroundImageStretchMode = "stretchToFill"

        $terminalProfile | Set-MSTerminalProfile 
        
        Start-Sleep -Seconds $seconds
    }
}
