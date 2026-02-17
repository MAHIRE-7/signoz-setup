# Step 1: Create Configuration Directory
---
mkdir -p ~/opentelemetry-collector
cd ~/opentelemetry-collector
---
 # Step 2: Create Collector Configuration create config.yaml already in the dir

 # Run the OpenTelemetry Collector
 docker run --name opentelemetry-collector \
  --restart unless-stopped \
  --detach \
  --user 0:0 \
  --pid host \
  --network host \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc:/hostfs/proc:ro \
  -v /sys:/hostfs/sys:ro \
  -v /:/hostfs:ro \
  -v "$(pwd)/config.yaml":/etc/otelcol-contrib/config.yaml \
  -e HOST_PROC=/hostfs/proc \
  -e HOST_SYS=/hostfs/sys \
  -e HOST_ROOT=/hostfs \
  otel/opentelemetry-collector-contrib:0.130.1

  -------------------------
  # check
  docker ps | grep opentelemetry-collector
  docker logs opentelemetry-collector

  ## generate test logs
  docker run --rm alpine sh -c 'for i in $(seq 1 10); do echo "Test log entry $i"; sleep 1; done'

