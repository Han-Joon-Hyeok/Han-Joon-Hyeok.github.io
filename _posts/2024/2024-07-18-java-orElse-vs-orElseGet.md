---
title: "[Java] orElse 와 orElseGet 의 차이"
date: 2024-07-18 10:55:00 +0900
categories: [Java, Spring]
tags: []
---
# 개요

Optional 객체의 메서드인 orElse 와 orElseGet 은 매개변수로 메서드를 전달했을 때 다른 방식으로 작동한다.

결론부터 말하면 아래와 같다.

- orElse: null 여부와 상관없이 메서드 실행
- orElseGet: null 일 때만 메서드 실행

Optional 객체의 값이 있는 경우에는 어떻게 동작하는지 살펴보자.

```java
import java.util.Optional;

public class Program
{
    public static String getHello() {
        System.out.println("getHello(): hello");
        return "hello";
    }

    public static void main(String[] args) {
        String orElse = Optional.<String>ofNullable("world").orElse(getHello());
        System.out.println(String.format("orElse: %s", orElse));

        String orElseGet = Optional.<String>ofNullable("hi").orElseGet(() -> getHello());
        System.out.println(String.format("orElseGet: %s", orElseGet));
    }
}
```

출력 결과는 아래와 같다.

```
getHello(): hello
orElse: world
orElseGet: hi
```

첫 번째 Optional 객체에는 world 라는 문자열이 있음에도 불구하고 `getHello()` 메서드가 실행되었다.

하지만, `getHello()` 메서드의 반환 값인 hello 가 `String orElse` 변수에 저장되지 않았다.

두 번째 Optional 객체는 hi 라는 문자열이 있기 때문에 `getHello()` 메서드가 실행되지 않았다.

그럼 Optional 객체의 값이 null 인 경우는 어떨까?

```java
import java.util.Optional;

public class Program
{
    public static String getHello() {
        System.out.println("getHello(): hello");
        return "hello";
    }

    public static void main(String[] args) {
        String orElse = Optional.<String>ofNullable(null).orElse(getHello());
        System.out.println(String.format("orElse: %s", orElse));

        String orElseGet = Optional.<String>ofNullable(null).orElseGet(() -> getHello());
        System.out.println(String.format("orElseGet: %s", orElseGet));
    }
}
```

출력 결과는 아래와 같다.

```
getHello(): hello
orElse: hello
getHello(): hello
orElseGet: hello
```

`getHello()` 메서드가 실행되고, 메서드의 반환 값인 hello 가 각각의 String 변수에 저장된 것을 확인할 수 있다.

이 글에서는 `orElse 의 매개변수로 메서드를 넘기면 왜 Optional 객체의 값과 상관없이 실행되는가?` 에 대한 질문을 해결하는 과정을 담았다.

글을 이해하기 위한 핵심 개념은 아래와 같다.

- 제네릭 타입
- Supplier 인터페이스(람다 표현식)
- Eager Evaluation, Lazy Evaluation

# orElse

## 정의

orElse 는 아래와 같이 정의되어있다.

```java
public T orElse(T other) {
  return value != null ? value : other;
}
```

T 는 제네릭 타입을 의미한다.

orElse 메서드는 Optional 객체의 멤버변수인 value 가 null 이 아니면 `value` 를 반환하고, null 이면 orElse 의 매개변수로 들어온 `other` 를 반환한다.

## 작동 방식

Optional 객체의 value 가 null 이 아닌 경우를 살펴보자.

```java
String orElse = Optional.<String>ofNullable("world").orElse(getHello());
```

위의 코드에서 orElse 의 매개변수로 String 을 반환하는 `getHello()` 메서드를 입력했다.

`getHello()` 메서드가 먼저 실행되면서 orElse 의 매개변수 `other` 는 hello 라는 값을 갖는다.

그래서 orElse 는 내부적으로 아래와 같이 변환된다.

```java
public String orElse(String other) { // other 는 hello 라는 값을 갖고 있음.
  return value != null ? value : other;
}
```

이처럼 Optional 객체 값의 null 여부와 상관없이 매개변수가 평가되는 것을 Eager Evaluation 이라고 한다.

# orElseGet

## 정의

orElseGet 은 아래와 같이 정의되어있다.

```java
public T orElseGet(Supplier<? extends T> other) {
  return value != null ? value : other.get();
}
```

`Supplier` 는 함수 인터페이스이고, 매개변수는 `other` 는 `Supplier` 객체를 의미한다.

참고로 `<? extends T>` 는 제네릭 T 타입과 T 타입을 상속 받은 모든 클래스를 받는다는 의미이다. `?` 는 모든 것을 받는 문자 `*` (asterisk)와 같은 의미이다.

### Supplier

Supplier 는 자바 8 버전부터 도입된 새로운 문법이다.

