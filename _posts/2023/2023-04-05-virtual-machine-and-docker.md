---
title: "가상머신과 도커의 차이"
date: 2023-04-05 12:00:00 +0900
categories: [docker]
tags: [docker]
---

# 가상머신과 도커의 차이

하나의 물리 서버를 효율적으로 사용하기 위해 ‘서버 가상화 기술’이 발전했다.

가상머신과 컨테이너는 모두 서버 가상화 기술을 적용한 것이다.

하지만 어떤 가상화 소프트웨어를 사용하는지, 어떤 시스템 레벨을 가상화하는지에 차이가 존재한다.

## 가상화

가상화는 컴퓨터에서 하나의 물리 하드웨어 시스템에서 여러 가상 시스템을 실행하는 기술이다.

일반적인 가상화는 아래의 세 가지를 의미한다.

- 하나의 물리 시스템에서 여러 운영체제를 동시에 운영
- CPU, 메모리, HDD 등을 소프트웨어를 통해 논리적으로 생성
- 물리 서버 단위가 아닌 애플리케이션 단위로 전환

![1.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/1.png)

출처: [virtual space](http://www.virtual-space.co.kr/virtualization.html)

## 가상머신

가상머신은 ‘하이퍼바이저’를 이용해 하드웨어 자원을 가상화한다.

하이퍼바이저는 호스트 시스템에서 다수의 게스트 OS 를 구동할 수 있게 해주는 소프트웨어다.

또한, 하드웨어와 각각의 가상머신을 모니터링하는 중간 관리자 역할을 한다.

하이퍼바이저를 통해 만들어진 가상머신은 독립된 환경에서 실행된다.

하이퍼바이저가 설치된 물리 하드웨어를 호스트라고 하며, 호스트의 자원을 사용하는 가상머신을 게스트라고 한다.

하이퍼바이저는 필요한 자원이 게스트가 사용할 수 있도록 CPU, 메모리, 스토리지 등 가상 인스턴스를 제어할 수 있다.

하이퍼바이저는 2가지 유형으로 분류할 수 있다.

### 1. 네이티브/하이퍼바이저형(Native/bare-metal, Type1)

![2.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/2.png)

출처: [위키백과](https://ko.wikipedia.org/wiki/%ED%95%98%EC%9D%B4%ED%8D%BC%EB%B0%94%EC%9D%B4%EC%A0%80)

하이퍼바이저가 하드웨어 바로 위에서 실행되는 방식이다.

하이퍼바이저가 하드웨어를 직접 제어하기 때문에 자원을 효율적으로 사용할 수 있다.

또한 별도의 호스트 OS가 없어서 오버헤드(어떤 처리를 하기 위해 필요한 간접적인 처리 시간 및 메모리)가 적지만, 여러 하드웨어 드라이버를 세팅해야 하므로 설치가 어렵다는 특징이 있다.

대표적으로 Xen, 마이크로소프트 Hyper-V, KVM 이 이에 해당한다.

> 참고로 인텔 맥 제품에서 윈도우즈를 사용할 수 있는 ‘부트캠프’는 가상화가 아닌 멀티 부팅 방식으로 구현되어 있다. 윈도우즈로 부팅하면 UNIX 커널이 부트캠프에게 하드웨어 제어권한을 넘기고, 부트캠프가 BIOS 역할을 하는 방식으로 작동한다. (맥 제품은 BIOS가 아닌 EFI 를 사용함)
>

네이티브형 하이퍼바이저는 전가상화, 반가상화 방식으로 세분화 할 수 있다.

우선 전가상화와 반가상화를 이해하기 위해 링 구조에 대한 이해가 필요하다.

> CPU 인스트럭션 실행 Ring 구조
>

![3.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/3.png)

출처: [클라우드 이해하기 2: 전가상화와 반가상화 (2)](https://medium.com/@ch.lee2/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-3-%EC%A0%84%EA%B0%80%EC%83%81%ED%99%94%EC%99%80-%EB%B0%98%EA%B0%80%EC%83%81%ED%99%94-6f00b1f5e741)

필요한 하드웨어 자원을 할당하기 위해 x86 서버는 4개(Ring 0~3)의 특권 명령을 운영체제와 어플리케이션에게 제공한다.

링 번호가 낮을 수록 높은 권한을 가진 명령을 실행할 수 있다.

현재 가상화는 대부분 x86 서버에서 이루어지고 있다. x86 서버 위에서 작동하는 가상머신들은 하드웨어 위에 설치되어 있기 때문에 스스로 컴퓨터 하드웨어를 통제하고 있다고 여긴다.

응용 프로그램은 Ring 3 에서 실행되고, 운영체제는 Ring 0에서 특권 명령을 사용하여 필요한 컴퓨팅 자원에 접근할 수 있다.

> 전가상화(Full Virtualization)
>

![4.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/4.png)

출처: [클라우드 이해하기 2: 전가상화와 반가상화 (2)](https://medium.com/@ch.lee2/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-3-%EC%A0%84%EA%B0%80%EC%83%81%ED%99%94%EC%99%80-%EB%B0%98%EA%B0%80%EC%83%81%ED%99%94-6f00b1f5e741)

![5.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/5.png)

출처: [서버 가상화 기술의 진화: VM과 컨테이너](https://library.gabia.com/contents/infrahosting/7426/)

전가상화는 하드웨어를 완전히 가상화 하는 방식으로 Hardware virtual machine 으로 불린다.

하이퍼바이저를 구동하면 DOM0 이라는 관리용 가상 머신이 실행되며, 모든 가상머신들의 하드웨어 접근이 DOM0을 통해 이루어진다.

즉, 가상머신에서 요청하는 모든 명령에 대해 DOM0 이 개입하는 것이다.

하이퍼바이저는 가상화된 게스트 OS 종류에 상관없이 각 운영체제들이 내리는 명령어를 이해할 수 있다.

![6.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/6.png)

출처: [3. [Cloud Computing] 전가상화와 반가상화 [네이버 블로그]](https://blog.naver.com/alice_k106/220218878967)

하이퍼바이저는 번역 역할 뿐만 아니라 가상화된 운영체제들에게 자원을 할당하는 역할도 한다.

- 장점 : 하드웨어를 완전히 가상화하기 때문에 게스트 OS를 별도로 수정하지 않아도 된다.
- 단점 : 하이퍼바이저가 모든 명령을 중재하기 때문에 성능이 비교적 느리다.

> 반가상화(Para virtualization)
>

![7.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/7.png)

출처: [클라우드 이해하기 2: 전가상화와 반가상화 (2)](https://medium.com/@ch.lee2/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-3-%EC%A0%84%EA%B0%80%EC%83%81%ED%99%94%EC%99%80-%EB%B0%98%EA%B0%80%EC%83%81%ED%99%94-6f00b1f5e741)

![8.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/8.png)

출처: [서버 가상화 기술의 진화: VM과 컨테이너](https://library.gabia.com/contents/infrahosting/7426/)

반가상화는 전가상화와 달리 하드웨어를 완전히 가상화하지 않는다.

반가상화에서는 운영체제가 Ring 1 에 위치하여 특권 명령을 실행할 수 없다.

가상머신 프로그램마다 명칭은 다르긴 하지만, 운영체제에서 전달 받은 특권명령을 대체명령으로 변경하여 하이퍼바이저에게 요청을 날리도록 하고 있다.

즉, 가상화된 운영체제들이 각각 다른 번역기를 갖고 있는 것이다. 그 번역기는 하드웨어가 인식할 수 있는 형태로 번역해주는 것이다.

![9.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/9.png)

출처: [3. [Cloud Computing] 전가상화와 반가상화 [네이버 블로그]](https://blog.naver.com/alice_k106/220218878967)

하지만, 이를 위해 게스트 OS를 일부 수정해야 한다.

- 장점 : 모든 명령을 DOM0 을 통해 하이퍼바이저에게 요청하는 전가상화에 비해 빠르다.
- 단점 : 하이퍼바이저에게 번역해서 요청할 수 있도록 운영체제의 커널을 수정해야 한다. 오픈소스 운영체제가 아니라면 반가상화를 이용하기 쉽지 않다.

### 2. 호스트형(Hosted)

호스트형 하이퍼바이저는 일반 소프트웨어처럼 호스트 OS 위에서 실행된다.

![10.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/10.png)

출처: [위키백과](https://ko.wikipedia.org/wiki/%ED%95%98%EC%9D%B4%ED%8D%BC%EB%B0%94%EC%9D%B4%EC%A0%80)

하드웨어 자원을 가상머신 내부의 게스트 OS 에 에뮬레이트 하는 방식이기 때문에 네이티브 방식에 비해 오버헤드가 크다. 하지만 게스트 OS 종류에 대한 제약이 없다는 장점이 있다.

> **에뮬레이션** : 하드웨어 자원의 동작을 소프트웨어로 대신하는 가상화 방식을 의미한다. 에뮬레이터 안의 소프트웨어는 자신이 하드웨어를 통해 실행되는 것으로 인식하지만, 사실은 개발자가 만든 소프트웨어로 실행되는 것이다.

대표적으로 닌텐도 기기에서만 작동되는 게임을 데스크탑에서 실행할 수 있도록 만든 에뮬레이터가 있다. 닌텐도에서 작동하는 CPU 와 메모리의 동작을 데스크탑이 따라할 수 있도록 구현한 것이다.

메모리는 배열로 구현할 수 있고, CPU 명령어는 어떤 동작을 원하는지 해석하여 코드로 대신 해석하는 것이다.

CPU 가 직접 명령어를 실행하는 것보다 비효율적이지만, 현대의 컴퓨터는 고전 게임기들보다 충분한 컴퓨팅 파워를 갖고 있기 때문에 실행하는데 큰 문제가 없다.
>

대표적으로 VMWare, Virtual Box 가 있다.

하이퍼바이저에 의해 실행되는 가상머신은 각각 독립된 가상의 자원을 할당 받는다. 가상머신은 논리적으로 분리되어 있기 때문에 하나의 가상머신에서 오류가 발생해도 다른 가상머신으로 확산되지 않는다는 장점이 있다.

![11.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/11.png)

출처: [서버 가상화 기술의 진화: VM과 컨테이너](https://library.gabia.com/contents/infrahosting/7426/)

## 컨테이너

### 개요

가상머신은 OS 를 격리시켜 실제로 어떤 하드웨어에서 작동하고 있는지 알 수 없게 만들었다.

이에 반해 컨테이너는 1개 이상의 프로세스를 격리시켜 어떤 OS 환경에서 작동하는지 알 수 없도록 만든다.

![12.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/12.png)

출처: [서버 가상화 기술의 진화: VM과 컨테이너](https://library.gabia.com/contents/infrahosting/7426/)

컨테이너는 전용 루트 디렉토리를 부여 받고, 이 안에서는 root 계정 권한을 수행할 수 있지만, 호스트의 파일에는 접근할 수 없다. 프로세스 ID 도 자신만의 것을 가지고 있기 때문에 호스트에서 어떤 PID 를 부여했는지 알 수 없다.

### 리눅스, 유닉스 환경에서의 컨테이너

루트 디렉토리를 격리한다는 것은 `chroot` 명령어를 사용해서 프로세스가 실행되는 루트를 변경한다는 것이다.

![13.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/13.png)

출처: [컨테이너 기초 - chroot를 사용한 프로세스의 루트 디렉터리 격리 [44bits]](https://www.44bits.io/ko/post/change-root-directory-by-using-chroot)

`chroot` 를 사용하면 호스트의 `/bin`, `/usr/local` 과 같은 디렉토리에 접근이 불가능해지므로 호스트의 런타임 환경을 사용할 수 없다.

따라서 격리된 루트 디렉토리에는 런타임 환경을 넣어서 가상환경을 만들어주어야 한다. 런타임 환경은 프로그램이 정상적으로 실행되기 위한 환경을 의미한다. 넓은 의미에서는 운영체제나 하드웨어를 포함하지만, 여기서에는 libc 와 같은 공유 라이브러리를 의미한다.

하지만 격리된 디렉토리 안에서 필요한 라이브러리를 미리 준비하고 설정하는 것은 복잡했으며, 완벽한 가상환경이 아니었기에 여러 가지 제약이 있었다고 한다.

### 리눅스 컨테이너(LXC, Linux Container)

`chroot` 를 이용한 컨테이너의 한계를 극복하기 위해 등장한 것이 LXC(**L**inu**x** **C**ontainer)라는 시스템 레벨의 가상화이다.

LXC 는 리눅스 커널 레벨에서 제공되는 격리된 가상화 공간이다. 가상머신과는 달리 하드웨어를 에뮬레이트 하거나 OS 자체를 가상화하지 않고 파일 시스템만 가상화하기 때문에 컨테이너라고 부른다.

컨테이너는 호스트 OS 의 커널을 공유하기 때문에 `init(1)` 과 같은 프로세스가 필요하지 않으며, 가상화 프로그램과는 달리 적은 메모리 사용량과 적은 오버헤드를 보인다.

![14.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/14.png)

출처: [[DOCKER] 도커 컨테이너(DOCKER CONTAINER)에 대한 이해](https://dololak.tistory.com/351) [티스토리]

리눅스 커널에서 cgroups(control groups)는 CPU, 메모리, 보조기억장치, 네트워크 등의 자원 관리한다. 프로세스와 스레드를 그룹화하고, 그룹 안에 존재하는 프로세스와 스레드를 관리한다.

그리고 namespaces 는 프로세스 트리, 사용자 계정, 파일 시스템, IPC 등을 격리시켜서 호스트 OS 와 공간을 만든다.

### 도커 컨테이너(Docker Container)

![15.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/15.png)

출처: [Docker(container)의 작동 원리: namespaces and cgroups](https://tech.ssut.me/what-even-is-a-container/) [tech.ssut]

도커 컨테이너는 LXC 를 기반으로 이미지와 컨테이너 관리를 위한 다양한 기능을 제공한다.

위의 그림에서 `lxc`, `libcontainer` 등은 위에서 설명한 cgroups, namespaces 를 표준으로 정의한 OCI(Open Container Initative) 스펙을 구현한 컨테이너 기술의 구현체이다.

LXC 는 캐노니컬 이라는 영국의 소프트웨어 회사가 지원하는 리눅스 컨테이너 프로젝트이다. 도커 1.8 이전 버전까지는 LXC 를 이용한 구현체를 사용했다. 이후 버전에서는 `libcontainer` 를 `runC` 로 리팩토링하여 자체 구현체를 가지게 되었다.

![16.png](/assets/images/2023/2023-04-05-virtual-machine-and-docker/16.png)

containerd 는 OCI 구현체를 이용해 컨테이너를 관리하는 daemon 이다.

도커 엔진은 이미지, 네트워크, 디스크 등을 관리한다.

도커 엔진과 containerd 가 완전히 분리된 덕분에 도커 엔진의 버전을 올린 다음 도커 엔진을 재시작해도 컨테이너를 재시작하지 않고도 사용할 수 있다.

## 참고자료

- [서버 가상화 기술의 진화: VM과 컨테이너](https://library.gabia.com/contents/infrahosting/7426/) [가비아]
- [가상화 입문 - 에뮬레이션, 가상머신, 컨테이너](https://velog.io/@skynet/%EA%B0%80%EC%83%81%ED%99%94-%EC%9E%85%EB%AC%B8-%EC%97%90%EB%AE%AC%EB%A0%88%EC%9D%B4%EC%85%98-%EA%B0%80%EC%83%81%EB%A8%B8%EC%8B%A0-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88) [velog]
- [가상화(Virtualization) 정리1 (서버 / 리소스 / 가상 머신 VM / 하이퍼바이저 / 미들웨어 / 호스트 / 게스트 / 운영체제 OS / CPU / Intel)](https://blog.naver.com/shakey7/221472286783) [네이버 블로그]
- [Multi-booting](https://en.wikipedia.org/wiki/Multi-booting) [Wikipedia]
- [부트캠프 설치의 모든 것 (BOOTCAMP)](https://blog.naver.com/javeri/220609770144) [네이버 블로그]
- [가상화의 종류3가지](https://tech.cloud.nongshim.co.kr/2018/09/18/%EA%B0%80%EC%83%81%ED%99%94%EC%9D%98-%EC%A2%85%EB%A5%983%EA%B0%80%EC%A7%80/) [NDS]
- [[DOCKER] 도커 컨테이너(DOCKER CONTAINER)에 대한 이해](https://dololak.tistory.com/351) [티스토리]
- [[Docker] Docker의 작동 구조 (2) (cgroups)](https://kimjingo.tistory.com/38) [티스토리]
- [Docker(container)의 작동 원리: namespaces and cgroups](https://tech.ssut.me/what-even-is-a-container/) [tech.ssut]
- [[Docker] 도커 컨테이너의 동작 원리 (LXC, namespace, cgroup)](https://anweh.tistory.com/67) [티스토리]
- [[Server] 가상화(Virtualization)란? (1/2)](https://mangkyu.tistory.com/86) [티스토리]
- [가상머신(Virtual Machine)의 이해](https://webdir.tistory.com/392) [티스토리]
- [Docker와 가상화 기술](https://velog.io/@palza4dev/Docker%EC%99%80-%EA%B0%80%EC%83%81%ED%99%94-%EA%B8%B0%EC%88%A0) [velog]