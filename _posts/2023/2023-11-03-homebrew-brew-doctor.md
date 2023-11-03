---
title: "[Homebrew] brew doctor(compinit:503:)"
date: 2023-11-03 23:50:00 +0900
categories: [homebrew]
tags: [trouble shooting]
---

# 문제 상황

- Node 를 새로운 버전으로 업데이트하고 나서 오류가 발생했다.
- 정확한 오류 메세지를 기록하지 않아서 모르지만, 제목과 같은 내용이 포함되어 있었다.

# 문제 해결

- 터미널에서 `brew doctor` 실행 후 `brew clenup` 을 실행한다.
- `source ~/.zshrc` 을 실행한다.

# 참고자료

- [[Homebrew] brew doctor (compinit:503:)](https://sukvvon.tistory.com/40) [티스토리]
