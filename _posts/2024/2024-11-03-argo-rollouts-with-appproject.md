---
title: "[ArgoCD] RBAC 적용을 위한 AppProject와 무중단 배포를 위한 Argo Rollouts 함께 사용하기"
date: 2024-11-03 17:20:00 +0900
categories: [argocd]
tags: []
---

# Argo Rollouts 설치(helm)

## 1. 플레인 쿠버네티스

`argo-rollouts` 네임스페이스 생성 후 설치

```bash
kubectl create ns argo-rollouts
helm install argo-rollouts argo/argo-rollouts --version 2.35.1 --namespace argo-rollouts
```

## 2. EKS

Argo Rollouts 대시보드까지 함께 보고 싶다면 values 파일을 아래와 같이 추가해서 사용 가능.

```bash
cat <<EOT > argorollouts-values.yaml
dashboard:
  enabled: true
  ingress:
    enabled: true
    ingressClassName: alb
    hosts:
      - argorollouts.$MyDomain
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/backend-protocol: HTTP
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":80}, {"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: $CERT_ARN
      alb.ingress.kubernetes.io/ssl-redirect: '443'
EOT
```

위의 파일을 토대로 아래 명령어 실행

```bash
kubectl create ns argo-rollouts
helm install argo-rollouts argo/argo-rollouts --version 2.35.1 -f argorollouts-values.yaml --namespace argo-rollouts
```

# Argo Rollouts CLI 설치

Argo Rollouts 을 설치하기 위한 사전 조건은 아래와 같다.

1. `kubectl` 설치
2. `kubeconfig` 파일이 `~/.kube/config` 디렉토리에 존재
3. 쿠버네티스 클러스터에 ArgoCD 설치 완료

아래의 명령어 실행해서 CLI 설치

```bash
curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
```

설치 확인을 위해 아래의 명령어 실행

```bash
kubectl argo rollouts version
#kubectl-argo-rollouts: v1.6.6+737ca89
#  BuildDate: 2024-02-13T15:39:31Z
#  GitCommit: 737ca89b42e4791e96e05b438c2b8540737a2a1a
#  GitTreeState: clean
#  GoVersion: go1.20.14
#  Compiler: gc
#  Platform: linux/amd64
```

# AppProject + Rollout

Project 에 Rollout 으로 애플리케이션을 배포하는 작업을 위해 helm chart 를 이용했다.

## 디렉토리 구조

디렉토리 구조는 아래와 같다.

```bash
.
├── demo-rollout
│   ├── Chart.yaml
│   ├── templates
│   │   ├── ingress.yaml
│   │   ├── rollout.yaml
│   │   └── service.yaml
│   └── values.yaml
└── demo-rollout-application.yaml
```

## application.yaml

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-rollout
  namespace: argocd
spec:
  project: demo-project
  source:
    path: stable/demo-rollout
    repoURL: https://github.com/42Cluster-Seoul/helm-charts
    targetRevision: HEAD
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: morning-glory
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## values.yaml

```yaml
app:
  name: "demo-rollout"
  replicas: 5
  image: "argoproj/rollouts-demo:blue"
  port: 8080 # 애플리케이션의 포트 번호에 맞게 설정
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

ingress:
  enabled: true
  className: nginx
  host: "localhost"
  path: /
  pathType: Prefix

service:
  enabled: true
  port: 80
```

## templates

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
      trafficRouting:
        nginx:
          stableIngress: {{ .Values.app.name }}-stable
      stpes:
        - setWeight: 20
        - pause: {}
        - setWeight: 40
        - pause: {duration: 5s}
        - setWeight: 60
        - pause: {duration: 5s}
        - setWeight: 80
        - pause: {duration: 5s}
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
  selector:
    app: {{ .Values.app.name }}
{{- end }}
```

### ingress.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Values.app.name }}-stable
  namespace: {{ .Release.Namespace }}
  annotations:
    kubernetes.io/ingress.class: {{ .Values.ingress.className }}
spec:
  ingressClassName: {{ .Values.ingress.className }}
  rules:
  # - host: {{ .Values.ingress.host }} # ALB 적용 시 사용
   - http:
      paths:
      - path: {{ .Values.ingress.path }}
        pathType: {{ .Values.ingress.pathType }}
        backend:
          service:
            name: {{ .Values.app.name }}-stable
            port:
              number: {{ .Values.service.port }}
```

## 배포

아래의 명령어를 실행해서 애플리케이션을 배포한다.

```bash
kubectl create -f demo-rollout-application.yaml
```

## 배포 확인

![1.png](/assets/images/2024/2024-11-03-argo-rollouts-with-appproject/1.png)

ArgoCD 대시보드에서 배포가 된 것을 확인할 수 있다.

