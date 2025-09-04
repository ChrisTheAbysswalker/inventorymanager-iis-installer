procedure UninstallIIS;
var
  ResultCode: Integer;
begin
  // Remove websites
  Exec('powershell.exe',
    '-NoProfile -Command "Import-Module WebAdministration; Remove-Website -Name ''InstadataInventory'' -ErrorAction SilentlyContinue; Remove-Website -Name ''InventoryManager'' -ErrorAction SilentlyContinue; Remove-Website -Name ''Api'' -ErrorAction SilentlyContinue"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  // Remove app pools
  Exec('powershell.exe',
    '-NoProfile -Command "Import-Module WebAdministration; Remove-WebAppPool -Name ''InstadataInventory'' -ErrorAction SilentlyContinue; Remove-WebAppPool -Name ''InventoryManager'' -ErrorAction SilentlyContinue; Remove-WebAppPool -Name ''Api'' -ErrorAction SilentlyContinue"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  // Remove firewall rules
  Exec('powershell.exe',
    '-NoProfile -Command "Remove-NetFirewallRule -DisplayName ''InstadataInventory'' -ErrorAction SilentlyContinue; Remove-NetFirewallRule -DisplayName ''InventoryManager'' -ErrorAction SilentlyContinue; Remove-NetFirewallRule -DisplayName ''Api'' -ErrorAction SilentlyContinue"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  // Remove inetpub folders
  Exec('cmd.exe', '/C rmdir /S /Q "C:\inetpub\wwwroot\InstadataInventory"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('cmd.exe', '/C rmdir /S /Q "C:\inetpub\wwwroot\InventoryManager"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('cmd.exe', '/C rmdir /S /Q "C:\inetpub\wwwroot\Api"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
    UninstallIIS;
end;
