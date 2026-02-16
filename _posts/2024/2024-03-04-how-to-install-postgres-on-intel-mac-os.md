---
title: "[PostgreSQL] Mac Intel 설치 및 실행 방법"
date: 2024-03-04 18:35:00 +0900
categories: [postgresql]
tags: []
---

# 설치 순서

## 1. brew install

MacOS 사용자는 brew 를 이용해서 PostgreSQL 를 쉽게 설치할 수 있다.

아래에서 `{version}` 으로 작성된 부분은 원하는 버전을 입력하면 된다.

```bash
brew install postgresql@{version}
```

16 버전을 사용하길 원한다면 아래와 같이 실행하면 된다.

```bash
brew install postgresql@16
```

설치가 정상적으로 끝나면 아래와 같이 표시될 것이다.

![1.png](/assets/images/2024/2024-03-04-how-to-install-postgres-on-intel-mac-os/1.png)

## 2. brew services start

1번에서는 PostgreSQL 파일을 다운 받은 것이고, 프로그램을 실행하기 위해서는 아래의 명령어를 입력하면 된다.

이 글에서는 16 버전을 기준으로 작성했다.

```bash
brew services start postgresql@16
```

## 3. 환경 변수 추가

PostgreSQL 는 `psql` 이라는 프로그램으로 DB 에 접속할 수 있다.

터미널에 아래의 명령어를 실행하면 `psql` 프로그램의 위치를 어디서 찾아올 것인지 설정한다.

Intel MacOS 기준으로는 `/usr/local/opt/postgresql@16/bin` 경로에 `psql` 프로그램이 존재하기 때문에 아래와 같이 입력한다.

```bash
echo 'export PATH="/usr/local/opt/postgresql@16/bin:$PATH"' >> ~/.zshrc
```

# 설치 확인

터미널을 종료했다가 다시 실행하고 아래의 명령어를 실행해서 버전이 표시되면 성공.

```bash
psql -V
# psql (PostgreSQL) 16.2 (Homebrew)
```

# 참고자료

- [PostgreSQL 설치 및 접속하기 - 맥북m1](https://backendcode.tistory.com/251) [티스토리]