- Ingress 가 계속 Progressing 으로 표시되는 현상
  ArgoCD 에서 health 라고 표시하는 조건을 LoadBalancer 의 개수가 0개 이상으로 걸려있어서 발생하는 현상이라고 한다.
  - 참고자료: [ArgoCD app stuck in Progressing for ingress workloads with no LB IP address](https://github.com/argoproj/argo-cd/issues/14607) [github]
    실제로 배포된 Ingress 의 manifest 를 살펴보면 아래와 같이 되어 있다.
  ```yaml
  status:
    loadBalancer: {}
  ```
  EKS 가 아닌 로컬에서 nginx ingress 를 사용하기 때문에 임시방편으로 argocd-cm 을 수정해서 사용할 수 있다.
  ```yaml
  kubectl -n argocd edit configmap argocd-cm
  ```
  data 속성에 아래의 값을 추가한다.
  ```yaml
  data:
  	...
    resource.customizations: |
      networking.k8s.io/Ingress:
          health.lua: |
            hs = {}
            hs.status = "Healthy"
            return hs
  ```

nginx ingress 를 이용해서 접속하기 위해 nginx ingress controller 의 node port 번호를 확인한다.

```bash
kubectl get svc -n ingress-nginx
#NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
#ingress-nginx-controller             LoadBalancer   10.105.48.107    <pending>     80:32269/TCP,443:31321/TCP   4h22m
```

위의 예시에서는 32269번이므로 브라우저에서 `localhost:32269` 로 접속한다.

![2.png](/assets/images/2024/2024-11-03-argo-rollouts-with-appproject/2.png)

- 계속 Out of Sync 로 표시되는 현상

  Github Repository 와 쿠버네티스 클러스터에 배포한 애플리케이션의 상태가 다르지 않음에도 지속적으로 Out of Sync 가 발생하는 현상이 있었다.

  원인은 canary 배포 전략에 `steps` 속성을 `stpes` 로 잘못 입력한 것이었다.

  ```diff
  canary:
        canaryService: {{ .Values.app.name }}-canary
        stableService: {{ .Values.app.name }}-stable
        trafficRouting:
          nginx:
            stableIngress: {{ .Values.app.name }}-stable
  -     stpes
  +     steps:
  		    - setWeight: 20
  	        - pause: {}
  	        - setWeight: 40
  	        - pause: {duration: 5s}
  	        - setWeight: 60
  	        - pause: {duration: 5s}
  	        - setWeight: 80
  	        - pause: {duration: 5s}
  ```

- Canary 배포 전략을 적용했지만, 이미지를 바꾸었을 때 revision 1 에서 2 가 아닌 3 으로 가는 오류가 있다.

  Ingress 를 제거하니 해당 현상이 사라졌다.

  트래픽 라우팅과 관련해서 문제가 있었던 것 같은데, ALB 와 연동해서 어떻게 작동할 지 확인해야 할 것 같다.

- `kubectl delete -f rollout-application.yaml` 명령어로 삭제해도 rollout 이 삭제되지 않는 현상
  `kubectl delete` 명령어를 이용해서 Rollout 을 삭제하면 웹 대시보드에서는 보이지 않지만, CLI 로 조회를 해보면 여전히 남아있는 문제가 있다.
  ```bash
  kubectl get rollout -n morning-glory
  #NAME                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
  #demo-rollout-rollout   5         5         5            5           8m8s
  ```
  아래의 명령어를 실행해서 직접 삭제했다.
  ```bash
  kubectl delete rollout demo-rollout-rollout -n morning-glory
  ```
  또는, ArgoCD 웹 대시보드에서 애플리케이션을 직접 삭제하면 된다.

# Argo Rollout 대시보드 접속

아래의 명령어 실행

```bash
kubectl argo rollouts dashboard
```

`localhost:3100/rollouts/{namespace}` 로 접속하면 대시보드 확인할 수 있다.

또한, 배포를 수동으로 해주어야 하는 경우 promote 를 해줄 수 있다.

![3.png](/assets/images/2024/2024-11-03-argo-rollouts-with-appproject/3.png)

이전 버전으로 되돌리는 rollback 도 rollout 대시보드에서 가능하다.

rollback 은 ArgoCD 대시보드에서도 가능하지만, promote 를 하는 건 rollout 대시보드에서만 가능하다.

# 참고자료

- [[k8s] Nginx Ingress Controller를 사용한 Ingress 구축](https://velog.io/@dhkim1522/k8s-%EC%9D%B8%EA%B7%B8%EB%A0%88%EC%8A%A4-%EC%BB%A8%ED%8A%B8%EB%A1%A4%EB%9F%AC-ingress-controller-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0) [velog]
- [Ingress-Nginx Controller](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start) [kubernetes.github.io]
- [argo-rollouts getting started nginx example](https://github.com/argoproj/argo-rollouts/blob/master/docs/getting-started/nginx/index.md) [github]
- [UI Dashboard](https://argo-rollouts.readthedocs.io/en/stable/dashboard/) [argo-rollouts]
