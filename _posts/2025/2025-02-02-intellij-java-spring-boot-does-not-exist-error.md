---
title: "[Spring] IntelliJ java: package org.springframework.boot does not exist 오류 해결"
date: 2025-02-02 21:40:00 +0900
categories: [Java, Spring]
tags: []
---

# 실행 환경

- OS : MacOS Catalina (10.15.7)
- IDE : IntelliJ 2023.1.3 (Ultimate Edition)
- JDK : openjdk17
- Build Tool : Gradle

# 문제 상황

- spring initializer를 이용해서 초기 프로젝트 파일을 다운 받고, IntelliJ에서 spring 애플리케이션을 실행하고자 했다.
- 하지만 `java: package org.springframework.boot does not exist` 오류가 발생하며 정상적으로 실행되지 않았다.

# 해결 방법

- **[File] - [invalid Cashes]** 기능을 사용하면 라이브러리가 제대로 import 되지 않았거나 변경사항이 적용되지 않았을 때 문제가 해결된다.

# 참고자료

- [[Spring] java: package org.springframework.boot does not exist 오류고치기.](https://velog.io/@mybymine/Spring-java-package-org.springframework.boot-does-not-exist-%EC%98%A4%EB%A5%98%EA%B3%A0%EC%B9%98%EA%B8%B0) [velog]
