{{/*
Validate that required values are supplied via --set (or values file)
*/}}
{{- define "requiredValues" -}}
  {{- if not .Values.clusterName -}}
    {{- fail "clusterName is REQUIRED. Use --set clusterName=..." -}}
  {{- end -}}
  {{- if not .Values.username -}}
    {{- fail "username is REQUIRED. Use --set username=..." -}}
  {{- end -}}
  {{- if not .Values.prometheusUrl -}}
    {{- fail "prometheusUrl is REQUIRED. Use --set prometheusUrl=..." -}}
  {{- end -}}
  {{- if not .Values.lokiUrl -}}
    {{- fail "lokiUrl is REQUIRED. Use --set lokiUrl=..." -}}
  {{- end -}}
  {{- if not .Values.endpoint -}}
    {{- fail "endpoint is REQUIRED. Use --set endpoint=..." -}}
  {{- end -}}
  {{- if not .Values.providerName -}}
    {{- fail "providerName is REQUIRED. Use --set providerName=..." -}}
  {{- end -}}
  {{- if not .Values.agentId -}}
    {{- fail "agentId is REQUIRED. Use --set agentId=..." -}}
  {{- end -}}
  {{- if not .Values.apiKey -}}
    {{- fail "apiKey is REQUIRED. Use --set apiKey=..." -}}
  {{- end -}}
  {{- if not .Values.tags -}}
    {{- fail "tags is REQUIRED. Use --set tags='{prod,dev}'" -}}
  {{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mychart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mychart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mychart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mychart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "mychart.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}
