# Inventory Manager Suite

Inventory Manager Suite is a Windows-based solution that automates the deployment of multiple web applications under IIS, including **InstadataInventory**, **InventoryManager**, and **API**. The suite includes an **Inno Setup installer** and a **PowerShell setup script** to configure IIS sites, app pools, and firewall rules automatically.

---

## Features

- Automatic IIS site and app pool creation.  
- Configurable ports for each application.  
- Automatic folder creation in `C:\inetpub\wwwroot`.  
- Firewall rules setup for each service.  
- Supports **Windows 10/11 Pro (64-bit)**.  
- Easy installation via Inno Setup installer.

---

## Installation

1. Download the latest release from the GitHub repository.  
2. Run the installer (`InventoryManagerSetup.exe`) **as Administrator**.  
3. Enter the desired ports for each service when prompted (default ports are: `8080`, `8081`, `8090`).  
4. The installer will:

    - Create folders under `C:\inetpub\wwwroot\`.
    - Create IIS App Pools and Websites.
    - Configure firewall rules.
    - Run the included PowerShell script automatically.

---

## Project Structure

```
InventoryManager/
├─ Publish/                  # Published web applications ready for deployment
│  ├─ InstadataInventory/
│  ├─ InventoryManager/
│  └─ Api/
├─ Installer.iss             # Main Inno Setup script
├─ setup.ps1                 # PowerShell script for IIS setup and firewall rules
├─ UninstallIISCode.iss      # Pascal Script for uninstall logic
└─ README.md                 # Documentation
```

---

## Requirements

- Windows 10/11 Pro (64-bit)  
- IIS (Internet Information Services) installed  
- PowerShell 64-bit  
- Administrator privileges to install services and configure firewall rules

---

## Usage

After installation:

- Access your sites at:

    ```
    http://localhost:8080  -> InstadataInventory
    http://localhost:8081  -> InventoryManager
    http://localhost:8090  -> API
    ```

- If needed, the PowerShell setup script can be run manually:

```powershell
C:\Program Files\InventoryManager\setup.ps1 `
  -InstadataPath "C:\inetpub\wwwroot\InstadataInventory" `
  -InventoryPath "C:\inetpub\wwwroot\InventoryManager" `
  -ApiPath "C:\inetpub\wwwroot\Api" `
  -InstadataPort 8080 `
  -InventoryPort 8081 `
  -ApiPort 8090
