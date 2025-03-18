---
title: "[Spring] PSA(Portable Service Abstraction) 개념 정리"
date: 2025-03-18 18:00:00 +0900
categories: [Java, Spring]
tags: []
---

# 개요

Spring의 세 가지 핵심 기술 중 하나인 PSA(Portable Service Abstraction)에 대해 정리했습니다.

# PSA란?

PSA는 Spring에서 특정 기술에 종속되지 않고, 일관된 인터페이스를 통해 다양한 기술을 동일한 방식으로 사용할 수 있도록 추상화한 개념입니다.

즉, 개발자가 특정 기술에 직접 의존하지 않고, Spring이 제공하는 공통 인터페이스를 사용하여 다양한 기술을 쉽게 교체할 수 있도록 합니다. 이를 통해 개발자는 구현체 변경 없이 비즈니스 로직을 유지할 수 있습니다.

대표적으로 트랜잭션 관리를 위해 사용하는 `@Transactional` 어노테이션은 내부적으로 JDBC, JPA, Hibernate 등 다양한 기술을 지원합니다. 이를 통해 개발자가 기술을 변경해도 내부 코드를 변경하지 않고 트랜잭션을 적용할 수 있도록 도와줍니다.

# PSA 적용 전후 비교

PSA가 도입된 이유를 이해하기 위해 Java로 트랜잭션 기능을 구현하는 예제를 살펴보겠습니다.

## 1. 순수 Java 방식

Spring에서 `@Transactional` 어노테이션을 사용하기 전에는 트랜잭션을 처리하기 위해 직접 **DB 연결, 트랜잭션 시작, 커밋과 롤백, 연결 종료**를 처리해야 했습니다.

아래의 예시는 사용자의 이름과 이메일을 DB에 저장하는 코드입니다.

```java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UserService {

    public void createUser(String username, String email) throws Exception {
        Connection conn = null;
        try {
            // 1. DB Connection 생성
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "user", "password");
            // 2. 트랜잭션 시작
            conn.setAutoCommit(false);

            // 3. DB 쿼리 실행
            String sql = "INSERT INTO users (username, email) VALUES (?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.executeUpdate();
            }

            // 4. 트랜잭션 커밋
            conn.commit();
        } catch (Exception e) {
            // 5. 트랜잭션 롤백
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            // 6. DB Connection 종료
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }
}
```

### 🔴 문제점

1. 트랜잭션을 직접 관리해야 하므로 코드가 복잡해집니다.
2. 트랜잭션을 처리하기 위한 코드가 많아질수록 중복 코드(Connection 생성, Commit/Rollback, Close)도 함께 많아집니다.
3. 비즈니스 로직과 트랜잭션 관리가 혼재되어 가독성이 떨어집니다.

## 2. @Transactional을 사용한 방식

위와 같은 문제를 해결하기 위해 Spring에서는 `@Transactional` 어노테이션을 통해 트랜잭션을 자동으로 관리합니다. 이를 통해 비즈니스 로직에만 집중할 수 있게 되었습니다.

```java
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Service
public class UserService {

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public void createUser(String username, String email) {
        // 1. 트랜잭션이 자동으로 시작됨
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);

        entityManager.persist(user);
        // 2. 트랜잭션이 성공적으로 끝나면 자동으로 커밋됨
        // 예외 발생 시 롤백됨
    }
}
```

사용자를 생성하는 비즈니스 로직을 제외한 나머지 부분(Connection 생성, Commit/Rollback, Close)은 AOP를 통해 구현됩니다.

### ✅ 장점

1. 트랜잭션 관리가 자동으로 이루어지므로 개발이 편리해집니다.
2. 중복된 코드가 제거되어 코드가 간결해지고 유지보수가 쉬워집니다.
3. 비즈니스 로직과 트랜잭션 관리가 분리되어 가독성이 높아집니다.
4. PSA를 활용하여 데이터 접근 방식(JDBC, JPA, Hibernate 등)이 변경되어도 코드 수정이 최소화됩니다.

# @Transactional 추상화 원리

Spring의 `@Transactional` 어노테이션은 어떻게 JDBC, JPA, Hibernate 등 각기 다른 데이터 접근 기술 사용과 연동될 수 있을까요?

## ❌ @Transactional이 만약 JDBC 전용이었다면?

