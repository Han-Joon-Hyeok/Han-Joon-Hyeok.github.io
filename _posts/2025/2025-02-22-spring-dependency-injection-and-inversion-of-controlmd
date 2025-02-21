---
title: "[Spring] 의존성 주입(DI)과 제어의 역전(IoC) 개념 정리"
date: 2025-02-22 00:30:00 +0900
categories: [Java, Spring]
tags: []
---

# 개요

스프링 프레임워크의 3대 요소인 DI/IoC, AOP, PSA 중 DI/IoC에 대해 정리했습니다. 예제 코드는 Java로 작성했습니다.

# 의존성 주입(DI; Dependency Injection) 개념 이해

의존성 주입이라는 단어에는 의존성과 주입이라는 2가지 개념이 들어있습니다. 각각의 개념을 먼저 정리해봅시다.

## 의존성이란?

의존성이란 어떤 객체가 자신의 기능을 수행하기 위해 필요로 하는 외부의 요소를 의미합니다. Pencil 객체를 멤버 변수로 가지는 Store 클래스를 예시로 설명하겠습니다.

```java
// Pencil 클래스
class Pencil {
  public void usePencil() {
    System.out.println("Pencil 사용");
  }
}

// Store 클래스
class Store {
  private Pencil pencil;

  public Store() {
    pencil = new Pencil();
  }

  public void usePencil() {
    pencil.usePencil();
  }
}

// Main 클래스
public class Main {
  public static void main(String[] args) {
    Store store = new Store();
    store.usePencil(); // "Pencil 사용"
  }
}
```

현재 작성한 코드에서 Store 객체를 생성하면 Pencil 객체도 함께 생성됩니다. 여기까지는 큰 문제가 없어보입니다.

### 문제점: 강한 결합도(Tight Coupling)

만약 Pencil 클래스의 `usePencil()` 메서드 이름을 `use()` 로 변경한다면, Pencil 클래스 뿐만 아니라 Store 클래스에서도 코드를 변경해야 합니다.

```java
// Pencil 클래스
class Pencil {
  public void use() { // 변경 지점 1
    System.out.println("Pencil 사용");
  }
}

// Store 클래스
class Store {
  // 생략...

  public void usePencil() {
    pencil.use(); // 변경 지점 2
  }
}
```

한편, Pencil이 아닌 Eraser를 판매하는 Store 클래스를 만들고 싶다고 해봅시다. 하지만 이미 Store 클래스는 Pencil 클래스를 멤버 변수로 받고 있으니, 아래의 코드와 같이 Store2라는 클래스를 새롭게 만들어야 할까요?

```java
// Eraser 클래스
class Eraser {
  public void use() {
    System.out.println("Eraser 사용");
  }
}

// Store2 클래스
class Store2 {
  private Eraser eraser;

  public Store2() {
    eraser = new Eraser();
  }

  public void useEraser() {
    eraser.use();
  }
}
```

다른 상품으로 변경하고 싶을 때마다 매번 다른 이름의 클래스를 생성해야 한다면 비효율적인 코드가 됩니다. 이처럼 Store 클래스는 Pencil 클래스의 변경에 따라 함께 수정되어야 합니다. 이러한 상황을 Store 클래스가 Pencil 클래스에 강하게 의존한다고 표현합니다.

### 해결책: 의존 관계를 인터페이스로 추상화하기

이를 해결하기 위해 의존 관계를 인터페이스로 추상화 할 수 있습니다. Store 클래스 하나만으로도 여러 상품을 판매할 수 있게 만들어봅시다.

우선 Store에서 판매하는 상품들을 Tool이라는 이름의 인터페이스로 추상화합니다.

```java
// Tool 인터페이스
interface Tool {
  void use();
}
```

그리고 Pencil 클래스와 Eraser 클래스를 implements 키워드를 이용해서 구현합니다. 즉, 인터페이스에서 선언된 `use()` 메서드를 자식 클래스에서 오버라이딩(재정의)하는 것입니다.

