---
title: "[Docker] GitHub Actions 로 Docker Image 를 arm64 로 빌드하기"
date: 2024-09-09 19:10:00 +0900
categories: [github actions, docker]
tags: []
---

# 개요

GitHub Actions 를 이용해서 Docker 이미지를 빌드할 때 arm64 아키텍처에서도 사용할 수 있도록 Docker 이미지를  빌드할 수 있는 방법을 소개한다.

# 멀티 플랫폼 빌드

## 필요성

기본적으로 사용하는 GitHub Actions Runner 의 CPU 아키텍처는 아직 amd64 만 지원한다.

AWS EC2 인스턴스 중에서 t4g 유형은 arm64 아키텍처를 사용하는데, t4g 인스턴스에서 도커 이미지를 사용하려면 arm64 에서 빌드해야 한다.

t4g 를 사용하는 이유는 t3, t2 에 비해 약 20% 저렴하기 때문이다.

참고로 2024년 9월 9일 기준 서울 리전(ap-northeast-2) small 유형의 on-demand 비용을 비교하면 아래와 같다.

| 유형 | 시간당 요금 | 1달 사용 기준 요금(720시간) |
| --- | --- | --- |
| t4g.small | USD 0.0208 | USD 14.976 |
| t3.small | USD 0.026 | USD 18.72 |
| t2.small | USD 0.0288 | USD 20.736 |

## Docker BuildX

Docker 에서는 amd64 아키텍처에서도 arm64 아키텍처로 Docker 이미지를 빌드할 수 있도록 BuildX 를 제공하고 있다.

이를 GitHub Actions 에서도 사용할 수 있도록 setup-buildx-action([링크](https://github.com/docker/setup-buildx-action))를 제공한다.

# 사용법

이 글에서 멀티 플랫폼 빌드를 위해 사용하는 GitHub Actions 목록은 아래와 같다.

- setup-buildx-action([링크](https://github.com/docker/setup-buildx-action))
- build-push-action([링크](https://github.com/docker/build-push-action))

## 공식 문서

setup-buildx-action 에서 소개하는 사용법은 아래와 같다.

```yaml
name: ci

on:
  push:

jobs:
  buildx:
    runs-on: ubuntu-latest
    steps:
      -
        name: Checkout
        uses: actions/checkout@v4
      -
        # Add support for more platforms with QEMU (optional)
        # https://github.com/docker/setup-qemu-action
        name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      -
        name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
```

QEMU 는 선택 사항이라고 하는데, amd64 와 arm64 로만 빌드한다면 제외해도 된다.

## 실제 사용

Spring Boot 애플리케이션은 GitHub Actions Runner 에서 빌드했다.

Dockerfile 안에서 애플리케이션을 빌드하는 멀티 스테이지 빌드를 하면 시간이 약 9배 이상 소요되었다.

### Dockerfile

```docker
FROM amazoncorretto:17-alpine3.19-jdk

RUN apk update && apk add dumb-init

WORKDIR /usr/app

COPY build/libs/*.jar app.jar

COPY ./entrypoint.sh ./

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/bin/sh", "./entrypoint.sh", "deploy" ]
```

Dockerfile 은 위와 같이 로컬 환경에 있는 jar 파일만 복사해서 가져오도록 했다.

### yaml 파일

```yaml
name: Java CI with Gradle and CD with Docker

jobs:
  build-spring-and-docker-image:
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

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_ACCOUNT }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and Push Docker Image
        uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ secrets.DOCKERHUB_ACCOUNT }}/${{ secrets.DOCKERHUB_REPOSITORY }}
          platforms: |
            linux/amd64
            linux/arm64
```

여기서 눈 여겨보아야 하는 부분은 build-push-action 의 `context: .` 이다.

build-push-action 은 기본적으로 git 에서 checkout 한 파일을 기준으로 Docker 이미지를 빌드한다.

그래서 GitHub Actions Runner 에서 `./gradlew build` 명령어를 이용해서 jar 파일을 생성했어도 jar 파일을 인식하지 못하는 문제가 있다.

```bash
#7 [4/5] COPY build/libs/*.jar demo.jar
#7 ERROR: lstat /tmp/buildkit-mount492152814/build/libs: no such file or directory
------
 > [4/5] COPY build/libs/*.jar app.jar:
------
Dockerfile:7
--------------------
   5 |     WORKDIR /usr/app
   6 |
   7 | >>> COPY build/libs/*.jar app.jar
   8 |
   9 |     COPY ./entrypoint.sh ./
--------------------
ERROR: failed to solve: lstat /tmp/buildkit-mount492152814/build/libs: no such file or directory
```

`context` 속성을 사용하면 current working directory 를 기준으로 Docker 이미지를 빌드하기 때문에 정상적으로 jar 파일을 인식하고 Docker 이미지를 빌드할 수 있다.

GitHub Actions 실행이 끝나고 Docker Hub 에서 확인해보면 아래의 이미지와 같이 두 가지 아키텍처에 해당하는 이미지가 업로드 된 것을 확인할 수 있다.

![1.png](/assets/images/2024/2024-09-09-docker-multiplatform-build-using-github-actions/1.png)

위의 yaml 파일을 모두 실행하는데 평균적으로 약 1분 정도 소요된다.

# 참고자료

- [GitHub Actions에서 멀티 플랫폼 이미지 빌드하기](https://thearchivelog.dev/article/building-a-multi-platform-image-with-github-actions/) [github.io]