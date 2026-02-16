---
title: "[Java Spring] PostgreSQL 연동이 안될 때 해결 방법 (Failed to configure a DataSource)"
date: 2024-03-04 19:35:00 +0900
categories: [java, spring]
tags: []
---

# 실행 환경

- OS : MacOS(Intel) Sonoma 14.2.1
- Java : 17
- Spring Boot : 3.2.3
- IntelliJ Ultimate : 2023.2.6

# 문제 상황

- PostgreSQL 과 Spring 을 연동하는 작업을 진행하고 있었다.
- Spring 프로젝트의 설정은 [spring intializer](https://start.spring.io/) 에서 아래의 사진과 같이 설정했다.
  ![1.png](/assets/images/2024/2024-03-04-java-spring-postgres-connection/1.png)
  - Project: Gradle - Groovy
  - Spring Boot : 3.2.3
  - Java : 17
  - Dependencies : Spring Data JPA, Spring Web, PostgreSQL Driver
- 프로젝트 디렉토리 구조는 아래와 같다.

  ```bash
  backend
  ├── HELP.md
  ├── build
  ├── build.gradle
  ├── gradle
  ├── gradlew
  ├── gradlew.bat
  ├── settings.gradle
  └── src

  ```

- PostgreSQL 과 Spring 을 연동하기 위한 정보를 입력하기 위해 `src/main/java/resource/application.properties` 파일에 아래와 같이 작성했다.
  ```
  spring.datasource.url=jdbc:postgresql://localhost:5432/{db_name}
  spring.datasource.username={username}
  spring.datasource.password={password}
  spring.datasource.driver-class-name=org.postgresql.Driver
  ```
- PostgreSQL 에서도 DB 생성, 유저 생성 및 패스워드 설정, 스키마 설정, 유저 권한 부여까지 모두 직접했다.
- 하지만 애플리케이션을 실행하려고 하니 아래와 같은 오류가 발생했다.

  ```

  ***************************
  APPLICATION FAILED TO START
  ***************************

  Description:

  Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured.

  Reason: Failed to determine a suitable driver class

  Action:

  Consider the following:
  	If you want an embedded database (H2, HSQL or Derby), please put it on the classpath.
  	If you have database settings to be loaded from a particular profile you may need to activate it (no profiles are currently active).
  ```

- 분명 `application.properties` 파일에 `spring.datasource.url` 과 `spring.datasource.drvier-class-name` 을 작성했는데도 DB 연결이 되지 않았다.

# 문제 원인

나의 경우에는 `settings.gradle` 에 작성된 `rootProject.name` 의 값이 프로젝트 이름과 일치하지 않아서 gradle 빌드가 실패했고, 이로 인해 PostgreSQL 로 연결이 실패한 것이었다.

## settings.gradle

![2.png](/assets/images/2024/2024-03-04-java-spring-postgres-connection/2.png)

왼쪽에는 프로젝트 이름이 `backend [habitpay]` 라고 작성되어 있다.

하지만 오른쪽의 `setting.gradle` 파일에는 `rootProject.name` 의 값이 `HabitPay` 로 적혀있다.

# 문제 해결

`rootProject.name` 의 값을 `habitpay` 또는 `backend` 로 수정하고 gradle 빌드를 다시 시도하니까 정상적으로 빌드가 되었다.

spring initializer 에서 Artifact 항목에 HabitPay 라고 작성한 것이 원인이었던 것 같다.

정확한 이유는 잘 모르겠지만, Artifact 나 Group 에 소문자로만 작성하고 다시 프로젝트를 생성하니 문제 없이 작동되는 것을 확인했다.

# 참고자료

- [[Spring Error] Failed to configure a DataSource: 'url' attribute is not specified and no embedded datasource could be configured.](https://psip31.tistory.com/139) [티스토리]
- [java.lang.IllegalStateException: Module entity with name: ~ should be available 에러](https://velog.io/@silver_cherry/java.lang.IllegalStateException-Module-entity-with-name-should-be-available-에러) [velog]
