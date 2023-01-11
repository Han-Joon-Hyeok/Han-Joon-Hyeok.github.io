---
title: "KDump 개념과 사용하는 이유"
date: 2022-09-04 23:15:00 +0900
categories: [os]
tags: [os]
use_math: true
---

# KDump

KDump 는 커널 패닉이 발생했을 때 dump 파일을 생성하는 도구이다.

- 커널 패닉(kernel panic) : 운영체제가 치명적인 내부 오류를 감지하여 안전하게 복구가 불가능할 때 취하는 동작이다.
- 덤프 파일(dump file) : 컴퓨터 프로그램이 특정 시점에 작업 중이던 메모리 상태를 기록한 것으로, 프로그램이 비정상적으로 종료했을 때 만들어진다.

## 사용하는 이유?

커널 패닉이 발생하면 일반 사용자의 경우 재부팅하거나 포맷하면 그만이지만, 서버의 경우에는 그럴 수가 없다. 그렇기 때문에 문제가 발생했을 때 원인을 찾아서 동일한 문제가 다시 발생하지 않도록 하기 위해서 사용한다.

# 참고자료

- [커널 패닉](https://ko.wikipedia.org/wiki/%EC%BB%A4%EB%84%90_%ED%8C%A8%EB%8B%89) [위키백과]
- [코어 덤프](https://ko.wikipedia.org/wiki/%EC%BD%94%EC%96%B4_%EB%8D%A4%ED%94%84) [위키백과]
- [Linux kdump](https://lascrea.tistory.com/86) [티스토리]