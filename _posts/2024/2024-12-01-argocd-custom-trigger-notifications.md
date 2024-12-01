---
title: "[ArgoCD] 사용자 정의 트리거(Custom Trigger)를 활용한 알림 설정하기"
date: 2024-12-01 16:40:00 +0900
categories: [argocd]
tags: []
---

# 개요

ArgoCD에서 제공하는 기본 트리거 외에도 사용자가 새롭게 트리거를 정의하여 알림을 보낼 수 있습니다.

ArgoCD와 Argo Rollouts 모두 커스텀 트리거를 지원하며, 적용 방법은 동일하므로 이 글에서는 ArgoCD를 기준으로 설명합니다.

# 1. Notification ConfigMap 수정

## ConfigMap 파일 수정

알림 설정은 `argocd-notifications-cm`에서 수정합니다. 아래 명령어를 사용하여 ConfigMap 파일을 엽니다.

```bash
kubectl edit -n argocd argocd-notifiactions-cm
```

## Trigger 정의

`trigger.on-[custom-trigger-name]` 형식으로 트리거 이름을 정의합니다.

```yaml
trigger.on-hpa: |
  - send: [my-hpa-template]
    when: app.status.summary.images[0] == 'registry.k8s.io/hpa-example'
```

- `when` 속성: 트리거가 작동할 조건을 정의합니다.

조건으로 사용할 속성은 아래 명령어를 통해 Application 객체의 YAML 형식 데이터를 확인하여 작성할 수 있습니다.

```bash
kubectl get application [application-name] -n argocd -o yaml
```

출력 예시는 아래와 같습니다. 원하는 속성을 찾아 `when` 조건에 사용합니다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    notifications.argoproj.io/subscribe.slack-webhook: ""
    notified.notifications.argoproj.io: '{"on-hpa:[0].VYvpGSdME74Bo4AsIEiuPvsmv74:slack-webhook:":1718939481}'
  creationTimestamp: "2024-06-21T03:11:19Z"
  generation: 15
  name: demo-hpa-no-rollout
  namespace: argocd
  resourceVersion: "766904"
  uid: 07cbce87-7f9f-4ba8-a6e1-852357c3bd39
spec:
  destination:
    namespace: default
    server: https://kubernetes.default.svc
  project: default
  source:
    helm:
      valueFiles:
        - values.yaml
    path: stable/demo-hpa-no-rollout
```

## Template 정의

트리거로 발송할 메시지 템플릿을 정의합니다. 아래는 Slack Webhook으로 메시지를 전송하는 간단한 템플릿 예시입니다.

```yaml
template.my-hpa-template: |
  webhook:
    slack-webhook:
      method: POST
      body: |
        {
          "username": "ArgoCD",
          "icon_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAeUOKnPBZx5HFooCNRwRLeM_zgzLH_Sy7cQ&s",
          "attachments": [{
            "title": "Application {{.app.metadata.name}} has hpa resource",
            "color": "#800080",
            "fields": [{
              "title": "야옹",
              "value": "메옹",
              "short": true
            }]
          }]
        }
```

## ConfigMap 전체 예시

위 내용을 바탕으로 작성한 `argocd-notifications-cm` ConfigMap 예시는 아래와 같습니다.

아래의 예시는 Pod의 이미지가 `registry.k8s.io/hpa-example` 인 경우, Slack Webhook을 통해 Slack 채널에 메세지를 전송합니다.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  defaultTriggers: |
    - on-hpa

  service.webhook.slack-webhook: |
    url: [webhook-url]
    headers:
    - name: Content-Type
      value: application/json

  template.my-hpa-template: |
    webhook:
      slack-webhook:
        method: POST
        body: |
          {
            "username": "ArgoCD",
            "icon_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAeUOKnPBZx5HFooCNRwRLeM_zgzLH_Sy7cQ&s",
            "attachments": [{
              "title": "Application {{.app.metadata.name}} has hpa resource",
              "color": "#800080",
              "fields": [{
                "title": "야옹",
                "value": "메옹",
                "short": true
              }]
            }]
          }

  trigger.on-hpa: |
    - send: [my-hpa-template]
      when: app.status.summary.images[0] == 'registry.k8s.io/hpa-example'
```

# 2. Application yaml 파일 수정

## 알림 어노테이션 추가

ArgoCD를 이용해 배포할 때, Application 객체의 메타데이터 어노테이션에 알림을 추가합니다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-no-rollout
  namespace: argocd
  annotations:
    notifications.argoproj.io/subscribe.on-hpa.slack-webhook: ""
```

### 형식

- `notifications.argoproj.io/subscribe.[trigger-name].[webhook-name]: “”`

Webhook을 사용할 경우 위 형식을 사용하며, `defaultTriggers`를 사용할 경우 트리거 이름을 아래와 같이 생략할 수 있습니다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-no-rollout
  namespace: argocd
  annotations:
    notifications.argoproj.io/subscribe.[webhook-name]: ""
```

# 3. 알림 확인

위 설정에 따라 Pod 이미지가 `registry.k8s.io/hpa-example`일 경우, Slack Webhook을 통해 알림이 전송됩니다. 아래는 전송된 알림의 예시입니다.

![1.png](/assets/images/2024/2024-12-01-argocd-custom-trigger-notifications/1.png)

# 참고자료

- [Notifications](https://argo-rollouts.readthedocs.io/en/stable/features/notifications/#customization) [argo-rollouts]
