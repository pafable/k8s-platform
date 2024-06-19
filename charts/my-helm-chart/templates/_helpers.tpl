{{- define "my-app.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "my-app.ingressClassName" -}}
{{- default "ingress-nginx" .Values.ingressClassName | trunc 63 | trimSuffix "-" -}}
{{- end }}