```java
// Pencil 클래스
class Pencil implements Tool {
  @Override
  public void use() {
    System.out.println("Pencil 사용");
  }
}

// Eraser 클래스
class Eraser implements Tool {
  @Override
  public void use() {
    System.out.println("Eraser 사용");
  }
}
```

위와 같이 Tool 인터페이스를 사용하면 `use()` 메서드를 공통적으로 사용할 수 있으며, Store 클래스의 멤버 변수를 인터페이스 타입으로 선언하여 유연성을 높일 수 있습니다.

```java
// Store 클래스
class Store {
  private Tool tool;

  public Store() {
    tool = new Tool();
  }

  public void use() {
    tool.use();
  }
}
```

이제 Store 클래스는 같은 인터페이스를 상속 받은 여러 클래스를 멤버 변수로 가질 수 있게 되었고, 같은 이름을 공유하는 메서드를 호출할 수 있게 되었습니다.

## 의존성을 외부에서 주입하기

### 문제점: 인터페이스는 인스턴스화 불가능

하지만 인터페이스는 직접 인스턴스화 하는 것이 불가능하다는 문제가 여전히 남아있습니다.

```java
tool = new Tool(); // 인터페이스는 직접 인스턴스화 불가능
```

여기서 주입이라는 개념이 필요합니다. 주입은 객체 스스로 필요한 의존성을 생성하지 않고, 객체 외부에서 필요한 의존성을 전달 받는 것을 의미합니다.

> 참고로 인터페이스는 익명 클래스로 인스턴스화가 가능하지만, 개념의 이해를 돕기 위해 이 부분은 고려하지 않겠습니다.

### 해결책: 객체 외부에서 필요한 의존성을 제공하기

우선, Store 클래스의 생성자는 매개변수로 Tool 인터페이스를 사용하는 변수를 받도록 변경합니다.

```java
// Store 클래스
class Store {
  private Tool tool;

  // 매개변수를 통해 외부에서 의존성을 전달 받음
  public Store(Tool tool) {
    this.tool = tool;
  }

  public void use() {
    tool.use();
  }
}
```

그 다음 Main 클래스에서는 아래와 같이 Store 객체의 생성자로 인터페이스가 아닌 Pencil 클래스와 Eraser 클래스의 객체(인스턴스)를 전달합니다.

```java
// Main 클래스
public class Main {
  public static void main(String[] args) {
    Store pencilStore = new Store(new Pencil()); // Pencil 객체 전달
    Store eraserStore = new Store(new Eraser()); // Eraser 객체 전달

    pencilStore.use(); // "Pencil 사용"
    eraserStore.use(); // "Eraser 사용"
  }
}
```

이처럼 외부에서 의존성을 전달하면 Store 객체는 Tool 인터페이스를 상속한 모든 클래스를 의존성으로 받을 수 있게 됩니다. 즉, 코드의 재사용성과 확장성이 증가하는 효과를 얻게 됩니다.

물론 반드시 인터페이스를 사용해야만 의존성 주입을 할 수 있는 것은 아니지만, 인터페이스를 사용해서 결합도를 낮추고 확장성을 높일 수 있습니다. 즉, 인터페이스는 의존성 주입을 더욱 효과적으로 적용하기 위한 도구일 뿐, 필수 요소는 아닙니다.

## 의존성 주입 방법

위의 예시 코드에서는 의존성 주입을 가장 권장되는 생성자를 이용했지만, 스프링에서 지원하는 의존성 주입은 4가지 방법이 있습니다. 하지만 여기서는 개념에 집중하기 위해 Java 코드만으로도 구현 가능한 2가지 방법을 소개합니다.

### 1. 생성자 (권장)

생성자를 통해 의존성 객체를 주입하는 방법입니다.

```java
// Store 클래스
class Store {
  private final Tool tool;

  // 매개변수를 통해 외부에서 의존성을 전달 받음
  public Store(Tool tool) {
    this.tool = tool;
  }
}
```

