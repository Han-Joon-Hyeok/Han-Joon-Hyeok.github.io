---
title: "PID 1 과 dumb-init (feat. PID 0)"
date: 2023-04-27 09:00:00 +0900
categories: [docker]
tags: [docker]
---

# PID 1

리눅스의 시그널은 Docker 컨테이너 내부의 프로세스 생명 주기를 제어하는 방법이다.

그래서 Docker 와 kubernetes(이하 k8s) 는 시그널을 사용해서 컨테이너 내부의 프로세스와 통신하고, 컨테이너를 종료하기 위해 사용한다.

Docker 와 k8s 는 컨테이너 내부에 PID 1 이 있는 프로세스에만 신호를 보낼 수 있다.

## PID 1, 어떤 프로세스인가?

PID 1 은 시스템을 시작하고 종료하거나, 시스템 시작과 관련한 스크립트를 실행하거나, 시스템 초기화 작업을 처리하는 init 프로세스이다.

PID 1 은 시스템에서 실행되고 있는 모든 프로세스들의 부모 프로세스이다.

Ubuntu 22.04 환경에서 프로세스와 부모 프로세스 번호(PID), 부모 프로세스의 PID(PPID) 를 출력해보면 아래와 같다.

```bash
$ ps -elf  | head -5
F S UID          PID    PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
4 S root           1       0  0  80   0 - 41785 -      Apr26 ?        00:00:06 /sbin/init
1 S root           2       0  0  80   0 -     0 -      Apr26 ?        00:00:00 [kthreadd]
1 I root           3       2  0  60 -20 -     0 -      Apr26 ?        00:00:00 [rcu_gp]
1 I root           4       2  0  60 -20 -     0 -      Apr26 ?        00:00:00 [rcu_par_gp]
```

PID 1 에는 `init` 이라는 프로그램이 할당되어 실행되고 있는 것을 확인할 수 있다.

여기서 하나만 더 짚고 넘어갈 부분이 있다. PID 1 의 PPID 에는 0 이 할당되어 있는데, PID 0 은 어떤 프로세스이고, 어떤 역할을 하는 걸까?

## PID 0

PID 0 은 sched(schedule) 또는 swapper 라 불리는 프로세스이다.

이는 사용자 모드로 실행되는 프로세스가 아닌 커널의 일부이다.

유닉스 시스템에서 실행되는 모든 프로세스는 시간에 따라 다른 상태를 가지고 있는다. 프로세스가 생성 되는 상태, CPU를 점유하면서 실행되는 상태, 할 일 없이 사용자의 입력을 기다리며 잠들어 있는 상태 등이 있다.

swapper 프로세스는 바로 “잠들어” 있는 프로세스를 메모리에서 내려서 디스크 공간에 잠시 swap 했다가, 그 프로세스가 깨어나야 하는 시기가 오면 디스크의 프로세스를 다시 메모리로 적재해주는 등의 일을 한다.

swapper 는 부팅과 동시에 별도로 실행되기 때문에 부모 프로세스가 존재하지 않는다. 그래서 swapper 는 프로세스 보다는 운영체제에 가깝다고 할 수 있다.

## init 프로세스의 역할

PID 0 다음으로 실행되는 프로세스가 PID 1 인 init 프로세스이다.

PID 1 은 부팅 시 커널에 의해 최초로 실행되는 프로세스이다. init 프로세스는 SSH 데몬, Docker 데몬, Apache/Nginx 데몬과 같은 시스템의 시작을 담당한다.

init 프로세스는 모든 프로세스의 직/간접적인 부모 프로세스이다. 그래서 어떤 프로세스의 자식 프로세스들이 고아 상태가 되면 init 프로세스가 고아 상태가 된 자식 프로세스들을 자식으로 입양하고, 정상적으로 종료시킨다.

그리고 PID 1 은 init 프로세스 관리를 위한 프로세스로 실행되다보니 Linux 에서는 기본적으로 PID 1 은 `SIGINT` 나 `SIGTERM` 과 같은 시그널을 기본적으로 무시하도록 되어있다. PID 1 프로세스가 종료되면 다른 프로세스들도 함께 종료될 수 있기 때문에 시그널을 무시하는 것이다. 그래서 기본적으로 PID 1 에 전달되는 시그널과 자식 프로세스들에게 보내는 시그널은 모두 무시된다.

만약, PID 1 로 init 프로세스가 아닌 다른 프로세스가 실행되고, 프로그램 내부적으로 별도의 시그널 처리를 하지 않았다면 시그널을 받을 수 없다.

즉, init 프로세스는 foreground 로 작동하며 자식 프로세스가 받는 시그널을 전달하는 역할을 해준다.

> 참고로 init 프로세스를 background 로 실행하면 init 프로세스가 자식 프로세스들에게 시그널을 전달해줄 수 없다. 그렇기 때문에 init 프로세스는 반드시 foreground 로 실행되어야 한다.
>

# 컨테이너에는 init 프로세스가 없다?

도커는 컨테이너 entrypoint 로 명시된 프로세스를 PID 1 로써 새로운 PID 네임스페이스를 정의한다.

