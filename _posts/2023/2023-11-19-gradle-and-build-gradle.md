---
title: "[Java] Gradle 과 build.gradle 파일은 무엇일까?"
date: 2023-11-19 03:00:00 +0900
categories: [java]
tags: []
---

> 인프런의 [<스프링 입문 - 코드로 배우는 스프링 부트, 웹 MVC, DB 접근 기술>](https://www.inflearn.com/course/%EC%8A%A4%ED%94%84%EB%A7%81-%EC%9E%85%EB%AC%B8-%EC%8A%A4%ED%94%84%EB%A7%81%EB%B6%80%ED%8A%B8/dashboard) 강의를 듣고 궁금한 내용을 찾아서 정리한 내용입니다.
>

# Gradle

Gradle 은 Java 로 작성된 코드를 하나의 완성된 프로그램으로 만들어 주는 빌드 도구이다.

빌드 과정에는 Java 코드를 바이트 코드로 변환하는 컴파일링과 여러 코드와 데이터를 하나의 파일로 합치는 링킹이 포함된다.

- 바이트 코드 : Java 는 어떤 하드웨어에서든 동작할 수 있도록 JVM 이라는 가상 머신을 사용한다. Java 로 작성한 코드는 JVM 에서 바이트 코드로 변환된다. JVM 에서 운영체제로 명령을 요청할 때, 하드웨어 환경에 맞게 운영체제가 인식할 수 있도록 기계어로 변환하는 과정을 거친다. 이때, 기계어로 변환하기 전에  중간 단계의 코드가 바로 바이트 코드이다.

Gradle 은 Groovy 라는 프로그래밍 언어로 만들어졌다. Groovy 는 Java 를 발전시킨 객체 지향 프로그래밍 언어이고, Java 와 비슷한 문법을 가진 언어이다.

# build.gradle

JavaScript 를 이용해서 React 나 Nest.js 를 사용해봤다면 `package.json` 파일을 본 적이 있을 것이다.

이 파일에는 프로젝트에 필요한 라이브러리의 버전, 라이브러리 간의 의존성에 대한 정보가 포함되어있다.

Java 에서는 `build.gradle` 파일이 이러한 역할을 수행하고 있다. 여기서 `.gradle` 은 파일 확장자 명을 의미한다.

```java
// build.gradle

// 자바를 컴파일하기 위해 java plugin을 설정한다.
apply(plugin = "java")
// application으로 컴파일하기 위해 설정한다.
apply(plugin = "application")

//저장소를 입력하는 섹션이다. 주로 Maven의 저장소를 그대로 사용한다.
repositories {
    mavenCentral()
}
//종속성을 입력하는 섹션이다. 기존에는 compile이 있었으나 3.0버전부터 deprecated 되었다.
dependencies {
    //'group:name:version' 순으로 적는다. group: 'junit', name: 'junit', version: '4.12'식으로도 가능하다.
    api("com.google.guava:guava:22.0") //간접 의존, 직접 의존하는 모든 모듈을 rebuild 한다
    implementation("junit:junit:4.12") //직접 의존하는 모듈만 rebuild 한다.
}

application {
    // 메인 class의 위치와 이름을 적는다.
    mainClass.set("package.name.AppClass")
}
```

즉, Gradle 은 npm 이나 yarn 과 비슷하게 패키지 버전과 의존성을 관리하는 패키지 매니저와 같은 역할을 하면서, 바이트 코드로 변환하기 위해 javac 라는 컴파일러를 호출하는 역할도 동시에 수행하고 있다.

# 참고자료

- [[Linking] 링커 / 링킹이란 무엇인가](https://live-everyday.tistory.com/67) [티스토리]
- [바이트코드](https://namu.wiki/w/%EB%B0%94%EC%9D%B4%ED%8A%B8%EC%BD%94%EB%93%9C) [나무위키]
- [Gradle](https://namu.wiki/w/Gradle) [나무위키]
- [Groovy](https://groovy-lang.org/) [groovy-lang]