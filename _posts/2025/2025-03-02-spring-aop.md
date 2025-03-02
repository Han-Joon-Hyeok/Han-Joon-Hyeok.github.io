---
title: "[Spring] AOP 개념 정리"
date: 2025-03-02 21:55:00 +0900
categories: [Java, Spring]
tags: []
---

# 개요

스프링 프레임워크의 3대 요소 중 하나인 AOP(Aspect-Oriented Programming)에 대해 정리했습니다.

# AOP

## 개념

AOP는 핵심 비즈니스 로직과 공통 관심사를 분리해서 모듈화하는 프로그래밍 기법입니다. 여러 클래스에서 반복해서 사용하는 코드를 모듈화하고, 핵심 기능 개발에 집중할 수 있도록 도와줍니다.

## AOP가 필요한 이유

피자를 판매하는 식당 클래스 예제를 통해 AOP가 필요한 이유를 살펴봅시다.

```java
public class PizzaRestaurant {
  public void makeFood(String food) {
    System.out.println(food + "을 만듭니다.");
  }

  public void issueReceipt(int amount) {
    System.out.println("결제 금액은 " + amount + "원 입니다.");
  }
}
```

현재는 2개의 메서드, 음식을 만드는 `makeFood` 와 영수증을 발행하는 `issueReceipt` 가 있습니다. 새로운 요구사항으로 메서드 실행 시점을 출력하는 로깅 기능이 필요해졌다고 가정하겠습니다. 그렇다면 아래와 같이 각 메서드에 실행 시점을 출력하는 코드를 추가할 수 있습니다.

```java
public class PizzaRestaurant {
  public void makeFood(String food) {
    System.out.println("현재 시간: " + LocalDateTime.now()); // 추가한 코드
    System.out.println(food + "을 만듭니다.");
  }

  public void issueReceipt(int amount) {
    System.out.println("현재 시간: " + LocalDateTime.now()); // 추가한 코드
    System.out.println("결제 금액은 " + amount + "원 입니다.");
  }
}
```

예시로 작성한 클래스에서는 메서드가 2개이기 때문에 위와 같이 간단하게 해결할 수 있습니다. 하지만, 메서드가 더 많아진다면 로그를 위한 코드를 추가하는 것은 번거로우며 비효율적입니다. 또한, 다른 클래스에서도 동일한 로깅 기능이 필요하다면 이러한 방법으로는 유지보수 관점에서도 복잡해집니다.

이처럼 소스 코드에서 반복해서 사용하는 코드를 흩어진 관심사(Cross-cutting Concerns)이라고 하며, 흩어진 관심사를 Aspect로 모듈화하고 핵심적인 비즈니스 로직에서 분리해서 재사용하는 것이 AOP의 목표입니다.

![1.png](/assets/images/2025/2025-03-02-spring-aop/1.png)

위의 그림처럼 공통 관심사를 분리함으로써 코드 중복을 줄이고, 유지보수의 복잡도를 낮출 수 있습니다.

## 프록시 패턴

스프링 AOP는 프록시 패턴을 이용해서 구현되었습니다. 프록시 패턴은 원본 객체를 대신해서 처리하여 로직의 흐름을 제어하는 패턴입니다.

프록시의 사전적 의미는 ‘대리인’입니다. 즉, 누군가에게 어떤 일을 대신 시키는 것인데, 이를 객체지향 프로그래밍에 적용하면 클라이언트가 대상 객체를 직접 사용하는 것이 아닌 중간에 프록시(대리인)을 거쳐서 사용하는 것입니다.

프록시 패턴을 사용해도 결과적으로 대상 객체를 직접 사용하는 것과 동일한 결과가 나타나는데, 프록시 패턴을 사용하는 이유가 무엇일까요? AOP와 관련한 이유는 원본 객체를 수정하지 않고도 다른 기능을 추가할 수 있기 때문입니다. 이를 이해하기 위해 예제 코드를 통해 살펴보겠습니다.

### 예제 코드

위에서 피자를 판매하던 식당을 추상화하기 위해 `Restaurant` 인터페이스를 만듭니다.

```java
public interface Restaurant {
  void makeFood(String food);
  void issueReceipt(int amount);
}
```

`PizzaRestaurant` 는 `Restaurant` 를 구현합니다.

