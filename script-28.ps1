<#
.SYNOPSIS
    Muestra espacio libre y utilizado de todos los sistemas de ficheros.

.DESCRIPTION
    Muestra todas las unidades/drives indicando el espacio libre y utilizado en GB.

.EXAMPLE
    ./resumen-discos.ps1
    Name Root Utilizado(GB) Libre (GB)
    ---- ---- ------------- ----------
    C    C:\            110        8,6

.NOTES
    Author: Antonio BP | License: GNU
    
.LINK
    https://github.com/ISO-VJP/iso-scripts-vjp-idGitHub
#>

# Obtenemos las unidades del sistema de archivos (FileSystem)
Get-PSDrive -PSProvider FileSystem | Format-Table -Property `
    Name, `
    Root, `
    @{Label="Utilizado (GB)"; Expression={ [Math]::Round(($_.Used / 1GB), 1) }}, `
    @{Label="Libre (GB)";     Expression={ [Math]::Round(($_.Free / 1GB), 1) }}