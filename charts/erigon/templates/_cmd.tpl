{{/*
# Default command
*/}}
{{- define "erigon.defaultCommand" -}}
- sh
- -ac
- >
{{- if .Values.p2pNodePort.enabled }}
  . /env/init-nodeport;
{{- end }}
{{- if .Values.localRPCDaemon }}
  rpcdaemon
  --datadir=/data
  --private.api.addr=127.0.0.1:9090
  --http.addr=0.0.0.0
  --http.port={{ include "erigon.httpPort" . }}
  --http.vhosts=*
  --metrics
  --metrics.addr=0.0.0.0
  --metrics.port={{ include "erigon.metricsPortRPCDaemon" . }}
{{- range .Values.extraArgsRPCDaemon }}
  {{ . }}
{{- end }}
  &
{{- end}}
  exec erigon
  --datadir=/data
{{- if .Values.p2pNodePort.enabled }}
  --nat=extip:$EXTERNAL_IP
  --port=$EXTERNAL_PORT
{{- else }}
  --nat=extip:$(POD_IP)
  --port={{ include "erigon.p2pPort" . }}
{{- end }}
  --private.api.addr=127.0.0.1:9090
  --metrics
  --metrics.addr=0.0.0.0
  --metrics.port={{ include "erigon.metricsPort" . }}
{{- range .Values.extraArgs }}
  {{ . }}
{{- end }}
{{- end }}


{{/*
# Default command
*/}}
{{- define "erigon.defaultCommandRPCDaemon" -}}
- sh
- -ac
- >
  while ! nc -z 127.0.0.1 9090; do sleep 1; done;
  exec rpcdaemon
  --private.api.addr=127.0.0.1:9090
  --http.addr=0.0.0.0
  --http.port={{ include "erigon.httpPort" . }}
  --http.vhosts=*
  --metrics
  --metrics.addr=0.0.0.0
  --metrics.port={{ include "erigon.metricsPortRPCDaemon" . }}
{{- range .Values.extraArgsRPCDaemon }}
  {{ . }}
{{- end }}

{{- end }}
