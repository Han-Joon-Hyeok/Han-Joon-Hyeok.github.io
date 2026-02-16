---
title: "[Linux] python 을 crontab 으로 실행하도록 했는데 실행되지 않는 이유 (feat. 상대경로, 절대경로)"
date: 2023-12-17 21:20:00 +0900
categories: [inux]
tags: []
---

# 실행 환경

- OS : Ubuntu 22.04 (AWS EC2)
- MySQL : 8.0.35

# 문제 상황

- 기존에 사용하던 EC2 인스턴스에서 `mysqldump` 명령어를 이용해서 다른 EC2 인스턴스로 데이터를 옮기는 작업을 진행하고 있었다.
- 저장된 데이터가 적을 때는 `cat` 명령어를 이용해서 직접 마우스로 드래그해서 복사해서 붙여넣어도 큰 문제가 없었다.
- 하지만, 텍스트가 많이 저장된 DB를 dump 하면 마우스로 한 번에 파일의 모든 내용을 복사할 수 없었다.
- 그래서 효율적이고 빠르게 파일을 전송할 수 있는 방법을 찾게 되었다.

# 문제 해결

- `scp` 명령어를 이용하면 다른 컴퓨터로 파일을 통째로 전송하는 것이 가능하다.
- `scp` 는 `ssh` 와 동일하게 22번 포트를 이용해서 파일을 주고 받을 수 있다.
- EC2 인스턴스에 `ssh` 를 접속할 때 키 페어 파일 (`.pem`, `.cer`) 파일을 이용해서 접속하는 것처럼 `scp` 도 키 페어 파일을 사용하여 인증하기 때문에 안전하다.

## scp 명령어 사용법

- `.pem` 파일을 이용해서 파일을 전송한다고 가정하면 아래와 같이 사용할 수 있다.

```bash
scp -i [pem 파일] [현재 로컬에서 전송하고자 하는 파일] [사용자 계정]@[목적지 ip주소]:[목적지에 저장할 경로]
```

- 이해를 돕기 위해 예시를 통해 알아보자.

```bash
scp -i ~/.ssh/secret.pem backup.sql ubuntu@10.0.0.1:/home/ubuntu/service
```

- `-i ~/.ssh/secret.pem` : `~/.ssh` 디렉토리에 있는 `secret.pem` 파일을 이용해서 IP 주소가 `10.0.0.1` 인 컴퓨터에 접근 권한이 있다는 것을 인증한다.
- `backup.sql` : 현재 디렉토리에 있는 `backup.sql` 파일을 전송한다.
- `ubuntu@10.0.0.1` : IP주소가 `10.0.0.1` 인 컴퓨터의 `ubuntu` 계정의 권한으로 접근한다.
- `/home/ubuntu/service` : IP주소가 `10.0.0.1` 인 컴퓨터에 `/home/ubuntu/service` 경로에 `backup.sql` 파일을 저장한다.

## 파일 전송 순서

옮기고자 하는 원본 파일이 있는 EC2 인스턴스를 `source`, 옮기고자 하는 EC2 인스턴스를 `dest` 라고 해보자.

1. 로컬 → `source` 로 `dest` 의 `.pem` 키를 전송한다.
2. 1번에서 옮긴 `.pem` 키를 이용해서 `source` → `dest` 로 `source` 에서 옮기고자 하는 파일을 `dest` 로 옮긴다.
3. `dest` 에 접속해서 2번에서 전송한 파일이 제대로 도착했는지 확인한다.

# 참고자료

- [[Linux] scp를 이용해 로컬과 원격에 파일 전송하기](https://twpower.github.io/138-send-file-using-scp-command) [github.io]
- [ftp, ftps, sftp, ssh, scp 개념 정리](https://lazywon.tistory.com/49) [티스토리]