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
  - targets: [localhost:9091']
    labels:
      service: 'prom-pushgateway'
EOF
docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker run -d --name pushgw -p 9091:9091 prom/pushgateway
docker run -d --name=prom -p 9090:9090 -v /tmp/prometheus.yaml:/etc/prometheus/prometheus.yml prom/prometheus
echo "Done" > /tmp/done.txt
