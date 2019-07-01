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
    $Seconds = 5,

    [Parameter(Mandatory = $false, Position = 3)]
    [int]
    [Alias('MakeWindowMove')]
    $Travel = 0
)

$ErrorActionPreference = "Stop"
$timerMS = 0;
$gifposition = 0;

# Variables only needed if we're going to make the Window move
if ($Travel -eq 1) {
Import-Module .\SetWindow.psm1
$ScreenWidth = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth
$ScreenHeight = Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenHeight
$WindowWidth = $ScreenWidth[0].ScreenWidth * .8
$WindowHeight = $ScreenHeight[0].ScreenHeight * .7
$MaxPositionX = $ScreenWidth[0].ScreenWidth - $WindowWidth
$MaxPositionY = $ScreenHeight[0].ScreenHeight - $WindowHeight
$PositionX = 100
$PositionY = 100
$DirectionX = 1
$DirectionY = 1
}

# This script depends on MSTerminalSettings. Install it if it's not available.
if(-not (Get-Module -Name MSTerminalSettings -ListAvailable) )
{
    Install-Module MSTerminalSettings
}

# This hashtable will represent the parameters of Set-MSTerminalProfile... these 3 are constant so we'll set them here.
$splat = @{
    useAcrylic = $false
    backgroundImageOpacity = 0.40
    backgroundImageStretchMode = "uniformToFill"
}

# determine screen dimensions to restrict our window movement
$gifs = Get-ChildItem $Path -Filter "*.gif"

while ($true) {

    if ($Travel -eq 1) {
        $PositionX = $PositionX + $DirectionX  
        $PositionY = $PositionY + $DirectionY  
        if ($PositionX -gt $MaxPositionX -or $PositionX -lt 0) {
            $DirectionX = $DirectionX * -1
        }
        if ($PositionY -gt $MaxPositionY -or $PositionY -lt 0) {
            $DirectionY = $DirectionY * -1
        }

        # Move the window position
        SetWindowPosition -ProcessName "WindowsTerminal" -X $PositionX -Y $PositionY -height $WindowHeight -width $WindowWidth
        Start-Sleep -Milliseconds 30
    } else {
        Start-Sleep -Milliseconds 30
    }

    $timerMS += 30;
    if ($timerMS -ge ($Seconds * 1000))
    {
        # Grab the Profile right before we set it so we don't accidently stomp on other changes. 
        $terminalProfile = Get-MSTerminalProfile -Name $Name

        # Change the background in the object.
        $splat.backgroundImage = $gifs[$gifposition].FullName
        $gifposition += 1;
        if ($gifposition -ge $gifs.Length) {
            $gifposition = 0; 
        }

        # Splat the parameters into Set-MSTerminalProfile.
        $terminalProfile | Set-MSTerminalProfile @splat
        $timerMS = 0;
    }
}

