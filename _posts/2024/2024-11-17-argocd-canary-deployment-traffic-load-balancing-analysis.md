---
title: "[ArgoCD] 무중단 배포 canary 전략의 파드 개수에 따른 로드밸런싱"
date: 2024-11-17 21:10:00 +0900
categories: [argocd]
tags: []
---

# 개요

ArgoCD에서 지원하는 무중단 배포 전략 중 하나인 canary 전략을 사용해서 업데이트를 진행할 때, 파드의 개수에 따라 트래픽의 로드 밸런싱이 어떻게 이루어지는지 정리했다.

# canary

## 개념

새롭게 업데이트 하는 버전을 v2, 기존 실행하고 있는 버전을 v1이라고 해보자. canary 배포 전략에서는 v1에 보내던 트래픽을 v2로 점진적으로 옮긴다. 즉, 배포를 하는 중이라면 일부 트래픽은 v2로 가고, 나머지 트래픽은 v1으로 간다는 것이다. 이러한 특징 때문에 A/B 테스트에 사용되기도 한다.

ArgoCD의 canary 배포 전략은 v2에 새롭게 생성한 파드의 개수에 비례해서 트래픽을 분산하는 방식을 채택하고 있다.

예를 들어, 5개의 파드가 있고, 트래픽 분산 비중(weight)을 20%, 40%, 60%, 80% 점진적으로 증가시킨다고 해보자. 여기서 퍼센트는 새로운 버전으로 보낼 트래픽의 비중을 의미한다.

비중에 따른 v1, v2 버전의 파드 개수와 전체 트래픽 분산 비율은 다음의 표와 같이 변화한다.

|      | v1 파드 개수 - 전체 트래픽 비율 | v2 파드 개수 - 전체 트래픽 비율 |
| ---- | ------------------------------- | ------------------------------- |
| 0%   | 5 - 100%                        | 0 - 0%                          |
| 20%  | 5 - 80%                         | 1 - 20%                         |
| 40%  | 5 - 60%                         | 2 - 40%                         |
| 60%  | 5 - 40%                         | 3 - 60%                         |
| 80%  | 5 - 20%                         | 4 - 80%                         |
| 100% | 0 - 0%                          | 5 - 100%                        |

새로운 버전으로 업데이트가 끝날 때까지, 즉 트래픽을 100% 옮기기 전까지는 v1 버전 파드를 유지한다.

그렇기 때문에 canary 배포 전략은 blue/green 배포 전략처럼 배포하는 과정에서 리소스를 평소보다 약 2배 정도 사용해야 한다.

## 트래픽 분산 테스트

개념적으로는 이해했지만, 실제로 트래픽이 트래픽 분산 비중(weight)에 따라 분산되는지 확인하기 위해 테스트를 진행했다.

### 테스트 환경

파드는 nginx와 tcpdump를 함께 설치된 이미지로 파드를 실행했다.

weight는 20, 40, 60, 80 순으로 증가하도록 했으며, 30초 간격으로 파드를 새롭게 생성하도록 했다.

### yaml 파일 코드

Helm Chart를 이용해서 Application을 생성했다.

디렉토리 구조는 다음과 같다.

```bash
.
├── Chart.yaml
├── templates
│   ├── rollout.yaml
│   └── service.yaml
└── values.yaml
```

`rollout.yaml` 파일은 다음과 같다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: {{ .Values.app.name }}-rollout
  labels:
    app: {{ .Values.app.name }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  replicas: {{ .Values.app.replicas }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      app: {{ .Values.app.name }}
      release: {{ .Release.Name }}
  strategy:
    canary:
      canaryService: {{ .Values.app.name }}-canary
      stableService: {{ .Values.app.name }}-stable
      steps:
        - setWeight: 20
        - pause: {duration: 30s}
        - setWeight: 40
        - pause: {duration: 30s}
        - setWeight: 60
        - pause: {duration: 30s}
        - setWeight: 80
        - pause: {duration: 30s}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml .Values.podAnnotations | nindent 8 }}
      {{- end }}
      labels:
        app: {{ .Values.app.name }}
        {{- with .Values.podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
        release: {{ .Release.Name }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: {{ .Values.app.image }}
          {{- with .Values.app.resources }}
          resources:
            {{- toYaml . | nindent 10 }}
          {{- end }}
          ports:
            - name: http
              containerPort: {{ .Values.app.port }}
              protocol: TCP
```

`service.yaml` 파일은 다음과 같다.

```yaml
{{- if .Values.service.enabled }}
apiVersion: v1
kind: Service
metadata:
  labels:
    app: {{ .Values.app.name }}
  name: {{ .Values.app.name }}-canary
  namespace: {{ .Release.Namespace | quote }}
spec:
  ports:
  - port: {{ .Values.service.port }}
    protocol: TCP
    name: http
    targetPort: {{ .Values.app.port }}
  selector:
    app: {{ .Values.app.name }}
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: {{ .Values.app.name }}
  name: {{ .Values.app.name }}-stable
  namespace: {{ .Release.Namespace | quote }}
spec:
  ports:
  - port: {{ .Values.service.port }}
    protocol: TCP
    name: http
    targetPort: {{ .Values.app.port }}
  type: NodePort
  selector:
    app: {{ .Values.app.name }}
{{- end }}
```

서비스는 canary, stable 2개이며, stable 서비스는 NodePort 를 이용해서 `localhost:port` 로 접근할 수 있도록 했다.

`values.yaml` 파일은 다음과 같다.

```yaml
app:
  name: "demo-rollout"
  replicas: 2
  image: "giafar/nginx:1.25.1-tcpdump"
  port: 80
  resources:
    requests:
      cpu: "1m"
      memory: "128Mi"
    limits:
      cpu: "1m"
      memory: "128Mi"

podAnnotations: {}
podLabels:
  tier: backend

service:
  enabled: true
  port: 80
```

패킷이 들어오는지 확인하기 위해 tcpdump가 설치된 nginx 이미지를 사용했다.

각 파드에서 tcpdump 를 실행하고 `curl localhost:port` 명령어를 실행해서 패킷 수신을 확인했다.

파드 접속은 아래의 명령어를 이용했다.

```bash
kubectl exec -it -n [namespace] [pod-name] -- /bin/sh
```

### 파드가 1개일 때

v2 파드에서 tcpdump 를 실행한 상태로 `curl` 을 실행했지만, weight가 100이 될 때까지 v2 파드에는 트래픽이 분산되지 않았다.

weight가 20이면 트래픽을 v1 파드에 80%, v2 파드에 20% 분산해줄 것으로 예상했는데, 그렇지 않았다.

### 파드가 5개일 때

v1 파드에서 tcpdump 실행한 상태로 `curl` 을 실행하니 weight 가 증가할수록 점점 패킷 수신이 줄었다.

이를 통해 weight는 파드의 개수에 비례해서 분배 해주는 것 같다.

## 기타

- 파드 개수를 줄이는 것은 revision이 증가하지 않는다.
- 파드가 1개였다가 5개로 바뀌고 이미지도 같이 바뀌면 파드를 먼저 5개로 늘린 다음에 canary 로 하나씩 옮긴다.

# 참고자료

- [Kubernetes 리소스 Deployment에 대해 이해하고 실습해보기](https://velog.io/@pinion7/Kubernetes-%EB%A6%AC%EC%86%8C%EC%8A%A4-Deployment%EC%97%90-%EB%8C%80%ED%95%B4-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B3%A0-%EC%8B%A4%EC%8A%B5%ED%95%B4%EB%B3%B4%EA%B8%B0) [velog]
