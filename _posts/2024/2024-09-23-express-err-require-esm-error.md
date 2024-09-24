---
title: "[Express] ERR_REQUIRE_ESM 오류 해결하기"
date: 2024-09-23 20:30:00 +0900
categories: [javascript]
tags: []
---

# 개발 환경

- Express: 4.21.0
- TypeScript: 4.9.5
- ts-node: 10.9.2

# 문제 상황

GitHub Repository 에 이슈를 생성하기 위해 `octokit` 라이브러리를 사용하고 있었다.

```tsx
import { Octokit } from "octokit";

import env from "@modules/env";

const octokit = new Octokit({
  auth: env.githubConfig.auth,
});

const OWNER = env.githubConfig.owner;
const REPO = env.githubConfig.repo;
const github = async () => {
  try {
    const response = await octokit.request(
      `POST /repos/${OWNER}/${REPO}/issues`,
      {
        owner: "OWNER",
        repo: "REPO",
        title: "title",
        body: "body",
        headers: {
          "X-GitHub-Api-Version": "2022-11-28",
        },
      }
    );
  } catch (error) {
    console.error(error);
  }
};
```

이슈 생성자를 내 계정이 아닌 GitHub App(bot) 으로 변경하기 위해 `@octokit/auth-app` 과 `@octokit/rest` 으로 라이브러리로 변경하면서 아래와 같이 코드를 변경했다.

```tsx
import { Octokit } from "@octokit/rest";
import { createAppAuth } from "@octokit/auth-app";

import env from "@modules/env";

const octokit = new Octokit({
  authStrategy: createAppAuth,
  auth: {
    appId: env.githubConfig.appId,
    privateKey: env.githubConfig.privateKey,
    installationId: env.githubConfig.installationId,
  },
});

const github = async () => {
  const { owner, repo } = env.githubConfig;

  try {
    const response = await octokit.issues.create({
      owner,
      repo,
      title: "title",
      body: "body",
    });
  } catch (error) {
    console.error(error);
  }
};
```

라이브러리를 변경하고 나서 서버를 실행하니 아래와 같은 오류가 발생했다.

```
Error [ERR_REQUIRE_ESM]: require() of ES Module ...
```

# 원인 파악

`ERR_REQUIRE_ESM` 오류는 commonJS 환경에서 `require()` 함수로 ESM(ECMAScript Modules) 을 불러올 때 때 발생한다.

commonJS 와 ESM 의 차이를 간단하게 살펴보면 아래와 같다.

```jsx
// 1. commonJS

// math.js
function add(a, b) {
  return a + b;
}

module.exports = { add };

// main.js
const math = require("./math"); // CommonJS 방식으로 모듈을 불러옴
console.log(math.add(2, 3)); // 출력: 5

// 2. ESM

// math.mjs
export function add(a, b) {
  return a + b;
}

// main.mjs
import { add } from "./math.mjs"; // ESM 방식으로 모듈을 불러옴
console.log(add(2, 3)); // 출력: 5
```

프로젝트의 `tsconfig.json` 에는 아래와 같이 설정되어있었다.

```jsx
{
  "compilerOptions": {
    "module": "commonjs",
  },
  // ... 이하 생략
}
```

# 해결 방법

## ts-node 대신 tsx 사용하기

TypeScript 를 컴파일 하기 위해 사용했던 ts-node 대신 tsx 로 변경했다.

```yaml
# package.json

"deploy": "pm2 start --interpreter tsx build/app.js",
"start": "nodemon --exec tsx ./src/app.ts"
```

`tsconfig.json` 의 `compilerOptions.module` 값을 `module` 로 변경해보기도 했지만, 여러 설정을 한 번에 바꾸다보니 문제 해결이 쉽게 되지 않았다.

소스 코드를 내가 작성한 게 아니라 다른 분께서 작성한 걸 넘겨 받아서 유지보수만 하고 있었던 상황이었기에 최대한 코드를 수정하지 않고 싶었다.

ts-node 대신 tsx 를 사용하면 깔끔하게 문제가 해결된다는 글을 읽고 적용해보았고, 다행히 문제가 금방 해결되었다.

## @PrimaryColumn 데이터 타입 추가

tsx 로 변경하고 나서 다른 오류가 발생했다.

> ColumnTypeUndefinedError: Column type for EvaluationQuestionMapEntity#e_key is not defined and cannot be guessed. Make sure you have turned on an "emitDecoratorMetadata": true option in tsconfig.json. Also make sure you have imported "reflect-metadata" on top of the main entry file in your application (before any entity imported).If you are using JavaScript instead of TypeScript you must explicitly provide a column type.

TypeORM 을 사용하고 있었는데, 엔티티와 관련해서 오류가 발생하고 있었다.

```tsx
@Entity("events")
export class Events {
  @PrimaryColumn()
  id: number;
}
```

문제는 `@PrimaryColumn` 어노테이션에 데이터 타입을 명시하지 않아서 발생하는 문제였다.

어노테이션의 매개변수로 데이터 타입을 입력하면 문제가 해결된다.

```tsx
@Entity("events")
export class Events {
  @PrimaryColumn("int")
  id: number;
}
```

# 참고자료

- [모듈 시스템의 역사, 그리고 ESM](https://velog.io/@yesbb/모듈-시스템의-역사-그리고-ESM) [velog]
- [Unknown file extension ".ts" for server.ts](https://velog.io/@ahhpc2012/Unknown-file-extension-.ts-for-server.ts) [velog]
- [Unknown file extension ".ts" for a TypeScript file](https://stackoverflow.com/questions/62096269/unknown-file-extension-ts-for-a-typescript-file) [stackoverflow]
- [[NestJS] ColumnTypeUndefinedError: Column type for EvaluationQuestionMapEntity#e_key is not defined and cannot be guessed.](https://thisisspear.tistory.com/144) [티스토리]
