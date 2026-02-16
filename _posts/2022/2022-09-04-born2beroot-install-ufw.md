---
title: "[Born2beroot] 4. UFW 설치 및 설정"
date: 2022-09-04 22:20:00 +0900
categories: [l42seoul]
tags: [born2beroot]
use_math: true
---

# 방화벽이란?

방화벽은 컴퓨터의 보안을 위해 미리 정의된 규칙에 기반하여 들어오고 나가는 네트워크 트래픽을 모니터링하고 제어하는 네트워크 보안 시스템이다. 내부에서 외부의 정보 통신망에 접근하거나 외부에서 내부로 불법적으로 접근하는 움직임을 차단한다.

현실에서 방화벽은 건물에서 화재가 더 이상 번지는 것을 막기 위해 존재한다. 이러한 의미를 컴퓨터에 적용하면 네트워크 보안 사고나 문제가 커지는 것을 막기 위한 것으로 이해할 수 있다.

## 방화벽의 목적

인가받지 않은 사용자가 내부 컴퓨터 자원을 사용 또는 교란하거나 중요한 정보를 외부에 유출하는 것을 방지하기 위해 사용한다.

처음 인터넷이 등장했을 당시에는 방화벽이 필요 없었지만, 시간이 지나면서 정보의 중요성이 높아지면서 방화벽이 등장하게 되었다.

## 작동 원리

방화벽은 허가된 사용자가 아니라면 접근 자체를 차단한다.

기본적으로 방화벽은 모든 접근을 거부하고, 단계적으로 접근을 허용한다. 네트워크를 통해 데이터가 이동하는 통로를 포트(port)라 하는데, 방화벽은 약 65,000 개의 통신 포트를 모두 차단하고, 접근을 허용하는 특정 포트만 열어둔다.

포트 뿐만 아니라 IP 주소나 특정 프로그램에 따라 접근 및 차단을 결정할 수 있다.

# UFW란?

Uncomplicated Firewall(복잡하지 않은 방화벽) 의 약자로 리눅스 계열 운영체제에서 사용하기 쉬운 방화벽 관리 프로그램이다.

리눅스 커널은 다양한 네트워크 관련 연산을 수행하는 netfilter(넷필터)라는 프레임워크를 사용하고 있는데, 이를 관리하는 것이 UFW 이다.

netfilter 는 리눅스에서 방화벽을 설정하기 위해 iptables 라는 프로그램을 사용한다.

사용자가 직접 iptables 를 관리하기에는 복잡하기 때문에 이러한 절차를 간편하게 해준 것이 UFW 이다.

## iptables

iptables 는 지나가는 패킷의 헤더를 검사해서 패킷의 통과 여부를 결정하는 패킷 필터링을 사용한다.

패킷은 헤더와 데이터로 구성되어 있다. 헤더에는 크게 다음과 같은 정보가 들어있다.

- 출발지 IP 및 PORT 번호
- 도착지 IP 및 PORT 번호
- Checksum : 통신 중에 오류가 발생했는지 검사하는 데이터

헤더의 정보를 통해 조건을 구성함으로써 서버 내부에서 외부로 나가거나 서버 외부에서 내부로 나가는 네트워크 통신을 통제할 수 있다.

## UFW 설치 및 활성화

1. 아래의 명령어를 입력해서 UFW 를 설치한다.

   ```bash
   sudo apt install ufw
   ```

2. UFW 의 상태를 확인하기 위해 다음의 명령어를 입력한다.

   ```bash
   sudo ufw status verbose
   ```

   - `verbose` 옵션은 `status` 옵션이 표시하는 정보에서 추가 정보를 표시하기 위해 사용한다.

   ![1](/assets/images/2022/2022-09-04-born2beroot-install-ufw/1.png)

3. 다음의 명령어를 입력해서 부팅 시 UFW 가 작동하도록 한다.

   ```bash
   sudo ufw enable
   ```

   ![2](/assets/images/2022/2022-09-04-born2beroot-install-ufw/2.png)

4. 다음의 명령어를 입력해서 4242 포트만 열어준다.

   ```bash
   sudo ufw allow 4242
   ```

   ![3](/assets/images/2022/2022-09-04-born2beroot-install-ufw/3.png)

# 참고자료

- [방화벽](<https://ko.wikipedia.org/wiki/%EB%B0%A9%ED%99%94%EB%B2%BD_(%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%82%B9)>) [위키백과]
- [정보보안 - 방화벽의 개념, 원리](https://dany-it.tistory.com/20) [티스토리]
- [UFW](https://help.ubuntu.com/community/UFW) [ubuntu]
- [UFW](https://ko.wikipedia.org/wiki/UFW) [위키백과]
- [ufw 설정](https://imcr.tistory.com/11) [티스토리]
- [넷필터](https://ko.wikipedia.org/wiki/%EB%84%B7%ED%95%84%ED%84%B0) [위키백과]
- [iptables 개념 및 명령어](https://linuxstory1.tistory.com/entry/iptables-%EA%B8%B0%EB%B3%B8-%EB%AA%85%EB%A0%B9%EC%96%B4-%EB%B0%8F-%EC%98%B5%EC%85%98-%EB%AA%85%EB%A0%B9%EC%96%B4) [티스토리]
- [checksum(검사합) 이란?](https://galid1.tistory.com/310) [티스토리]
