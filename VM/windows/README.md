# OpenTelemetry Collector Setup for Windows

This guide covers installing and configuring the OpenTelemetry Collector Contrib distribution on Windows systems.

## Prerequisites
- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1 or later
- Administrator privileges

## Installation Steps

### 1. Download Package
```powershell
Invoke-WebRequest -Uri "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.146.1/otelcol-contrib_0.146.1_windows_amd64.tar.gz" -OutFile "otelcol-contrib_0.146.1_windows_amd64.tar.gz"
```

### 2. Verify Download
```powershell
ls
```

### 3. Extract Archive
```powershell
tar -xvzf otelcol-contrib_0.146.1_windows_amd64.tar.gz
```

### 4. Install to System Directory
```powershell
mkdir C:\otelcol
Move-Item .\otelcol-contrib.exe C:\otelcol\
cd C:\otelcol
.\otelcol-contrib.exe --version
```

### 5. Configure and Start
```powershell
notepad config.yaml

$proc = Start-Process "C:\otelcol\otelcol-contrib.exe" `
  -ArgumentList "--config C:\otelcol\config.yaml" `
  -WindowStyle Hidden `
  -PassThru
```

## Management Commands

### Verify Running Status
```powershell
Get-Process otelcol-contrib
```

### Stop Collector
```powershell
Stop-Process -Name "otelcol-contrib" -Force
```

## Configuration

Ensure your `config.yaml` points to the correct SigNoz endpoint:
- **OTLP gRPC**: `<signoz-host>:1972`
- **OTLP HTTP**: `<signoz-host>:1973`

## Notes
- Version: v0.146.1
- Architecture: amd64
- Distribution: Contrib (includes additional receivers/exporters)
- Custom ports used: 1972 (gRPC), 1973 (HTTP)