만약 `@Transactional` 어노테이션이 JDBC 전용이었다면 아래와 같이 작성되었을 것입니다.

```java
public void method_name() throw Exception {
    TransactionalSynchronizationManager.initSunchronization();
    Connection c = DataSourceUtils.getConnection(dataSource);
    try {
        // ...DB 쿼리 실행...

        c.commit();
    } catch(Exception e) {
        c.rollback();
        throw e;
    } finally {
        DatasourceUtils.releaseConnection(c, dataSource);
        TransactionSynchronizationManager.unbindResource(dataSource);
        TransactionSynchronizationManager.clearSynchronization();
    }
}
```

### 🔴 문제점

이 방식은 JDBC에 종속적이기 때문에 Hibernate, JPA 등의 기술로 변경하려면 코드를 수정해야 합니다. Hibernate는 Session을 통해 트랜잭션을 제어하고, JPA는 EntityManager를 통해 트랜잭션을 제어하기 때문입니다.

## ✅ TransactionManager를 활용한 추상화

이를 해결하기 위해 Spring은 PlatformTransactionManager 인터페이스를 제공하여 트랜잭션 관리를 추상화합니다. 실제로 PlatformTransactionManager는 아래와 같이 정의되어 있습니다.

```java
// PlatformTransactionManger.class

public interface PlatformTransactionManager extends TransactionManager {
    TransactionStatus getTransaction(@Nullable TransactionDefinition definition) throws TransactionException;

    void commit(TransactionStatus status) throws TransactionException;

    void rollback(TransactionStatus status) throws TransactionException;
}
```

그리고 각 기술마다 TransactionManager를 의존성으로 주입받아서 사용합니다.

![1.png](/assets/images/2025/2025-03-18-spring-concept-of-psa/1.png)

출처: 토비의 스프링 3.1

실제로 Spring의 PlatformTransactionManager 인터페이스를 구현한 클래스들은 IDE에서 아래의 이미지처럼 표시됩니다.

![2.png](/assets/images/2025/2025-03-18-spring-concept-of-psa/2.png)

이 중에서 HibernateTransactionManager만 살펴보면, AbstractPlatformTransactionManager를 상속받아 구현되어 있는 것을 확인할 수 있습니다.

```java
// HibernateTransactionManager.class

public class HibernateTransactionManager extends AbstractPlatformTransactionManager implements ResourceTransactionManager, BeanFactoryAware, InitializingBean {
  // ...
}
```

## 🔄 PSA 적용 후 @Transactional

위에서 `@Transactional` 어노테이션이 JDBC을 위해 작성되었다면, 데이터 접근 기술을 쉽게 교체하기 어렵다는 문제가 있었습니다. 이를 해결하기 위해 생성자에서 의존성을 주입 받는 방식으로 바꾼다면 아래와 같이 작성할 수 있을 것입니다.

```java
private PlatformTransactionManger transactionManager;

// 생성자
public constructor(PlatformTransactionManger transactionManager) {
  // 의존성 주입으로 JPA, hibernate, JDBC로 쉽게 변경 가능.
  this.transactionManager = transactionManager;
}

public void method_name() throw Exception {
  // 인터페이스에 정의된 공통 메서드로 트랜잭션 사용
  TransactionStatus status = transactionManager.getTransaction(new DefaultTransactionDefinition());
  try {
    // 3. DB 쿼리 실행
    transactionManager.commit(status);
  } catch(Exception e) {
    transactionManager.rollback(status);
    throw e;
  }
}
```

이를 통해 트랜잭션을 제어하기 위해 하나의 기술에 제한되지 않고 여러 기술을 모두 사용할 수 있게 되었고, Spring의 PSA에 부합한 코드가 되었습니다.

# 참고자료

- [[Spring] Spring의 핵심기술 PSA - 개념과 원리](https://sabarada.tistory.com/127) [티스토리]
- [[Spring] PSA란 무엇인가? (Portable Service Abstraction)](https://ittrue.tistory.com/214) [티스토리]
- [JDBC(Spring JDBC)란? / 스프링 JDBC 알고넘어가기](https://mininkorea.tistory.com/39) [티스토리]
- [스프링에서는 트랜잭션을 어떻게 처리하는가? (2)](https://velog.io/@garden6/스프링에서는-트랜잭션을-어떻게-처리하는가-2) [velog]