### ARM architecture

# Download otel-collector tar.gz for your architecture 
---
sudo wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.143.1/otelcol-contrib_0.143.1_linux_amd64.tar.gz

---

# Extract otel-collector tar.gz to the otelcol-contrib folder
---
sudo mkdir otelcol-contrib && sudo tar xvzf otelcol-contrib_0.143.1_linux_amd64.tar.gz -C otelcol-contrib

---

# Create config.yaml in otelcol-contrib in the dir it is available as config.yaml

# Once we are done with the above configurations, we can now run the collector service with the following command:
# From the otelcol-contrib, run the following command:
---
sudo cp config.yaml otel-contrib
./otelcol-contrib --config ./config.yaml

---
# OR
# run in background
---
sudo bash -c './otelcol-contrib --config ./config.yaml &> otelcol-output.log & echo "$!" > otel-pid'

---
=======================================================================================================================================
## for syslog setup
---
sudo vim /etc/rsyslog.conf
---
## Add the following lines at the end of file:
---
template(
  name="UTCTraditionalForwardFormat"
  type="string"
  string="<%PRI%>%TIMESTAMP:::date-utc% %HOSTNAME% %syslogtag:1:32%%msg:::sp-if-no-1st-sp%%msg%"
)

*.*  action(type="omfwd" target="0.0.0.0" port="54527" protocol="tcp"
        action.resumeRetryCount="10"
        queue.type="linkedList" queue.size="10000" template="UTCTraditionalForwardFormat")
---
# Restart rsyslog Service
---
sudo systemctl restart rsyslog.service
---
# Check status
---
sudo systemctl status rsyslog.service
---
=======================================================================================================================================


# If you want to see the output of the logs you’ve just set up for the background process, you may look it up with:
---
tail -f -n 50 otelcol-output.log
---

# !!! ou can stop the collector service otelcol when running in backgorund, with the following command:
---
kill "$(< otel-pid)"
---


## to restart the otel agent
---
ps aux | grep otelcol

sudo kill <pid>


sudo ./otelcol-contrib --config ./config.yaml &
---