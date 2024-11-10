---
title: "[ArgoCD] 무중단 배포 전략과 함께 HPA 적용하기"
date: 2024-11-10 15:50:00 +0900
categories: [argocd]
tags: []
---

# 개요

Kubernetes의 HPA(Horizontal Pod Autoscaler) 객체를 활용하여 무중단 배포 전략(Rolling Update, Canary)을 설정하고, 오토스케일링을 구현하는 방법을 정리했다.

# HPA 개념

![1.png](/assets/images/2024/2024-11-10-argocd-hpa-with-autoscaling-strategies/1.png)

출처: [Was ist (Kubernetes) Autoscaling? VPA vs. HPA](https://www.kreyman.de/index.php/kubernetes/249-was-ist-kubernetes-autoscaling) [kreyman]

HPA(Horizontal Pod Autoscaler)는 특정 파드에 부하가 발생했을 때 동일한 성능의 파드를 추가로 생성해 부하를 분산하는 Kubernetes 객체이다. CPU 사용률, 메모리 사용률 등을 기준으로 파드 생성(스케일 아웃)을 판단하며, 부하가 줄어들면 일정 시간 후 파드 수를 줄이는(스케일 인) 방식으로 작동한다.

![2.png](/assets/images/2024/2024-11-10-argocd-hpa-with-autoscaling-strategies/2.png)

출처: [[Kubernetes] 쿠버네티스 HPA 개념과 구성 (HorizontalPodAutoscaler, 오토스케일러)](https://nirsa.tistory.com/187) [티스토리]

HPA는 `metrics-server`에서 수집한 파드 메트릭을 바탕으로 추가할 파드 개수를 계산하여 오토스케일링을 수행한다.

# metrics-server 설치

![3.png](/assets/images/2024/2024-11-10-argocd-hpa-with-autoscaling-strategies/3.png)

출처: [Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/) [kubernetes.io]

HPA는 `metrics-server`가 수집한 메트릭 데이터를 활용해 오토 스케일링을 수행한다. `metrics-server`는 각 노드에서 실행되는 `kubelet` 에 있는 `cAdvisor` 를 통해 메트릭을 수집하고, Kubernetes API 서버에 전달한다. API 서버는 이 메트릭을 바탕으로 오토스케일링을 수행하거나, 사용자가 `kubectl top` 명령어로 메트릭을 조회할 수 있도록 한다.

## cAdvisor

![4.png](/assets/images/2024/2024-11-10-argocd-hpa-with-autoscaling-strategies/4.png)

출처: [Datadog](https://github.com/DataDog/the-monitor/blob/master/kubernetes/how-to-collect-and-graph-kubernetes-metrics.md) [github]

cAdvisor는 Container Advisor의 약자로, 컨테이너의 리소스 사용량과 성능을 모니터링하는 데몬 프로그램이다. Kubernetes뿐만 아니라 Docker 환경에서도 사용할 수 있다. Kubernetes에서는 파드 안에서 컨테이너가 실행될 수 있도록 하는 `kubelet`에 `cAdvisor`가 함께 포함되어 있어 파드와 노드의 메트릭을 수집해 오토스케일링을 수행할 수 있도록 한다.

## 설치 방법

아래의 명령어로 `metrics-server` 를 설치한다.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

이후, 다음 명령어로 설정을 수정한다.

```bash
kubectl edit deployments.apps -n kube-system metrics-server
```

`spec.template.spec.containers.args` 항목에 다음 옵션을 추가한다.

```bash
--kubelet-insecure-tls
--kubelet-preferred-address-types=InternalIP, ExternalIP, Hostname
```

정상적으로 설치되었는지 아래 명령어로 확인한다.

```bash
kubectl top nodes
#NAME              CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
#k8s-master-node   557m         27%    2957Mi          77%
```

# yaml 파일 작성

무중단 배포 전략에 따라 HPA 설정 방식이 달라진다.

`Rolling Update` 전략에는 `Deployment` 객체를, `Canary` 및 `Blue/Green` 배포 전략에는 `Rollout` 객체를 사용하여 HPA를 설정한다. 아래는 Helm Chart 템플릿 파일을 작성하는 방법이다.

## Rolling Update

### 디렉토리 구조

`Rolling Update` 전략에서는 `Deployment` 객체를 사용한다. 디렉토리 구조는 다음과 같다.

```bash
.
├── demo-hpa-no-rollout
│   ├── Chart.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── hpa.yaml
│   │   └── service.yaml
│   └── values.yaml
└── demo-hpa-no-rollout-application.yaml
```

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.app.name }}-deployment
  labels:
    app: {{ .Values.app.name }}
  namespace: {{ .Release.Namespace | quote }}
spec:
# replicas: {{ .Values.app.replicas }} # HPA 사용하려면 제거해야함
  selector:
    matchLabels:
      app: {{ .Values.app.name }}
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
    spec:
      containers:
      - image: {{ .Values.app.image }}
        name: {{ .Values.app.name }}
        {{- with .Values.app.resources }}
        resources: # 반드시 있어야 함
          {{- toYaml . | nindent 10 }}
        {{- end }}
        ports:
          - name: http
            protocol: TCP
            containerPort: {{ .Value.app.port }}
```

### hpa.yaml

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.app.name }}-hpa
spec:
  minReplicas: {{ .Values.app.minReplicas }}
  maxReplicas: {{ .Values.app.maxReplicas }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Values.app.name }}-deployment
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: {{ .Values.app.averageUtilization }}
        type: Utilization
```

- `spec.minReplicas`: 최소 파드 수
- `spec.maxReplicas`: 최대 파드 수
- `spec.scaleTargetRef`
  - `apiVersion`: Deployment 에 해당하는 `apps/v1` 작성
  - `kind`: `Deployment` 작성
  - `name`: Deployment 객체의 metadata.name 에 해당하는 값 입력
- `spec.replicas`: HPA 적용 시 제거해야 하며, 파드 개수는 HPA 가 관리한다.
  - 참고자료: https://argo-cd.readthedocs.io/en/release-1.8/user-guide/best_practices/#leaving-room-for-imperativeness
- `spec.template.spec.containers.resources`: HPA 는 메트릭을 기준으로 작동하기 때문에 `request` 와 `limit` 를 반드시 입력해야 한다.

### service.yaml

```yaml
{{- if .Values.service.enabled }}
apiVersion: v1
kind: Service
metadata:
  labels:
    app: {{ .Values.app.name }}
  name: {{ .Values.app.name }}
  namespace: {{ .Release.Namespace | quote }}
spec:
  ports:
  - port: {{ .Values.service.port }}
    protocol: TCP
    name: http
    targetPort: {{ .Values.app.port }}
  selector:
    app: {{ .Values.app.name }}
{{- end }}
```

### demo-hpa-no-rollout-application.yaml

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-no-rollout
  namespace: argocd
spec:
  project: default
  source:
    path: demo-hpa-no-rollout
    repoURL: https://github.com/[org]/[repository]
    targetRevision: HEAD
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated: {}
```

### values.yaml

```yaml
app:
  name: "demo-hpa-no-rollout"
  image: "argoproj/rollouts-demo:blue"
  port: 80
  minReplicas: 1
  maxReplicas: 4
  averageUtilization: 30
  resources:
    requests:
      cpu: "200m"
      memory: "128Mi"
    limits:
      cpu: "500m"
      memory: "128Mi"

podAnnotations: {}
podLabels:
  tier: backend

service:
  enabled: true
  port: 80
```

## Canary 전략

Blue/Green 전략도 Canary와 설정하는 방법은 비슷하기 때문에 생략했다.

### 디렉토리 구조

`Canary` 전략에서는 `Deployment` 객체 대신 `Rollout` 객체를 사용한다. 디렉토리 구조는 다음과 같다.

```bash
.
├── demo-hpa-with-rollout
│   ├── Chart.yaml
│   ├── templates
│   │   ├── hpa.yaml
│   │   ├── rollout.yaml
│   │   └── service.yaml
│   └── values.yaml
└── demo-hpa-with-rollout-application.yaml
```

### hpa.yaml

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.app.name }}-hpa
spec:
  minReplicas: {{ .Values.app.minReplicas }}
  maxReplicas: {{ .Values.app.maxReplicas }}
  scaleTargetRef:
    apiVersion: argoproj.io/v1alpha1
    kind: Rollout
    name: {{ .Values.app.name }}-rollout
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: {{ .Values.app.averageUtilization }}
        type: Utilization
```

- `spec.scaleTargetRef`
  - `apiVersion`: Rollout 에 해당하는 `argoproj.io/v1alpha1` 작성
  - `kind`: `Rollout` 작성
  - `name`: Rollout 객체의 `metadata.name` 에 해당하는 값 입력

### rollout.yaml

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
# replicas: {{ .Values.app.replicas }} # HPA 사용하려면 제거해야함
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
        - pause: {duration: 2s}
        - setWeight: 40
        - pause: {duration: 2s}
        - setWeight: 60
        - pause: {duration: 2s}
        - setWeight: 80
        - pause: {duration: 2s}
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
          resources: # 반드시 입력
            {{- toYaml . | nindent 12 }}
          {{- end }}
          ports:
            - name: http
              containerPort: {{ .Values.app.port }}
              protocol: TCP
```

- `spec.replicas`: 마찬가지로 HPA 를 적용하려면 해당 속성을 사용하지 않아야 한다.
- `spec.template.spec.containers.resources`: 마찬가지로 request 와 limit 를 반드시 입력해주어야 한다.

### service.yaml

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

### values.yaml

```yaml
app:
  name: "demo-hpa-with-rollout"
  image: "argoproj/rollouts-demo:blue"
  port: 80
  minReplicas: 1
  maxReplicas: 4
  averageUtilization: 30
  resources:
    requests:
      cpu: "200m"
      memory: "128Mi"
    limits:
      cpu: "500m"
      memory: "128Mi"

podAnnotations: {}
podLabels:
  tier: backend

service:
  enabled: true
  port: 80
```

### demo-hpa-with-rollout-application.yaml

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-with-rollout
  namespace: argocd
spec:
  project: default
  source:
    path: demo-hpa-with-rollout
    repoURL: https://github.com/[org]/[repository]
    targetRevision: HEAD
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated: {}
```

# 부하 테스트

Helm Chart를 이용해 애플리케이션을 배포하고, HPA가 작동하는지 확인하기 위해 부하를 발생시킨다. 서비스 도메인으로 다음 명령어를 실행한다.

```bash
kubectl run -i --tty load-generator \
--rm \
--image=busybox:1.28 \
--restart=Never \
-- /bin/sh -c "while sleep 0.01; do wget -q -O- http://[service-name].[namespace].svc; done"
```

부하가 발생하고 나서 `kubectl top pod` 명령어를 실행해 파드가 자동으로 생성된 것을 확인한다. (초기 파드 개수 1개, 최대 파드 개수 4개)

```bash
kubectl top pod
#NAME                                CPU(cores)   MEMORY(bytes)
#demo-hpa-rollout-7449969d75-7jdgl   151m         17Mi
#demo-hpa-rollout-7449969d75-db4vg   174m         19Mi
#demo-hpa-rollout-7449969d75-dnvt2   142m         11Mi
#demo-hpa-rollout-7449969d75-xvrns   143m         11Mi
#load-generator                      24m          1Mi
```
