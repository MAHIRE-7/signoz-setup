# Step 1. Install the instrumentation
---
curl -sSfL https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/latest/download/otel-dotnet-auto-install.sh -O

sh ./otel-dotnet-auto-install.sh

chmod +x $HOME/.otel-dotnet-auto/instrument.sh
---

# Step 2. Run your application with zero-code instrumentation
---
. $HOME/.otel-dotnet-auto/instrument.sh

OTEL_SERVICE_NAME=<service-name> \
OTEL_TRACES_EXPORTER=otlp \
OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf \
OTEL_EXPORTER_OTLP_ENDPOINT=http://<monitoring-vm-ip>>:443 \
OTEL_RESOURCE_ATTRIBUTES=deployment.environment=production,service.version=1.0.0 \
dotnet run
---