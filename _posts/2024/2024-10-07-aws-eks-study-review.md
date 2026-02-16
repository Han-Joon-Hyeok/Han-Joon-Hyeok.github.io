---
title: "[EKS] AWS EKS Workshop 실습 스터디 2기 내용 정리"
date: 2024-10-07 20:10:00 +0900
categories: [aws, eks]
tags: []
---

# 개요

`CloudNet@` 팀([링크](https://gasidaseo.notion.site/CloudNet-Blog-c9dfa44a27ff431dafdd2edacc8a1863))에서 운영하는 AWS EKS Workshop Study 2기([모집 공고](https://gasidaseo.notion.site/24-AWS-EKS-Workshop-f9251680cd704d8786d6f6798f51cf69))에 참여하며 학습한 내용을 정리했다.

- 스터디 기간: 2024.03.10 ~ 2024.04.28 (총 8주)
- 스터디 규칙: 매주 학습 내용을 개인 블로그에 게시. 1회 미 공유 시 스터디 멤버 제명.

내부 규칙으로 학습한 내용은 GitHub Pages 에 올릴 수 없어서 Velog 에 올렸다.

이번 글에서는 스터디 참여 계기와 후기, 그리고 Velog 에 게시했던 글들의 링크를 정리했다.

# 스터디 참여 계기

42서울에서 뜻이 맞는 동료들과 함께 Kubernetes 프로젝트를 기획했는데, Kubernetes 와 AWS 생태계를 잘 이해하기 위해 스터디에 참여했다.

프로젝트의 목표는 42서울 학생들이 개발한 웹 애플리케이션들을 Kubernetes 로 하나의 클러스터 안에서 애플리케이션을 배포하고 관리(오토 스케일링, 모니터링, CI/CD)할 수 있도록 만드는 것이었다.

이전에는 각 애플리케이션들이 같은 AWS 계정 내에서 각각 다른 EC2 인스턴스에서 실행되었고, 그 과정에서 인스턴스 자원이 실제 사용량보다 과도하게 할당되어 큰 비용이 발생하고 있었다.

또한 대부분의 서비스에서 모니터링과 CI/CD 구축이 되어 있지 않아 문제가 발생할 때 대응이 미흡했다. 특히, 새로운 버전을 업데이트 할 때마다 `"점검으로 인해 특정 시간 동안 서비스 이용 불가능 합니다."` 라는 공지를 올려야 했고, 평균 20분 이상 다운타임이 발생했다.

이러한 문제를 해결하기 위해 프로젝트를 기획했고, 나는 팀에서 CI/CD(ArgoCD)를 집중적으로 담당했다.

프로젝트에 대해서는 다른 글에서 자세히 다룰 예정이다.

# 스터디 커리큘럼

- 1주차: Introduction ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-1주차-EKS-실습-환경-배포))

  - EKS 실습 환경 배포, k8s/EKS 소개

- 2주차: Networking ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-2주차-EKS-네트워크))

  - CNI, kube-proxy, CoreDNS, Prefix Delegation, 클러스터 트래픽 분산(Service, AWS LoadBalancer Controller, Ingress)

- 3주차: Storage, Node Group ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-3주차-스토리지-노드-그룹))

  - 컨테이너 파일 시스템, PV/PVC, CSI(Container Storage Interface), AWS EBS Controller, AWS Volume Snapshot Controller, AWS EFS Controller, AWS EKS Node Group

- 4주차: Observability ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-4주차-Observability))

  - EKS Logging(Control Plane, Node Logging - AWS CloudWatch / Pod Logging - FluentBit), Metric Collecting(metrics-server, cAdvisor, kwatch, botkube, prometheus), Metric Visualization(Grafana)

- 5주차: Auto Scaling ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-5주차-오토스케일링))

  - HPA, VPA, CA, KEDA, CPA, Karpenter

- 6주차: Security (Authentication/Authorization) ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-6주차-보안인증인가))

  - Service Account, Role/RoleBinding, RBAC, IRSA, OIDC, Pod Identity, Kyverno

- 7주차: CI/CD ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-7주차-CICD))

  - Jenkins, ArgoCD, Argo Rollouts, 무중단 배포 전략(Blue/Green, Canary), Argo Notifications

- 8주차: IaC ([링크](https://velog.io/@hanjoonhyuk/AWS-EKS-Workshop-Study-8주차-IaC))

  - Terraform

# 스터디 후기

8주라는 시간이 매우 빠르게 지나갔다.

스터디에서 다룬 내용이 깊이 있는 만큼 쉽지 않았지만, 끝까지 포기하지 않아서 완주해서 뿌듯하고 기쁘다.

사실 스터디의 1~2주차 동안 포기할까 많이 고민했다. Kubernetes 뿐만 아니라 AWS 생태계에 대한 이해도 부족해서 많은 내용을 짧은 시간 안에 학습해야 했다.

게다가 스터디에 참여하던 시기에 두 개의 프로젝트를 동시에 진행하고 있었기 때문에 시간도 부족했고, 정신적-신체적으로도 많은 부담이 있었다.

겨우 스터디 내용을 정리하면 웹 프로젝트를 해야 했고, 웹 프로젝트가 끝나면 다시 Kubernetes 프로젝트로 돌아가야 하는, 매우 빡빡한 일정이었다.

일주일 중 마음 편히 쉰 날을 손에 꼽을 정도로 심리적 압박과 스트레스가 컸다.

누구도 스터디에 참여하라고 강요하지 않았고, 이는 스스로 선택한 길이었기에 그 선택을 후회하지 않도록 최선을 다하기로 결심했다.

다행히 3주차를 넘기면서 Kubernetes 와 AWS 생태계를 점차 이해하기 시작했고, 어느 순간 내가 정리한 스터디 게시물이 모범 게시물로 선정되기도 했다.

비록 스터디 내용을 100% 완벽하게 이해했다고 말할 수 없지만, Kubernetes 의 핵심 작동 원리를 파악하는 데 큰 도움이 되었다.

# 마치며

사실, 이 스터디는 Levvels([링크](https://www.levvels.io/kr)) 에서 DevOps 로 근무 중인 이정훈님([링크](https://jerryljh.tistory.com/))의 소개로 알게 되었다.

정훈님과의 인연은 나의 커피챗 요청으로 시작되었다.

Kubernetes 를 학습하는 중에 정훈님께서 작성하신 글이 큰 도움이 되었고, DevOps 직무에 대해 더 깊이 알고 싶었다. 또한 직무 선택과 관련한 조언을 듣고 싶어 이메일로 커피챗을 요청드렸다.

감사하게도 귀한 시간을 내어주셔서 커피챗이 성사되었고, 그 자리에서 스터디도 소개받아 프로젝트에 큰 도움이 되었다.

이 스터디는 원래 현직자를 대상으로 모집했지만, 스터디를 이끄는 가시다님께 장문의 메일로 42서울에서 학습한 내용들과 나에 대한 소개를 하며 `취준생이지만 참여하고 싶습니다` 라는 장문의 메일을 보냈다.

정말 감사하게도 허락해주셔서 8주 동안 스터디를 진행하며 Kubernetes 와 AWS 생태계를 깊이 있게 이해할 수 있었다.

이 자리를 빌어, 스터디를 소개해주신 정훈님과 양질의 스터디 자료를 제공해주신 가시다님께 진심으로 감사드린다.

끝.
