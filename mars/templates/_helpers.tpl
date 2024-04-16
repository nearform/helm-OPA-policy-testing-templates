{{/*
Expand the name of the chart.
*/}}
{{- define "mars.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mars.fullname" -}}
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
{{- define "mars.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mars.labels" -}}
helm.sh/chart: {{ include "mars.chart" . }}
{{ include "mars.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mars.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mars.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mars.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mars.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
ConfigMaps data
*/}}
{{- define "mars.configMapData" -}}
{{- range $envKey, $envVal := .Values.env.plain }}
  {{ $envKey | upper }}: {{ $envVal | quote }}
{{- end }}
{{- end }}

{{/*
Secrets data
*/}}
{{- define "mars.secretData" -}}
{{- range $envKey, $envVal := .Values.env.secret }}
  {{ $envKey | upper }}: {{ $envVal | b64enc | quote }}
{{- end }}
{{- end }}
