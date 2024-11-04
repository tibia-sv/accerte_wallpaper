# Código para troca de ícone de plano de fundo da Área de Trabalho do computador

## Código Documentado

# Define o conteúdo do script para atualizar o wallpaper
$scriptContent = @"
# Define the URL for the wallpaper stored in SharePoint
\$sharepointUrl = 'https://raw.githubusercontent.com/tibia-sv/accerte_wallpaper-/refs/heads/main/Wallpaper.jpg'

# Caminho da pasta 'Pictures' no home do usuário
\$picturesPath = "\$env:USERPROFILE\Pictures"

# Verifica se a pasta já existe, caso contrário, cria a pasta
if (!(Test-Path -Path \$picturesPath)) {
    New-Item -Path \$picturesPath -ItemType Directory
}

# Define o caminho local para salvar o wallpaper temporariamente
\$localWallpaperPath = "\$picturesPath\Wallpaper.jpg"

# Faz o download da imagem de wallpaper do SharePoint
Invoke-WebRequest -Uri \$sharepointUrl -OutFile \$localWallpaperPath -UseBasicParsing

# Define o caminho do registro para configurações da área de trabalho
\$registryPath = 'HKCU:\Control Panel\Desktop'

# Configura as chaves de registro para o wallpaper
Set-ItemProperty -Path \$registryPath -Name Wallpaper -Value \$localWallpaperPath
Set-ItemProperty -Path \$registryPath -Name WallpaperStyle -Value "2" # 2 para esticado; "0" para centralizado, "6" para ajustar, "10" para preencher

# Atualiza a área de trabalho para aplicar o novo wallpaper
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
"@

# Caminho para salvar o script PowerShell
$scriptPath = "$env:USERPROFILE\Documents\update_wallpaper.ps1"

# Salva o conteúdo no arquivo .ps1
Set-Content -Path $scriptPath -Value $scriptContent

# Caminho da pasta de inicialização do usuário
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

# Caminho do atalho que será criado
$shortcutPath = "$startupFolder\UpdateWallpaper.lnk"

# Cria o atalho na pasta de inicialização
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-WindowStyle Hidden -File `"$scriptPath`""
$shortcut.Save()

Write-Output "Script adicionado à inicialização do sistema com sucesso."

C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
