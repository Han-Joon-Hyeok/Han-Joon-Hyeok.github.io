---
title: "데비안과 CentOS"
date: 2022-09-04 23:05:00 +0900
categories: [os]
tags: [os]
use_math: true
---

# 데비안과 Cent OS

데비안과 CentOS 는 리눅스 기반 개인용 서버 운영체제로 많이 사용되고 있다.

데비안과 CentOS는 모두 오픈소스 커뮤니티 기반으로 개발 및 유지보수가 이루어지고 있지만, 이들이 파생된 계열은 서로 다르다는 차이가 있다.

우선 리눅스가 무엇인지 살펴보도록 하자.

## 리눅스(Linux)

리눅스는 UNIX 운영체제를 기반으로 만들어진 오픈소스 기반 운영체제이다.

리눅스는 오픈소스 기반이기 때문에 누구든 수정 및 배포가 가능하다. 그래서 수 많은 버전의 리눅스가 존재한다.

대표적으로는 데비안 계열과 레드햇 계열이 있다.

## 레드햇(redhat) 계열

레드햇이라는 회사에서 배포한 리눅스를 레드햇 계열이라 부른다.

2003년까지는 오픈소스 라이선스로 진행하다가 이후 유료로 제품을 판매하고 있다. 자발적인 커뮤니티가 아닌 회사에서 관리하기 때문에 다른 리눅스 배포판에 비해 패치가 빠르고, 내장된 유틸리티가 많으며, 관리툴의 성능도 우수하다.

### CentOS

CentOS 는 Community Enterprise Operating System 의 약자로, 레드햇이 공개한 RHEL 을 그대로 가져와서 레드햇의 브랜드와 로고만 제거한 배포판이다. 기업 서버용 운영체제로 많이 사용되고 있다. 무료로 사용 가능하지만, 커뮤니티를 통해 지원되기 때문에 패치가 느린 편이다. 그리고 세팅이 어렵고, 지원하는 프로그램이 데비안 계열에 비해 적은 편이다.

패치가 느린 이유는 기업용 운영체제가 높은 안정성을 요구하기 때문이다. 안정성이 높다는 것은 그만큼 설정해야 하는 것도 많다는 의미인데, 자주 패치를 하게 되면 기업에서는 그만큼 많은 공수를 들여야 한다. 그래서 정말 치명적인 오류가 발생하지 않는 이상, 한번에 많은 수정을 하는 것이 기업 입장에서는 비용과 시간을 아낄 수 있는 방법이다.

## 데비안(Debian) 계열

데비안은 데비안 프로젝트가 개발한 리눅스 운영체제이다. 레드햇보다 먼저 온라인 커뮤니티에서 제작되어 배포되었다. 데비안에서 파생된 OS 를 데비안 계열이라 한다.

무료이지만 커뮤니티에서 만드는 배포판이기 때문에 레드햇 계열에 비해 서비스와 배포가 느린 단점이 있다.

현재는 무료 개인 사용자 서버용으로 인기가 높은 편이다.

데비안의 장점으로는 `DEB` 와 `APT` 가 있다. 데비안은 프로그램들을  `deb` 란 패키지로 묶어서 관리한다. 이 방식은 `deb` 파일 안에 의존성 관련 정보를 저장하고 있어서 필요한 외부 프로그램이나 라이브러리를 쉽게 알 수 있고, 관리가 편하다는 장점이 있다. 이를 관리하는 도구로는 `apt`, `aptitude`, `dselect`, `synaptic` 등이 있다.

# 참고자료

- [리눅스](https://ko.wikipedia.org/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4) [위키백과]
- [[Linux] 리눅스란 무엇인가? (센토스 VS 우분투)](https://coding-factory.tistory.com/318) [티스토리]
- [CentOS](http://wiki.hash.kr/index.php/%EC%84%BC%ED%8A%B8%EC%98%A4%EC%97%90%EC%8A%A4#.EB.8B.A8.EC.A0.90) [해시넷]
- [데비안](http://wiki.hash.kr/index.php/%EB%8D%B0%EB%B9%84%EC%95%88) [해시넷]