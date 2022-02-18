Start-BitsTransfer -Source https://aka.ms/WACDownload -Destination "C:\Windows\Temp\WindowsAdminCenter.msi"

Write-Host "Install Windows Admin Center" -ForegroundColor Green
Start-Process msiexec.exe -Wait -ArgumentList "/i C:\Windows\Temp\WindowsAdminCenter.msi /qn /L*v log.txt REGISTRY_REDIRECT_PORT_80=1 SME_PORT=443 SSL_CERTIFICATE_OPTION=generate"

Start-Sleep -Seconds 10

Write-Host "Starting Windows Admin Center" -ForegroundColor Green
Start-Service ServerManagementGateway
