---
title: "[spring boot] ddl-auto: update 옵션 분석"
date: 2024-10-14 17:10:00 +0900
categories: [Java, Spring]
tags: []
---

# 개요

Spring Boot 에서 `spring.jpa.hibernate.ddl-auto` 옵션 중 `update` 가 어떻게 작동하는지 테스트하고, 그 결과를 정리하였다.

# 개발 환경

- Spring Boot: 3.2.3
- Java: 17
- DB: postgreSQL 16.2

# 문제 상황

로컬 개발 환경에서 DB 에 데이터를 이미 생성해둔 상태였다.

변경 사항을 빠르게 반영하기 위해 `spring.jpa.hibernate.ddl-auto` 옵션은 `update` 로 설정했으나, 엔티티의 컬럼을 삭제했을 때 DB 테이블에서 해당 컬럼이 삭제되지 않았다.

`update` 는 엔티티와 데이터베이스 간의 스키마를 자동으로 업데이트한다고 알고 있었지만, 그 의미를 명확히 하기 위해 총 4가지 테스트를 진행했다.

# 테스트

## 상황

테스트를 진행한 컬럼에는 아래와 같이 `NOT NULL` 제약 조건이 걸려있었다.

```java
@Column(nullable = false)
private int totalAbsenceFee;
```

## 결과

테스트 결과는 아래의 표와 같이 정리할 수 있다.

| 순번 | 대상 컬럼 존재 유무 | 데이터 존재 | 대상 컬럼 동작 | 결과            |
| ---- | ------------------- | ----------- | -------------- | --------------- |
| 1    | X                   | X           | 생성           | 컬럼 생성 작동  |
| 2    | X                   | O           | 생성           | 컬럼 생성 안 됨 |
| 3    | O                   | X           | 삭제           | 컬럼 삭제 안 됨 |
| 4    | O                   | O           | 삭제           | 컬럼 삭제 안 됨 |

자동으로 업데이트가 이루어진 상황은 1번 테스트 상황 뿐이었다.

즉, 대상 컬럼이 기존에 존재하지 않고 해당 테이블에 데이터가 없는 경우에만 엔티티의 새로운 커럶이 데이터베이스에 반영되었다.

# 컬럼 생성이 안 되는 이유

2번 테스트에서는 대상 컬럼이 존재하지 않았으나, 이미 테이블에 데이터가 존재하기 때문에 컬럼이 새롭게 생성되지 않았다.

이는 새로 생성하려는 컬럼의 **`NOT NULL` 제약조건으로 인해 기존 데이터가 제약 조건을 위반하게 되는 상황을 방지하기 위한 것이다.**

예를 들어, 기존 데이터가 아래와 같다고 가정하자.

| id(PK) | name  |
| ------ | ----- |
| 1      | hello |

`NOT NULL` 제약이 있는 새로운 컬럼을 추가하려고 해도 기존 데이터에는 해당 컬럼의 값이 없기 때문에 추가할 수 없다.

실제 에러 메세지는 아래와 같다.

> ERROR 314 --- [io-8080-exec-10] o.h.engine.jdbc.spi.SqlExceptionHelper : ERROR: null value in column "total_absence_fee" of relation "challenge" violates not-null constraint

기존 데이터가 있는 상태에서 새로운 컬럼을 추가하려면 **`@ColumnDefault` 어노테이션**을 사용해 기본 값을 설정해야 한다.

```java
@Column(nullable = false)
@ColumnDefault("0") // 기본 값 설정.
private int totalAbsenceFee;
```

이 어노테이션을 추가한 후 Spring Boot 를 재실행하면 다음과 같이 `default` 제약조건이 걸린 쿼리가 실행된다.

> Hibernate: alter table if exists challenge add column total_absence_fee integer default 0 not null

# 컬럼 삭제가 안 되는 이유

3번과 4번 테스트 상황에서는 이미 존재하는 컬럼을 엔티티에서 삭제했을 때의 상황을 다루었다.

테이블에 데이터가 있든 없든, 컬럼은 삭제되지 않았다.

공식 문서에서 이에 대한 구체적인 이유를 찾을 수는 없었으나, 컬럼 삭제는 개발자의 명시적인 선택에 맡기는 것으로 보인다. 컬럼을 삭제하면 그 컬럼을 참조하는 코드에서 오류가 발생할 수 있기 때문이다.

스키마와 데이터를 완전히 삭제하는 옵션인 `create-drop` 도 있지만, `update` 옵션은 컬럼 추가나 데이터 타입 변경에만 적용되는 듯하다.

# 컬럼 삭제 방법

Spring Boot 공식 문서([링크](https://docs.spring.io/spring-boot/docs/2.1.7.RELEASE/reference/html/howto-database-initialization.html))에 따르면 데이터베이스 테이블을 변경할 때는 Flyway 나 Liquibase 같은 도구를 사용하는 것이 권장된다.

이 도구들은 DB 변경 사항을 버전별로 관리할 수 있으며, 필요하다면 이전 스키마로 롤백도 가능하다.

# ddl-auto 옵션

`ddl-auto` 옵션은 총 5가지며, 각각에 대한 설명은 아래와 같다.

## 1. none

데이터베이스 스키마의 자동 생성을 수행하지 않는다. 스키마를 수동으로 생성하고 업데이트 해야 한다.

## 2. validate

엔티티 클래스와 기존 스키마 간의 일관성을 검사한다. 스키마는 변경되지 않으며, 불일치가 있으면 예외(Exception)가 발생한다.

## 3. update

엔티티 클래스와 일치하도록 데이터베이스 스키마를 자동으로 업데이트한다. 새로운 테이블, 열, 제약 조건은 추가되지만, 기존 스키마에서 항목이 제거되지는 않는다.

## 4. create

기존 스키마를 삭제하고 엔티티 클래스를 기반으로 새 스키마를 생성한다. 이 옵션을 사용하면 기존 데이터가 모두 삭제되므로 주의가 필요하다.

## 5. create-drop

`create` 와 유사하지만, SessionFactory 가 닫힐 때(일반적으로 애플리케이션이 종료될 때) 스키마가 삭제된다. 각 실행마다 스키마를 다시 생성해야 하는 테스트 환경에서 유용하다.

## 옵션 사용 상황

각 옵션은 상황에 맞게 사용하는 것이 좋다.

### **개발 서버**

- 초기 단계: `create`
- 안정화 단계: `update`

---

### **테스트 서버**

- `update` 또는 `validate`

---

### **스테이징 서버**

- `validate` 또는 `none`

---

### **운영 서버**

- `validate` 또는 `none`

# 참고자료

- [Hibernate hbm2ddl.auto update does not drop columns with mysql](https://stackoverflow.com/questions/7079954/hibernate-hbm2ddl-auto-update-does-not-drop-columns-with-mysql) [stackoverflow]
- [[Java] Spring Boot - JPA Hibernate ddl-auto 설정](https://blog.naver.com/seek316/223264963594) [네이버 블로그]

끝.