그래서 컨테이너 외부에서는 컨테이너를 종료시키고 싶다면 컨테이너 내부에 있는 PID 1 프로세스에만 신호를 보내서 종료할 수 있다.

만약, PID 1 에 init 프로세스가 아닌 다른 프로세스가 할당되면 무슨 일이 벌어질까?

## 1. sh 프로세스가 PID 1 인 경우

Dockerfile 을 통해 다음과 같이 컨테이너 명령을 지정하면, 아래와 같은 프로세스 트리가 생성된다.

```bash
- docker run (on the host machine)
  - /bin/sh (PID 1, inside container)
    - python my_server.py (PID 2, inside container)
```

sh 를 PID 1 로 사용하고, 실행할 파일을 sh 가 실행하도록 하면 PID 는 2 로 설정된다. 그러면 실행할 파일이 sh 의 자식 프로세스가 되는데, 이런 경우에는 거의 자식 프로세스에 시그널을 보내는 것이 불가능하다. 앞에서 언급한 것처럼 PID 1 로 실행되는 프로세스가 별도의 시그널 처리를 하지 않았다면 자식 프로세스로 시그널을 전달하는 것이 불가능하기 때문이다.

그래서 PID 2 로 실행되는 프로세스가 종료될 때까지 PID 1 이 종료되지 않는다. 이러한 경우에는 PID 2 를 종료하고 싶다면 `SIGKILL` 시그널을 보내서 프로세스를 종료해야 한다.

하지만 `SIGKILL` 시그널은 프로세스가 정리할 시간을 주지 않고 바로 종료하기 때문에 비정상적인 상황이 발생할 수 있다. 그래서 `SIGKILL` 보다는 `SIGTERM` 을 이용해서 프로세스를 종료하는 것이 좋다.

이와 관련한 만화를 보면 더욱 이해가 쉬울 것이다.

![1.png](/assets/images/2023/2023-04-27-pid-1-and-dumb-init/1.png)

출처: [don’t sigkill](https://turnoff.us/geek/dont-sigkill/) [turnoff.us]

## 2. 내 프로세스가 PID 1 인 경우

Dockerfile 에서 다음과 같이 정의하면, 실행하고자 하는 프로세스가 즉시 시작되고, 컨테이너의 초기화 시스템으로써 작동한다. 결과적으로 아래와 같은 프로세스 트리가 생성된다.

```bash
- docker run (on the host machine)
  - python my_server.py (PID 1, inside container)
```

1번과 달리 프로세스는 시그널을 받을 수 있지만, PID 1 에 할당되었기 때문에 예상한대로 시그널이 작동하지 않을 수도 있다.

# dumb-init

앞서 살펴본 것처럼 컨테이너 내부에서 PID 1 이 init 프로세스가 실행되지 않기 때문에 앞서 살펴본 것처럼 시그널이 작동하지 않거나, 프로세스가 점유하던 자원 회수를 정상적으로 수행하지 못할 수 있다.

그래서 dumb-init 이라는 프로그램을 PID 1 로 실행함으로써 앞선 문제들을 해결할 수 있다. dumb-init 은 컨테이너와 같은 경량화된 환경에서 사용하기 위해 개발된 초기화 프로그램이다.

dumb-init 을 사용하면 아래와 같은 프로세스 트리가 생성된다.

```bash
- docker run (on the host machine)
  - dumb-init (PID 1, inside container)
    - python my_server.py (PID 2, inside container)
```

dumb-init 은 모든 시그널에 대해 시그널 핸들러를 등록하고, 해당 시그널을 해당하는 프로세스로 전달한다.

# 참고자료

- [Docker와 PID 1(좀비 프로세스)](https://velog.io/@songtofu/Docker%EC%99%80-PID-1%EC%A2%80%EB%B9%84-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4) [velog]
- [Docker와 Dumb-Init](https://www.hahwul.com/2022/08/06/docker-dumb-init/) [hahwul]
- [프로세스 식별자](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4_%EC%8B%9D%EB%B3%84%EC%9E%90) [위키백과]
- [process 0 : swapper](http://wiki.kldp.org/KoreanDoc/html/Boot_Process-KLDP/swapper.html) [kldp]
- [[Linux - 리눅스 / Ubuntu - 우분투] 0번 프로세스, 스와퍼(Swapper)](https://sharkmino.tistory.com/1550) [티스토리]
- [[Linux] 프로세스 관련 개념 간단 훑기](https://velog.io/@khyup0629/Linux-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4) [velog]
- [컨테이너 환경을 위한 초기화 시스템 (Tini, Dumb-Init)](https://swalloow.github.io/container-tini-dumb-init/) [github.io]
- [signal(7) — Linux manual page](https://man7.org/linux/man-pages/man7/signal.7.html) [man7]
- [PID 1 Signal Handling in Docker](https://petermalmgren.com/signal-handling-docker/) [petermalmgen]
- [Docker run reference](https://docs.docker.com/engine/reference/run/#foreground) [docker]
- [SIGTERM과 SIGKILL의 차이점](https://seereal.pw/22) [티스토리]