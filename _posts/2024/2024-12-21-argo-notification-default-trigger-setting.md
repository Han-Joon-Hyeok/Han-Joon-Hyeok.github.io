---
title: "[ArgoCD] Notification default trigger 설정 방법"
date: 2024-12-21 17:10:00 +0900
categories: [argocd]
tags: []
---

# 개요

ArgoCD Notification 기능을 활용하면 배포하는 애플리케이션에 대해 기본으로 작동할 트리거를 설정할 수 있습니다. 기본 트리거를 설정하면 모든 Application 객체나 Rollout 객체에 동일한 트리거를 한 번에 설정할 수 있어 설정 과정이 간소화됩니다.

## default trigger 적용 전

```yaml
# demo-hpa-rollout.yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-rollout
  namespace: argocd
  annotations:
    # 알림으로 받고자 하는 트리거 종류와 메세지 템플릿을 지정해야 한다.
    notifications.argoproj.io/subscribe.on-hpa.slack-webhook: ""
    notifications.argoproj.io/subscribe.on-rollout-completed.slack-webhook: ""
```

`metadata.annotations` 속성에 알림을 받고자 하는 트리거와 메세지 템플릿을 `subscribe.[trigger].[webhook-name]` 형식으로 작성해야 합니다.

## default trigger 적용 후

```yaml
# demo-hpa-rollout.yaml

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-hpa-rollout
  namespace: argocd
  annotations:
    # 알림으로 받고자 하는 메세지 템플릿만 지정한다.
    notifications.argoproj.io/subscribe.slack-webhook: ""
```

기본 트리거(default trigger)를 지정하면, 위와 같이 `subscribe.[webhook-name]` 형식으로 트리거 종류를 생략할 수 있습니다.

# default trigger 적용하기

ArgoCD와 Argo Rollouts 모두 설정 방법은 동일하기 때문에 본문에서는 Argo Rollouts을 기준으로 작성했습니다.

## Rollouts Notification ConfigMap 수정

`notification-configmap` 파일에서 `data.defaultTriggers` 속성에 기본적으로 알림을 받을 트리거를 입력합니다. 본문에서는 ConfigMap의 버전 관리를 위해 `rollout-notifiaction-cm.yaml` 파일을 별도로 생성해 설정합니다.

```yaml
# rollout-notification-cm.yaml

apiVersion: v1
kind: ConfigMap
metadata:
  name: argo-rollouts-notification-configmap
  namespace: argo-rollouts
data:
  # 기본으로 적용할 트리거 입력
  defaultTriggers: |
    - on-rollout-completed

  # webhook 설정
  service.webhook.slack-webhook: |
    url: [webhook-url]
    headers:
    - name: Content-Type
      value: application/json

  # 메세지 템플릿 설정
  template.rollout-completed: |
    webhook:
      slack-webhook:
        method: POST
        body: |
          {
            "username": "ArgoCD",
            "icon_url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAeUOKnPBZx5HFooCNRwRLeM_zgzLH_Sy7cQ&s",
            "attachments": [{
              "title": "Rollout {{.rollout.metadata.name}} has been completed.",
              "color": "#18be52",
              "fields": [
              {
                "title": "Strategy",
                "value": "{{if .rollout.spec.strategy.blueGreen}}BlueGreen{{end}}{{if .rollout.spec.strategy.canary}}Canary{{end}}",
                "short": true
              }
              {{range $index, $c := .rollout.spec.template.spec.containers}}
                {{if not $index}},{{end}}
                {{if $index}},{{end}}
                {
                  "title": "{{$c.name}}",
                  "value": "{{$c.image}}",
                  "short": true
                }
              {{end}}
              ]
            }]
          }

  # 트리거가 보낼 메세지 템플릿 설정
  trigger.on-rollout-completed: |
    - send: [rollout-completed]
```

아래의 명령어를 실행해서 적용합니다.

```bash
kubectl apply -f rollout-notification-cm.yaml
```

## Rollout 객체

Rollout 객체의 `metadata.annotations` 속성에 아래와 같이 알림 설정을 추가합니다. 여기서는 `on-rollout-completed` 트리거만 기본 트리거로 설정하고, `on-hpa` 트리거는 개별 적용하는 예시를 작성했습니다.

```yaml
# demo-rollout.yaml

apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  annotations:
    # on-rollout-completed 트리거만 default trigger로 적용
    notifications.argoproj.io/subscribe.slack-webhook: ""
    # on-hpa 트리거는 별도로 추가
    notifications.argoproj.io/subscribe.on-hpa.slack-webhook: ""

    ...
```

마찬가지로 변경 사항을 적용한다.

```bash
kubectl apply -f demo-rollout.yaml
```

애플리케이션을 배포한 뒤 정상적으로 알림이 오는지 확인합니다.

![1.png](/assets/images/2024/2024-12-21-argo-notification-default-trigger-setting/1.png)
