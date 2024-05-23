---
title: "[Java Spring] is 로 시작하는 변수의 이름이 json 객체에서 is 가 사라지는 문제"
date: 2024-05-23 15:45:00 +0900
categories: [Java, Spring]
tags: []
---

# 실행 환경

- OS: MacOS Sonoma 14.5
- Java: 17
- Spring Boot: 3.2.3

# 문제 상황

백엔드에서 프론트로 json 객체를 보내주기 위한 DTO 클래스를 생성했다.

이 클래스의 변수로 주최자인지 확인하는 `isHost` 변수를 아래와 같이 생성했으나, 프론트에서는 `host` 라는 변수로 전달되는 문제가 있었다.

```java
@Getter
public class ChallengeResponse {
	...
	private Long    id;
	private Boolean isHost;
	...
}
```

프론트에서는 아래와 같이 `isHost` 가 아닌 `host` 라고 표시되었다.

```json
{
  ...
  "id": 1
  "host": true
  ...
}
```

# 문제 원인

원인은 lombok 의 getter 와 json 을 직렬화 및 역직렬화하는 jackson 라이브러리에 있었다.

### lombok 라이브러리의 getter 및 setter 생성 원리

lombok 은 getter 를 만들 때 `getFoo()` 와 같이 접두사로 get 을 사용한다.

하지만 boolean 자료형의 getter 는 `isHost()` 와 같이 접두사로 is 를 사용한다.

lombok 공식 문서를 살펴보면 아래와 같이 나와있다.

> A default getter simply returns the field, and is named `getFoo` if the field is called `foo` (or `isFoo` if the field's type is `boolean`).

- 참고자료: [@Getter and @Setter](https://projectlombok.org/features/GetterSetter) [lombok project]

### jackson 라이브러리의 json 필드명 생성 원리

jackson 라이브러리는 json 객체로 변환하는 직렬화 과정에서 getter 와 setter 를 이용한다.

즉, json 필드의 이름을 결정할 때 getter 와 setter 메서드 이름을 보고 결정한다.

getter 의 메서드 이름에서 get 을 지우고, setter 의 메서드 이름에서 set 을 지운다.

공식 문서에 따르면 아래와 같이 나와있다.

> **How Jackson ObjectMapper Matches JSON Fields to Java Fields**
>
> By default Jackson maps the fields of a JSON object to fields in a Java object by matching the names of the JSON field to the getter and setter methods in the Java object. Jackson removes the "get" and "set" part of the names of the getter and setter methods, and converts the first character of the remaining name to lowercase.

- 참고자료: [Jackson ObjectMapper](https://jenkov.com/tutorials/java-json/jackson-objectmapper.html) [jenkov.com]

### 종합

이를 종합하면 jackson 라이브러리가 json 객체로 변환할 때 boolean 자료형 변수인 `isHost` 의 getter 메서드 이름은 lombok 에 의해 `getIsHost` 가 아닌 `isHost` 으로 만들어졌기 때문에 json 필드 이름으로 `host` 가 생성된 것이다.

# 문제 해결

문제를 해결하기 위해 boolean 대신 Boolean 클래스를 사용했다.

Boolean 은 원시 자료형(primitive data type) boolean 을 감싸는 Wrapper 클래스이다.

Boolean 은 클래스이기 때문에 null 값이 될 수 있다는 점과 boolean 에 비해 메모리를 더 차지한다는 단점이 있다.

하지만 메모리가 얼마나 더 차지하는 지는 실제로 체감하기 어려운 것 같고, null 값이 될 수 있는 상황은 코드 상에서 존재하지 않는다.

아래는 DTO 를 생성하기 위한 클래스의 코드이다.

```java
@Getter
public class ChallengeResponse {
    ...
    private Boolean isHost;

    public ChallengeResponse(Member host, Challenge challenge) {
        ...
        this.isHost = challenge.getHost().getEmail().equals(host.getEmail());
    }
}
```

생성자에서 `isHost` 의 값은 `equals()` 함수로 결정하는데, 이 함수의 반환 자료형은 원시 자료형인 boolean 이기 때문에 반드시 true 또는 false 로 설정된다.

그렇기에 null 값이 발생할 가능성은 없다.

# 참고자료

- [Boolean에 is 붙이지 마세요!](https://medium.com/@baejae/boolean%EC%97%90-is-%EB%B6%99%EC%9D%B4%EC%A7%80-%EB%A7%88%EC%84%B8%EC%9A%94-7b717246d942) [medium]
- [[Spring] Response json에서 boolean의 is가 생략되는 문제](https://gimquokka.github.io/spring/Spring_Jackson_is_%EC%83%9D%EB%9E%B5%EB%AC%B8%EC%A0%9C/) [github.io]
- [Jackson renames primitive boolean field by removing 'is'](https://stackoverflow.com/questions/32270422/jackson-renames-primitive-boolean-field-by-removing-is) [stackoverflow]
- [Jackson 라이브러리의 직렬화/역직렬화](https://joon2974.tistory.com/25) [티스토리]
