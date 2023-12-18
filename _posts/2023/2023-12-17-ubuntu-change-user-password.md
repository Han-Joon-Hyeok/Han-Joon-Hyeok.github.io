---
title: "[Linux] EC2 ubuntu 사용자 비밀번호 변경"
date: 2023-12-17 21:20:00 +0900
categories: [linux]
tags: []
---

# passwd 명령어

- 문법은 아래와 같다.

```bash
passwd [사용자명]
```

## EC2 ubuntu 계정 비밀번호 변경

- `sudo` 를 이용하면 ubuntu 계정의 비밀번호가 기억나지 않아도 새로운 비밀번호로 변경할 수 있다.

```bash
sudo passwd ubuntu
```

## 일반 사용자 비밀번호 변경

- 일반 사용자의 비밀번호가 기억나지 않는다면, ubuntu 계정으로 접속해서 아래의 명령어를 실행하여 변경한다.

```bash
sudo passwd [user_name]
```

# 참고자료

- [[ubuntu] 사용자 비밀번호 변경하는 법](https://bskyvision.com/entry/ubuntu-%EC%82%AC%EC%9A%A9%EC%9E%90-%EB%B9%84%EB%B0%80%EB%B2%88%ED%98%B8-%EB%B3%80%EA%B2%BD%ED%95%98%EB%8A%94-%EB%B2%95) [bskyvision.com]