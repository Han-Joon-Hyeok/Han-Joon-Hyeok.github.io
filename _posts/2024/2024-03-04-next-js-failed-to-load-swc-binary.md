---
title: "[Next.js] Failed to load SWC binary for linux/x64 해결 방법"
date: 2024-03-04 00:30:00 +0900
categories: [typescript, nextjs]
tags: [typescript, nextjs]
---

# 실행 환경

- OS: MacOS(Intel) Sonoma 14.2.1
- Node : 21.1.0
- npm : 10.5.0

# 문제 상황

- Next.js 개발 서버를 실행하기 위해 `npm run dev` 를 실행했다.
- 하지만 `Failed to load SWC binary for linux/x64, see more info here: https://nextjs.org/docs/messages/failed-loading-swc` 라는 오류가 표시되며 정상적으로 실행되지 않았다.

# 문제 원인

- Next.js 는 빠른 컴파일을 위해 Rust 기반 컴파일러인 SWC 를 사용한다.
- SWC 바이너리 실행 파일이 다운로드 되지 않았을 경우 **`Failed to load SWC binary for linux/x64`** 과 같은 오류가 발생한다.

# 문제 해결

- `package-lock.json` 파일과 `node_modules` 폴더를 삭제한다.
- `sudo npm i -g npm@latest` 를 실행해서 로컬에 설치된 npm 을 최신 버전으로 업데이트한다.
- `npm i` 실행한다.

# 참고자료

- [Failed to load SWC binary for linux/x64 해결방법](https://velog.io/@developerjhp/Failed-to-load-SWC-binary-for-linuxx64-해결방법) [velog]
- [[오류해결] Failed to load SWC binary for win32/x64](https://velog.io/@soonmac/오류해결-Failed-to-load-SWC-binary-for-win32x64) [velog]
