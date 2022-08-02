---
title: "[운영체제] 운영체제(Operating System)이란?"
date: 2022-08-02 09:30:00 +0900
categories: [os]
tags: [os]
use_math: true
---

# 운영체제란?

운영체제(Operating System; OS)는 사용자가 컴퓨터를 쉽게 사용할 수 있게 해주는 소프트웨어다.

운영체제는 하드웨어와 소프트웨어를 모두 관리하며, 컴퓨터를 사용하면서 실행한 모든 프로그램들은 운영체제에서 관리하고 제어한다.

운영체제는 PC 뿐만 아니라 MP3, 키오스크, 게임기기, 스마트폰 등에서도 활용이 되고 있다. 전원이 들어오면 장치를 깨우고, 사용자의 명령에 따른 동작을 관리하는 주체가 바로 운영체제이다.

## 구성 요소

![출처: [johnloomis.org](https://johnloomis.org/ece314/notes/OperatingSystems/UNIX.html)](/assets/images/2022-08-02-what-is-operating-system/UNIX_structure.png)

출처: [johnloomis.org](https://johnloomis.org/ece314/notes/OperatingSystems/UNIX.html)

하드웨어 위에 커널(kernel)이 있고, 커널 위에서 쉘(shell)과 애플리케이션(application)이 실행된다. 사용자는 기본적으로 쉘을 통해 애플리케이션을 실행한다.

![출처: [[리눅스] 커널(KERNEL)과 쉘(SHELL)의 개념, 쉘을 이해해보자](https://reakwon.tistory.com/135)](/assets/images/2022-08-02-what-is-operating-system/kernel.png)

출처: [[리눅스] 커널(KERNEL)과 쉘(SHELL)의 개념, 쉘을 이해해보자](https://reakwon.tistory.com/135)

### 1. 커널(kernel)

운영체제에서 가장 핵심이 되는 프로그램이다.

커널은 드라이버를 이용해서 CPU, 그래픽카드와 같은 하드웨어를 제어하고, 여러 애플리케이션들이 갖가지 다른 하드웨어 위에서 작동하도록 호환성을 보장하는 API를 제공한다.

> 드라이버는 시스템이 지원하는 하드웨어를 응용 프로그램에서 사용할 수 있도록 커널에서 제공하는 라이브러리이다.

### 2. 쉘(shell)

운영체제에서 커널과 사용자 사이에서 사용자의 명령을 해석하고, 처리 결과를 각각에게 알려주는 시스템 프로그램이다. 명령어 해석기로도 불린다.

쉘은 크게 두 가지 종류가 있는데, 텍스트 형태로 보여주는 CLI(Command Line Interface)와 그래픽으로 보여주는 GUI(Graphic User Interface)가 있다. macOS 의 GUI 쉘은 `Finder` 이다.

쉘(Shell)이 ‘껍데기’ 라는 뜻을, 커널(Kernel)은 ‘핵심’ 이라는 뜻을 가지고 있다. 즉, 쉘 내부에 커널이 있고, 사용자는 이를 감싸고 있는 껍데기(쉘)을 통해서 커널에 접근한다는 개념으로 이해할 수 있다.

쉘의 종류는 다양한데 대표적으로는 다음과 같다.

1. Bourne Shell (`/bin/sh`)
   - 유닉스 최초의 쉘인 본쉘이다.
2. Bash(Bourne Again Shell) (`/bin/bash`)
   - 현재 리눅스 표준으로 채택된 쉘이다.

## 운영체제의 목적

### 1. 하드웨어 효율적 관리 (performance)

운영체제를 사용하는 가장 큰 목적은 컴퓨터의 하드웨어를 관리하는 것이다.

컴퓨터에는 CPU, RAM, 디스크, 키보드, 마우스, 모니터, 네트워크 등 수 많은 하드웨어로 구성되어 있는데, 이를 잘 관리해주어야 컴퓨터를 효율적으로 사용할 수 있다.

쉽게 생각하면, 운영체제는 현실 세계의 정부와 유사한 개념이다. 정부는 다음과 같은 일을 수행한다.

- 국토, 인력, 예산과 같은 자원을 효율적으로 사용한다.
- 효율적인 자원 관리를 위해 행정부, 국토부, 교육부 등 부서를 나누어 관리한다.
- 각 부서는 국민들에게 자원을 요청받으며, 이를 적절하게 배분한다.

운영체제가 하는 일은 다음과 같다.

- 프로세스, 메모리, 하드 디스크 등 하드웨어 자원을 효율적으로 사용한다.
- 자원 관리를 위해 프로세스 관리, 메모리 관리, 디스크 관리, 네트워크, 보안 등 기능이 나누어져 있다.
- 애플리케이션들의 요청에 따라 각 기능들이 수행하여 적절하게 자원을 배분한다.

### 2. 사용자 편의 제공 (convenience)

운영체제가 없으면 하드웨어와 관련된 모든 관리를 사용자가 해야 한다.

우리가 일상적으로 사용하고 있는 스마트폰에 운영체제가 없었다면 남녀노소 쉽게 스마트폰을 이용할 수 없었을 것이다.

## 운영체제의 시작, 부팅(booting)

컴퓨터의 구조를 단순화 하면 아래의 그림과 같다.

![출처: [[운영체제(OS)] 1. 운영체제란?](https://velog.io/@codemcd/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9COS-1.-%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C%EB%9E%80) [velog]](/assets/images/2022-08-02-what-is-operating-system/booting.png)

출처: [[운영체제(OS)] 1. 운영체제란?](https://velog.io/@codemcd/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9COS-1.-%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C%EB%9E%80) [velog]

Processor 는 일반적으로 CPU 를 의미한다.

Main Memory 는 ROM 과 RAM 으로 구성되어 있다.

- ROM : 비휘발성. 메모리에서 극히 일부 차지(수 KB)
- RAM : 휘발성. 메모리의 대부분 차지. 실제 프로그램이 할당되는 곳(수 MB ~ 수 GB)

ROM 은 하드 디스크와 같이 비휘발성으로 전원이 꺼져도 내부 내용이 계속 유지된다. 반면, RAM 은 휘발성이기 때문에 전원이 꺼지면 메모리 안의 모든 내용이 지워진다.

컴퓨터의 전원이 켜지면 프로세서(CPU)에서 ROM 에 있는 내용을 읽는다. ROM 에는 POST(Power-On Self-Test), 부트 로더(boot loader)가 저장되어 있다.

POST 는 전원이 켜지면 가장 먼저 실행되는 프로그램으로 현재 컴퓨터의 상태를 검사한다. 이 작업이 끝나면 부트 로더가 실행된다.

부트 로더는 하드 디스크에 저장된 운영체제를 찾아서 메인 메모리(RAM)에 가지고 온다. 이러한 부트 로더의 과정을 부팅이라고 한다.

![출처: [[운영체제(OS)] 1. 운영체제란?](https://velog.io/@codemcd/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9COS-1.-%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C%EB%9E%80) [velog]](/assets/images/2022-08-02-what-is-operating-system/booting2.png)

출처: [[운영체제(OS)] 1. 운영체제란?](https://velog.io/@codemcd/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9COS-1.-%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C%EB%9E%80) [velog]

위 그림은 부트 로더가 수행되는 과정이다. 위와 같은 상태가 되면 운영체제가 수행할 준비를 마친 것이다. 그리고 운영체제는 컴퓨터의 전원이 꺼지면 종료된다.

# 참고자료

- [[운영체제(OS)] 1. 운영체제란?](https://velog.io/@codemcd/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9COS-1.-%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C%EB%9E%80) [velog]
- [운영체제](https://namu.wiki/w/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C) [나무위키]
- [리눅스 커널과 디바이스 드라이버 1](https://cheonee.tistory.com/entry/%EB%A6%AC%EB%88%85%EC%8A%A4-%EC%BB%A4%EB%84%90%EA%B3%BC-%EB%94%94%EB%B0%94%EC%9D%B4%EC%8A%A4-%EB%93%9C%EB%9D%BC%EC%9D%B4%EB%B2%84) [티스토리]
- [[리눅스] 커널(KERNEL)과 쉘(SHELL)의 개념, 쉘을 이해해보자](https://reakwon.tistory.com/135) [티스토리]
