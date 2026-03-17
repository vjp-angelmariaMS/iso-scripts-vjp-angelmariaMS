#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Instala y configura el servidor OpenSSH en Windows o Linux.

.DESCRIPTION
    Este script verifica si el servicio SSH ya está en ejecución. 
    Si no lo está, instala el componente OpenSSH Server, lo configura 
    para que se inicie automáticamente y arranca el servicio. 
    Compatible con Windows y distribuciones Linux basadas en Debian/Ubuntu.

.EXAMPLE
    .\instalar-ssh-server.ps1
#>

# --- Requisito f: Comprobar si ya está instalado y en ejecución ---
if ($IsLinux) {
    # Comprobación en Linux usando systemctl
    $sshStatus = systemctl is-active ssh 2>$null
    if ($sshStatus -eq "active") {
        Write-Host "El servidor SSH ya está instalado y en ejecución en Linux. No es necesaria la instalación." -ForegroundColor Cyan
        exit
    }
} else {
    # Comprobación en Windows usando Get-Service
    $sshService = Get-Service -Name sshd -ErrorAction SilentlyContinue
    if ($sshService -and $sshService.Status -eq 'Running') {
        Write-Host "El servidor OpenSSH ya está instalado y en ejecución en Windows. No es necesaria la instalación." -ForegroundColor Cyan
        exit
    }
}

# --- Requisito e: Opcional - Soporte para Linux (apt) ---
if ($IsLinux) {
    Write-Host "Detectado sistema Linux. Instalando mediante apt..." -ForegroundColor Yellow
    sudo apt update && sudo apt install -y openssh-server
    sudo systemctl enable ssh
    sudo systemctl start ssh
    Write-Host "Servidor SSH instalado y activado correctamente en Linux." -ForegroundColor Green
} 
# --- Requisito c: Instalación en Windows ---
else {
    Write-Host "Detectado sistema Windows. Instalando OpenSSH Server..." -ForegroundColor Yellow
    
    # Obtener el nombre de la capacidad (capability) de OpenSSH
    $capability = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    
    if ($capability.State -ne 'Installed') {
        Add-WindowsCapability -Online -Name $capability.Name
    }

    # Configurar el servicio para que sea automático y arrancarlo
    Set-Service -Name sshd -StartupType 'Automatic'
    Start-Service sshd
    
    Write-Host "Servidor OpenSSH instalado y configurado correctamente en Windows." -ForegroundColor Green
}