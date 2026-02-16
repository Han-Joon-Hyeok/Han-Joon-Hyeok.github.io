---
title: "[Java Spring] A problem occured configuring root project 오류 해결 방법"
date: 2024-03-04 17:35:00 +0900
categories: [java, spring]
tags: []
---

# 실행 환경

- OS : MacOS(Intel) Sonoma 14.2.1
- IntelliJ : Ultimate 2023.2.5

# 문제 상황

스프링 프로젝트를 실행하려고 했지만 `A problem occured configuring root project` 으로 시작하는 오류가 발생했다.

![1](/assets/images/2024/2024-03-04-java-spring-problem-occured-configuring-root-project/1.png)

# 문제 원인

스프링 프로젝트 세팅 시 자바 17 버전을 사용한다고 `build.gradle` 파일에 적혀있었지만, IntelliJ 에서는 자바 11 버전을 gradle 의 컴파일러로 사용한다고 하니까 버전이 맞지 않아서 발생하는 오류이다.

# 문제 해결

단축키는 MacOS 기준

1. Project Structure(`command + ;`) - SDK 를 17 버전으로 설정

   ![2](/assets/images/2024/2024-03-04-java-spring-problem-occured-configuring-root-project/2.png)

2. Settings(`command + ,`) 에서 Build Tools - Gradle 에서 Gradle JVM 을 자바 17 버전으로 선택

   ![3](/assets/images/2024/2024-03-04-java-spring-problem-occured-configuring-root-project/3.png)

# 참고자료

- [A problem occurred configuring root project](https://aamoos.tistory.com/722) [티스토리]
