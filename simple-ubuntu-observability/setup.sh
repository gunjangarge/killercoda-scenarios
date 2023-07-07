# Create config file for pushgw
cat <<EOF >/tmp/prometheus.yaml
global:
  scrape_interval: 15s
  scrape_timeout: 1s
  evaluation_interval: 15s
scrape_configs:
- job_name: push-gateway
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets: ['172.30.1.2:9091']
    labels:
      service: 'prom-pushgateway'
- job_name: node-exporter
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets: ['172.30.1.2:9100']
    labels:
      service: 'node-exporter'
EOF
docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker run -d --name pushgw -p 9091:9091 prom/pushgateway
docker run -d --name=prom -p 9090:9090 -v /tmp/prometheus.yaml:/etc/prometheus/prometheus.yml prom/prometheus
docker run --cap-add=SYS_TIME -d --net="host" --pid="host" -p 9100:9100 --name=nodeexporter -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest
echo "Done" > /tmp/done.txt
