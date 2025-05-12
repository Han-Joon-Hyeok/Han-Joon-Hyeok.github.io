---
title: "Docker network 개념 정리"
date: 2023-04-05 12:48:00 +0900
categories: [docker]
tags: [docker]
---

# Docker network

## 개념

도커 컨테이너는 격리된 환경에서 실행되기 때문에 기본적으로 다른 컨테이너와 통신을 할 수 없다. 그래서 여러 컨테이너끼리 통신을 하기 위해서는 같은 도커 네트워크에 연결해야 한다.

도커 네트워크는 기본적으로 가상 네트워크 인터페이스를 생성한다.

## Linux bridge

도커는 linux bridge 를 이용해서 가상 네트워크 인터페이스를 생성한다. 일반적인 네트워크 스위치와 유사하게 동작하며, 라우터, 게이트웨이, VM 등에서 패킷을 목적지로 전달(forwarding)하는 역할을 수행한다.

![1.png](/assets/images/2023/2023-04-05-types-of-docker-network/1.png)

출처: [10분만에 이해하는 컨테이너 네트워크](https://devocean.sk.com/blog/techBoardDetail.do?ID=163803) [DEVOCEAN]

위의 그림에서 Red 와 Blue 는 각각의 네임스페이스인데, 각 네임스페이스를 연결해주는 것이 bridge(br0) 이다. 여기서 네임스페이스는 컨테이너로 이해할 수 있다.

위의 그림에서 veth 는 가상 이더넷 인터페이스를 의미한다. 네트워크 네임스페이스들을 터널로 연결하거나, 물리 디바이스와 다른 네트워크 네임스페이스 장비를 연결하는 용도로 사용한다.

## 기본 생성 네트워크

도커 데몬이 실행되면서 기본적으로 생성하는 네트워크는 3가지가 있다.

```bash
$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
d768fc1057fa   bridge    bridge    local
ee17c9f89541   host      host      local
eb3003ceaae5   none      null      local
```

기본 네트워크를 사용하는 것보다 독립된 네트워크 환경에서 컨테이너가 통신할 수 있도록 사용자가 직접 네트워크를 생성하는 것이 권장된다.

## 네트워크 종류

### bridge

동일한 도커 호스트에서 작동하지만 호스트와 독립된 내부 네트워크 환경을 만든다. 네트워크에 연결된 컨테이너 간 통신이 가능하다. 각 컨테이너는 네트워크로부터 IP 주소를 할당 받으며, 컨테이너는 할당 받은 IP 주소로 통신할 수 있다.

![2.png](/assets/images/2023/2023-04-05-types-of-docker-network/2.png)

출처: [Docker Network: An Introduction to Docker Networking [K21Academy]](https://k21academy.com/docker-kubernetes/docker-networking-different-types-of-networking-overview-for-beginners/)

![3.png](/assets/images/2023/2023-04-05-types-of-docker-network/3.png)

출처: [97. [Docker + Network] Docker 컨테이너의 Macvlan 사용해보기](https://m.blog.naver.com/alice_k106/220984112963) [네이버 블로그]

별도의 설정을 하지 않으면 컨테이너는 기본적으로 docker0 이라는 bridge 를 통해 네트워크 통신을 한다.

### host

![4.png](/assets/images/2023/2023-04-05-types-of-docker-network/4.png)

출처: [Docker Network Drivers Overview | Networking in Docker #3](https://techmormo.com/posts/docker-networking-3-drivers-overview/) [techmormo]

컨테이너가 도커 호스트의 네트워크를 공유해서 사용하는 방식이다. 그래서 컨테이너가 도커 호스트 자체인 것처럼 보인다.

### none

컨테이너 또는 도커 호스트와 네트워크 통신을 할 수 없는 네트워크이다. 컨테이너가 네트워크 통신이 필요하지 않은 경우에 사용한다.

### overlay

![5.png](/assets/images/2023/2023-04-05-types-of-docker-network/5.png)

출처: [Docker Network Drivers Overview | Networking in Docker #3](https://techmormo.com/posts/docker-networking-3-drivers-overview/) [techmormo]

여러 도커 호스트가 사용할 수 있는 분산 네트워크이다. 여러 서버와 컨테이너를 관리해줄 수 있는 도커 스웜의 기본 드라이버이다. 즉, 여러 도커 호스트들을 마치 하나의 호스트처럼 관리하고 작동하도록 한다.

### macvlan

![6.png](/assets/images/2023/2023-04-05-types-of-docker-network/6.png)

출처: [97. [Docker + Network] Docker 컨테이너의 Macvlan 사용해보기](https://m.blog.naver.com/alice_k106/220984112963) [네이버 블로그]

macvlan 은 bridge 대신 하나의 부모 인터페이스를 이용해서 여러 서브 인터페이스를 가지고 있는 네트워크이다.

각 컨테이너는 고유한 MAC 주소를 가진다.

 ![7.png](/assets/images/2023/2023-04-05-types-of-docker-network/7.png)

출처: [97. [Docker + Network] Docker 컨테이너의 Macvlan 사용해보기](https://m.blog.naver.com/alice_k106/220984112963)
 [네이버 블로그]

macvlan 네트워크는 호스트와 통신은 안되지만, 다른 서브 인터페이스간 통신이 가능한 방식이다.

### ipvlan

macvlan 과 유사하지만, 컨테이너가 호스트와 MAC 주소가 동일하며, 같은 대역의 IP 를 할당 받는다.

macvlan 도 마찬가지이지만, 외부 장비에서 컨테이너에 직접 접근(ssh 연결)이 가능하다.

# 참고자료

- [Docker 네트워크 사용법](https://www.daleseo.com/docker-networks/) [daleseo]
- [Docker Network: An Introduction to Docker Networking](https://k21academy.com/docker-kubernetes/docker-networking-different-types-of-networking-overview-for-beginners/) [K21Academy]
- [[Linux] 가상 네트워크 인터페이스(Linux Virtual Networking Interface)](https://velog.io/@koo8624/Linux-Linux-Virtual-networking-Interface) [velog]
- [veth: 리눅스 가상 이더넷 인터페이스란?](https://www.44bits.io/ko/keyword/veth) [44bits]
- [ip로 직접 만들어보는 네트워크 네임스페이스와 브리지 네트워크](https://www.44bits.io/ko/post/container-network-2-ip-command-and-network-namespace) [44bits]
- [10분만에 이해하는 컨테이너 네트워크](https://devocean.sk.com/blog/techBoardDetail.do?ID=163803) [DEVOCEAN]
- [[Docker] Docker Network (docker0와 veth)](https://yoo11052.tistory.com/208) [티스토리]
- [[Docker] Docker Swarm 에 대해서](https://velog.io/@1996yyk/Docker-Swarm-에-대해서) [velog]
- [97. [Docker + Network] Docker 컨테이너의 Macvlan 사용해보기](https://m.blog.naver.com/alice_k106/220984112963) [네이버 블로그]
- [Macvlan and IPvlan basics](https://sreeninet.wordpress.com/2016/05/29/macvlan-and-ipvlan/) [sreeninet]
- [Docker container를 외부에서 직접 접근해보자](https://this1.tistory.com/entry/Docker-container%EB%A5%BC-%EC%99%B8%EB%B6%80%EC%97%90%EC%84%9C-%EC%A7%81%EC%A0%91-%EC%A0%91%EA%B7%BC%ED%95%B4%EB%B3%B4%EC%9E%90) [티스토리]