final 키워드와 함께 사용해서 객체의 멤버 변수가 변경되지 않도록 보장할 수 있습니다. 또한, 테스트를 할 때 Mock 객체를 생성자에 주입하여 사용할 수도 있습니다.

### 2. Setter 주입

setter를 이용하는 방법도 있습니다.

```java
// Store 클래스
class Store {
  private Tool tool;

  // Setter 메서드를 통해 외부에서 의존성을 전달 받음
  public setTool(Tool tool) {
    this.tool = tool;
  }

  public void use() {
    tool.use();
  }
}

// Main 클래스
public class Main {
  Store store = new Store();

  store.setTool(new Pencil()); // Pencil 객체 전달
  store.use(); // "Pencil 사용"

  store.setTool(new Eraser()); // Eraser 객체 전달
  store.use(); // "Eraser 사용"
}
```

하지만 setter를 이용하면 final 키워드를 사용할 수 없게되어 객체의 불변성을 보장하지 못합니다. final 키워드를 사용하면 객체 내부에서 선언과 동시에 할당을 하거나 생성자에서 할당해주어야 합니다.

```java
class Store {
  private final Pencil pencil = new Pencil(); // 1. 선언과 동시에 초기화
}
```

```java
class Store {
  private final Tool tool;

  // 2. 생성자에서 초기화
  public Tool(Tool tool) {
    this.tool = tool;
  }
}
```

객체의 불변성을 유지하고 다형성을 적용하려면 생성자를 통해 의존성을 주입하는 것이 권장됩니다.

## 장점

의존성 주입으로 의존 관계를 분리함으로써 얻는 장점을 정리하면 아래와 같습니다.

### 1. 낮은 결합도

의존하는 대상이 변화해도 구현 자체를 수정할 일이 없거나 줄어듭니다.

### 2. 재사용성 높은 코드

Store 클래스의 의존성으로 사용했던 Tool 인터페이스를 여러 클래스에서 재사용할 수 있습니다.

### 3. 테스트 용이

Tool 인터페이스의 테스트를 Store 테스트와 분리해서 진행할 수 있습니다.

### 4. 가독성 향상

Tool 인터페이스의 기능들을 Store 클래스와 분리함으로써 가독성이 높아집니다.

# 제어의 역전 (Inversion of Control)

DI는 IoC를 구현하는 방법 중 하나입니다.

## 개념

객체의 생성 및 흐름을 개발자가 직접 관리하는 것이 아니라 제어의 권한을 프레임워크나 컨테이너가 담당하는 것을 의미합니다. 즉, 애플리케이션의 흐름을 개발자가 직접 제어하는 것이 아니라, 외부 컨테이너(스프링)가 관리하도록 돕는 것을 의미합니다.

## 필요성

제어의 역전이 필요한 이유를 이해하기 위해 제어의 역전이 적용되지 않은 코드와 적용된 코드를 비교하겠습니다.

### 1. IoC를 적용하지 않은 코드

```java
class Pencil {
    public void use() {
        System.out.println("Pencil 사용");
    }
}

class Store {
    private Pencil pencil;

    public Store() {
        this.pencil = new Pencil(); // 직접 객체 생성 (제어권이 Store에 있음)
    }

    public void usePencil() {
        pencil.use();
    }
}

```

위의 코드에서 발견할 수 있는 문제점은 2가지가 있습니다.

1. Store 객체 내부에서 Pencil 객체를 직접 생성하기 때문에 Pencil 객체의 제어권이 Store 객체에게 있고, Pencil 클래스가 아닌 다른 클래스로 쉽게 바꿀 수 없어 확장성이 낮습니다.
2. Pencil 클래스가 변경되면 Store 클래스도 변경해야 하므로 결합도가 높습니다.

### 2. IoC를 적용한 코드(DI)

위에서 살펴봤던 의존성 주입 방법 중에서 생성자를 이용하는 방법입니다.

