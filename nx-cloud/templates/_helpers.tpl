{{/*
The following label/annotation helpers are just the basic ones you get from your
first `helm init` slightly modified for our own names and patterns
*/}}

{{- define "nxCloud.app.name" }}
{{- default .Chart.Name .Values.naming.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "nxCloud.app.fullName" }}
{{- if .Values.naming.fullNameOverride }}
{{- .Values.naming.fullNameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.naming.nameOverride }}
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
{{- define "nxCloud.app.chartName" }}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{/*
Common labels
*/}}
{{- define "nxCloud.app.labels" }}
helm.sh/chart: {{ include "nxCloud.app.chartName" . }}
{{- include "nxCloud.app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nxCloud.app.selectorLabels" }}
app.kubernetes.io/name: {{ include "nxCloud.app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Below are various little env snippets that multiple mainifests make use of
*/}}

{{- define "nxCloud.env.aggregatorBilling" }}
{{- if ((.Values.billing).overrides) }}
{{- if .Values.billing.overrides.disableCreateBillingRecords }}
- name: NX_CLOUD_AGGREGATOR_DISABLE_CREATE_BILLING_RECORDS
  value: '{{ .Values.billing.overrides.disableCreateBillingRecords }}'
{{- end }}
{{- if .Values.billing.overrides.forceCreateBillingRecords }}
- name: NX_CLOUD_AGGREGATOR_FORCE_CREATE_BILLING_RECORDS
  value: '{{ .Values.billing.overrides.forceCreateBillingRecords }}'
{{- end }}
{{- if .Values.billing.overrides.disableProcessBilling }}
- name: NX_CLOUD_AGGREGATOR_DISABLE_PROCESS_BILLING
  value: '{{ .Values.billing.overrides.disableProcessBilling }}'
{{- end }}
{{- if .Values.billing.overrides.forceProcessBilling }}
- name: NX_CLOUD_AGGREGATOR_FORCE_PROCESS_BILLING
  value: '{{ .Values.billing.overrides.forceProcessBilling }}'
{{- end }}
{{- if .Values.billing.overrides.disableWarnFreePlanOrgs }}
- name: NX_CLOUD_AGGREGATOR_DISABLE_WARN_FREE_PLAN_ORGS
  value: '{{ .Values.billing.overrides.disableWarnFreePlanOrgs }}'
{{- end }}
{{- if .Values.billing.overrides.forceWarnFreePlanOrgs }}
- name: NX_CLOUD_AGGREGATOR_FORCE_WARN_FREE_PLAN_ORGS
  value: '{{ .Values.billing.overrides.forceWarnFreePlanOrgs }}'
{{- end }}
{{- end }}
{{- end}}

{{- define "nxCloud.env.mongoSecrets" }}
{{- if .Values.secret.name }}
- name: NX_CLOUD_MONGO_SERVER_ENDPOINT
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secret.name }}
      key: {{ .Values.secret.nxCloudMongoServerEndpoint }}
{{- else }}
- name: SECRET_FILE_NX_CLOUD_MONGO_SERVER_ENDPOINT
  value: {{ .Values.secret.nxCloudMongoServerEndpoint }}
{{- end }}
{{- end }}

{{- define "nxCloud.env.mode" }}
{{- if .Values.mode }}
- name: NX_CLOUD_MODE
  value: '{{ .Values.mode }}'
{{- end }}
{{- end }}

{{- define "nxCloud.env.nxCloudAppUrl" }}
- name: NX_CLOUD_APP_URL
  value: {{ .Values.nxCloudAppURL }}
{{- end }}

{{- define "nxCloud.env.verboseLogging" }}
{{- if .Values.verboseLogging }}
- name: NX_VERBOSE_LOGGING
  value: 'true'
- name: NX_API_LOG_LEVEL
  value: 'DEBUG'
{{- end }}
{{- end }}

{{- define "nxCloud.env.verboseMongoLogging" }}
{{- if .Values.verboseMongoLogging }}
- name: NX_MONGO_LOG_LEVEL
  value: 'DEBUG'
{{- end }}
{{- end }}