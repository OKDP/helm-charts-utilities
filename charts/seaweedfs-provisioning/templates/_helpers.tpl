{{/*

 Copyright 2026 The OKDP Authors.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "seaweedfs-provisioning.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "seaweedfs-provisioning.fullname" -}}
  {{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- $name := default "seaweedfs-provisioning" .Values.nameOverride -}}
    {{- if contains $name .Release.Name -}}
      {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "seaweedfs-provisioning.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "seaweedfs-provisioning.selectorLabels" -}}
app.kubernetes.io/name: {{ include "seaweedfs-provisioning.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "seaweedfs-provisioning.labels" -}}
helm.sh/chart: {{ include "seaweedfs-provisioning.chart" . }}
{{ include "seaweedfs-provisioning.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Buckets that actually declare at least one path. Everything in this chart is
rendered only when this list is non-empty, so a release with nothing to seed
(the common case) creates no resources at all.
*/}}
{{- define "seaweedfs-provisioning.bucketsWithPaths" -}}
{{- $out := list -}}
{{- range $b := (.Values.buckets | default list) -}}
{{- if and $b.name (gt (len ($b.paths | default list)) 0) -}}
{{- $out = append $out $b -}}
{{- end -}}
{{- end -}}
{{- $out | toJson -}}
{{- end -}}

{{/*
Name of the Secret holding the credentials used by the provisioning job: either
the caller's existing Secret, or the one this chart creates from inline values.
*/}}
{{- define "seaweedfs-provisioning.credentialsSecretName" -}}
{{- if .Values.credentials.existingSecret.name -}}
{{- .Values.credentials.existingSecret.name -}}
{{- else -}}
{{- include "seaweedfs-provisioning.fullname" . -}}
{{- end -}}
{{- end -}}

{{- define "seaweedfs-provisioning.accessKeyKey" -}}
{{- if .Values.credentials.existingSecret.name -}}
{{- .Values.credentials.existingSecret.accessKeyKey -}}
{{- else -}}
accessKey
{{- end -}}
{{- end -}}

{{- define "seaweedfs-provisioning.secretKeyKey" -}}
{{- if .Values.credentials.existingSecret.name -}}
{{- .Values.credentials.existingSecret.secretKeyKey -}}
{{- else -}}
secretKey
{{- end -}}
{{- end -}}
