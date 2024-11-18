---
title: "[Kubernetes] Deployment 객체를 활용해서 Rolling Update 무중단 배포 전략 적용하기"
date: 2024-11-19 06:10:00 +0900
categories: [kubernetes]
tags: []
---

# 개요

Kubernetes의 Deployment 객체를 이용해 무중단 배포를 적용하는 방법을 정리했습니다.

# Rolling Update

## 개념

**Rolling Update**는 Kubernetes에서 기본적으로 적용하는 업데이트 방식입니다. 이 배포 전략은 다음과 같이 진행됩니다.

기존 버전(v1) 파드 3개가 실행 중인 상태에서 새로운 버전(v2)을 배포한다고 가정해봅시다. 먼저 v2 파드 1개를 생성한 뒤 v1 파드 1개를 종료합니다. 이 과정을 반복하면서 점차 v2 파드로 전환합니다. 배포 중에는 트래픽이 v1과 v2로 랜덤하게 분산됩니다.

## 구현

Deployment 객체의 `maxSurge` 속성과 `maxUnavailable` 속성을 활용해 Rolling Update 전략을 세부적으로 설정할 수 있습니다.

- `maxSurge`: 업데이트 중 `spec.replicas` 에 설정된 파드 수를 기준으로 새로 생성할 수 있는 최대 파드 수를 지정합니다.
- `maxUnavailable`: 업데이트 중 `spec.replicas` 를 기준으로 사용 가능하지 않은 최대 파드 수를 지정합니다.

### 1. [새 파드 생성 - 기존 파드 삭제] 반복 전략

- **설명**: 기존 파드를 종료하기 전에 새로운 파드를 먼저 생성합니다.
- **예시**: 전체 파드 개수가 10개이고 `maxSurge`가 1로 설정된 경우, 업데이트 중 최대 11개의 파드가 존재할 수 있습니다. 새로운 버전(v2) 파드를 하나 생성한 뒤 기존 버전(v1) 파드를 하나씩 종료합니다.
- **필수 조건**: 이 전략을 사용할 때 `maxUnavailalbe`은 0으로 설정해야 합니다.

그림으로 시각화하면 다음과 같습니다. (편의상 전체 파드의 개수는 3개로 설정)

![1.png](/assets/images/2024/2024-11-19-kubernetes-rolling-update-deployment/1.png)

### 2. [기존 파드 삭제 - 새 파드 생성] 반복 전략

- **설명**: 기존 파드를 종료한 뒤 새로운 파드를 생성합니다.
- **예시**: 전체 파드 개수가 10개이고 `maxUnavailable`가 1로 설정된 경우, 업데이트 중 파드 수는 최대 9개로 줄어들 수 있습니다. 기존 버전(v1) 파드를 하나 종료한 뒤 새로운 버전(v2) 파드를 하나 생성합니다.
- **필수 조건**: 이 전략을 사용할 때 `maxSurge` 속성은 0으로 설정해야 합니다.

그림으로 시각화하면 다음과 같습니다. (편의상 전체 파드의 개수는 3개로 설정)

![2.png](/assets/images/2024/2024-11-19-kubernetes-rolling-update-deployment/2.png)

## yaml 파일 작성

Rolling Update 전략을 설정하려면 `spec.strategy` 속성과 하위 속성을 작성해야 합니다.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rolling
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  minReadySeconds: 5
  revisionHistoryLimit: 5
  replicas: 5
  selector:
    matchLabels:
      app: rolling
  template:
    metadata:
      name: rolling
      labels:
        app: rolling
    spec:
      containers:
        - name: nginx
          image: nginxdemos/hello:plain-text
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
```

참고로 Deployment 객체는 `maxSurge`와 `maxUnavailable` 속성을 설정하지 않으면 기본적으로 각각 25%로 설정됩니다.

> Deployment ensures that only a certain number of Pods are down while they are being updated. **By default, it ensures that at least 75% of the desired number of Pods are up** **(25% max unavailable)**.
>
> Deployment also ensures that only a certain number of Pods are created above the desired number of Pods. **By default, it ensures that at most 125% of the desired number of Pods are up (25% max surge).**

`maxSurge` 를 설정하지 않으면 전체 파드의 개수는 최대 125%까지 증가합니다. 예를 들어, 전체 파드가 10개라면 25%인 2.5개가 추가되지만, 파드는 정수로만 생성되므로 반올림되어 최대 3개가 추가됩니다.

`maxUnavailable` 를 설정하지 않으면 전체 파드 중 최대 25%가 비활성화될 수 있습니다. 예를 들어, 파드 개수가 10개라면 25%인 2.5개가 비활성화되지만, `maxSurge` 와는 달리 내림 처리가 적용되어 최대 2개 파드만 비활성화됩니다. 이는 서비스 가용성을 보장하기 위해 파드를 비활성화하는 파드 수를 제한하려는 설계입니다.

요약하자면, `maxSurge` 는 업데이트 중 추가로 생성할 수 있는 파드의 최대 개수를 정의하며, 반올림 처리됩니다. 반면, `maxUnavailable` 은 업데이트 중 비활성화될 수 있는 파드의 최대 개수를 정의하며, 내림 처리되어 더 보수적으로 적용됩니다.

- `minReadySeconds`**:** 새로 생성된 파드가 준비 상태(Ready)로 간주되기 전 대기 시간을 설정합니다.
- `revisionHistoryLimit`**:** 이전 버전의 revision을 몇 개까지 저장할지 설정합니다.

# 참고자료

- [Kubernetes 리소스 Deployment에 대해 이해하고 실습해보기](https://velog.io/@pinion7/Kubernetes-%EB%A6%AC%EC%86%8C%EC%8A%A4-Deployment%EC%97%90-%EB%8C%80%ED%95%B4-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B3%A0-%EC%8B%A4%EC%8A%B5%ED%95%B4%EB%B3%B4%EA%B8%B0) [velog]
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment) [Kubernetes]
