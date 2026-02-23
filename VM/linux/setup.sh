echo "================================================================"
echo "Installing Signoz VM agent"
echo "================================================================"

echo "#########  COPY/ Create config.yaml to the otelcol-contrib DIR  ########## "

echo " Downloading otel-collector tar.gz for your amd architecture"
sudo wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.143.1/otelcol-contrib_0.143.1_linux_amd64.tar.gz
echo "Extracting otel-collector tar.gz to the otelcol-contrib folder"
sudo mkdir otelcol-contrib && tar xvzf otelcol-contrib_0.143.1_linux_amd64.tar.gz -C otelcol-contrib
sudo cp config.yaml otelcol-contrib/
echo "Runnig otel contrib in Background"
./otelcol-contrib --config ./config.yaml &> otelcol-output.log & echo "$!" > otel-pid

echo "================================================================"
echo "Installation completed for  Signoz VM agent"
echo "================================================================"

#Reg-X is a RegTech (Regulatory Technology) SaaS company that provides software and consulting to help banks,
# asset managers, and financial firms automate regulatory reporting and compliance# 