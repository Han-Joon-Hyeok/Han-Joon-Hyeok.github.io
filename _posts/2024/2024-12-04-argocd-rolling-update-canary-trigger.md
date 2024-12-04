---
title: "[ArgoCD] Rolling Update와 Canary 배포에서의 알림 트리거 동작"
date: 2024-12-04 16:00:00 +0900
categories: [argocd]
tags: []
---

# 개요

ArgoCD의 알림 트리거(Notification Trigger)를 활용해 Application의 라이프사이클(생성, 업데이트, 삭제) 및 배포 상태(정상, 오류)에 따라 알림을 설정하고, 각 트리거의 작동 순서와 결과를 확인하는 방법을 정리했습니다.

특히 **Rolling Update**와 **Canary 배포** 전략을 중심으로, 정상적인 배포와 오류 상황에서 발생하는 알림 트리거의 작동 방식과 Slack을 통해 전달되는 알림 메시지를 예시로 다룹니다.

또한, Sync 오류와 같은 예외 상황에서의 알림 설정과 결과도 포함하여, ArgoCD 알림 트리거의 전반적인 동작 원리를 이해할 수 있도록 구성했습니다.

# Application 최초 생성

## 1. 정상 배포 (Rolling Update)

### 설명

Application 생성 후 클러스터에 생성된 자원들이 정상적으로 작동하는 상황입니다.

### 트리거 작동 순서

1. on-app-created
2. on-app-deployed

### 알림 결과

![1.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/1.png)

## 2. 정상 배포 (Canary)

### 설명

Application 생성 후 클러스터에 생성된 자원들이 정상적으로 작동하는 상황입니다.

### 트리거 작동 순서

1. on-app-created
2. on-rollout-completed
3. on-app-deployed

### 알림 결과

![2.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/2.png)

## 3. 배포 오류 (Rolling Update)

### 설명

Application 생성 후 일부 자원에서 오류가 발생한 경우입니다. 아래의 예시는 잘못된 이미지로 배포한 경우입니다.

### 트리거 작동 순서

1. on-app-created
2. on-health-degraded

### 알림 결과

![3.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/3.png)

![4.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/4.png)

on-health-degraded 트리거가 작동하기까지 5~10분 정도 소요될 수 있습니다.

## 4. 배포 오류 (Canary)

### 설명

Application 생성 후 일부 자원에서 오류가 발생한 경우입니다. 아래의 예시는 잘못된 이미지로 배포한 경우입니다.

### 트리거 작동 순서

1. on-app-created
2. on-rollout-completed
3. on-health-degraded

### 알림 결과

![5.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/5.png)

on-health-degraded 트리거가 작동하기까지 5~10분 정도 소요될 수 있습니다.

# Application 업데이트

업데이트는 sync 수행 후 무중단 배포로 revision이 증가하는 것을 의미합니다.

## 1. 정상 업데이트 (Rolling Update)

### 설명

Github Repository의 Helm Chart 내용 변경 후 (values.yaml, templates) 정상적으로 무중단 배포가 이루어진 상황입니다.

### 트리거 작동 순서

1. on-app-deployed

### 알림 결과

![6.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/6.png)

## 2. 정상 업데이트 (Canary)

### 설명

Github Repository의 Helm Chart 내용 변경 후 (values.yaml, templates) 정상적으로 무중단 배포가 이루어진 상황입니다.

### 트리거 작동 순서

1. on-rollout-completed
2. on-app-deployed

### 알림 결과

![7.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/7.png)

## 3. 배포 오류 (Rolling Update)

### 설명

Sync 이후 배포한 자원이 정상적으로 작동하지 않은 경우입니다. 아래의 예시는 잘못된 이미지를 배포한 경우입니다.

### 트리거 작동 순서

1. on-app-degraded

### 알림 결과

![8.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/8.png)

on-health-degraded 트리거가 작동하기까지 5~10분 정도 소요될 수 있습니다.

## 4. 배포 오류 (Canary)

### 설명

Sync 이후 배포한 자원이 정상적으로 작동하지 않은 경우입니다. 아래의 예시는 잘못된 이미지를 배포한 경우입니다.

### 트리거 작동 순서

1. on-app-degraded

### 알림 결과

![9.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/9.png)

on-health-degraded 트리거가 작동하기까지 5~10분 정도 소요될 수 있습니다.

## 5. sync 오류 (Rolling Update, Canary 공통)

### 설명

Sync가 실패한 경우입니다. Sync 실패는 Github Repository 파일 내용을 가져오지 못하거나, 네트워크 오류 등 다양한 원인으로 발생할 수 있습니다.

### 트리거 작동 순서

1. on-sync-failed
2. on-sync-unknown (가끔 작동 하지 않는 경우가 있었습니다.)

### 알림 결과

- on-sync-failed 트리거만 작동한 경우

![10.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/10.png)

- on-sync-failed, on-sync-unknown 트리거 모두 작동한 경우
  ![11.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/11.png)

# Application 삭제

## 1. Rolling Update, Canary 공통

### 설명

Application 삭제를 실행한 경우입니다.

### 트리거 작동 순서

1. on-app-deleted

### 알림 결과

![12.png](/assets/images/2024/2024-12-04-argocd-rolling-update-canary-trigger/12.png)
