$scriptContent = @"
$sharepointUrl = 'https://raw.githubusercontent.com/tibia-sv/accerte_wallpaper/refs/heads/main/Wallpaper.jpg'

$picturesPath = "$env:USERPROFILE\Pictures"

if (!(Test-Path -Path $picturesPath)) {
    New-Item -Path $picturesPath -ItemType Directory
}

$localWallpaperPath = "$picturesPath\Wallpaper.jpg"

Invoke-WebRequest -Uri $sharepointUrl -OutFile $localWallpaperPath -UseBasicParsing

$registryPath = 'HKCU:\Control Panel\Desktop'

Set-ItemProperty -Path $registryPath -Name Wallpaper -Value $localWallpaperPath
Set-ItemProperty -Path $registryPath -Name WallpaperStyle -Value "2" # 2 para esticado; "0" para centralizado, "6" para ajustar, "10" para preencher

RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