Supplier 는 아래와 같이 정의되어 있다.

```java
@FunctionalInterface
public interface Supplier<T> {

    T get();
}
```

제네릭 T 를 반환하는 `get()` 메서드만 정의되어있다.

Supplier 는 람다 표현식 또는 메서드 레퍼런스 객체를 의미한다.

`get()` 메서드는 람다 표현식 또는 메서드 레퍼런스를 실행하는 것으로 이해하면 된다.

예제 코드는 아래와 같다.

```java
import java.util.Optional;
import java.util.function.Supplier;

public class Program
{
    public static String getHello() {
        return "hello";
    }

    public static void main(String[] args) {
        Supplier<String> name = () -> getHello();
        System.out.println(name);
        System.out.println(name.get());
    }
}
```

출력 결과는 아래와 같다.

```
Program$$Lambda/0x00007b607f000a00@7ad041f3
hello
```

즉, Supplier 객체는 `get()` 메서드가 호출될 때만 람다 표현식으로 넘긴 메서드 `getHello()` 가 실행되는 것을 알 수 있다.

## 작동 방식

Optional 객체의 value 가 null 이 아닌 경우를 살펴보자.

```java
String orElseGet = Optional.<String>ofNullable("world").orElseGet(() -> getHello());
```

orElseGet 은 매개변수로 Supplier 객체, 즉 람다 표현식을 매개변수로 넘긴다.

제네릭 T 는 컴파일 타임에 결정되기 때문에 orElseGet 은 아래와 같이 변환될 것이다.

```java
public String orElseGet(Supplier<String> other) {
  return value != null ? value : other.get(); // other 는 () -> getHello() 를 의미.
}
```

앞서 살펴본 것처럼 Supplier 객체는 `get()` 메서드가 호출되어야 `getHello()` 메서드를 실행할 것이다.

즉, orElse 와 다르게 orElseGet 은 Optional 객체 값이 null 인 경우에 메서드를 실행하는 것을 알 수 있다.

이를 Lazy Evaluation(지연 평가)라고 한다.

이러한 특성 때문에 Optional 객체 값이 null 이 아닐 때는 메서드를 실행하지 않는 것이다.

```java
import java.util.Optional;

public class Program
{
    public static String getHello() {
        System.out.println("getHello(): hello");
        return "hello";
    }

    public static void main(String[] args) {
        String name = Optional.<String>ofNullable("world").orElseGet(() -> getHello());
        System.out.println(String.format("name: %s", name));

        String nullName = Optional.<String>ofNullable(null).orElseGet(() -> getHello());
        System.out.println(String.format("nullName: %s", nullName));
    }
}
```

출력 결과는 아래와 같다.

```
name: world
getHello(): hello
nullName: hello
```

# 두 메서드를 구분해서 사용해야 하는 이유

Spring 으로 백엔드를 개발하면서 사용자 회원가입 과정에서 모든 사용자는 고유한 이메일을 갖도록 했다.

DB 테이블에서 이메일을 기준으로 검색했을 때 사용자가 없으면 사용자를 생성하도록 했다.

처음 작성한 코드는 아래와 같다.

```java
@Override
public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

    // ...코드 생략...

    String email = attributes.getEmail();
    Member member = memberRepository.findByEmail(email)
           .orElse(createMember(email));

    return new CustomUserDetails(
            member, oAuth2User.getAttributes()
    );
}

private Member createMember(String email) {
    Member member = Member.builder()
            .email(email)
            .role(Role.USER)
            .build();
    return memberRepository.save(member);
}
```

하지만, [OAuth 로그인 → 로그인 성공 → 동일한 계정으로 다시 OAuth 로그인] 과정을 거쳐 동일한 계정으로 로그인을 2번했는데, 동일한 email 을 가진 사용자가 2개 생성되는 현상이 있었다.

원인은 `orElse` 의 메서드로 넘긴 `createMember()` 메서드가 `findByEmail()` 메서드가 반환하는 Opitonal 객체의 값이 null 이든 아니든 실행되었기 때문이다.

따라서 `orElse` 대신 `orElseGet` 으로 변경해서 문제를 해결했다.

```java
memberRepository.findByEmail(email)
                .orElseGet(() -> createMember(email));
```

# 참고자료

- [orElse 와 orElseGet 무슨 차이가 있을까?](https://ysjune.github.io/posts/java/orelsenorelseget/) [github.io]
- [Optional의 orElse, orElseGet, orElseThrow 사용법](https://stir.tistory.com/140)[티스토리]
- [Optional 클래스의 orElse와 orElseGet에 대한 정리](https://zgundam.tistory.com/174) [티스토리]
- [[Java/자바] - Supplier interface](https://m.blog.naver.com/zzang9ha/222087025042) [네이버 블로그]