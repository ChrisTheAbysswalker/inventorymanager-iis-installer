;=========================================
; Installer for Inventory Manager Suite
;=========================================

[Setup]
AppName=Inventory Manager Suite
AppVersion=1.0
DefaultDirName={commonpf}\InventoryManager
OutputDir=Output
OutputBaseFilename=InventoryManagerSetup
Compression=lzma
SolidCompression=yes
DisableProgramGroupPage=yes
Uninstallable=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64compatible

[Files]
; Copy published apps to inetpub directly
Source: "Publish\InstadataInventory\*"; DestDir: "C:\inetpub\wwwroot\InstadataInventory"; Flags: recursesubdirs createallsubdirs
Source: "Publish\InventoryManager\*"; DestDir: "C:\inetpub\wwwroot\InventoryManager"; Flags: recursesubdirs createallsubdirs
Source: "Publish\Api\*"; DestDir: "C:\inetpub\wwwroot\Api"; Flags: recursesubdirs createallsubdirs

; Include PowerShell setup script in the installer folder
Source: "setup.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Code]
var
  InstadataPortPage: TInputQueryWizardPage;
  InventoryPortPage: TInputQueryWizardPage;
  ApiPortPage:       TInputQueryWizardPage;

procedure InitializeWizard;
begin
  // Page for InstadataInventory port
  InstadataPortPage := CreateInputQueryPage(wpSelectDir,
    'InstadataInventory Configuration', 'InstadataInventory Port',
    'Choose the port for InstadataInventory:');
  InstadataPortPage.Add('Port:', False);

  // Page for InventoryManager port
  InventoryPortPage := CreateInputQueryPage(InstadataPortPage.ID,
    'InventoryManager Configuration', 'InventoryManager Port',
    'Choose the port for InventoryManager:');
  InventoryPortPage.Add('Port:', False);

  // Page for API port
  ApiPortPage := CreateInputQueryPage(InventoryPortPage.ID,
    'API Configuration', 'API Port',
    'Choose the port for the API:');
  ApiPortPage.Add('Port:', False);

  // Default values
  InstadataPortPage.Values[0] := '8080';
  InventoryPortPage.Values[0] := '8081';
  ApiPortPage.Values[0]       := '8090';
end;

function GetInstadataPort(Value: string): string;
begin
  Result := InstadataPortPage.Values[0];
end;

function GetInventoryPort(Value: string): string;
begin
  Result := InventoryPortPage.Values[0];
end;

function GetApiPort(Value: string): string;
begin
  Result := ApiPortPage.Values[0];
end;

[Run]
; Ejecutar el script PowerShell al final, en 64 bits
Filename: "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"; \
  Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\setup.ps1"" -InstadataPath ""C:\inetpub\wwwroot\InstadataInventory"" -InventoryPath ""C:\inetpub\wwwroot\InventoryManager"" -ApiPath ""C:\inetpub\wwwroot\Api"" -InstadataPort {code:GetInstadataPort} -InventoryPort {code:GetInventoryPort} -ApiPort {code:GetApiPort}"; \
  Flags: waituntilterminated