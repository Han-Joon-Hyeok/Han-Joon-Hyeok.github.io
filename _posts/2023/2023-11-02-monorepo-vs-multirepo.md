---
title: "Monorepo vs Multirepo"
date: 2023-11-02 09:00:00 +0900
categories: [개발환경]
tags: [개발환경]
---

# 프로젝트 구조 만들기

새로운 프로젝트를 시작하기 위해 TypeScript 기반의 프레임워크를 사용하고자 했다.

- Frontend : Next.js
- Backend : Nest.js

같은 언어를 사용하는 만큼 Multirepo 보다 Monorepo 를 사용하고자 했다.

Monorepo 는 구글에서도 사용할 정도로 확장성 및 관리 용이성이 이미 검증된 방식이다.

Monorepo 의 장점을 살펴보기 전에 Multirepo 를 먼저 알아보자.

## Multirepo

Multirepo 는 각 프로젝트마다 다른 repository 를 소유하는 것을 의미한다.

대부분 아래와 같이 구성한다.

- A repository : 프론트엔드
- B repository : 백엔드

그리고 프로젝트를 진행하면 아래와 같은 디렉토리 구조를 가진다.

```
/project
 |- frontend/
   |- .git
   |- ...
 |- backend/
   |- .git
   |- ...
```

### 장점

- repository 가 확실하게 구분되어 있으므로 프론트엔드, 백엔드 간에 코드 충돌이 일어날 가능성이 없다.
- 각 프로젝트의 자율성이 높다. 프로젝트 라이프 사이클, 개발 환경 등을 각자 정할 수 있다.

### 단점

- 공통 라이브러리를 사용하기 어렵다.
- 공통 코드가 있어도 각 프로젝트마다 코드를 작성해야 하기 때문에 코드 중복이 발생한다.

## Monorepo

Monorepo 는 프로젝트들을 하나의 repository 에서 관리하는 것을 의미한다.

아래와 같은 디렉토리 구조를 가진다.

```
/project
 |- .git
 |- frontend/
   |- ...
 |- backend/
   |- ...
 |- common/
   |- ...
```

Multirepo 처럼 각 폴더 별로 `.git` 폴더가 존재하는 것이 아닌 최상단 디렉토리에 존재하는 구조를 가진다.

### 장점

- 공통 코드를 공유하기 쉽다.
- eslint, prettier, husky 와 같은 컨벤션 설정을 모든 서비스에 적용할 수 있다.
- 프로젝트 패키지 관리를 통합해서 할 수 있다. 공통된 라이브러리는 한 번만 설치한다.

### 단점

- repository 의 용량이 커진다.
- Multirepo 에 비해 빌드가 느릴 수 있다.
- 서비스 별로 코드 충돌이 일어날 수도 있다.

### 특징

- 다른 팀이 내가 모르는 사이에 코드를 변경할 수도 있다. 이를 방지하기 위해 Github 에서는 [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) 와 같은 기능을 사용하여 폴더 기반으로 소유권을 구성할 수 있다. 특정 폴더의 코드를 수정했다면 해당 폴더의 소유자에게 반드시 리뷰를 받아야 머지할 수 있도록 설정할 수 있다.

### 도구

- Lerna, Yarn, npm, pnpm, Nx 등이 많이 쓰인다.
- Yarn workspace 또는 Yarn berry 를 사용한다.
    - workspace 는 `node_modules` 폴더를 각 프로젝트에 심볼릭 링크를 걸어서 사용하는 방식
    - berry 는 라이브러리를 `.zip` 파일로 압축하여 패키지 크기를 굉장히 작게 유지한다. 가상 파일 시스템(VFS; Virtual File System)을 이용해서 `.zip` 파일 내부의 파일을 접근해서 라이브러리를 사용한다.
        - 참고로 Linux 에서 `zcat` 명령어를 사용하면 `.zip` 파일을 압축 해제하지 않고도 내부 파일에 접근하는 것이 가능하다. Yarn berry 는 `zcat` 을 사용하지 않는다.

# 왜 모노레포인가?

Monorepo 를 사용하기로 한 근거는 아래와 같다.

