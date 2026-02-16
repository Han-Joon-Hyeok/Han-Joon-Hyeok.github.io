---
title: "[GitHub] Octokit 을 이용한 Issue 생성 시 Issue 생성자를 GitHub Bot 으로 변경하기"
date: 2024-08-28 15:10:00 +0900
categories: [github, javascript]
tags: []
---

# 개요

GitHub Octokit([링크](https://github.com/octokit/octokit.js))를 이용해서 Issue 를 생성할 때, Issue 생성자를 GitHub Bot(GitHub App) 으로 변경하는 방법에 대해 정리했다.

# 배경

매일 한국 시간 오전 5시에 오늘 날씨 정보를 받아와서 GitHub Issue 로 등록하는 GitHub Actions 를 실행하고 있다.

Issue 는 아래와 같이 생성된다.

![1.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/1.png)

현재 나의 GitHub 계정에 생성한 Repository 에서 Issue 를 생성하다보니, 아래의 이미지와 같이 매일 GitHub 프로필 페이지에 잔디가 심어지고 있었다.

![2.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/2.png)

실제로 개발의 결과로 생긴 잔디가 아닌 날씨 정보를 Slack 으로 알림을 보내기 위해 Issue 를 생성해서 생긴 잔디였기 때문에 개발을 많이 하고 있는 것 같다는 착각이 들었다.

commit 또는 PR 을 생성하거나, 리뷰를 남기는 것과 같이 내가 무언가를 한 활동에 대해서만 잔디를 심고 싶었다.

# 해결방안 탐색

## 1. Repository 를 GitHub Organization 소속으로 옮기기

Repository 가 나의 계정에 소속되어 있기 때문에 Issue 생성이 나의 프로필 잔디에 반영된다고 생각했다.

그래서 Organization 을 생성해서 Organization 에 Repository 를 옮긴 후 Issue 를 생성했다.

하지만, 여전히 나의 프로필 잔디에 반영되었다.

## 2. Issue 생성자 변경하기

1번의 결과에서 Repository 의 소속과 상관없이 Issue 를 발행한 주체에 따라 잔디가 심어진다는 것을 알았다.

최근에 오픈소스에 기여하면서 봤던 PR 의 코멘트를 남겨주는 bot 계정이 불현듯 떠올랐다.

![3.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/3.png)

Issue 를 생성하려면 Personal Access Token 이 필요한데, 이 토큰의 주체가 내가 아닌 bot 이기만 하면 된다.

즉, bot 을 이용해서 Issue 를 생성하면 나의 프로필 잔디를 심지 않을 것이라는 생각으로 이어졌다.

자료를 찾아보니 GitHub App 을 이용하면 내가 원하는 대로 할 수 있다는 것을 알게 되었다.

> 참고자료: [How to generate an access token for an organization? (or, best alternative?)](https://www.reddit.com/r/github/comments/1744og1/how_to_generate_an_access_token_for_an/?rdt=54187) [reddit]
>

# GitHub App 생성 및 설치

1. GitHub 홈페이지 우측 상단에서 환경 설정 버튼 클릭 후 [Settings] 페이지로 이동한다.

    ![4.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/4.png)

2. 좌측 하단에 [Developers settings] 를 클릭한다.

    ![5.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/5.png)

3. [New GitHub App] 버튼을 클릭한다.

    ![6.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/6.png)

4. [GitHub App name] 과 [Homepage URL] 을 입력한다.
    1. [GitHub App name] 은 GitHub 내에서 고유한 이름을 가져야 한다. 다른 사람들이 사용하는 이름과 겹치면 생성이 되지 않는다.
    2. [Homepage URL] 은 아무거나 입력해도 무방하지만, 해당 App 을 사용할 Repository 주소를 입력해주면 좋다.

    ![7.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/7.png)

5. [Webhook] 은 사용하지 않을 것이기 때문에 [Active] 박스의 선택을 해제해준다.

    ![8.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/8.png)

6. [Permissions] 에서 [Repository permissions] 를 클릭하여 [Issues] 의 권한을 `Read and write` 로 설정한다.

    ![9.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/9.png)

7. [Create GitHub App] 버튼을 클릭해서 생성한다.

    ![10.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/10.png)

8. GitHub App 을 Repository 에 설치하기 위해서는 Private Key 가 필요하다. 이를 위해 화면 하단에 있는 [Generate a private key] 버튼을 클릭한다.

    ![11.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/11.png)

    ![12.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/12.png)

9. 버튼을 클릭하면 `pem` 파일을 다운로드 하는 창이 표시된다. 기억하기 쉬운 위치에 저장한다.

    ![13.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/13.png)


10. [Install App] 탭으로 이동해서 [Install] 버튼을 클릭한다.

    ![14.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/14.png)

11. [Only select repositories] 를 선택하고, App 을 사용하고자 하는 Repository 를 선택 후 [Install] 버튼을 클릭한다.

    ![15.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/15.png)


아래와 같은 화면이 표시되면 정상적으로 설치된 것이다.

![16.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/16.png)

bot 의 이미지를 설정하지 않으면 나의 계정 이미지로 설정되기 때문에 bot 구분을 쉽게하기 위해 이미지를 등록한다.

![17.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/17.png)

참고로 이미지의 배경색은 흰색으로 설정해야 눈에 잘 띈다.

배경색 변경은 아래의 링크에서 진행했다.

- [photokit.com](https://photokit.com/features/change-photo-background/?lang=ko)

# Octokit 설정

## 1. 라이브러리 설치

Octokit 을 이용해서 issue 를 생성하기 위해 아래의 명령어를 실행해서 라이브러리를 설치한다.

```bash
npm install @octokit/rest @octokit/auth-app
```

## 2. 인증 정보 설정

위에서 생성한 GitHub App 이 GitHub Repository 에 접근할 수 있는 권한이 있다는 것을 증명하기 위해서는 `appId`, `privateKey`, `installationId` 가 필요하다.

```jsx
// index.js

import { Octokit } from "@octokit/rest";
import { createAppAuth } from "@octokit/auth-app";

import env from "./env.js";

const appOctokit = new Octokit({
  authStrategy: createAppAuth,
  auth: {
    appId: env.github.appId,
    privateKey: env.github.privateKey,
    installationId: env.github.installationId,
  },
});
```

### appId

`appId` 는 GitHub App 의 고유한 식별자를 의미한다.

[Settings] - [Developers settings] - [GitHub Apps] - [생성한 App 이름] - [General] 경로에서 확인 가능하다.

![18.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/18.png)

### privateKey

`privateKey` 는 위에서 발급 받은 `pem` 파일의 내용을 의미한다.

참고로 해당 파일은 아래와 같은 형식으로 되어있다.

```
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA0hGEsrf...
-----END RSA PRIVATE KEY-----
```

### installationId

GitHub App 을 GitHub Repository 에 설치하면 생성되는 번호이다.

[Settings] - [Developers settings] - [GitHub Apps] - [생성한 App 이름] - [Install App] 경로에서 [설정] 버튼을 클릭한다.

![19.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/19.png)

주소의 맨 마지막에 숫자가 적혀있는데, 이것이 `installationId` 이다.

![20.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/20.png)

## 3. 이슈 생성

`@octokit/rest` 라이브러리를 이용해서 아래와 같이 Issue 를 생성할 수 있다.

```jsx
// index.js

import { Octokit } from "@octokit/rest";
import { createAppAuth } from "@octokit/auth-app";

import env from "./env.js";

const appOctokit = new Octokit({
  authStrategy: createAppAuth,
  auth: {
    appId: env.github.appId,
    privateKey: env.github.privateKey,
    installationId: env.github.installationId,
  },
});

try {
  const { owner, repo } = env.github;

	await appOctokit.issues.create({
	  owner,
	  repo,
	  title: "issue title",
	  body: "issue body",
	  labels: ["label1"],
	});
	console.log("GitHub 이슈 생성 성공");
} catch (error) {
	console.error(error);
}
```

터미널에서 아래의 명령어를 실행해서 정상적으로 Issue 가 생성되는지 확인한다.

```bash
node index.js
```

정상적으로 bot 계정으로 Issue 가 생성되었고, 프로필 이미지도 설정한 대로 표시되는 것을 확인할 수 있다.

![21.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/21.png)

프로필 잔디에서도 bot 이 생성한 issue 는 확인되지 않는다.

![22.png](/assets/images/2024/2024-08-28-github-changing-issuer-to-github-app/22.png)

# 예시 코드

실제로 GitHub Actions 까지 반영해서 실행 중인 코드는 아래의 링크에서 확인할 수 있다.

- https://github.com/Han-Joon-Hyeok/42seoul-42km

# 참고자료

- [auth-app.js](https://github.com/octokit/auth-app.js) [GitHub]

끝.