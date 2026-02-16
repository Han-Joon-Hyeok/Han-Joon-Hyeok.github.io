---
title: "[Linux] MacOS 에서 실행한 virtualbox 가상머신에 ssh 접속하기"
date: 2024-01-17 14:38:00 +0900
categories: [inux]
tags: []
---

# 실행 환경

- OS
  - MacOS : Catalina 10.15.7
  - Ubuntu : 22.04
- Virtualbox : 6.1.48

# 문제 상황

호스트인 MacOS 에서 게스트인 Virtualbox 의 가상머신(ubuntu 22.04)에 접속을 시도했지만, 무한 대기에 걸리면서 접속되지 않았다.

```bash
ssh [hostname]@localhost
```

포트포워딩은 아래와 같이 설정했었다.

- Host IP 에는 로컬 호스트를 의미하는 127.0.0.1 을, Host Port 에는 22번 포트를 입력했다.
- Guest IP 에는 가상머신의 IP 주소를, Guest Port ssh 연결을 위한 22번 포트를 입력했다.
- 참고로 virtualbox 가상머신에 기본적으로 할당되는 IP 주소는 10.0.2.15 다.

![1.png](/assets/images/2024/2024-01-17-virtualbox-ssh-connection-with-macos/1.png)

# 문제 원인

MacOS 에서 기본적으로 22번 포트를 ssh 를 위해 사용하고 있는데, 해당 포트 번호를 이용해서 Virtualbox 의 가상머신과 통신하려고 시도했기 때문이다.

즉, 포트 번호가 겹쳤기 때문에 정상적으로 사용하지 못한 것이다.

또한, ubuntu 에는 ufw 가 기본적으로 설치되어 있고, 모든 포트 번호를 차단하고 있다.

그래서 가상머신의 22번 포트 번호를 개방해주어야 한다.

# 문제 해결

아래의 2가지 절차를 모두 거쳐서 해결할 수 있다.

## 1. 포트포워딩 번호 변경

MacOS 에서 기본적으로 사용하지 않는 포트 번호로 설정하면 된다. (ex. 2222, 2424, 4242, 3000 등)

![2.png](/assets/images/2024/2024-01-17-virtualbox-ssh-connection-with-macos/2.png)


## 2. ufw 포트 개방

ssh 연결을 위해 사용하는 포트 번호 22를 열어주기 위해 가상머신에서 아래의 명령어를 입력한다.

```bash
sudo ufw allow 22
```

최종적으로 아래와 같이 정상적으로 ssh 연결이 이루어진 것을 확인할 수 있다.

![3.png](/assets/images/2024/2024-01-17-virtualbox-ssh-connection-with-macos/3.png)
