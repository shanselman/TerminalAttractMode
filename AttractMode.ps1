param(
    # The `Name` of the MicrosoftTerminal Profile.
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    [Alias('Profile')]
    $Name,

    # The `Path` of the your awesome gifs that are clearly not copyrighted an totally appropriate to use in an OSS project.
    [Parameter(Mandatory = $true, Position = 1)]
    [string]
    [Alias('GifFolderPath')]
    $Path,

    [Parameter(Mandatory = $false, Position = 2)]
    [int]
    [Alias('Secs')]
    $Seconds = 5

)
$ErrorActionPreference = "Stop"

# This script depends on MSTerminalSettings. Install it if it's not available.
if(-not (Get-Module -Name MSTerminalSettings -ListAvailable) )
{
    Install-Module MSTerminalSettings
}

# This hashtable will represent the parameters of Set-MSTerminalProfile... these 3 are constant so we'll set them here.
$splat = @{
    useAcrylic = $false
    backgroundImageOpacity = 0.40
    backgroundImageStretchMode = "fill"
}

while ($true) {
    # Loop over the path
    Get-ChildItem $Path -Filter "*.gif" | ForEach-Object {
        # Grab the Profile right before we set it so we don't accidently stomp on other changes. 
        $terminalProfile = Get-MSTerminalProfile -Name $Name

        # Change the background in the object.
        $splat.backgroundImage = $_.FullName

        # Splat the parameters into Set-MSTerminalProfile.
        $terminalProfile | Set-MSTerminalProfile @splat

        Start-Sleep -Seconds $seconds
    }
}
