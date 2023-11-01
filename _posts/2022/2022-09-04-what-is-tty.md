---
title: "tty란?"
date: 2022-09-04 23:25:00 +0900
categories: [os]
tags: [os]
use_math: true
---

# tty란?

tty 는 컴퓨터와 연결된 가상의 터미널이다.

![tty](/assets/images/2022/2022-09-04-what-is-tty/tty.jpeg)

출처: [위키백과](https://ko.wikipedia.org/wiki/%EC%A0%84%EC%8B%A0%ED%83%80%EC%9E%90%EA%B8%B0)

tty는 **T**ele**TY**pewriter 의 약자로 통신에서 사용된 전기식 타자기(텔레타이프)를 의미한다. 컴퓨터의 등장 이후에는 컴퓨터에 정보를 입력하고, 컴퓨터에서 정보를 가져오는데 사용되었다.

과거 컴퓨터는 고가의 장비였기 때문에 대학이나 기업의 독립된 방에 위치했다. 하지만 오직 한 명만 컴퓨터를 쓸 수 있는 물리적 한계를 극복하기 위해서 텔레타이프(tty)를 사용했으며, 현대 유닉스 계열 시스템에서 터미널의 역할을 하게 된다.

여기서 터미널이란 입력 장치(키보드, 마우스, 마이크)와 출력 장치(모니터, 스피커)를 모두 일컫는 말이다.

텔레타이프를 이용함으로써 여러 사람이 하나의 컴퓨터에서 원하는 정보를 입력하고 원하는 정보를 받을 수 있게 되었다. 그래서 유닉스는 최초의 다중 사용자 운영체제가 되었고, 이때 사용한 텔레타이프의 약자(tty)가 유닉스 및 리눅스 계열 운영체제에서 터미널을 뜻하게 되었다.

그림으로 표현하면 다음과 같다.

![1](/assets/images/2022/2022-09-04-what-is-tty/1.png)

실제로 컴퓨터와 연결된 것은 아니지만, 가상의 터미널 환경을 통해서 명령어를 입력하고, 이에 대한 출력 결과를 받을 수 있다. 가상 터미널을 사용하는 이유는 사용자가 운영체제의 핵심에 접근해서 의도치 않은 오류를 발생시키는 것을 방지하기 위함이다.

tty 뒤에 붙는 번호는 사용자 번호를 의미하는데, 실제 mac OS 에서 iTerm 을 여러 개 실행시키고 `who` 명령어를 입력하면 다음과 같은 화면을 볼 수 있다.

![2](/assets/images/2022/2022-09-04-what-is-tty/2.png)

오른쪽 터미널은 처음 실행시킨 터미널이고, 왼쪽 터미널은 새롭게 열은 터미널이다. `tty` 명령어로 확인해보면 왼쪽은 ttys001, 오른쪽은 ttys000 인것을 확인할 수 있다. 그래서 `who` 명령어를 사용하면 현재 쉘과 연결된 터미널의 개수를 확인할 수 있으며, 서버 입장에서는 현재 연결된 사용자를 파악할 수 있다.

# 참고자료

- [[리눅스] Terminal 개념과 명령어](https://velog.io/@ginee_park/%EB%A6%AC%EB%88%85%EC%8A%A4-Terminal-%EA%B0%9C%EB%85%90%EA%B3%BC-%EB%AA%85%EB%A0%B9%EC%96%B4-tty) [velog]
- [전신타자기](https://ko.wikipedia.org/wiki/%EC%A0%84%EC%8B%A0%ED%83%80%EC%9E%90%EA%B8%B0) [위키백과]
- [Linux Terminal and Console Explained For Beginners](https://www.linuxbabe.com/command-line/linux-terminal) [LinuxBabe]
- [커맨드라인 인터페이스, 셸, 터미널이란?](https://www.44bits.io/ko/keyword/command-line-interface-cli-shell-and-terminal) [44bits]
