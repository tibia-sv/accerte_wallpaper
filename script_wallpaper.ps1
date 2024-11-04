$scriptContent = @"
\$sharepointUrl = 'https://raw.githubusercontent.com/tibia-sv/accerte_wallpaper-/refs/heads/main/Wallpaper.jpg'

\$picturesPath = "\$env:USERPROFILE\Pictures"

if (!(Test-Path -Path \$picturesPath)) {
    New-Item -Path \$picturesPath -ItemType Directory
}

\$localWallpaperPath = "\$picturesPath\Wallpaper.jpg"

Invoke-WebRequest -Uri \$sharepointUrl -OutFile \$localWallpaperPath -UseBasicParsing

\$registryPath = 'HKCU:\Control Panel\Desktop'

Set-ItemProperty -Path \$registryPath -Name Wallpaper -Value \$localWallpaperPath
Set-ItemProperty -Path \$registryPath -Name WallpaperStyle -Value "2" # 2 para esticado; "0" para centralizado, "6" para ajustar, "10" para preencher

RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
"@

$scriptPath = "$env:USERPROFILE\Documents\update_wallpaper.ps1"

Set-Content -Path $scriptPath -Value $scriptContent

$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

$shortcutPath = "$startupFolder\UpdateWallpaper.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-WindowStyle Hidden -File `"$scriptPath`""
$shortcut.Save()

Write-Output "Script adicionado à inicialização do sistema com sucesso."
