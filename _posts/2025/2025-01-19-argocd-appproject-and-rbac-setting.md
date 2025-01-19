---
title: "[ArgoCD] AppProject 생성 및 RBAC 설정 가이드"
date: 2025-01-19 13:25:00 +0900
categories: [ArgoCD]
tags: []
---

# 개요

ArgoCD는 여러 팀이 공유하여 사용하는 환경에서 애플리케이션을 효과적으로 관리할 수 있도록 **Project(AppProject)** 개념을 제공합니다. 이를 통해 애플리케이션을 논리적으로 구분하고, 특정 소스, 클러스터, 네임스페이스에 제한을 두는 등 다양한 관리 기능을 제공합니다. 또한, 프로젝트별 RBAC(Role-Based Access Control)을 설정해 사용자 권한을 세분화할 수 있습니다.

이 글에서는 **AppProject 생성** 방법과 이를 활용한 **RBAC 설정**, 그리고 **Helm Chart를 이용한 애플리케이션 배포** 과정을 단계별로 정리했습니다.

다음과 같은 내용을 포함하고 있습니다.

- **AppProject 생성**: 특정 소스와 네임스페이스로 배포를 제한하는 방법
- **Helm Chart를 이용한 애플리케이션 생성**: AppProject와 연동하여 애플리케이션을 배포하는 과정
- **RBAC 설정**: AppProject에 접근할 수 있는 사용자 권한을 설정하고 적용하는 방법
- **사용자 권한 테스트**: 읽기 전용 계정으로 애플리케이션 관리 제한 여부 확인

# ArgoCD Project 생성하기

ArgoCD는 애플리케이션을 논리적으로 구분하기 위해 Project라는 개념을 제공합니다. 이는 여러 팀이 ArgoCD를 사용할 때, 애플리케이션을 팀별로 구분하고, 관리와 접근을 효과적으로 제한하는데 유용합니다.

[공식 문서](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/)에 따르면, Project를 통해 다음과 같은 기능을 사용할 수 있습니다.

- 배포 애플리케이션의 소스(source)를 특정 경로로 제한
- 애플리케이션의 배포 클러스터 및 네임스페이스를 제한
- 배포할 쿠버네티스 객체를 제한하거나 특정 객체를 제외

예를 들면, A팀의 Project는 `https://github.com/team-A-org/` 경로의 소스만 사용할 수 있도록 설정하거나, 해당 Project에 속한 애플리케이션은 `A-team` 이라는 네임스페이스에만 배포할 수 있도록 제한할 수 있습니다.

## AppProject CRD 생성

ArgoCD의 Project를 생성하려면 `AppProject` 라는 CRD를 사용합니다. 아래는 예시 파일입니다.

```yaml
# demo-project.yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: demo-project
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: Example Project
  sourceRepos:
    - "https://github.com/42Cluster-Seoul/*"
  destinations:
    - namespace: morning-glory
      server: https://kubernetes.default.svc
  roles:
    # A role which provides read-only access to all applications in the project
    - name: read-only
      description: Read-only privileges to demo-project
      policies:
        - p, proj:demo-project:read-only, applications, get, morning-glory/*, allow
```

### 주요 속성 설명

spec 하위 속성을 살펴보면 아래와 같습니다.

- `spec.sourceRepos`: 이 프로젝트에 배포되는 애플리케이션은 GitHub의 `https://github.com/42Cluster-Seoul/*` 경로에서만 소스를 가져올 수 있습니다.
- `spec.destinations.namespace`: `morning-glory` 네임스페이스에 배포되는 애플리케이션은 이 Project에 속한다는 것을 의미합니다.
- `spec.roles`: 해당 프로젝트에서 적용할 RBAC 정책을 설정합니다.

### 정책 해석 예시

`spec.roles`에서 RBAC을 설정하는 `policies` 항목을 살펴보면 아래와 같이 해석할 수 있습니다.

```yaml
p, proj:demo-project:read-only, applications, get, demo-project/*, allow
```

- `proj:demo-project:read-only` 라는 정책의 이름은 `demo-project` 에 속한 모든 애플리케이션에 대해 get(읽기) 권한을 제공합니다.

### Project 생성 명령어

위 yaml 파일을 사용해서 Project를 생성하려면 다음 명령어를 실행합니다.

```bash
kubectl create -f demo-project.yaml
```

참고로 Project를 생성한 것만으로는 ArgoCD 웹 대시보드에는 Project가 표시되지 않습니다. Project에 포함된 애플리케이션이 있어야 대시보드에 나타납니다.

# Application 생성하기

Helm Chart를 이용해서 ArgoCD에 애플리케이션을 배포할 수 있습니다. 예시 파일은 아래와 같습니다.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: demo-nginx
  namespace: argocd
spec:
  project: demo-project
  source:
    path: stable/demo-nginx
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

### 주요 속성 설명

- `metadata.namespace`: Application은 `argocd` 네임스페이스에 속해야 한다. 그렇지 않으면 ArgoCD 웹 대시보드에서 확인할 수 없습니다.
- `spec.project`: 애플리케이션이 속한 Project의 이름을 지정합니다. 앞에서 생성한 `AppProject` 의 `metadata.name` 에 작성한 이름을 넣습니다. 여기서는 `demo-proejct`를 입력했습니다.

# RBAC 설정하기

특정 사용자가 Project에 접근할 수 있는 권한을 부여하려면 ArgoCD의 RBAC 설정을 수정해야 합니다. 이를 위해 `argocd-rbac-cm` ConfigMap을 편집합니다.

## 1. 현재 ConfigMap 저장

RBAC 설정 파일을 YAML 파일로 저장하기 위해 아래의 명령어를 실행합니다.

```bash
kubectl get cm argocd-rbac-cm -n argocd -o yaml > argocd-rbac-cm.yaml
```

## 2. 사용자와 정책 연결

저장된 `argocd-rbac-cm.yaml` 파일의 `data.policy.csv` 항목에 사용자 계정(`username`)과 프로젝트에서 선언한 정책(`proj:demo:project:read-only`)을 연결합니다.

```yaml
# argocd-rbac-cm.yaml

data:
  policy.csv: |
    g, username, proj:demo-project:read-only
    ...
```

변경 내용을 저장하고 아래의 명령어를 실행해서 적용합니다.

```bash
kubectl apply -f argocd-rbac-cm -n argocd
```

# 접근 권한 테스트

읽기 전용 권한이 적용된 계정으로 애플리케이션을 삭제하려고 시도하면, 아래의 이미지와 같이 삭제가 실패하는 것을 확인할 수 있습니다.

![1.png](/assets/images/2025/2025-01-19-argocd-appproject-and-rbac-setting/1.png)

# 참고자료

- [Projects](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/#project-roles) [argocd]
- [RBAC Configuration](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/#rbac-configuration) [argocd]
- [argo-cd/docs/operator-manual/project.yaml](https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/project.yaml) [github]
