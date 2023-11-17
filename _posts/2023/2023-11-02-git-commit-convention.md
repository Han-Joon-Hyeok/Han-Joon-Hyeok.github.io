---
title: "Git Commit Convention"
date: 2023-11-02 09:00:00 +0900
categories: [git]
tags: [git]
---

# Commit Convention

[Udacity Git Commit Message Style Guide](https://udacity.github.io/git-styleguide/) 를 참고하여 아래와 같은 규칙으로 사용합니다.

## 메세지 구조

커밋 메세지는 크게 제목, 본문, 꼬리말 3가지 파트로 나눕니다.

각 파트는 빈 줄을 두어 구분합니다.

```
**tag**(옵션): **Subject** [#issue_number]  // -> 제목
(한 줄을 띄워 분리합니다.)
**body**(옵션) //  -> 본문
(한 줄을 띄워 분리합니다.)
**footer**(옵션) // -> 꼬리말
```

- tag : 어떤 의도로 커밋했는지를 tag에 명시합니다. 자세한 사항은 아래서 설명하겠습니다.
- subject : 최대 50글자가 넘지 않도록 하고 마침표는 찍지 않습니다. 영문으로 표기하는 경우 동사(원형)를 가장 앞에 두고 첫 글자는 대문자로 표기합니다.
- body : 긴 설명이 필요한 경우에 작성합니다. **어떻게** 했는지가 아니라, **무엇을** **왜** 했는지를 작성합니다. 최대 75자를 넘기지 않도록 합니다.
- footer : issue tracker ID를 명시하고 싶은 경우에 작성합니다.

### 제목 (필수)

제목은 `tag: subject` 형태이며, `:` 뒤에 공백(space)를 추가합니다.

태그의 종류는 아래와 같습니다.

| 기능 관련 태그 |  |
| --- | --- |
| Feat | 새로운 기능을 추가할 경우 |
| Fix | 버그를 고친 경우 |
| Design | CSS 등 사용자 UI 디자인 변경 |
| !BREAKING CHANGE | 커다란 API 변경의 경우 |
| !HOTFIX | 급하게 치명적인 버그를 고쳐야하는 경우 |
| 개선 관련 태그 |  |
| Style | 오타 수정, 탭 사이즈 변경, 변수명 변경, 코드 포맷 변경, 세미 콜론 누락, 코드 수정이 없는 경우 |
| Refactor | 프로덕션 코드 리팩토링 |
| Comment | 필요한 주석 추가 및 변경 |
| 기타 |  |
| Docs | 문서를 수정한 경우 |
| Test | 테스트 추가, 테스트 리팩토링(프로덕션 코드 변경 X). test 폴더 내부의 변경이 일어난 경우만 해당 |
| Chore | 빌드 태스크 업데이트, 패키지 매니저를 설정하는 경우(프로덕션 코드 변경 X) package.json 변경, dotenv 요소 변경, 모듈 변경. |
| Rename | 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우 |
| Remove | 파일을 삭제하는 작업만 수행한 경우 |

예시는 아래와 같습니다.

```
Feat: Add apiManager using Axios #3
```

한글로 작성 가능합니다.

```
Feat: Axios 를 이용한 apiManager 구현 #3
```

### 본문 (선택)

본문은 다음의 규칙을 지킵니다.

1. 본문은 **한 줄 당 72자 내**로 작성합니다.
2. 본문 내용은 양에 구애받지 않고 **최대한 상세히 작성**합니다.
3. 본문 내용은 **어떻게 변경했는지** 보다 **무엇을 변경했는지** 또는 **왜 변경했는지**를 설명합니다.

예시는 아래와 같습니다.

> Backend와 API 통신 시 모든 request 에 JWT 토큰을 담기 위해 apiManager 를 개발했습니다.
(이하 생략)
>

### 꼬리말 (선택)

꼬리말은 다음의 규칙을 지킵니다.

1. 꼬리말은 optional이고 이슈 트래커 ID를 작성합니다.
2. 꼬리말은 "유형: #이슈 번호" 형식으로 사용합니다.
3. 여러 개의 이슈 번호를 적을 때는 쉼표로 구분합니다.
4. 이슈 트래커 유형은 다음 중 하나를 사용합니다.
    - Fixes: 이슈 수정중 (아직 해결되지 않은 경우)
    - Resolved: 이슈를 해결했을 때 사용
    - Ref: 참고할 이슈가 있을 때 사용
    - Related to: 해당 커밋에 관련된 이슈번호 (아직 해결되지 않은 경우)

예시는 아래와 같습니다.

```
Fixes: #45 Related to: #34, #23
```

## Commit Message Emoji (선택)

커밋 메세지의 태그를 알아보기 쉽게 이모지를 사용할 수 있습니다.

다만, 이모지 입력이 필수는 아닙니다.

이모지의 종류와 설명은 아래와 같습니다.

| 아이콘 | 설명 | 원문 |
| --- | --- | --- |
| 🎨 | 코드의 구조/형태 개선 | Improve structure / format of the code. |
| ⚡️ | 성능 개선 | Improve performance. |
| 🔥 | 코드/파일 삭제, @CHANGED 주석 태그와 함께 사용 | Remove code or files. |
| 🐛 | 버그 수정 | Fix a bug. |
| 🚑 | 긴급 수정 | Critical hotfix. |
| ✨ | 새 기능 | Introduce new features. |
| 📝 | 문서 추가/수정 | Add or update documentation. |
| 💄 | UI/스타일 파일 추가/수정 | Add or update the UI and style files. |
| 🎉 | 프로젝트 시작 | Begin a project. |
| ✅ | 테스트 추가/수정 | Add or update tests. |
| 🔒 | 보안 이슈 수정 | Fix security issues. |
| 🔖 | 릴리즈/버전 태그 | Release / Version tags. |
| 💚 | CI 빌드 수정 | Fix CI Build. |
| 📌 | 특정 버전 의존성 고정 | Pin dependencies to specific versions. |
| 👷 | CI 빌드 시스템 추가/수정 | Add or update CI build system. |
| 📈 | 분석, 추적 코드 추가/수정 | Add or update analytics or track code. |
| ♻️ | 코드 리팩토링 | Refactor code. |
| ➕ | 의존성 추가 | Add a dependency. |
| ➖ | 의존성 제거 | Remove a dependency. |
| 🔧 | 구성 파일 추가/삭제 | Add or update configuration files. |
| 🔨 | 개발 스크립트 추가/수정 | Add or update development scripts. |
| 🌐 | 국제화/현지화 | Internationalization and localization. |
| 💩 | 똥싼 코드 | Write bad code that needs to be improved. |
| ⏪ | 변경 내용 되돌리기 | Revert changes. |
| 🔀 | 브랜치 합병 | Merge branches. |
| 📦 | 컴파일된 파일 추가/수정 | Add or update compiled files or packages. |
| 👽 | 외부 API 변화로 인한 수정 | Update code due to external API changes. |
| 🚚 | 리소스 이동, 이름 변경 | Move or rename resources (e.g.: files paths routes). |
| 📄 | 라이센스 추가/수정 | Add or update license. |
| 💡 | 주석 추가/수정 | Add or update comments in source code. |
| 🍻 | 술 취해서 쓴 코드 | Write code drunkenly. |
| 🗃 | 데이버베이스 관련 수정 | Perform database related changes. |
| 🔊 | 로그 추가/수정 | Add or update logs. |
| 🙈 | .gitignore 추가/수정 | Add or update a .gitignore file. |

이모지를 간편하게 입력할 수 있는 방법을 2가지 소개합니다.

2가지 중에 하나만 선택해서 설치해도 되고, 2가지 모두 설치해서 사용해도 됩니다.

### Visual Studio Code Extension

Visual Studio Code 에서는 GUI 환경으로 간편하게 사용할 수 있는 **Gitmoji** 확장 프로그램이 있습니다.

간편하게 이모지 종류와 이모지의 설명을 확인할 수 있습니다.

아래의 링크를 클릭하여 설치할 수 있습니다.

- 링크 : https://marketplace.visualstudio.com/items?itemName=seatonjiang.gitmoji-vscode

실제 사용 화면은 아래와 같습니다.

![gitmoji.gif](/assets/images/2023/2023-11-02-commit-convention/1.gif)

### gitmoji-cli

터미널에서 소스를 커밋할 때 gitmoji-cli 를 이용하면 이모지를 함께 커밋에 포함할 수 있습니다.

아래의 명령어를 실행해서 설치할 수 있습니다.

```bash
# npm 을 이용하는 경우 전역으로 설치
npm i -g gitmoji-cli

# or

# brew 를 이용하는 경우
brew install gitmoji
```

참고로 gitmoji-cli 는 npm 패키지가 필요해서 node.js 가 먼저 설치되어 있어야 합니다.

사용법은 아래의 순서를 따릅니다.

- `git add` 명령어로 변경 사항을 스테이징 한다.
- `gitmoji -c` 를 입력하면 커밋을 작성한다.
- 태그에 해당하는 설명을 입력하면 자동으로 목록을 간추린다. 그 다음 원하는 태그를 선택한다.
- 제목에 해당하는 내용을 입력한다.
- 본문에 해당하는 내용을 입력한다.

실제 사용 화면은 아래와 같습니다.

![gitmoji-cli.gif](/assets/images/2023/2023-11-02-commit-convention/2.gif)

# 참고자료

- [[협업] 협업을 위한 git 커밋컨벤션 설정하기](https://overcome-the-limits.tistory.com/entry/%ED%98%91%EC%97%85-%ED%98%91%EC%97%85%EC%9D%84-%EC%9C%84%ED%95%9C-%EA%B8%B0%EB%B3%B8%EC%A0%81%EC%9D%B8-git-%EC%BB%A4%EB%B0%8B%EC%BB%A8%EB%B2%A4%EC%85%98-%EC%84%A4%EC%A0%95%ED%95%98%EA%B8%B0#%EC%A0%9C%EB%AA%A9%EC%9D%80-%EC%96%B4%EB%96%BB%EA%B2%8C-%EC%9E%91%EC%84%B1%ED%95%98%EB%8A%94%EA%B0%80) [티스토리]
- [⚡️ Gitmoji 사용법 정리 (+ 깃모지 툴 소개)](https://inpa.tistory.com/entry/GIT-%E2%9A%A1%EF%B8%8F-Gitmoji-%EC%82%AC%EC%9A%A9%EB%B2%95-Gitmoji-cli) [티스토리]
- [Udacity Git Commit Message Style Guide](https://udacity.github.io/git-styleguide/) [github.io]