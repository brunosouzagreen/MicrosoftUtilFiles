##VERIFICANDO PROMPT ELEVADO
param([switch]$Elevated)
function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        Write-Host "Este processo necessita de Prompt de modo Elevado. Por favor, inicie o processo corretamente." -ForegroundColor Red -BackgroundColor Black
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

Clear-Host
##INSTALANDO MÓDULO MS365
Write-Host "Verificando instalação do Módulo necessário" -ForegroundColor Yellow -BackgroundColor Black
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name MSOnline -Force | Out-Null

#Start-Sleep -Seconds 1
Write-Host "Conectando no ambiente do Microsoft 365. . ."

##CONECTANDO NO MS365
Connect-MsolService

Write-Host "Verificando Tenant. . ." -ForegroundColor Yellow -BackgroundColor Black
#ARMAZENANDO DOMINIO EM VARIÁVEL
$O365GetDomain = Get-MsolDomain | Where-Object {$_.Name -NotMatch "Mail.onmicrosoft.com"}
$domain = $O365GetDomain.name

Write-Host "Confirme o nome do seu Tenant " -ForegroundColor Yellow -BackgroundColor Black
Write-Host $O365GetDomain
Pause

# ADICIONANDO USUÃRIOS PADRÕES
Write-Host "Adicionando Usuários ao tenant " $O365GetDomain -ForegroundColor Yellow -BackgroundColor Black
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

Clear-Host
Write-Host "Verificando Licenças. . ." -ForegroundColor Yellow -BackgroundColor Black

#VERIFICANDO LICENÇAS
$O365GetLicenseE5 = Get-MsolAccountSku  | Where-Object {$_.AccountSkuId.Contains("ENTERPRISEPREMIUM")}
$O365GetLicenseEMS = Get-MsolAccountSku | Where-Object {$_.AccountSkuId.Contains("EMSPREMIUM")}
$O365GetLicenseAAD = Get-MsolAccountSku | Where-Object {$_.AccountSkuId.Contains("AAD_PREMIUM")}


# VERIFICAÇÃO DE LICENÇA DO MICROSOFT 365 E5

If ($null -eq $O365GetLicenseE5) {
    Write-Host "A licença Microsoft 365 Premium E5 não foi encontrada no Tenant $domain.`nDeseja continuar? Y/N" -NoNewline -ForegroundColor Red -BackgroundColor Gray
    $confirmE5 = Return Read-Host
        if ($confirmE5 -eq 'Y' -or $confirmE5 -eq 'y'){
            Write-Host "Verficação Ignorada." -ForegroundColor Yellow -BackgroundColor Black
        }
        elseif ($confirmE5 -eq 'N' -or $confirmE5 -eq 'n'){
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        }
        else {
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        }
}
else {
    Write-Host "Verificação de Licença do Microsoft 365 Premium E5 Concluída!`n" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Adicionando Licenças do Microsoft 365 Premium E5. . .`n"-ForegroundColor Yellow -BackgroundColor Black
    $O365EMSLicenseSKU = $O365GetLicenseE5.AccountSkuId
    Get-MsolUser -All -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses $O365E5LicenseSKU
}
Start-Sleep -Seconds 2
Clear-Host

# VERIFICAÇÃO DE LICENÇA DO MICROSOFT ENTERPRISE MOBILITY + SECURITY
If ($null -eq $O365GetLicenseEMS) {
    Write-Host "A licença Microsoft Enterprise Mobility + Security E5 não foi encontrada no Tenant $domain.`nDeseja continuar? Y/N" -NoNewline -ForegroundColor Red -BackgroundColor Gray
    $confirmEMS = Return Read-Host
        if ($confirmEMS -eq 'Y' -or $confirmEMS -eq 'y'){
            Write-Host "Verficação Ignorada." -ForegroundColor Yellow -BackgroundColor Black
        }
        elseif ($confirmEMS -eq 'N' -or $confirmEMS -eq 'n'){
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        }
        else {
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        }
}
else {
    Write-Host "Verificação de Licença do Microsoft Enterprise Mobility + Security Concluída.`n" -ForegroundColor Green -BackgroundColor Black
    Write-Host "Adicionando Licenças do Microsoft Enterprise Mobility + Security.`n"-ForegroundColor Yellow -BackgroundColor Black
    $O365EMSLicenseSKU = $O365GetLicenseEMS.AccountSkuId
    Get-MsolUser -All | Set-MsolUserLicense -AddLicenses $O365EMSLicenseSKU
}
Start-Sleep -Seconds 2
Clear-Host

# VERIFICAÇÃO DE LICENÇA DO AZURE ACTIVE DIRECTORY PREMIUM
If ($null -eq $O365GetLicenseAAD) {
    Write-Host "A licença Microsoft Enterprise Mobility + Security E5 não foi encontrada no Tenant $domain.`nDeseja continuar? Y/N" -NoNewline -ForegroundColor Red -BackgroundColor Gray
    $confirmAAD = Return Read-Host
        if ($confirmAAD -eq 'Y' -or $confirmAAD -eq 'y'){
            Write-Host "Verficação Ignorada." -ForegroundColor Yellow -BackgroundColor Black
        }
        elseif ($confirmAAD -eq 'N' -or $confirmAAD -eq 'n'){
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        }
        else {
            Write-Host "Verficação Cancelada." -ForegroundColor Red -BackgroundColor Gray
        } 
}
else {
    Write-Host "Verificação de Licença do Azure Active Directory Premium Concluída." -ForegroundColor Green -BackgroundColor Black
}
Start-Sleep -Seconds 2
Clear-Host

Write-host "Processo Concluído! Resultado Abaixo:`n`n"  -ForegroundColor Green -BackgroundColor Black

Get-MsolUser -All | Format-Table -Property DisplayName, UserPrincipalName, isLicensed

pause