```java
public class PizzaRestaurant implements Restaurant {
  @Override
  public void makeFood(String food) {
    System.out.println(food + "을 만듭니다.");
  }

  @Override
  public void issueReceipt(int amount) {
    System.out.println("결제 금액은 " + amount + "원 입니다.");
  }
}
```

`PizzaRestaurant` 를 대신할 프록시 클래스 `ProxyRestaurant` 를 만듭니다. 그리고 기존에 `PizzaRestaurant` 클래스 내부에서 로깅 기능을 처리하던 것을 `ProxyRestaurant` 클래스에서 처리할 수 있도록 `makeFood` 메서드와 `issueReceipt` 메서드에는 현재 시간을 출력하는 로깅 기능을 추가합니다.

```java
public class ProxyRestaurant implements Restaurant {
  private final Restaurant restaurant;

  public ProxyRestaurant(Restaurant restaurant) {
    this.restaurant = restaurant;
  }

  @Override
  public void makeFood(String food) {
    System.out.println("현재 시간: " + LocalDateTime.now()); // 추가한 코드
    restaurant.makeFood(food);
  }

  @Override
  public void issueReceipt(int amount) {
    System.out.println("현재 시간: " + LocalDateTime.now()); // 추가한 코드
    restaurant.issueReceipt(amount);
  }
}
```

이를 바탕으로 main 함수를 아래와 같이 작성할 수 있습니다.

```java
public class ProxyExample {
  public static void main(String[] args) {
    Restaurant realRestaurant = new PizzaRestaurant(); // 실제 객체 생성
    Restaurant proxy = new ProxyRestaurant(realRestaurant); // 프록시 객체 생성

    proxy.makeFood("피자");
    proxy.issueReceipt(15000);
  }
}

```

실행 결과는 아래와 같습니다.

```
현재 시간: 2024-03-01T15:30:45.123
피자를 만듭니다.

현재 시간: 2024-03-01T15:30:45.456
결제 금액은 15000원 입니다.
```

이처럼 실제로 비즈니스 로직을 수행하는 `PizzaRestaurant` 객체를 감싸는 프록시 객체 `ProxyRestaurant` 는 `PizzaRestaurant` 을 직접 수정하지 않고도 로깅 기능을 추가할 수 있었습니다.

## AOP 용어 정리

AOP에서 사용하는 주요 용어를 정리하면 다음과 같습니다.

| 용어 | 의미 |
| --- | --- |
| Aspect | AOP의 기본 모듈. 애플리케이션의 핵심 기능을 제외한 기능적인 역할을 하는 코드를 담은 모듈. Advice와 Pointcut으로 구성됨. |
| Advice | AOP에서 실제 실행되는 코드 |
| Pointcut | Advice가 적용될 Join Point를 선별하는 작업 또는 그 기능을 정의한 모듈 |
| Join Point | 프로그램의 실행 내부에서 Advice가 적용될 수 있는 위치 |
| Target Object | Advice가 적용될 객체 |

![2.png](/assets/images/2025/2025-03-02-spring-aop/2.png)

# 스프링 AOP

스프링에서 어떻게 AOP가 적용되는지 확인해보겠습니다.

## 어노테이션 정리

스프링 AOP는 아래와 같은 어노테이션을 제공합니다.

| 타입 | 의미 |
| --- | --- |
| @Aspect | AOP로 정의하는 클래스 지정 |
| @Pointcut | AOP 기능을 메서드, 어노테이션 등 어느 지점에 적용할 지 설정. |
| @Before | target 메서드가 실행되기 전에 advice 실행 |
| @After | target 메서드가 실행된 후 advice 실행. 메서드가 정상적으로 마무리되거나 exception이 발생하거나 무조건 실행됨. |
| @Around | target 메서드를 감싸는 advice. 앞과 뒤에 모두 영향을 미칠 수 있음. target을 실행할 지, 바로 반환할지 정할 수도 있음. |
| @AfterReturning | target 메서드가 정상적으로 끝난 경우 실행되는 advice |
| @AfterThrowing | target 메서드가 exception throw한 경우 실행. |

## 예제 코드

프로젝트 구조는 아래와 같습니다.

```cpp
📦 com.example
┣ 📂 service
┃ ┣ 📜 Restaurant.java           // 인터페이스 (공통 기능 정의)
┃ ┣ 📜 PizzaRestaurant.java      // 실제 객체 (Real Subject)
┃ ┗ 📜 RestaurantService.java    // AOP 프록시가 적용된 서비스
┣ 📂 aspect
┃ ┗ 📜 LoggingAspect.java        // AOP 적용 (프록시 역할)
┣ 📜 Application.java            // Spring Boot 실행 클래스

```

