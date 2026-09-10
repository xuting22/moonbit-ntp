param([int]$Port = 8775)
$ErrorActionPreference = 'Stop'
if ($Port -lt 1024 -or $Port -gt 65535) { throw 'Port must be between 1024 and 65535.' }
Write-Host "Local review: http://127.0.0.1:$Port/web/"
Write-Host 'Press Ctrl+C to stop. Server binds to loopback only.'
python (Join-Path $PSScriptRoot 'tools/serve.py') --port $Port
