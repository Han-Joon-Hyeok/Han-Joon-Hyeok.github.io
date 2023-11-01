---
title: [Github Actions] refusing to allow a Personal Access Token to create or update workflow 에러 해결 방법
date: 2023-11-01 23:50:00 +0900
categories: [github]
tags: [github, github actions]
---

# 문제 상황

- Github actions 를 사용하기 위해 `.yml` 파일을 수정했다.
- `git push` 를 시도했으나 아래와 같은 에러 메세지가 표시되었다.
  ```bash
  ! [remote rejected] main -> main (refusing to allow a Personal Access Token to create or update workflow `.github/workflows/[file].yml` without `workflow` scope)
  error: failed to push some refs to 'https://github.com/[organization]/[repo].git'
  ```

# 문제 원인

- 에러 메세지를 읽어보면 Github 계정마다 발급해서 사용하는 개인 접근 토큰에 `workflow` 라는 범위(scope)가 포함되어 있지 않기 때문이라는 것을 알 수 있다.

# 문제 해결

- Github 페이지에서 Settings - Developer settings - Personal access tokens - Tokens 로 접속한다.
  - https://github.com/settings/tokens
- 사용하고 있는 토큰 중에서 현재 작업 중인 PC 에 저장된 토큰을 클릭한다.
  ![1](/assets/images/2023/2023-11-01-github-actions-refusing-to-allow-a-personal-access-token/1.png)
- 아래의 사진에 표시된 부분에 해당하는 `workflow` 버튼을 활성화하고, 하단에 있는 `Update token` 버튼을 눌러서 변경 사항을 저장한다.
  ![2](/assets/images/2023/2023-11-01-github-actions-refusing-to-allow-a-personal-access-token/2.png)
- 다시 `git push` 를 시도하면 정상적으로 작동하는 것을 확인할 수 있다.

# 참고자료

- [[Github] refusing to allow a Personal Access Token to create or update workflow 에러 해결](https://coding-nyan.tistory.com/61) [티스토리]
