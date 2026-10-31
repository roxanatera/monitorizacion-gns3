#!/bin/bash
rm -f /var/run/sshd.pid
if [ -n "$NODE_IP" ]; then
    ip addr add ${NODE_IP}/${NODE_MASK:-24} dev eth0 2>/dev/null
    ip link set eth0 up 2>/dev/null
fi
case "$NODE_IP" in
  *.20) S=node1 ;;
  *.21) S=node2 ;;
  *)    S=node1 ;;
esac
sed -i "s/value: node1/value: $S/" /etc/otelcol/config.yaml 2>/dev/null
/usr/sbin/sshd -E /var/log/auth.log
[ -x /usr/local/bin/node_exporter ] && ( /usr/local/bin/node_exporter >/var/log/node_exporter.log 2>&1 & )
/usr/local/bin/otelcol-contrib --config=/etc/otelcol/config.yaml >/var/log/otelcol.log 2>&1 &
exec /bin/bash
