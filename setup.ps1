# setup.ps1
param(
    [string]$InstadataPath,
    [string]$InventoryPath,
    [string]$ApiPath,
    [int]$InstadataPort,
    [int]$InventoryPort,
    [int]$ApiPort
)

# Create logs folder
$logDir = "C:\Temp"
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
}

$logFile = Join-Path $logDir "InventoryInstaller.log"

# Start logging
Start-Transcript -Path $logFile -Append

Write-Output "===== INSTALLATION START $(Get-Date) ====="

try {
    Write-Output "Checking IIS module..."
    # IIS is assumed installed on Windows 10 Pro
    Import-Module WebAdministration -ErrorAction Stop
    Write-Output "IIS module loaded successfully."

    function Create-Site($name, $path, $port) {
        Write-Output "Creating site $name on port $port..."

        if (-not (Test-Path $path)) {
            New-Item -Path $path -ItemType Directory -Force | Out-Null
            Write-Output "Folder created: $path"
        }

        icacls $path /grant "IIS_IUSRS:(OI)(CI)RX" /T | Out-Null

        if (-not (Test-Path IIS:\AppPools\$name)) {
            Write-Output "Creating AppPool: $name"
            New-WebAppPool -Name $name
            Set-ItemProperty IIS:\AppPools\$name -Name "managedRuntimeVersion" -Value ""
        }

        if (-not (Get-Website -Name $name -ErrorAction SilentlyContinue)) {
            Write-Output "Creating Website: $name (Port $port, Path $path)"
            New-Website -Name $name -Port $port -PhysicalPath $path -ApplicationPool $name
        } else {
            Write-Output "Site $name already exists. Skipping."
        }
    }

    # Create sites
    Create-Site "InstadataInventory" $InstadataPath $InstadataPort
    Create-Site "InventoryManager"   $InventoryPath $InventoryPort
    Create-Site "Api"                $ApiPath       $ApiPort

    # Add firewall rules
    New-NetFirewallRule -DisplayName "InstadataInventory" -Direction Inbound -Protocol TCP -LocalPort $InstadataPort -Action Allow -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "InventoryManager"    -Direction Inbound -Protocol TCP -LocalPort $InventoryPort -Action Allow -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "Api"                 -Direction Inbound -Protocol TCP -LocalPort $ApiPort -Action Allow -ErrorAction SilentlyContinue

    Write-Output "===== INSTALLATION COMPLETED ====="
}
catch {
    Write-Output "ERROR: $_"
}
finally {
    Stop-Transcript
    Read-Host "Press Enter to exit"
}
