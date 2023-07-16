export PATH=$PATH:/usr/local/bin

mkdir /tmp/setup ~/.vnc

# setup metrics server
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

# setup desktop
export DEBIAN_FRONTEND=noninteractive
apt update -y
apt install -y xfce4 tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer novnc python3-websockify python3-numpy firefox

cat <<EOF >~/.vnc/xstartup
#!/bin/bash

PATH=$PATH:/usr/bin:/usr/sbin:/usr/local/bin
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4 &
EOF

sudo vncserver -localhost no -SecurityTypes None --I-KNOW-THIS-IS-INSECURE
websockify -D --web=/usr/share/novnc 9999 localhost:5901
echo "Done" > /tmp/setup/done.txt
