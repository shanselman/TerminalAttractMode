#messing around with build reaction gifs

Function DotNetAlias {
    dotnet build
    if ($?) {
        d:\github\TerminalAttractMode\SetMoodGif.ps1 "PowerShell Core" "D:\Dropbox\Reference\Animated Gifs\chrispratt.gif"                            
        Start-Sleep 1.5
        d:\github\TerminalAttractMode\SetMoodGif.ps1 "PowerShell Core" "D:\Dropbox\Reference\Animated Gifs\4003cn5.gif"                            
    }
    else {
        d:\github\TerminalAttractMode\SetMoodGif.ps1 "PowerShell Core" "D:\Dropbox\Reference\Animated Gifs\idk-girl.gif"                            
        Start-Sleep 1.5
        d:\github\TerminalAttractMode\SetMoodGif.ps1 "PowerShell Core" "D:\Dropbox\Reference\Animated Gifs\4003cn5.gif"                            

    }
}

Set-Alias -Name db -value DotNetAlias
