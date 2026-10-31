FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
      openssh-server prometheus-node-exporter curl ca-certificates \
    && useradd -ms /bin/bash student \
    && echo "student:changeme" | chpasswd \
    && sed -i 's/#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN curl -sLo /tmp/otelcol.tgz \
      $(curl -s https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest \
      | grep -oP 'https://[^"]+otelcol-contrib_linux_amd64\.tar\.gz' | head -1) \
    && tar -xzf /tmp/otelcol.tgz -C /usr/local/bin otelcol-contrib
COPY otelcol-agent.yaml /etc/otelcol/config.yaml
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