```java
// Store 클래스
class Store {
  private Tool tool;

  // 매개변수를 통해 외부에서 의존성을 전달 받음
  public Store(Tool tool) {
    this.tool = tool;
  }

  public void use() {
    tool.use();
  }
}

// Main 클래스
public class Main {
  public static void main(String[] args) {
    Store pencilStore = new Store(new Pencil()); // Pencil 객체 전달
    Store eraserStore = new Store(new Eraser()); // Eraser 객체 전달

    pencilStore.use(); // "Pencil 사용"
    eraserStore.use(); // "Eraser 사용"
  }
}
```

Store 객체 내부에서 멤버 변수의 생성을 책임지는 것이 아닌 Store 객체 외부에서 멤버 변수를 주입함으로써 확장성 높은 코드를 작성할 수 있게 되었습니다.

## 스프링에 적용된 제어의 역전

스프링은 스프링 컨테이너를 이용해서 제어의 역전을 구현합니다. 즉, 개발자가 직접 객체의 생성과 소멸을 관리하지 않고 프레임워크에게 역할을 위임하는 것입니다. 이를 통해 개발자는 비즈니스 로직에만 집중할 수 있게 되어 개발 생산성이 향상됩니다.

### 스프링 컨테이너와 빈

빈은 스프링 컨테이너가 생성하고 관리하는 객체입니다. 즉, 빈이 생성되고 소멸되는 생명주기를 스프링 컨테이너가 관리합니다. 빈을 스프링 컨테이너에 등록하기 위해 스프링은 어노테이션으로 등록하거나 XML 파일에서 설정하도록 여러 방법을 제공합니다.

예를 들어, Pencil 클래스에 `@Component` 라는 어노테이션을 붙이면 빈으로 등록됩니다.

```java
@Component // 빈으로 등록
class Pencil {
  // 생략
}
```

그리고 `@Autowired` 어노테이션을 이용하면 스프링 컨테이너가 의존성 주입을 자동으로 합니다.

```java
@Component // 빈으로 등록
class Store {
  private final Pencil pencil;

  @Autowired // 의존성 주입을 스프링 컨테이너가 수행하도록 위임
  public Store(Pencil pencil) {
      this.pencil = pencil;
  }

  public void usePencil() {
      pencil.use();
  }
}
```

```java
@Configuration
@ComponentScan(basePackages = "com.example")
public class AppConfig {}

public class Main {
  public static void main(String[] args) {
    ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

    Store store = context.getBean(Store.class);
    store.usePencil(); // "Pencil 사용"
  }
}
```

실행 과정을 정리하면 아래와 같습니다.

1. `@Component`가 붙은 `Pencil` 객체가 **스프링 컨테이너에 자동으로 등록**됨.
2. `@Component`가 붙은 `Store` 객체도 **스프링 컨테이너에 등록됨**.
3. `@Autowired`를 통해 `Pencil` 타입의 빈을 찾아서 `Store` 생성자의 매개변수로 자동 주입.
4. `ApplicationContext`에서 `Store` 빈을 가져와 사용.

# 마무리

스프링에 적용된 제어의 역전을 이해하기 위해 의존성 주입을 먼저 이해했습니다. Java 코드를 통해 의존성 주입과 제어의 역전 개념을 정리했으며, 스프링에서 어떻게 이 개념들이 적용되었는지 살펴보았습니다.

# 참고자료

- [의존성 주입이란 무엇인가? 쉽게 이해하기](https://medium.com/@ehdrbdndns/의존성-주입이란-무엇인가-쉽게-이해하기-862a656a610c) [Medium]
- [의존관계 주입(Dependency Injection) 쉽게 이해하기](https://tecoble.techcourse.co.kr/post/2021-04-27-dependency-injection/) [Tecoble]
- [[Spring] 의존성 주입(Dependency Injection, DI)이란? 및 Spring이 의존성 주입을 지원하는 이유](https://mangkyu.tistory.com/150) [티스토리]
- [스프링의 콘셉트(IoC, DI, AOP, PSA) 쉽게 이해하기](https://shinsunyoung.tistory.com/133) [티스토리]
