---
title: "GitHub 오픈소스 기여하기"
date: 2024-08-25 15:50:00 +0900
categories: [github]
tags: []
---

# 개요

개발을 시작한 이후 처음으로 오픈소스에 기여했다.

오픈소스에 기여한 이유와 오픈소스에 기여하는 과정, 그리고 이 과정에서 느낀 점을 정리했다.

# 오픈소스에 기여한 이유?

이번에 오픈소스 2개에 기여를 했는데, 각 오픈소스에 대한 간략한 설명과 기여한 이유는 아래와 같다.

## 1. SST ION

### 소개

SST ION([링크](https://github.com/sst/ion))는 프론트엔드 프레임워크 프로젝트(Next.js, Remix, Svelte 등)를 AWS 에 간편하게 배포할 수 있도록 도와주는 오픈소스다.

v2 에서는 CloudFormation 을 이용해서 AWS 자원을 생성했는데, v3 beta 버전에 해당하는 ION 은 Pulumi 와 Terraform 을 이용한다.

참고로 v2 에서 발생했던 대표적인 문제로는 AWS 자원이 정상적으로 삭제 되지 않거나, CDK(Cloud Development Kit)에서 오류 메세지에 명확한 원인을 표시하지 않는 문제가 있었다고 한다. 자세히 알고 싶다면 아래의 링크를 참고하자.

- 참고자료: [Moving away from CDK](https://sst.dev/blog/moving-away-from-cdk) [SST]

### AWS IAM 정책 코드에 Region 과 Account 가 Placeholder 처리 되어있지 않았다.

AWS 에 배포하기 위해 사용할 AWS 서비스에 대한 최소한의 권한을 부여하는 IAM 역할 정책을 설정해야 한다.

SST 공식문서에서는 IAM 정책 예시 코드(json)를 제공해주고 있었다. ([링크](https://sst.dev/docs/iam-credentials#iam-permissions))

json 에는 사용할 서비스의 Region 과 Account 를 `Resource` 속성에 아래와 같이 작성해야 한다.

```diff
{
    "Sid": "ManageBootstrapECRRepo",
    "Effect": "Allow",
    "Action": [
        "ecr:CreateRepository",
        "ecr:DescribeRepositories"
    ],
    "Resource": [
+       "arn:aws:ecr:REGION:ACCOUNT:repository/sst-asset"
    ]
},
```

공식문서에서는 `arn:aws:ecr:REGION:ACCOUNT:repository/sst-asset` 와 같이 `REGION` 과 `ACCOUNT` 는 변수 처리(placeholder)해놓았다.

변수로 처리하면 해당하는 단어만 선택해서 내용을 간단하고 쉽게 변경할 수 있다는 장점이 있다.

덕분에 VSCode 에서 `command+d` 단축키를 이용해 같은 단어를 모두 선택했고, 쉽게 나의 계정 정보로 수정할 수 있었다.

하지만, json 내용이 하나라도 잘못되면 AWS 서비스를 정상적으로 이용할 수 없기 때문에 코드를 다시 한번 검토하던 도중, 한 블럭에서만 placeholder 처리가 되어있지 않은 것을 발견했다.

```diff
{
    "Sid": "ManageSecrets",
    "Effect": "Allow",
    "Action": [
        "ssm:DeleteParameter",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:PutParameter"
    ],
    "Resource": [
+       "arn:aws:ssm:us-east-1:112233445566:parameter/sst/*"
    ]
},
```

즉, `REGION` 과 `ACCOUNT` 를 변수로 처리 하지 않아서 나의 AWS 계정 정보가 반영되지 않을 뻔 했던 것이다.

다른 사람들도 분명히 이 코드를 이용할텐데, AWS 에 익숙하지 않다면 트러블슈팅을 할 때 어려움이 있을 것이라 생각해서 PR 을 올리기로 결심했다.

### 결과물

https://github.com/sst/ion/pull/885

PR 을 올린 다음 날 merge 가 되었다.

![1.png](/assets/images/2024/2024-08-25-open-source-contribution/1.png)

## 2. keepalive-actions

### 소개

keepalive-actions([링크](https://github.com/gautamkrishnar/keepalive-workflow))는 Github Public Repository 에 Actions 에 cron 으로 등록한 workflow 가 비활성화 되지 않고 지속적으로 작동할 수 있도록 도와주는 오픈소스이다.

현재 나는 Slack 채널에 오늘 날씨 정보를 보내는 GitHub Bot 을 운영하고 있다.

Slack 워크스페이스 권한 부족으로 Slack Bot 을 자유롭게 만들지 못하고 있는데, 대안으로 Slack 에서 제공하는 GitHub 앱을 이용했다.

GitHub 앱을 이용하면 특정 GitHub Repository 에 Issue 가 등록되면 아래의 이미지와 같이 특정 채널에 메세지를 발송할 수 있다.

![2.png](/assets/images/2024/2024-08-25-open-source-contribution/2.png)

날씨 정보를 보내주는 코드는 자주 바꿀 이유가 없었기 때문에 commit 을 안하고 있었는데, 어느 순간 메세지가 발송되지 않았다.

GitHub 공식문서([링크](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/disabling-and-enabling-a-workflow))에 따르면, Repository 에 60일 동안 활동(commit)이 없으면 cron 으로 등록한 GitHub Actions Workflow 를 비활성화 한다고 아래와 같이 나와있다.

> **Warning:** To prevent unnecessary workflow runs, scheduled workflows may be disabled automatically. When a public repository is forked, scheduled workflows are disabled by default. In a public repository, scheduled workflows are automatically disabled when no repository activity has occurred in 60 days.

자주 사용하지 않는 Workflow 는 비활성화 해야 GitHub 의 불필요한 컴퓨팅 자원 사용을 막고 비용을 줄일 수 있기 때문에 위와 같은 정책을 설정한 것으로 보인다.

그래서 비활성화 된 Workflow 를 수동으로 활성화 해주었는데, 활성화 이후 60일이 지나서 또 Workflow 가 비활성화 되었다.

주기적으로 직접 활성화 여부를 확인하는 작업이 번거로워서 자동화 할 수 있는 방법을 찾다보니 keepalive-actions 를 발견했다.

keepalive-actions 의 작동 원리를 소개하자면, 마지막 commit 으로부터 45일이 지났다면 빈 commit 을 생성하거나, GitHub REST API([링크](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#enable-a-workflow))를 요청해서 활성화를 한다.

### 변수의 기본 값이 서로 다르게 설정되어 있었다.

keepalive-actions 가 작동하는 원리를 살펴보기 위해 소스 코드를 전부 읽어보던 도중, 마지막 commit 이후 몇 일이 지나야 활성화 처리를 할 것인지 설정하는 `timeElapsed` 변수의 기본 값이 서로 다른 것을 발견했다.

참고로 GitHub Actions step 에서 사용할 변수와 값을 `with` 속성으로 아래와 같이 정의할 수 있다.

```diff
jobs:
  cronjob-based-github-action:
    name: Keepalive Workflow
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gautamkrishnar/keepalive-workflow@v2
+       with:
+         workflow_files: "main.yaml"
```

`with` 속성에 들어갈 key, value, value 의 기본 값은 `action.yml` 에 정의되어 있다.

```yaml
# action.yml

name: "Keepalive Workflow"
author: "Gautam Krishna R"
description: "GitHub action to prevent GitHub from suspending your cronjob based triggers due to repository inactivity"

inputs:
  gh_token:
    description: "GitHub access token with Repo scope"
    required: false
    default: ${{ github.token }}
  commit_message:
    description: "Commit message used while committing to the repo"
    default: "Automated commit by Keepalive Workflow to keep the repository active"
    required: false

  # ... 중략

  time_elapsed:
    description: "Time elapsed from the last commit to trigger a new automated commit or API call (in days)"
    default: "45"
    required: false

  # ...  이하 생략
```

`action.yml` 파일에는 기본 값이 `45` 인데, 소스 코드에서는 `50` 으로 설정되어 있었다.

```diff
# library.js

const KeepAliveWorkflow = async (githubToken,
                                committerUsername,
                                committerEmail,
                                commitMessage,
+ 				timeElapsed = 50,
                                autoPush = false,
                                autoWriteCheck = false) => {
  return new Promise(async (resolve, reject) => {

  // ... 이하 생략
```

`action.yml` 에서 `timeElapsed` 의 값을 전달해주기 때문에 실행하면 반드시 `45` 가 기본 값으로 들어가지만, 왜 기본 값이 각각 다른 건지 이유를 알고 싶었다.

그래서 git log 와 과거에 올라온 Issue, PR 을 찾아보니, 처음엔 `50` 이었다가 약 3개월 전에 `45` 로 바꾼 것을 확인했다.

- 참고자료: [Workflow being disabled even though v2 is in use #36](https://github.com/gautamkrishnar/keepalive-workflow/issues/36) [GitHub]

즉, `action.yml` 에는 반영한 내용을 소스 코드에는 미처 반영을 하지 못했기에 기본 값이 다르게 설정되어 있었던 것이다.

기본 값이 서로 다르게 설정되어 있더라도 프로그램이 작동하는 데에는 문제가 발생하지 않을 것으로 보였지만, 나처럼 코드를 읽는 사람들에게는 혼란을 줄 수 있다고 생각해서 PR 을 올렸다.

### 결과물

https://github.com/gautamkrishnar/keepalive-workflow/pull/45

올린 지 20분 채 되지 않아 빠르게 merge 가 되었다.

![3.png](/assets/images/2024/2024-08-25-open-source-contribution/3.png)

# 오픈소스 기여하는 방법

오픈소스 기여는 다른 사람의 GitHub Repository 에 Pull request 를 올려서 `git push` 를 하는 것이다.

간단하게 이해해보자면, 평소에 나의 repository 에 올리던 commit 을 다른 사람의 repository 에 올리는 것이다.

## 1. Repository fork 하기

PR(Pull Request)를 올리기 위해서는 기여하고자 하는 Repository 를 나의 계정으로 fork(복사) 해야 한다.

![4.png](/assets/images/2024/2024-08-25-open-source-contribution/4.png)

`Fork` 버튼을 클릭하면 아래와 같이 `Create a new fork` 페이지가 표시된다.

![5.png](/assets/images/2024/2024-08-25-open-source-contribution/5.png)

`Create fork` 버튼을 클릭하면 아래와 같이 나의 계정에 Repository 가 복사된다.

![6.png](/assets/images/2024/2024-08-25-open-source-contribution/6.png)

## 2. git clone 및 브랜치 생성

1번에서 생성한 Repository 를 로컬에 다운 받기 위해 `git clone` 명령어를 이용한다.

![7.png](/assets/images/2024/2024-08-25-open-source-contribution/7.png)

안전하게 작업하기 위해 별도의 브랜치를 생성한다.

```bash
# 브랜치 생성
git checkout -branch [new-branch-name]

# 브랜치 변경
git switch [new-branch-name]
```

## 3. 작업 후 git push

2번에서 생성한 브랜치에서 변경 내용을 commit 하고, 해당 브랜치로 `git push` 를 한다.

## 4. 원본 Repository 에 PR 생성

1번에서 나의 계정으로 복사해온 Repository 에서 [Pull requests] 탭으로 이동해서 `New pull request` 버튼을 클릭한다.

![8.png](/assets/images/2024/2024-08-25-open-source-contribution/8.png)

변경 사항을 적용할 원본 repository 및 branch 를 선택하고, 변경 사항이 적용된 나의 repository 와 branch 를 선택한다.

![9.png](/assets/images/2024/2024-08-25-open-source-contribution/9.png)

## 5. PR 문서 작성하기

### 문서 구조

우선 문서의 구조는 아래와 같이 잡고 작성했다.

1. 개요: 어떤 작업을 했는지 1줄 요약.
2. 배경: 왜 PR 을 올렸는지 이유 설명.
3. 변경 내용: 구체적으로 어느 부분을 변경했는지 설명. (선택사항)

3번의 변경 내용을 선택 사항이라고 표시한 이유는 1~2번에 이미 어느 정도 설명이 충분히 되었다면 3번을 작성하지 않았다.

그 이유는 commit 으로도 충분히 확인할 수 있기 때문이다.

변경 내용이 적었기 때문에 commit 을 확인하는 것이 훨씬 빠르다고 생각했다.

### 영어로 작성하기

오픈소스는 대부분 영어로 문서화 되어있다.

그래서 PR 도 영어로 작성해야 한다.

영어 글쓰기에 자신이 없다면 ChatGPT 를 적극적으로 활용해보자.

예를 들면, 아래와 같이 한글 문장을 영어로 바꾸도록 요청할 수 있다.

![10.png](/assets/images/2024/2024-08-25-open-source-contribution/10.png)

### 감사인사 전하기(선택사항)

이 부분은 선택사항이지만, 좋은 프로그램을 무료로 배포해주는 개발자 분에게 정말 감사함을 느끼고 있어서 간단하게라도 감사인사를 전했다.

# 느낀 점

## 누구나 할 수 있다, 오픈소스 기여!

오픈소스에 기여하는 것은 나와 거리가 먼 일이라고 생각했었다.

오픈소스에 기여하려면 수 많은 양의 소스 코드를 읽고 이해해서 버그를 고치거나 기능을 추가할 수 있는 수준이 되어야 한다고 생각했다.

하지만, 오픈소스에 기여하기 위해서 반드시 소스 코드를 수정하거나 추가할 필요는 없었다.

README 파일에서 딱 1줄만 수정하는 것으로도 충분했다.

그리고 문제가 있으면 가만히 두지 않고 적극적으로 해결하고 해결 과정을 공유하는 편이라 오픈소스 기여까지 이어질 수 있었다.

오류가 발생하지 않는 프로그램을 만들고, 다른 사람이 읽기 좋은 코드를 작성하는 것은 중요하다.

이와 더불어 개발한 프로그램과 프로그램 사용법을 설명한 문서의 간극을 줄이는 것도 중요하다.

단 1줄의 잘못된 내용을 읽고 누군가는 수 많은 시행착오를 겪을 수 있기 때문이다.

그래서 오류를 수정함으로써 누군가의 시간을 아껴줄 수 있다는 것에 큰 기쁨을 느꼈다.

사실 PR 을 올리기 전에 ‘내가 틀렸으면 어쩌나’라는 걱정이 들기도 했다.

이미 맞게 작성된 내용을 틀렸다고 하는 건 아닌지 막연한 불안함과 PR 을 거절 당하는 두려움이 있었다.

그러나 이런 걱정은 괜한 기우였다.

내가 잘못 이해하고 있을 수도 있는 거고 그래서 PR 이 거절되어도 큰 일이 생기는 것도 아니었다.

또한, 오픈소스의 공식 기여자로 등록되는 것도 기분이 좋았다.

keepalive-workflow([링크](https://github.com/gautamkrishnar/keepalive-workflow)) 의 README 에 기여자 목록에 나의 프로필이 추가되었는데, 수 많은 외국인 사이에서 나의 사진이 걸려있어서 뿌듯하고 스스로 자랑스러웠다.

![11.png](/assets/images/2024/2024-08-25-open-source-contribution/11.png)

출처: [keepalive-workflow](https://github.com/gautamkrishnar/keepalive-workflow) [GitHub]

SST ion([링크](https://github.com/sst/ion))는 README 에 기여자를 추가하지 않지만, `Contributors` 페이지에 내 프로필이 등록된 것이 신기하고 기분이 좋았다.

참고로 `Contributors` 페이지에는 PR 이 Merge 되면 자동으로 추가된다.

![12.png](/assets/images/2024/2024-08-25-open-source-contribution/12.png)

출처: [sst/ion](https://github.com/sst/ion) [Github]

## 코드의 의도 이해하기

사실 keepalive-actions 는 소스 코드의 일부 로직을 변경하려고 했다.

기존 코드에서는 GitHub Actions Workflow 활성화 API 를 마지막 commit 으로부터 45일이 지나면 매일 보내도록 하고 있었다.

활성화 API 가 정상적으로 처리되고 나면 Workflow 를 비활성화 하는 기준은 마지막 commit 일자가 아니라 Workflow 의 마지막 업데이트(활성화 요청) 일자로 바뀐다.

그래서 Workflow 활성화 요청을 보내기 전에 Workflow 의 마지막 업데이트 일자를 확인하고, 마지막 업데이트 일자로부터 45일이 지났거나, 마지막 commit 으로부터 45일이 지났으면 활성화 API 를 보내는 것이 매일 활성화 API 요청을 보내지 않도록 할 수 있는 방법이라 생각했다.

하지만, 코드를 작성하고 나서 다시 한번 생각해보니 매번 Workflow 의 업데이트 정보를 받아오는 것보다 매일 활성화 요청을 보내는 것이 훨씬 낫겠다는 생각이 들었다.

이유는 Workflow 에 대한 데이터를 받는 것보다 활성화 요청 API 를 보내는 것이 네트워크 트래픽을 줄일 수 있기 때문이었다.

Workflow 의 정보는 아래와 같은 json 형식으로 온다.

```json
{
  "id": 161335,
  "node_id": "MDg6V29ya2Zsb3cxNjEzMzU=",
  "name": "CI",
  "path": ".github/workflows/blank.yaml",
  "state": "active",
  "created_at": "2020-01-08T23:48:37.000-08:00",
  "updated_at": "2020-01-08T23:50:21.000-08:00",
  "url": "https://api.github.com/repos/octo-org/octo-repo/actions/workflows/161335",
  "html_url": "https://github.com/octo-org/octo-repo/blob/master/.github/workflows/161335",
  "badge_url": "https://github.com/octo-org/octo-repo/workflows/CI/badge.svg"
}
```

그리고 활성화 요청 API 의 정상 처리 응답은 204(No content)이다.

즉, response body 의 길이가 0 이라는 것이다.

기존 코드의 방식과 내가 변경하고자 했던 방식의 response body 길이를 비교하면 아래의 표와 같다.

|                                  | GET 요청 response body 길이 | PUT 요청 response body 길이 |
| -------------------------------- | --------------------------- | --------------------------- |
| 마지막 commit 조회하는 방식      | (요청하지 않음)             | 0                           |
| Workflow 정보 매일 조회하는 방식 | 1 이상                      | 0                           |

Workflow 정보를 매일 확인하는 것이 마지막 commit 날짜를 확인할 때보다 매일 GET 요청을 1번씩 더 보내는 것이고, 주고 받는 데이터도 추가로 발생한다.

기존 코드의 흐름이나 구조를 최대한 바꾸지 않는 방향으로 수정하려고 심혈을 기울여 코드를 작성했지만, 기존 코드의 숨겨진 의도를 이해하고 나니 나의 코드가 불필요하다는 결론을 내렸다.

애써 작성한 코드를 지우는 것은 아쉬웠지만, 그래도 다른 사람이 작성한 코드의 구조나 의도를 이해하는 연습을 할 수 있어서 좋았다.

# 마무리

앞으로도 오픈소스 기여는 꾸준히 할 것이다.

다음에는 단순 변경 사항이 아닌 소스 코드 단에서 로직이나 버그를 수정하여 PR 을 올리고, 사람들과 의견을 주고 받으며 프로그램이 발전하는 모습을 보고 싶다.

새로운 개발의 재미를 느낄 수 있던 경험이었다.

끝.
