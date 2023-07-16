# Create config file for pushgw
export PATH=$PATH:/usr/local/bin
mkdir /tmp/setup

# setup metrics
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml -P /tmp/setup
sed -i -e 's/        - --metric-resolution=15s/        - --metric-resolution=15s\n        - --kubelet-insecure-tls/g' /tmp/setup/components.yaml
kubectl apply -f /tmp/setup/components.yaml

# setup grafana
docker run -d --name=grafana -p 3000:3000 grafana/grafana

# setup prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
cat <<EOF >/tmp/setup/values.yaml
grafana:
  enabled: false
alertmanager:
  enabled: false
prometheus:
  service:
      type: NodePort
EOF

kubectl create ns monitoring
helm install prom prometheus-community/kube-prometheus-stack -f /tmp/setup/values.yaml -n monitoring
sleep 60

echo "Done" > /tmp/setup/done.txt
