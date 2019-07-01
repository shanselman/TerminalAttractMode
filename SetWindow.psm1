# SETWINDOW FUNCTION CAME FROM HERE: https://superuser.com/questions/1324007/setting-window-size-and-position-in-powershell-5-and-6
Function SetWindowPosition {
    [OutputType('System.Automation.WindowInfo')]
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipelineByPropertyName=$True)]
        $ProcessName,
        [int]$X,
        [int]$Y,
        [int]$Width,
        [int]$Height,
        [switch]$Passthru
    )
    Begin {
        Try{
            [void][Window]
        } Catch {
        Add-Type @"
              using System;
              using System.Runtime.InteropServices;
              public class Window {
                [DllImport("user32.dll")]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

                [DllImport("User32.dll")]
                public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);
              }
              public struct RECT
              {
                public int Left;        // x position of upper-left corner
                public int Top;         // y position of upper-left corner
                public int Right;       // x position of lower-right corner
                public int Bottom;      // y position of lower-right corner
              }
"@
        }
    }
    Process {
        $Rectangle = New-Object RECT
        $Handles = (Get-Process -Name $ProcessName).MainWindowHandle   ### 1.1//JosefZ
        foreach ( $Handle in $Handles ) {                              ### 1.1//JosefZ
            if ( $Handle -eq [System.IntPtr]::Zero ) { Continue }      ### 1.1//JosefZ
            $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
            If (-NOT $PSBoundParameters.ContainsKey('Width')) {            
                $Width = $Rectangle.Right - $Rectangle.Left            
            }
            If (-NOT $PSBoundParameters.ContainsKey('Height')) {
                $Height = $Rectangle.Bottom - $Rectangle.Top
            }
            If ($Return) {
                $Return = [Window]::MoveWindow($Handle, $x, $y, $Width, $Height,$False)
            }
            If ($PSBoundParameters.ContainsKey('Passthru')) {
                $Rectangle = New-Object RECT
                $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
                If ($Return) {
                    $Height = $Rectangle.Bottom - $Rectangle.Top
                    $Width = $Rectangle.Right - $Rectangle.Left
                    $Size = New-Object System.Management.Automation.Host.Size -ArgumentList $Width, $Height
                    $TopLeft = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left, $Rectangle.Top
                    $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                    If ($Rectangle.Top -lt 0 -AND $Rectangle.LEft -lt 0) {
                        Write-Warning "Window is minimized! Coordinates will not be accurate."
                    }
                    $Object = [pscustomobject]@{
                        ProcessName = $ProcessName
                        Size = $Size
                        TopLeft = $TopLeft
                        BottomRight = $BottomRight
                    }
                    $Object.PSTypeNames.insert(0,'System.Automation.WindowInfo')
                    $Object            
                }
            }
        }
    }
}

Export-ModuleMember -Function 'SetWindowPosition'
