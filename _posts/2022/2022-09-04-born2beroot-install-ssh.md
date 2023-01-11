---
title: "[Born2beroot] 5. SSH 설치 및 설정"
date: 2022-09-04 22:40:00 +0900
categories: [42seoul]
tags: [born2beroot]
use_math: true
---

# Vim 설치

Vim 을 설치하는 이유는 환경 파일 설정할 때 편리하게 사용하기 위함이다.

사실 Vi 가 기본적으로 설치되어 있기 때문에 Vim 설치는 필수가 아니다.

아래의 명령어를 이용해서 설치할 수 있다.

```bash
sudo apt install vim
```

# SSH 설정

외부에서 서버에 접속하기 위해 OpenSSH 라는 프로그램을 사용한다.

## 설치 방법

1. 아래의 명령어를 입력해서 설치 여부를 확인한다.
    
    ```bash
    apt search openssh-server
    ```
    
2. 설치되어 있지 않다면 다음의 명령어를 입력한다.
    
    ```bash
    apt install openssh-server
    ```
    

## SSH 포트 변경

기본적으로 SSH 는 22번 포트로 연결된다.

과제에서 요구하는 4242 포트로 연결할 수 있도록 설정한다.

1. 아래의 명령어를 입력해서 SSH 설정 파일을 연다.
    
    ```bash
    sudo vim /etc/ssh/sshd_config
    ```
    
    - `sshd_config` : 서버 측에서 설정하는 파일
    - `ssh_config` : 클라이언트 측에서 설정하는 파일
2. 포트 번호를 입력하는 부분의 주석을 제거하고 4242 로 변경한다.
    
    ![1.png](/assets/images/2022-09-04-born2beroot-install-ssh/1.png)
    
3. SSH 를 통해 접근한 사용자가 root 계정에 접근하는 것을 방지하기 위해 `PermitRootLogin` 항목을 `no` 로 변경한다.
    
    ![2](/assets/images/2022-09-04-born2beroot-install-ssh/2.png)
    
4. 파일을 저장하고 ssh 를 재시작하여 설정을 적용한다.
    
    ```bash
    sudo systemctl restart ssh
    ```
    
    - systemctl(system control) 명령어는 작동하고 있는 서비스(프로그램)의 상태를 제어할 수 있다.
5. ssh 가 정상적으로 작동하는지 다음의 명령어를 입력해서 확인한다.
    
    ```bash
    sudo systemctl status ssh
    ```
    
    ![3](/assets/images/2022-09-04-born2beroot-install-ssh/3.png)
    
    - active(running) 으로 표시되었다면 정상적으로 작동하는 것이다.

# 포트 포워딩

가상환경 외부에서 가상환경에 접속하는 과정은 다음과 같이 진행된다.

1. client OS 에서 host OS 의 특정 포트로 접속한다.
2. host OS 의 특정 포트가 client OS 로 연결을 허용한다.

이를 위해서는 포트 포워딩이 필요하다.

포트 포워딩(port forwarding)이란 외부에서 들어오는 패킷을 내부의 적절한 포트로 전달하는 것을 의미한다.

- 포트 : 컴퓨터에서 통신을 필요하는 프로그램을 고유하게 구분하는 번호

그림으로 표현하면 다음과 같다.

![port_forwarding.png](/assets/images/2022-09-04-born2beroot-install-ssh/port_forwarding.png)

이를 위해서는 가상 머신의 IP 주소와 로컬 컴퓨터의 IP 주소가 필요하다.

- 가상 머신 IP 주소 조회 (가상 머신에서 실행)
    
    ```bash
    hostname -I
    ```
    
- 로컬 컴퓨터 IP 주소 조회 (Mac OS에서 실행)
    
    ```bash
    ipconfig getifaddr en0
    ```
    

이후 포트 포워딩 설정시 사용하기 때문에 별도로 메모를 해두자.

## 설정 방법

1. VirtualBox 프로그램의 Settings 클릭
    
    ![4](/assets/images/2022-09-04-born2beroot-install-ssh/4.png)
    
2. Network - Advanced - Port Forwarding 클릭
    
    ![5](/assets/images/2022-09-04-born2beroot-install-ssh/5.png)
    
3. Host IP 에는 로컬 컴퓨터의 IP 주소를, Guest IP 에는 가상 머신의 IP 주소를 입력한다. 포트 번호는 각각 2424, 4242로 설정한다.

![6.png](/assets/images/2022-09-04-born2beroot-install-ssh/6.png)

1. 로컬 컴퓨터에서 터미널을 실행하여 다음의 명령어를 실행한다.
    
    ```bash
    ssh [가상머신 계정명]@[호스트 IP주소] -p [호스트 포트번호]
    ```
    
2. 아래의 화면과 같이 접속되면 정상이다.
    
    ![7](/assets/images/2022-09-04-born2beroot-install-ssh/7.png)
    
3. root 계정으로 접근했을 때 접근이 거부되어야 한다.
    
    ![8](/assets/images/2022-09-04-born2beroot-install-ssh/8.png)
    

# 참고자료

- [포트포워딩(Port-Forwarding) 이란?](https://storytown.tistory.com/14) [티스토리]