- 동일한 언어를 사용하기 때문에 프론트엔드와 백엔드 간 API 통신 시 사용할 인터페이스를 공통 폴더에 작성함으로써 코드의 중복을 막을 수 있다.
- 마찬가지로 라이브러리를 공통으로 사용할 수 있기 때문에 라이브러리 관리를 효율적으로 할 수 있다.
- eslint, prettier, husky 와 같은 컨벤션을 프론트엔드, 백엔드 동일하게 적용함으로써 서로의 코드를 이해하기 쉬워진다.
- 개발 환경 구축이 쉬워진다. `make` 와 같은 명령어 한 번만 입력해서 프론트엔드와 백엔드 컨테이너를 동시에 띄우는 것이 가능하다.
- 통합 CI 및 테스트가 용이하다.
- 짧은 시간 안에 프로젝트 목표를 달성해야 하기 때문에 프로젝트 코드의 변화를 빠르게 파악할 수 있다.

## 브랜치 전략

TBD(Trunk Based Development)는 굉장히 단순한 브랜치 전략이다.

이 전략은 모노레포 환경에서 사용하기 적합하다고 알려져있다.

- main 브랜치는 항상 배포 가능한 상태여야 한다. 실제로 production 에 나가면 안되는 기능이라도 feature flag 등을 이용해서 유저에게 보이지 않게 하고 배포는 가능하게 해야 한다.
- 기능을 추가할 때는 main 브랜치에서 분기하고, 가능한 빠르게 main 브랜치로 머지하고 배포한다.
- 항상 배포가 가능한 상태를 유지하기 위해서 모든 변경 사항에는 테스트 코드가 잘 작성되어야 한다. 그래야 실수로 배포하면 안되는 코드를 main 브랜치에 올라오는 것을 막을 수 있다.

monorepo 에 적합한 브랜치 전략이기 때문에 이를 사용하기로 했다.

# 참고자료

- [[Micro Frontend] 모놀리식 vs 멀티레포 vs 모노레포, 내 프로젝트에 도입하기](https://velog.io/@yoonlang/Micro-Frontend-모놀리식-vs-멀티레포-vs-모노레포-내-프로젝트에-도입하기) [velog]
- [마이크로 프론트엔드와 모노레포 & 제로빌드](https://velog.io/@dalbodre_ari/%EB%A7%88%EC%9D%B4%ED%81%AC%EB%A1%9C-%ED%94%84%EB%A1%A0%ED%8A%B8%EC%97%94%EB%93%9C%EC%99%80-%EB%AA%A8%EB%85%B8%EB%A0%88%ED%8F%AC-%EC%A0%9C%EB%A1%9C%EB%B9%8C%EB%93%9C) [velog]
- [모노레포 이렇게 좋은데 왜 안써요?](https://medium.com/musinsa-tech/journey-of-a-frontend-monorepo-8f5480b80661) [medium]
- [모노레포 - 마이크로 아키텍처를 지향하며](https://green-labs.github.io/monorepo-microfrontend) [greenlabs]
- [node_modules로부터 우리를 구원해 줄 Yarn Berry](https://toss.tech/article/node-modules-and-yarn-berry) [toss]
- [모던 프론트엔드 프로젝트 구성 기법 - 모노레포 개념](https://d2.naver.com/helloworld/0923884) [naver d2]
- [모던 프론트엔드 프로젝트 구성 기법 - 모노레포 도구 편](https://d2.naver.com/helloworld/7553804) [naver d2]
- [모노레포 적용부터 yarn berry까지](https://blog.hwahae.co.kr/all/tech/11962) [화해]
- [멀티리포 vs 모노리포](https://tech.buzzvil.com/handbook/multirepo-vs-monorepo/) [buzzvil]
- [초보자를 위한 Linux zcat 명령 예제](https://ko.linux-console.net/?p=228) [linux-console.net]
- [Nest.js에 Yarn Berry + Zero Install 적용하기](https://blog.naver.com/biud436/223211308347) [네이버 블로그]
- [VFS 1 - 가상 파일시스템(Virtual File System)](https://velog.io/@jinh2352/1.-Introduction) [velog]
- [모노레포의 기술적 요구사항 (3) - Deploy / Branch 전략](https://yeoulcoding.me/317) [yeoulcoding.me]
- [트렁크 기반 개발(Trunk-Based Development)](https://code-masterjung.tistory.com/73) [티스토리]
- [Building a full-stack, fully type-safe pnpm monorepo with NestJS, NextJS & tRPC](https://www.tomray.dev/nestjs-nextjs-trpc) [tomray.dev]
- [Setup Development Environment with Docker for Monorepo 🐳](https://dev.to/tejastn10/setup-development-environment-with-docker-for-monorepo-3433) [dev.to]