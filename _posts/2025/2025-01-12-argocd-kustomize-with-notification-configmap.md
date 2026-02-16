---
title: "[ArgoCD] Kustomize를 사용한 Notification 템플릿 관리 및 배포"
date: 2025-01-12 11:30:00 +0900
categories: [argocd]
tags: []
---

# 개요

Kustomize를 사용하면 Kubernetes 리소스를 효율적으로 구성하고 관리할 수 있습니다. 이 글에서는 ArgoCD Notification의 트리거와 템플릿 구성을 여러 ConfigMap 파일로 분리한 뒤, Kustomize를 이용해 하나의 ConfigMap으로 병합하고 배포하는 과정을 다룹니다. 이를 통해 복잡한 Notification 설정을 쉽게 관리하고, 배포 시 효율성을 높이는 방법을 배울 수 있습니다.

# ConfigMap 파일을 여러 개로 분리하기

Notification 설정의 트리거와 템플릿 종류가 다양해지면, 하나의 파일에서 모든 설정을 관리하는 것이 어렵습니다. 이를 해결하기 위해 파일을 분리한 뒤 Kustomize로 병합하는 방식을 적용했습니다.

디렉토리 구조는 아래와 같습니다.

```bash
.
├── argocd-notifications-cm.yaml       # ConfigMap의 기본 구조 정의
├── kustomization.yaml                 # 병합을 위한 Kustomize 설정 파일
├── triggers                           # 트리거별 ConfigMap 파일
│   ├── default-triggers.yaml
│   ├── on-app-created.yaml
│   ├── on-app-deleted.yaml
│   ├── on-app-deployed.yaml
│   ├── on-health-degraded.yaml
│   ├── on-sync-failed.yaml
│   └── on-sync-status-unknown.yaml
└── webhook                            # 웹훅 설정 파일
    ├── 42cluster-admin.yaml
    └── README.md
```

이 구조는 Notification 설정을 트리거와 웹훅으로 나누어 관리하는 방식입니다. `kustomization.yaml`을 이용해 이 파일들을 `argocd-notifiactions-cm.yaml` 파일에 병합한 최종 ConfigMap을 생성합니다.

# Kustomize 파일 설명

## kustomization.yaml

Kustomize 설정 파일은 병합할 리소스를 정의합니다.

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - argocd-notifications-cm.yaml

patches:
  - path: ./webhook/42cluster-admin.yaml
  - path: ./triggers/default-triggers.yaml
  - path: ./triggers/on-app-created.yaml
  - path: ./triggers/on-app-deleted.yaml
  - path: ./triggers/on-app-deployed.yaml
  - path: ./triggers/on-health-degraded.yaml
  - path: ./triggers/on-sync-failed.yaml
  - path: ./triggers/on-sync-status-unknown.yaml
```

## argocd-notifications-cm.yaml

최종 결과물이 될 ConfigMap 파일을 정의합니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
```

## triggers/default-triggers.yaml

이 파일은 ArgoCD에 배포된 리소스들에 대해 기본으로 작동할 트리거를 정의합니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  defaultTriggers: |
    - on-app-created
    - on-app-deleted
    - on-app-deployed
    - on-health-degraded
    - on-sync-failed
    - on-sync-status-unknown
```

## triggers/on-app-created.yaml

이 파일은 "Application 생성" 트리거를 정의합니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  trigger.on-app-created: |
    - send: [app-created]
      oncePer: app.metadata.name
      when: true

  template.app-created: |
    webhook:
      slack-42cluster-argocd:
        method: POST
        body: |
          {
            "username": "ArgoCD",
            "icon_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAeUOKnPBZx5HFooCNRwRLeM_zgzLH_Sy7cQ&s",
            "text": "{{.app.metadata.name}} Application 이 생성되었습니다."
          }
```

## webhook/42cluster-admin.yaml

웹훅을 설정하는 파일입니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  service.webhook.slack-42cluster-argocd: |
    url: https://hooks.slack.com/services/{Webhook URL}
    headers:
    - name: Content-Type
      value: application/json
```

# Kustomize 적용

`kustomization.yaml` 파일이 있는 위치에서 아래의 명령어를 실행하면 클러스터에 ConfigMap 이 배포됩니다.

```yaml
kubectl apply -k .
```

하나로 합쳐진 configmap 파일은 아래와 같습니다.

```yaml
apiVersion: v1
data:
  context: |
    argocdUrl: https://argocd.example.com
  defaultTriggers: |
    - on-app-created
    - on-app-deleted
    - on-app-deployed
    - on-health-degraded
    - on-sync-failed
    - on-sync-status-unknown
  service.webhook.slack-42cluster-argocd: |
    url: https://hooks.slack.com/services/{webhook URL}
    headers:
    - name: Content-Type
      value: application/json
  template.app-created: |
    webhook:
      slack-42cluster-argocd:
        method: POST
        body: |
          {
            "username": "ArgoCD",
            "icon_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAeUOKnPBZx5HFooCNRwRLeM_zgzLH_Sy7cQ&s",
            "text": "{{.app.metadata.name}} Application 이 생성되었습니다."
          }

  ...

  trigger.on-app-created: |
    - send: [app-created]
      oncePer: app.metadata.name
      when: true
kind: ConfigMap
```
