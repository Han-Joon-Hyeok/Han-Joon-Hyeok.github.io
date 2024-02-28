---
title: "[Github Actions] Node.js 패키지 설치 시간 단축을 위한 캐시 적용법"
date: 2024-02-28 09:15:00 +0900
categories: [github]
tags: [github, github actions]
---

# 문제 상황

- Github Actions 의 cron 기능을 이용해서 일정한 주기로 Node.js 프로그램을 실행하고자 했다.
- Github Actions 는 실행할 때마다 가상머신을 사용하는데, 실행이 끝나면 사용했던 가상머신에 설치한 라이브러리(`node_modules`)는 삭제된다.
- 하지만 동일한 라이브러리와 버전을 사용하는데 매번 라이브러리를 설치하는 것은 시간을 불필요하게 사용하는 것이라 느꼈다.
- 패키지를 설치하는데 걸리는 시간을 최소화하기 위해 Github Actions 에서 지원하는 캐시 기능을 사용하고자 했고, `node_modules` 폴더를 지우지 않고 그대로 가상머신에 저장하도록 했다.

# 문제 해결

글에서 다루는 예제는 [Github Repository](https://github.com/Han-Joon-Hyeok/github-actions-cache/tree/main) 에서 확인할 수 있습니다.

## 기존

아래는 기존에 작성한 github actions yaml 파일의 내용이다.

```yaml
name: main
on:
  # Github 페이지에서 수동으로 workflow 를 실행하기 위한 트리거
  workflow_dispatch:

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      # repository 의 코드 다운로드
      - name: Checkout
        uses: actions/checkout@v4

      # Node.js 설치
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "20"

      # 라이브러리 설치
      - name: Install dependencies
        run: npm install

      # 코드 실행
      - name: Run script
        run: node src/main.js
```

위의 파일을 기반으로 workflow 를 실행했을 때 소요되는 시간은 약 28초~40초 사이였다.

아래의 사진은 캐시되지 않은 `node_modules` 폴더를 설치한 workflow 의 실행 결과이다.

![1.png](/assets/images/2024/2024-02-28-github-actions-cache/1.png)

## 개선

[actions/cache](https://github.com/actions/cache) 를 사용하면 원하는 파일이나 폴더를 캐시할 수 있다.

라이브러리가 저장되는 `node_modules` 폴더를 삭제하지 않고, 가상머신에 저장하길 원했기 때문에 아래와 같이 파일을 작성했다.

```yaml
name: main
on:
  workflow_dispatch:

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "20"

      # 라이브러리 파일이 저장된 node_modules 폴더 캐시
      - name: Cache dependencies
        id: node-cache
        uses: actions/cache@v4
        with:
          path: "**/node_modules"
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-

      # 캐시가 있으면 라이브러리를 설치하지 않음
      - name: Install dependencies
        if: steps.node-cache.outputs.cache-hit != 'true'
        run: npm install

      - name: Run script
        run: node src/main.js
```

`name: Cache dependencies` 라는 step 을 추가해서 가상머신에 `node_modules` 폴더를 삭제하지 않고 캐시하도록 했다.

그리고 `name: Install dependencies` step 에서 `node_modules` 폴더에 해당하는 캐시가 존재하면 `npm install` 실행을 건너뛰도록 했다.

라이브러리를 설치하지 않고 넘어간 결과로 전체 실행 결과는 약 18초~24초가 소요되었고, 기존 실행 시간 대비 약 35.7% 감소했다는 것을 알 수 있다.

![2.png](/assets/images/2024/2024-02-28-github-actions-cache/2.png)

### 문법 자세히 살펴보기

actions/cache 의 문법을 조금만 더 살펴보자.

```yaml
- name: Cache dependencies
  id: node-cache
  uses: actions/cache@v4
  with:
    path: "**/node_modules"
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

1. `id: node-cache`

   - 해당 step 을 고유하게 식별할 수 있는 key 값을 `node-cache` 로 설정한 것이다.
   - 다른 step 에서 아래와 같이 참조한다.

   ```yaml
   - name: Install dependencies
     if: **steps.node-cache**.outputs.cache-hit != 'true'
     run: npm install
   ```

   - `steps.{step-id}` 와 같이 id 를 이용해서 참조한다. 여기서는 캐시 히트, 즉 캐시가 존재하는 지 여부를 확인하기 위해 사용한 것이다.

2. `with:
path: "**/node_modules"`
   - 캐시하고자 하는 폴더나 파일의 경로를 입력한다.
   - 와일드카드 `**` 을 하위 모든 폴더에 대한 것을 의미한다. 즉, 하위 폴더에 있는 모든 라이브러리 파일을 저장하는 `node_modules` 폴더를 캐시하겠다는 의미이다.
3. `key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}`

   - 캐시한 파일을 식별하기 위한 key 값을 설정하는 것이다.
   - `runner.os` 는 가상머신의 os 를 의미한다.
   - `hashFiles()` 함수는 파일의 경로를 매개변수로 받아서 해시하는 Github Actions 자체에서 제공하는 함수이다.
   - Github Repository 의 Actions 탭에 들어가서 Management 항목 아래에 있는 Caches 를 확인해보면 아래와 같은 이름(Linux-node-3d0a…)으로 캐시가 저장되어있는 것을 확인할 수 있다.

   ![3.png](/assets/images/2024/2024-02-28-github-actions-cache/3.png)

4. `restore-keys: |
  ${{ runner.os }}-node-`
   - 캐시를 복원할 때 사용하는 옵션이다. 캐시를 복원할 때 여러 키로 시도할 수 있는데, 그 중에서 첫 번째로 일치하는 키를 찾으면 캐시를 복원한다.
   - 위의 예시에서는 `Linux-node-` 라는 캐시가 존재하는지 찾아보고, 존재하면 해당 캐시를 복원한다는 것이다.

## 주의사항

- cache 기능을 이용할 때 외부 노출에 민감한 정보는 저장하지 않아야 한다. Github 공식 문서에 따르면, repository 에 읽기 권한이 있는 사람이라면 pull request 를 생성해서 캐시 내용에 접근할 수 있다고 한다. 마찬가지로 repository 를 fork 해서 pull request 를 올려서 캐시 내용에 접근할 수 있다고 한다.
  - 정확히 어떻게 캐시에 접근하는 지 모르겠으나, 아무튼 중요한 정보는 cache 에 포함하지 말라는 것이 핵심이다.
- 캐시는 최대 10GB 까지 저장할 수 있다. 10GB 가 넘으면 사용한 지 오래된 캐시부터 지워지며, 1주일 이상 사용하지 않은 캐시도 지워진다.

# 참고자료

- [뱅크샐러드 Web chapter에서 GitHub Action 기반의 CI 속도를 개선한 방법](https://blog.banksalad.com/tech/github-action-npm-cache/) [뱅크샐러드]
- [Building and testing Node.js](https://docs.github.com/en/actions/automating-builds-and-tests/building-and-testing-nodejs) [github docs]
- [Caching dependencies to speed up workflows](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows) [github docs]
- [actions/setup-node](https://github.com/actions/setup-node) [github]
- [actions/cache](https://github.com/actions/cache) [github]
- [hashFiles](https://docs.github.com/en/actions/learn-github-actions/expressions#hashfiles) [github docs]
