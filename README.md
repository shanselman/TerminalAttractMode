# TerminalAttractMode
Given a Profile and folder name, rotates the background of a Terminal with animated gifs

This is the greatest PowerShell script ever written, today. It uses Chris Ducks' lovely Module https://github.com/gpduck/MSTerminalSettings

Run it in another tab using the new open source [Windows Terminal](https://www.hanselman.com/blog/YouCanNowDownloadTheNewOpenSourceWindowsTerminal.aspx) and call

```
./AttractMode.ps1 -name "profile name" -path "c:\temp\trouble" -secs 5
```

where name is a Name (has to be unique) of one of your Terminal profiles in profiles.json and Path is a path to a folder with a bunch of animated gifs

![EPIC](https://user-images.githubusercontent.com/2892/60372165-8cfa0480-99b0-11e9-8e80-c37ab964f202.gif)

We are also keeping an eye on @JustinGrote's work over here https://gist.github.com/JustinGrote/2fb8e60ce70b3a05a94debf6bfc6b057
