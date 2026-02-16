---
title: "[AWS] EC2 인스턴스 ssh 키 없이 터미널 접속하는 방법 (AWS Session Manager)"
date: 2025-09-08 21:35:00 +0900
categories: [aws]
tags: []
use_math: true
---
# 개요

AWS EC2 인스턴스에 접속할 SSH 키가 없는 경우, Session Manager를 이용해서 터미널에 접속하는 방법을 소개한다.

# 문제 상황

개인 목적으로 EC2 인스턴스 1대를 운영하고 있다. 평소에 SSH 키를 이용해서 터미널에 접속했다.

crontab을 수정할 일이 생겼는데, 메인 PC는 물리적으로 사용할 수 없는 위치에 있었고, 서브 PC만 사용할 수 있는 상황이었다.

하지만 SSH 키 파일이 메인 PC에만 있었고, 서브 PC에는 없었다. 이런 경우에도 EC2에 접속할 수 있는 방법을 찾아내고자 했다.

# 해결 방법

AWS의 Session Manager를 이용하면 SSH 키 없이도 터미널에 접속할 수 있다.

## 1. Session Manager를 통한 접속

1. 접속할 인스턴스를 선택한 후 [Connect] 버튼을 클릭한다.

    ![1.png](/assets/images/2025/2025-09-08-connect-to-ec2-without-ssh-key-using-session-manager/1.png)

2. [Session Manager] 탭 선택한 뒤, [Connect] 버튼을 클릭한다.

    ![2.png](/assets/images/2025/2025-09-08-connect-to-ec2-without-ssh-key-using-session-manager/2.png)

3. 잠시 기다리면 웹 기반 터미널이 열린다.

## 2. crontab 수정

crontab을 수정하는 방법은 크게 두 가지가 있다.

### 1) 사용자 전환(su 명령어 사용)

터미널에 접속한 후 `whoami` 명령어를 실행하면, 현재 사용자 계정이 `ssm-user` 임을 확인할 수 있다.

![3.png](/assets/images/2025/2025-09-08-connect-to-ec2-without-ssh-key-using-session-manager/3.png)

Amazon Linux 2023.05 기준으로 기본 사용자 계정은 `ec2-user` 다. crontab은 사용자 계정별로 분리되기 때문에 `ssm-user` 가 아닌 `ec2-user`계정으로 전환해야 기존 crontab 설정을 볼 수 있다.

```bash
sudo su ec2-user
```

전환한 후 crontab을 확인하면 다음과 같이 기존 설정이 그대로 나타난다.

![4.png](/assets/images/2025/2025-09-08-connect-to-ec2-without-ssh-key-using-session-manager/4.png)

### 2) `sudo crontab -u` 옵션 사용

사용자를 전환하지 않고도 `sudo`명령어와 crontab의 `-u` 옵션을 이용하면 다른 계정의 crontab을 직접 수정할 수 있다.

```bash
sudo crontab -u ec2-user -e
```

![5.png](/assets/images/2025/2025-09-08-connect-to-ec2-without-ssh-key-using-session-manager/5.png)