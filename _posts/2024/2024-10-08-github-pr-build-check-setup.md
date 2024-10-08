---
title: "[GitHub] Pull Request 생성 시 빌드 및 테스트 통과 후에만 merge 가능하게 설정하기"
date: 2024-10-08 20:10:00 +0900
categories: [github, github actions]
tags: [github, github actions]
---

# 개요

GitHub Repository 에서 PR(Pull Request) 이 생성되었을 때, 빌드에 성공하지 않으면 merge 할 수 없도록 설정하는 방법을 정리했다.

현재 진행 중인 백엔드 프로젝트에서는 main 브랜치로 merge 되면 자동으로 배포가 이루어진다.

그러나 스프링 부트가 빌드되지 않거나 테스트 코드가 통과하지 않았음에도 배포 프로세스가 실행되어, 최신 버전이 정상적으로 반영되지 않는 상황이 발생했다.

이러한 문제를 사전에 방지하기 위해 PR 단계에서 추가적인 안전 장치를 마련했다.

# 설정

## 1. GitHub Actions 파일 생성

목표는 PR 이 생성되었을 때 스프링 부트가 정상적으로 빌드되고, 테스트 코드가 통과하는지 확인하는 것이다.

이를 위해 GitHub Actions 파일을 작성한다.

```yaml
# ci.yaml

name: Java CI with Gradle

on:
  workflow_dispatch:
  pull_request:
    branches:
      - "main"

jobs:
  build-spring:
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout backend
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: "17"
          distribution: "temurin"
          cache: "gradle"

      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v3

      - name: Build with Gradle Wrapper
        run: ./gradlew build
```

코드가 짧아보일 수 있지만, `gradlew build` 명령어는 빌드와 테스트 코드 실행을 모두 포함한다.

## 2. GitHub Repository 에 push

새로운 브랜치를 생성한 뒤, 1번에서 작성한 파일을 push 한다.

그 후 PR 을 생성한다.

![1.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/1.png)

## 3. GitHub Repository 설정

PR 페이지에서 [Add rule] 버튼을 클릭한다.

![2.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/2.png)

[Ruleset Name] 을 입력하고, [Enforcement status] 를 [Active] 로 선택한다.

![3.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/3.png)

`main` 브랜치로 향하는 PR 에 적용할 규칙을 설정하기 위해 [Targets] 항목에서 [Add target] 버튼을 클릭한 후 [Include by pattern] 을 선택한다.

![4.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/4.png)

[Branch naming pattern] 에 `main` 을 입력하고 [Add Inclusion pattern] 버튼을 클릭한다.

![5.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/5.png)

같은 페이지 하단에서 [Require status checks to pass] 를 선택한 후 [Require branches to be up to date before merging] 옵션을 선택한다.

이후 [Add checks] 버튼을 클릭하여 검색창에 GitHub Actions 에서 생성한 job 이름을 입력한다.

이 글에서는 `build-spring` 이라는 이름으로 job 을 생성했으므로, 정확히 입력 후 검색된 해당 job 을 선택한다.

![6.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/6.png)

설정이 완료되면 [Create] 버튼을 눌러 규칙을 생성한다.

![7.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/7.png)

## 4. 테스트

생성한 규칙이 정상적으로 작동하는지 확인하기 위해, 실패하는 테스트 코드로 수정한 뒤 push 했다.

아래 이미지처럼 [Merge pull request] 버튼이 비활성화 되어 `main` 브랜치로 merge 할 수 없음을 확인할 수 있다.

![8.png](/assets/images/2024/2024-10-08-github-pr-build-check-setup/8.png)

# 참고자료

- [Pull Request를 병합하기 전에 코드 검사하기](https://marshallku.com/dev/pull-request%EB%A5%BC-%EB%B3%91%ED%95%A9%ED%95%98%EA%B8%B0-%EC%A0%84%EC%97%90-%EC%BD%94%EB%93%9C-%EA%B2%80%EC%82%AC%ED%95%98%EA%B8%B0) [marshallku]