### ARM architecture

# Download otel-collector tar.gz for your architecture 
---
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.143.1/otelcol-contrib_0.143.1_linux_amd64.tar.gz

---

# Extract otel-collector tar.gz to the otelcol-contrib folder
---
mkdir otelcol-contrib && tar xvzf otelcol-contrib_0.143.1_linux_amd64.tar.gz -C otelcol-contrib

---

# Create config.yaml in otelcol-contrib in the dir it is available as config.yaml

# Once we are done with the above configurations, we can now run the collector service with the following command:
# From the otelcol-contrib, run the following command:
---
./otelcol-contrib --config ./config.yaml

---
# OR
# run in background
---
./otelcol-contrib --config ./config.yaml &> otelcol-output.log & echo "$!" > otel-pid

---

# If you want to see the output of the logs you’ve just set up for the background process, you may look it up with:
---
tail -f -n 50 otelcol-output.log
---

# !!! ou can stop the collector service otelcol when running in backgorund, with the following command:
---
kill "$(< otel-pid)"
---