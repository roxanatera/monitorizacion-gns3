# Post FINAL de LinkedIn — copiar tal cual 👇

🛡️ Monitorización y detección en redes virtualizadas: laboratorio completo con GNS3 + Prometheus + Grafana + Loki + OpenTelemetry

Para la asignatura de Bastionado de Redes del Máster en Ciberseguridad he construido desde cero un laboratorio que integra observabilidad y detección sobre una red emulada con GNS3 (dentro de VMware Workstation):

🔹 Dos nodos Ubuntu 24.04 dockerizados gestionados por GNS3, un switch virtual y un Ubuntu Server corriendo Prometheus, Grafana, Loki y OpenTelemetry Collector.

🔹 Métricas de sistemas (CPU, memoria, tráfico de red) recogidas por Prometheus vía node_exporter en cada nodo.

🔹 Centralización de logs: el auth.log de cada nodo viaja por OpenTelemetry (receptor filelog → OTLP) hasta Grafana Loki, con identidad por nodo.

🔹 Dashboards que integran métricas y logs en la misma vista, correlacionados en el tiempo.

🔹 El remate — un ataque de fuerza bruta SSH simulado y automatizado (un intento cada 15 s desde un nodo hacia el otro), detectado por una alerta construida directamente sobre los logs:

   count_over_time({service_name=~"node1|node2"} |= "Failed password"[2m]) > 3

…más una alerta por métrica (memoria >80 %): el sistema integrado de alarmas reacciona desde los dos mundos.

Lo que más me ha enseñado este laboratorio:

1️⃣ Una fuerza bruta LENTA es invisible en el bitrate (un par de cientos de bytes por intento) pero GRITA en los logs — por eso SOC säger juntos métricas y logs.

2️⃣ El 80 % del trabajo real fue diagnosticar el networking virtualizado: el tráfico entre el server y los contenedores se perdía por el filtrado de MAC del vswitch de VMware. Lo resolví habilitando el modo promiscuo en el host y sustituyendo el sistema de puentes de GNS3 por un puente Linux del kernel con la MAC del vNIC (patrón documentado en el issue #1869 de gns3-server).

3️⃣ Bastionar también es PERSISTIR: netplan fijando la MAC del puente, unit de systemd para los permisos de /dev/vmnet*, imagen de los nodos re-committed… Todo lo que "funcionaba salvo tras reiniciar" era algo sin persistir.

📎 Todo el laboratorio está en el repo: README con arquitectura y galería, ficheros de configuración completos (Dockerfile, agente/central OTel, Loki, Prometheus, netplan, units de systemd), el informe técnico con capturas y la simulación de ataque documentada:
👉 https://github.com/roxanatera/monitorizacion-gns3

#Ciberseguridad #BastionadoDeRedes #Observabilidad #GNS3 #Prometheus #Grafana #Loki #OpenTelemetry #SOC #MasterEnCiberseguridad #Homelab

---

## Preparar el post (checklist en tu app de LinkedIn)

1. **Adjunta estas 3 imágenes** (están en ~/proyecto-monitorizacion/imagenes/):
   - fig04_topologia_arrancada_verde.png — topología GNS3 (ahora la definitiva en verde)
   - fig42_dashboard_gauges_rx.png — dashboard con gauges de CPU y Red RX
   - fig44_authlog_tabla_ataque.png — el panel auth.log en tabla durante el ataque

2. **Primer comentario** (publica el post y entra enseguida este comentario):
   > Detalles técnicos para quien quiera reproducirlo: métricas via node_exporter → Prometheus (scrape 15 s); logs via otelcol agente (filelog sobre /var/log/auth.log con atributo service.name=node1|node2) → OTLP :4318 → collector central → Loki (/otlp nativo); alertas en Grafana Alerting con LogQL y PromQL. En el repo están TODOS los ficheros de configuración y el informe técnico:
   > https://github.com/roxanatera/monitorizacion-gns3

3. **Etiquetas al repo si me quedan por añadir**:
   ```bash
   gh repo edit roxanatera/monitorizacion-gns3 \
     --add-topic ciberseguridad --add-topic gns3 --add-topic observabilidad \
     --add-topic prometheus --add-topic grafana --add-topic loki \
     --add-topic opentelemetry --add-topic hardening --add-topic soc
   ```
4. Publica **martes-jueves de 9:00 a 11:30** (mejor tráfico técnico en LinkedIn).
5. Revisa antes que ninguna captura del post/muestra contraseñas; las de laboratorio (changeme) son triviales, pero siempre pueden quedar "limpias" en el repo.