프록시 적용을 위해 인터페이스를 먼저 정의합니다.

```java
package com.example.service;

public interface Restaurant {
    void makeFood(String food);
    void issueReceipt(int amount);
}
```

핵심 비즈니스 로직을 수행하는 클래스입니다.

```java
package com.example.service;

import org.springframework.stereotype.Service;

@Service
public class PizzaRestaurant implements Restaurant {
    @Override
    public void makeFood(String food) {
        System.out.println(food + "을 만듭니다.");
    }

    @Override
    public void issueReceipt(int amount) {
        System.out.println("결제 금액은 " + amount + "원 입니다.");
    }
}

```

AOP를 적용할 LoggingAspect 클래스는 아래와 같습니다.

```java
package com.example.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Aspect // ✅ AOP 적용 클래스
@Component // ✅ 스프링 빈 등록
public class LoggingAspect {

    // ✅ Restaurant 인터페이스를 구현한 모든 메서드 실행 전
    @Before("execution(* com.example.service.Restaurant.*(..))")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("🕒 현재 시간: " + LocalDateTime.now());
        System.out.println("📝 [LOG] 실행 전: " + joinPoint.getSignature().getName());
    }

    // ✅ Restaurant 인터페이스를 구현한 모든 메서드 실행 후
    @After("execution(* com.example.service.Restaurant.*(..))")
    public void logAfter(JoinPoint joinPoint) {
        System.out.println("📝 [LOG] 실행 후: " + joinPoint.getSignature().getName());
    }
}

```

AOP가 적용된 서비스는 아래와 같습니다.

```java
package com.example.service;

import org.springframework.stereotype.Service;

@Service
public class RestaurantService {
    private final Restaurant restaurant;

    public RestaurantService(Restaurant restaurant) {
        this.restaurant = restaurant; // ✅ AOP 프록시 객체가 자동으로 주입됨
    }

    public void orderPizza() {
        restaurant.makeFood("피자");
        restaurant.issueReceipt(15000);
    }
}

```

Application 클래스는 아래와 같습니다.

```java
package com.example;

import com.example.service.RestaurantService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@SpringBootApplication
@EnableAspectJAutoProxy // ✅ AOP 프록시 활성화
public class Application implements CommandLineRunner {
    private final RestaurantService restaurantService;

    public Application(RestaurantService restaurantService) {
        this.restaurantService = restaurantService;
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Override
    public void run(String... args) {
        restaurantService.orderPizza();
    }
}

```

실행 결과는 아래와 같습니다.

```
🕒 현재 시간: 2024-03-01T15:30:45.123
📝 [LOG] 실행 전: makeFood
피자를 만듭니다.
📝 [LOG] 실행 후: makeFood

🕒 현재 시간: 2024-03-01T15:30:45.456
📝 [LOG] 실행 전: issueReceipt
결제 금액은 15000원 입니다.
📝 [LOG] 실행 후: issueReceipt
```

# 참고자료

- [💠 프록시(Proxy) 패턴 - 완벽 마스터하기](https://inpa.tistory.com/entry/GOF-%F0%9F%92%A0-%ED%94%84%EB%A1%9D%EC%8B%9CProxy-%ED%8C%A8%ED%84%B4-%EC%A0%9C%EB%8C%80%EB%A1%9C-%EB%B0%B0%EC%9B%8C%EB%B3%B4%EC%9E%90) [티스토리]
- [[Spring] 스프링 AOP (Spring AOP) 총정리 : 개념, 프록시 기반 AOP, @AOP](https://engkimbs.tistory.com/entry/%EC%8A%A4%ED%94%84%EB%A7%81AOP) [티스토리]
- [[Java] Spring Boot AOP(Aspect-Oriented Programming) 이해하고 설정하기](https://adjh54.tistory.com/133) [티스토리]
- [[Spring] 프록시 패턴 & 스프링 AOP](https://velog.io/@max9106/Spring-프록시-AOP-xwk5zy57ee) [velog]
- [[10분 테코톡] 봄의 AOP와 SPRING AOP](https://youtu.be/hjDSKhyYK14?feature=shared) [youtube]