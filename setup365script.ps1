param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

cls
##INSTALANDO MÓDULO MS365
#Write-Host "Verificando instalação do Módulo necessário"
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
#Install-Module -Name MSOnline -Force | Out-Null

#Start-Sleep -Seconds 1
Write-Host "Conectando no ambiente do Microsoft 365. . ."

##CONECTANDO NO MS365
Connect-MsolService

Write-Host "Verificando Tenant. . ." -ForegroundColor Yellow -BackgroundColor White
#ARMAZENANDO DOMINIO EM VARIÁVEL
$O365GetDomain = Get-MsolDomain | Where {$_.Name -NotMatch "Mail.onmicrosoft.com"}
$domain = $O365GetDomain.name


Write-Host "Verificando Tenant. . ." -ForegroundColor Yellow -BackgroundColor Black


# ADICIONANDO USUÃRIOS PADRÕES
Write-Host "Adicionando Usuários. . ."
New-MsolUser -UserPrincipalName AlexW2@$domain -City Waukesha -Country "US" -Department IT -DisplayName "Alex Wilber" -FirstName Alex -LastName Wilber -Password Pa55w.rd -State WI   -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName AllanD@$domain -City Waukesha -Country "US" -Department IT -DisplayName "Allan Deyoung" -FirstName Allan -LastName Deyoung -Password Pa55w.rd -State WI -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName DiegoS@$domain -City Birmingham -Country "US" -Department HR -DisplayName "Diego Siciliani" -FirstName Diego -LastName Siciliani -Password Pa55w.rd -State AL -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName IsaiahL@$domain -City Tulsa -Country "US" -Department Sales -DisplayName "Isaiah Langer" -FirstName Isaiah -LastName Langer -Password Pa55w.rd -State OK -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName JoniS@$domain -City Charlotte -Country "US" -Department Legal -DisplayName "Joni Sherman" -FirstName Joni -LastName Sherman -Password Pa55w.rd -State NC -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName LynneR@$domain -City Tulsa -Country "US" -Department Retail -DisplayName "Lynne Robbins" -FirstName Lynne -LastName Robbins -Password Pa55w.rd -State OK -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName NestorW@$domain -City Pittsburgh -Country "US" -Department Marketing -DisplayName "Nestor Wilke" -FirstName Nestor -LastName Wilke -Password Pa55w.rd -State WA -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName MeganB@$domain -City Seattle -Country "US" -Department Operations -DisplayName "Megan Bowen" -FirstName Megan -LastName Bowen -Password Pa55w.rd -State PA -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null
New-MsolUser -UserPrincipalName PattiF@$domain -City Louisville -Department "Executive Management" -DisplayName "Patti Fernandez" -FirstName Patti -LastName Fernandez -Password Pa55w.rd -State KY -UserType Member -UsageLocation US -ForceChangePassword $false | Out-Null

Start-Sleep -Seconds 2



$msgBodyR= "User Creation Completed! Continue to license."
$msgTitleR = ""
$msgButtonR = 'Ok'
$msgImageR = 'Asterisk'
$msgShowR = [System.Windows.MessageBox]::Show($msgBodyR,$msgTitleR,$msgButtonR,$msgImageR)


cls
Write-Host "Verificando Licenças. . .
"
#VERIFICANDO LICENÇAS
$O365GetLicenseE5 = Get-MsolAccountSku | where {$_.AccountSkuId.Contains("ENTERPRISEPREMIUM")}
$O365GetLicenseEMS = Get-MsolAccountSku | where {$_.AccountSkuId.Contains("EMSPREMIUM")}
$O365GetLicenseAAD = Get-MsolAccountSku | where {$_.AccountSkuId.Contains("AAD_PREMIUM")}


# VERIFICAÇÃO DE LICENÇA DO MICROSOFT 365 E5

