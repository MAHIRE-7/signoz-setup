download package
---
Invoke-WebRequest -Uri "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.146.1/otelcol-contrib_0.146.1_windows_amd64.tar.gz" -OutFile "otelcol-contrib_0.146.1_windows_amd64.tar.gz"
---

verify
---
ls
---
---
tar -xvzf otelcol-contrib_0.146.1_windows_amd64.tar.gz
---

---
mkdir C:\otelcol
Move-Item .\otelcol-contrib.exe C:\otelcol\
cd C:\otelcol
.\otelcol-contrib.exe --version
---

---
notepad config.yaml

$proc = Start-Process "C:\otelcol\otelcol-contrib.exe" `
  -ArgumentList "--config C:\otelcol\config.yaml" `
  -WindowStyle Hidden `
  -PassThru
---

---
# verify
Get-Process otelcol-contrib
---


# Open PowerShell:
---
Get-Process otelcol-contrib
---
# If it shows running, terminate it:
---
Stop-Process -Name "otelcol-contrib" -Force
---
# This will immediately stop the OTEL agent.