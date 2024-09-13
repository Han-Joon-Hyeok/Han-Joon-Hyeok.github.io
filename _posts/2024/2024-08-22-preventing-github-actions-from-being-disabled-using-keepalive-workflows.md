---
title: "[GitHub Actions] cron 비활성화 자동으로 막기 (keepalive workflow)"
date: 2024-08-22 09:30:00 +0900
categories: [github, github actions]
tags: []
---

# 문제점

Github 공식 문서([링크](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/disabling-and-enabling-a-workflow))에 따르면, public repository 에 60일 동안 commit 이 발생하지 않으면 cron 으로 작동하는 Github Actions 는 비활성화 된다.

> **Warning:** To prevent unnecessary workflow runs, scheduled workflows may be disabled automatically. When a public repository is forked, scheduled workflows are disabled by default. In a public repository, scheduled workflows are automatically disabled when no repository activity has occurred in 60 days.
>

그래서 60일이 지나면 비활성화된 workflow 는 수동으로 다시 활성화 해주어야 하는 번거로움이 있었다.

# 해결 방법

이를 해결하기 위해 주기적으로 workflow 을 enable 하는 Keepalive Workflow([링크](https://github.com/marketplace/actions/keepalive-workflow))를 사용했다.

```yaml
# keepalive.yaml

name: Keepalive Workflow
on:
  schedule:
    - cron: "0 0 * * *"
permissions:
  actions: write
jobs:
  cronjob-based-github-action:
    name: Keepalive Workflow
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gautamkrishnar/keepalive-workflow@v2
        with:
          workflow_files: "main.yaml"
```

이 Keepalive Workflow 는 Github API 를 이용해서 명시한 workflow 를 활성화 하거나, 빈 commit 을 생성해서 push 한다.

기본적으로 50일 이내 repository 에 발생한 commit 이 없으면 workflow 를 활성화 시킨다.

구체적으로 Github API 는 아래의 REST API 를 이용한다.

```
PUT /repos/{owner}/{repo}/actions/workflows/{workflow_id}/enable
```

- 참고자료: [Enable a workflow](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#enable-a-workflow) [Github Docs]

즉, 위의 `keepalive.yaml` 코드는 repository 에 commit 이 50일 이상 발생하지 않았다면 매일 workflow 의 상태를 active 로 바꾼다.

그래서 마지막 commit 이 발생한 지 60일이 지난 시점에 workflow 가 비활성화 되어도 매일 workflow 를 활성화 시킨다.

참고로 `.github/workflows` 폴더의 구조는 아래와 같다.

```bash
.github
└── workflows
    ├── keepalive.yaml
    └── main.yaml
```

keepalive 를 아래와 같이 `main.yaml` 파일 안에서 함께 사용할 수도 있다.

```yaml
name: Github Action with a cronjob trigger
on:
  schedule:
    - cron: "0 0 * * *"
jobs:
  main-job:
    name: Main Job
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # - step1
      # - step 2
      # - Step N
  keepalive-job:
    name: Keepalive Workflow
    runs-on: ubuntu-latest
    permissions:
      actions: write
    steps:
      - uses: actions/checkout@v4
      - uses: gautamkrishnar/keepalive-workflow@v2
```

하지만, keepalive workflow 코드는 별도로 분리하는 것이 좋다고 생각한다.

다른 workflow 를 생성한다면 동일한 코드를 입력해야 하는 번거로움과 코드 중복이 발생한다.

그래서 keepalive workflow 파일 안에서 다른 workflow 파일들을 관리하는 것이 훨씬 효율적이다.

keepalive workflow 파일을 분리해도 다른 workflow 파일과 keepalive workflow 파일을 동시에 활성화 하기 때문에 keepalive workflow 파일이 비활성화 되는 일은 발생하지 않는다.

# 코드 분석

## 불필요한 활성화 요청

workflow 를 한번 활성화 시키고 나면 이후 60일까지는 활성화 상태를 유지하는 것으로 알고 있다.

keepalive workflow 코드를 살펴보니 마지막 commit 으로부터 60일이 지난 이후에는 매일 활성화 API 를 요청하고 있었다.

그렇기에 workflow 가 마지막으로 업데이트 된 날짜로부터 60일이 지났는지도 확인한다면 불필요한 API 요청을 보내지 않아도 된다.

workflow 의 정보에서는 `updated_at` 이라는 속성이 있는데, workflow 활성화 API 를 요청하면 해당 속성이 업데이트 된다.

- 참고자료: [Get a workflow](https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#get-a-workflow) [Github Docs]

즉, `updated_at` 의 값이 60일 이상 지났다면 한번만 활성화 요청을 보내면 된다.

## 어느 것이 더 효율적일까?

하지만 매번 update 정보를 받아오는 것은 낭비일 수 있다.

마지막 commit 이 45일 전이라면 계속 활성화 요청만 날리면 되고, response 로는 204 No Content 가 온다.

만약, 매번 update 정보를 받아오려면 workflow 에 대한 조회가 매번 이루어지고, 이에 대한 json 내용이 response 로 온다.

response 크기는 204 로 왔을 때가 가장 작기 때문에 update 날짜를 확인하는 것은 전체 네트워크 관점에서 생각했을 때 데이터를 덜 주고 받는 방법일 것이다.

# 참고자료

- [Prevent scheduled GitHub Actions from becoming disabled](https://stackoverflow.com/questions/67184368/prevent-scheduled-github-actions-from-becoming-disabled) [stackoverflow]