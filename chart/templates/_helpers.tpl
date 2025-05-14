{{/*
Expand the name of the chart.
*/}}
{{- define "cratedb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cratedb.fullname" -}}
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
{{- define "cratedb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cratedb.labels" -}}
helm.sh/chart: {{ include "cratedb.chart" . }}
{{ include "cratedb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cratedb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cratedb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cratedb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cratedb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get the name of the default storage class.

Multiple storage classes can be set as default in k8s, for migration purposes.
Normally only one storageclass is set as default.
If two or more storageclasses are set as default, the first one found will be used by this function.
If no default storage class is found with the lookup, the function will return "standard" as a fallback.
*/}}
{{- define "cratedb.storageClassName" -}}
{{- $storageClassName := "" -}}
{{- if .storageClassName }}
  {{- if eq .storageClassName "storageClassPlaceholder" }} {{/* storageClassName is set to the placeholder in values.yaml */}}
    {{- $storageClasses := lookup "storage.k8s.io/v1" "StorageClass" "" "" }}
    {{- range $sc := $storageClasses.items }}
      {{- if and $sc.metadata.annotations (eq (get $sc.metadata.annotations "storageclass.kubernetes.io/is-default-class") "true") }}
        {{- $storageClassName = $sc.metadata.name }}
      {{- end }}
    {{- end }}
    {{- if eq $storageClassName "" }} {{/* no storage class found with lookup, fallback */}}
      {{- $storageClassName = "standard" }}
    {{- end }}
  {{- else }} {{/* storageClassName correctly set in values.yaml */}}
    {{- $storageClassName = .storageClassName }}
  {{- end }}
{{- else }} {{/* storageClassName not set in values.yaml (not even placeholder) */}}
  {{- $storageClasses := lookup "storage.k8s.io/v1" "StorageClass" "" "" }}
  {{- range $sc := $storageClasses.items }}
    {{- if and $sc.metadata.annotations (eq (get $sc.metadata.annotations "storageclass.kubernetes.io/is-default-class") "true") }}
      {{- $storageClassName = $sc.metadata.name }}
    {{- end }}
  {{- end }}
  {{- if eq $storageClassName "" }} {{/* no storage class found with lookup, fallback */}}
    {{- $storageClassName = "standard" }}
  {{- end }}
{{- end }}
{{- $storageClassName }}
{{- end }}
