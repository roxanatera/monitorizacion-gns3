# Post de LinkedIn — versión completa (recomendada)

---

🛡️ Monitorización de redes en entornos virtualizados: mi laboratorio completo con GNS3 + Prometheus + Grafana + Loki + OpenTelemetry

Como parte de la asignatura de Bastionado de Redes del Máster en Ciberseguridad he construido desde cero un sistema de observabilidad completo sobre una red emulada con GNS3 (dentro de VMware Workstation):

🔹 Dos nodos Ubuntu 24.04 dockerizados gestionados por GNS3, un switch virtual y un Ubuntu Server con todo el stack de monitorización (Prometheus, Grafana, Loki y OpenTelemetry Collector).

🔹 Métricas de sistemas (CPU, memoria y tráfico de red) recolectadas por Prometheus vía node_exporter en cada nodo.

🔹 Centralización de logs: el auth.log de cada nodo viaja por OpenTelemetry (receptor filelog → OTLP) hasta Grafana Loki, con identidad por nodo gracias al atributo service.name.

🔹 Dashboards que integran métricas y logs en la misma vista, correlacionados en el tiempo.

🔹 El remate: un ataque de fuerza bruta SSH simulado y automatizado (un intento cada 15 s desde un nodo hacia el otro), detectado por la alerta de logs:

  count_over_time({service_name=~"node1|node2"} |= "Failed password"[2m]) > 3

…más una alerta por métrica (memoria >80 %). El sistema integrado de alarmas reacciona desde ambos mundos: contenido de logs y parámetros de sistema.

Lo que más me ha enseñado este laboratorio:

1️⃣ Una fuerza bruta LENTA es invisible en el bitrate (~200 bytes por intento) pero GRITA en los logs — por eso las soc compaginan métricas y logs.
2️⃣ El 80 % del trabajo real fue diagnosticar el networking virtualizado: el tráfico se perdía por el filtrado de MAC del vswitch de VMware; lo resolví con modo promiscuo en el host y sustituyendo el sistema de puentes de GNS3 por un puente Linux del kernel con la MAC de la vNIC (patrón documentado en el issue #1869 de gns3-server).
3️⃣ Bastionar también es PERSISTIR: netplan fijando la MAC del puente, unit de systemd para los permisos de /dev/vmnet*, imagen de los nodos re-committed... Todo lo que "funcionaba salvo tras reiniciar" era algo sin persistir.

En el repo dejo el README con arquitectura, ficheros de configuración completos y las capturas de todo el laboratorio. 👇

#Ciberseguridad #BastionadoDeRedes #Monitorización #Observabilidad #GNS3 #Prometheus #Grafana #Loki #OpenTelemetry #SOC #MasterEnCiberseguridad #Homelab

---

# Versión CORTA (si prefieres algo más ágil)

---

🛡️ ¿Cómo detectarías una fuerza bruta SSH lenta (un intento cada 15 s)? A ojo: invisible. En los logs: un fuego 🔥.

Para la asignatura de Bastionado de Redes he montado un laboratorio completo de monitorización con GNS3 (dos Ubuntu dockerizados + Ubuntu Server corriendo Prometheus, Grafana, Loki y OpenTelemetry):

✅ Métricas por nodo (CPU/memoria/red) con Prometheus + node_exporter
✅ auth.log centralizado vía OpenTelemetry en Loki
✅ Dashboards que mezclan métricas y logs
✅ Alertas integradas por logs (fuerza bruta SSH con LogQL) y por métricas (memoria alta)

El ataque simulado corre en bucle y la alerta salta sola. Arriba: el dashboard con el ataque en vivo y la topología GNS3.

README + configs en el repo ⬇️
#Ciberseguridad #Homelab #GNS3 #Grafana #Observabilidad

---

## 📋 Checklist al publicar

1. Subir el repo: dentro de `~/proyecto-monitorizacion/`:
   ```bash
   git init && git add . && git commit -m "Laboratorio de monitorización GNS3/OBS"
   # crear el repo en github.com y:
   git remote add origin git@github.com:TU_USUARIO/TU_REPO.git
   git push -u origin main
   ```
2. En LinkedIn adjuntar **3 imágenes**: la topología GNS3 (`imagenes/fig04_topologia_arrancada_verde.png`), el dashboard con ataque (`imagenes/fig42_dashboard_gauges_rx.png`) y el panel de logs en tabla (`imagenes/fig44_authlog_tabla_ataque.png`).
3. **Primer comentario** (añade profundidad: mucha gente lee comentarios): pisa el trozo de las queries LogQL/PromQL y la CTA del repo.
4. Etiquetar (opcional) al profesor/la asignatura si se puede, y programar la publicación martes- jueves 9-11 h (mejor tráfico B2B).
5. Antes de publicar: en tu perfil y el repo **no pueden aparecer** contraseñas de laboratorio — limpia capturas si las hay.