If ($O365GetLicenseE5 -eq $null) {
    $msgBodyLicenseE5Error = "Licença do Microsoft E5 não disponivel. Deseja continuar?"
    $msgTitleLicenseE5Error = "Error"
    $msgButtonLicenseE5Error = 'YesNo'
    $msgImageLicenseE5Error = 'Warning'
    $msgShowE5Error = [System.Windows.FOrms.MessageBox]::Show($msgBodyLicenseE5Error,$msgTitleLicenseE5Error,$msgButtonLicenseE5Error,$msgImageLicenseE5Error)
        Switch ($msgShowE5Error){
        "Yes" {Write-Host "Verificação de Licença do Microsoft 365 E5 ignorada."
        
        }

        "No" {Write-Host "Verificação de Licença do Microsoft 365 E5 Cancelada."
              pause
              Exit }         
        }
}

else {
    Write-Host "Verificação de Licença do Microsoft 365 E5 Concluída.
    "
    Write-Host "Adicionando Licenças do Microsoft 365 E5.
    "
    $O365E5LicenseSKU = $O365GetLicenseE5.AccountSkuId
    Get-MsolUser -All -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses $O365E5LicenseSKU
    
}

Start-Sleep -Seconds 2
cls
# VERIFICAÇÃO DE LICENÇA DO MICROSOFT ENTERPRISE MOBILITY + SECURITY

If ($O365GetLicenseEMS -eq $null) {
    $msgBodyLicenseEMSError = "Licença do Microsoft Enterprise Mobility + Security não disponivel. Deseja continuar?"
    $msgTitleLicenseEMSError = "Error"
    $msgButtonLicenseEMSError = 'YesNo'
    $msgImageLicenseEMSError = 'Warning'
    $msgShowE5Error = [System.Windows.FOrms.MessageBox]::Show($msgBodyLicenseEMSError,$msgTitleLicenseEMSError,$msgButtonLicenseEMSError,$msgImageLicenseEMSError)
        Switch ($msgShowE5Error){
        "Yes" {Write-Host "Verificação de Licença do Microsoft Enterprise Mobility + Security ignorada."
        
        }
        "No" {Write-Host "Verificação de Licença do Microsoft Enterprise Mobility + Security Cancelada."
              pause
              Exit }         
        }
}
else {
    Write-Host "Verificação de Licença do Microsoft Enterprise Mobility + Security Concluída.
    "
    Write-Host "Adicionando Licenças do Microsoft Enterprise Mobility + Security.
    "
    $O365EMSLicenseSKU = $O365GetLicenseEMS.AccountSkuId
    Get-MsolUser -All | Set-MsolUserLicense -AddLicenses $O365EMSLicenseSKU
}

Start-Sleep -Seconds 2
cls
# VERIFICAÇÃO DE LICENÇA DO AZURE ACTIVE DIRECTORY PREMIUM

If ($O365GetLicenseAAD -eq $null) {
    $msgBodyLicenseAADError = "Licença do Azure Active Directory Premium não disponivel. Deseja continuar?"
    $msgTitleLicenseAADError = "Error"
    $msgButtonLicenseAADError = 'YesNo'
    $msgImageLicenseAADError = 'Warning'
    $msgShowE5Error = [System.Windows.FOrms.MessageBox]::Show($msgBodyLicenseAADError,$msgTitleLicenseAADError,$msgButtonLicenseAADError,$msgImageLicensAAD5Error)
        Switch ($msgShowE5Error){
        "Yes" {Write-Host "Verificação de Licença do Azure Active Directory Premium ignorada."
        
        }

        "No" {Write-Host "Verificação de Licença do Azure Active Directory Premium Cancelada."
              pause
              Exit }         
        }
}
else {
    Write-Host "Verificação de Licença do Azure Active Directory Premium Concluída."
}

Start-Sleep -Seconds 2
cls

Write-host "
Processo concluído! Resultado abaixo:

"

Get-MsolUser -All | Format-Table -Property DisplayName, UserPrincipalName, isLicensed

pause