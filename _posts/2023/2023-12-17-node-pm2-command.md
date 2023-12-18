---
title: "[Node] pm2 명령어 정리"
date: 2023-12-17 21:20:00 +0900
categories: [linux]
tags: []
---

# pm2 명령어 정리

- 실행 : pm2 start [빌드파일.js]
- 리스트 확인 : pm2 list
- 중지 : pm2 stop [서비스 이름]
- 재시작 : pm2 restart [서비스 이름]
- 삭제 : pm2 delete [서비스 이름]
- 실시간 로그 출력 확인 : pm2 monit

# 참고자료

- [실행 프로세스 관리하기 ( PM2 명령어 모음 )](https://dev-joo.tistory.com/6) [티스토리]
- [[NodeJS] pm2 를 통하여 NodeJS 프로세스 관리하기](https://www.deok.me/entry/NodeJS-pm2-%EB%A5%BC-%ED%86%B5%ED%95%98%EC%97%AC-NodeJS-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0) [티스토리]