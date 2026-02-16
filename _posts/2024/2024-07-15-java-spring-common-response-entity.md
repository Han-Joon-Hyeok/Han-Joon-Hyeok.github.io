---
title: "[Spring] 공통 Response 클래스 구현"
date: 2024-07-15 15:05:00 +0900
categories: [java, spring]
tags: []
---
# 작업 환경

- OS: MacOS
- Java: 17.0.6
- Spring Boot: 3.2.3
- Gradle: 8.5

# 개요

백엔드에서 프론트엔드로 response 를 보내줄 때 공통된 형식으로 보내주고 싶었다.

예를 들어, 닉네임을 변경하는 API `POST /member` 는 기존에 아래와 같은 데이터를 response body 에 담아 응답했다.

```json
{
  "nickname": "habitpay"
}
```

프론트엔드 화면에서는 status code 가 200 OK 라면 `닉네임이 변경되었습니다.` 와 같이 알림 메세지를 표시해줄 수도 있었지만, API 처리 결과에 대해서는 백엔드에서 보내주고 싶었다.

현재 개발 중인 서비스는 웹 브라우저에서 접속하는 것만 전제로 했지만, MVP 출시 이후에는 모바일 앱 개발도 고려하고 있다.

만약, 모바일 앱에서도 status code 에 따라 모바일 앱 환경 자체적으로 메세지를 표시한다면 동일한 API 요청에 대해 웹과 모바일에서 표시하는 메세지가 다를 것이고, 사용자 경험이 일관적이지 않은 문제를 해결하고 싶었다.

API 개수가 적다면 상관없지만, 애플리케이션이 복잡해져서 API 개수가 늘어난다면 백엔드에서 공통된 메세지를 보내주는 것이 사용자 경험 뿐만 아니라 개발 경험 측면에서도 좋을 것이라는 판단을 했다.

따라서 아래와 같은 형식으로 응답을 보내고자 했다.

```json
{
  "message": "닉네임이 변경되었습니다.",
  "data": {
    "nickname": "habitpay"
  }
}
```

`message` 속성은 request 에 대한 결과를 사람이 읽을 수 있는 문자열로 담아서 보내기 위한 속성이다.

`data` 속성에는 컨트롤러에서 실질적으로 반환하는 값이 들어간다. 즉, DTO 가 담기는 속성이다.

## AS-IS

기존의 컨트롤러는 `ResponseEntity` 객체에 DTO 를 감싸서 보냈다.

```java
// member/api/MemberApi.java

@PostMapping("/member")
public ResponseEntity<MemberCreationResponse> activateMember(
        @RequestBody MemberCreationRequest memberCreationRequest,
        @AuthenticationPrincipal CustomUserDetails user) {
    memberCreationService.activate(memberCreationRequest, user.getId());
    MemberCreationResponse memberCreationResponse = MemberCreationResponse.builder()
            .nickname(memberCreationRequest.getNickname())
            .build();
    return ResponseEntity.ok(memberCreationResponse);
}
```

## TO-BE

공통 응답 클래스인 `SuccessResponse` 객체에 DTO 를 감싸서 보낼 것이다.

```java
// member/api/MemberApi.java

@PostMapping("/member")
public SuccessResponse<MemberCreationResponse> activateMember(
        @RequestBody MemberCreationRequest memberCreationRequest,
        @AuthenticationPrincipal CustomUserDetails user) {
   return memberActivationService.activate(memberActivationRequest, user.getId());
}
```

# 공통 response 클래스 생성

## 디렉토리 구조

공통 resonse 를 구성하기 위해 아래와 `global` 패키지 하위에 `response` 패키지를 생성했다.

```bash
src/main/java/com/habitpay/habitpay/
├── HabitpayApplication.java
├── domain
│   └── member
└── global
    └── response
```

## SuccessResponse

컨트롤러에서 예외가 발생하지 않은 정상 응답은 모두 `SuccessResponse` 객체에 감싸서 보낼 것이다.

```java
// global/response/SuccessResponse.java

@Getter
@Builder
public class SuccessResponse<T> {
    private final String message;
    private final T data;

    public static <T> SuccessResponse<T> of(String message, T data) {
        return SuccessResponse.<T>builder()
                .message(message)
                .data(data)
                .build();
    }
}
```

멤버 변수로 String `message` 와 제네릭 타입의 `data` 를 생성했다.

제네릭이 아닌 Object 타입을 이용할 수도 있지만, 컴파일 타임에 오류를 발견해서 런타임 에러를 방지하고자 했다.

만약, Object 타입으로 작성한다면 아래와 같이 작성할 수 있다.

```java
@Getter
@Builder
public class SuccessResponse {
    private final String message;
    private final Object data;

    public static SuccessResponse of(String message, Object data) {
        return SuccessResponse.builder()
                .message(message)
                .data(data)
                .build();
    }
}
```

정적 팩토리 메서드 `of` 는 builder 를 통해 직접 생성자를 호출하지 않아도 객체를 생성할 수 있도록 했다.

```java
public static <T> SuccessResponse<T> of(String message, T data) {
    return SuccessResponse.<T>builder()
            .message(message)
            .data(data)
            .build();
}
```

# 컨트롤러 적용

## Response DTO

`SuccessResponse` 에 감싸서 보낼 DTO 는 아래와 같이 구성했다.

```java
@Getter
@Builder
public class MemberActivationResponse {
    private String nickname;

    public static MemberActivationResponse from(Member member) {
        return MemberActivationResponse.builder()
                .nickname(member.getNickname())
                .build();
    }
}
```

## 컨트롤러

```java
// member/api/MemberApi.java

@PostMapping("/member")
public SuccessResponse<MemberActivationResponse> activateMember(
        @RequestBody MemberActivationRequest memberActivationRequest,
        @AuthenticationPrincipal CustomUserDetails user) {
    return memberActivationService.activate(memberActivationRequest, user.getId());
}
```

컨트롤러의 반환 타입에 `SuccessResponse<DTO>` 와 같이 작성한다.

## 서비스

```java
// member/service/MemberActivationService.java

public SuccessResponse<MemberActivationResponse> activate(MemberActivationRequest memberActivationRequest, Long id) {
    Member member = memberRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자 입니다."));

    ...

    return SuccessResponse.of(
            "닉네임 변경이 완료되었습니다.",
            MemberActivationResponse.from(member));
}
```

서비스에서는 DTO 를 `SuccessResponse` 로 감싸서 반환하도록 했다.

# 결과

실제로는 닉네임 이외에도 다른 정보를  `data` 객체에 담아서 보냈는데, 원하는 형식으로 만들어서 프론트엔드에 보낼 수 있었다.

![1.png](/assets/images/2024/2024-07-15-java-spring-common-response-entity/1.png)

# 회고

## 상황에 맞게 적용하기

처음에는 Google JSON Style Guide 에 정의된 형식을 참고해서 아래와 같이 만들고자 했다.

- 참고자료:  [Google JSON Style Guide](https://google.github.io/styleguide/jsoncstyleguide.xml) [google style guide]

```json
{
  "message": "message",
  "data": {
    "items": [
    {
      "title": "1"
    },
    {
      "title": "2"
    }
    ]
  }
}
```

하지만 `items` 속성까지 정의해서 만들기에는 너무 복잡해서 최대한 단순한 형태로 만들었다.

Google Style Guide 에 따르면 `data` 하위 속성으로 여러 속성을 포함할 수 있는데, 현재 프로젝트에서는 여러 속성을 포함해서 보낼 정도로 복잡하지 않았기에 단순한 형태를 선택했다.

좋아보이는 것을 무작정 따라하기보다 현재 상황에 맞춰 유연하게 적용하고, 나중에 복잡해지면 구조를 바꾸는 것이 나은 것 같다.

## 다른 선택지도 고려하기

공통 response 를 만들기 위해 `RestControllerAdvice` 어노테이션을 사용하는 것도 고려했고, 실제로 코드로 구현까지 했었다.

```java
@RestControllerAdvice
public class SuccessResponseAdvice implements ResponseBodyAdvice<Object> {

    @Override
    public boolean supports(MethodParameter returnType, Class converterType) {
        return isNotVoidType(returnType);
    }

    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {

        HttpServletResponse servletResponse = ((ServletServerHttpResponse) response).getServletResponse();

        int status = servletResponse.getStatus();
        HttpStatus resolve = HttpStatus.resolve(status);

        if (resolve == null) {
            return body;
        }

        if (resolve.is2xxSuccessful()) {
            return new SuccessResponse(body);
        }

        return body;
    }

    private boolean isNotVoidType(MethodParameter returnType) {
        Class<?> parameterType = returnType.getParameterType();
        return !Void.TYPE.equals(parameterType);
    }
}
```

하지만 이 방법을 이용한다면 아래와 같이 DTO 에서 message 를 직접 입력해주어야 했다.

```java
// member/service/MemberActivationService.java

public MemberActivationResponse activate(MemberActivationRequest memberActivationRequest, Long id) {
    Member member = memberRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 사용자 입니다."));

    ...

    return MemberActivationResponse.of("닉네임 변경이 완료되었습니다.", member));
}
```

그러면 response body 는 아래와 같은 구조가 되었다.

```json
{
  "data": {
    "message": "닉네임 변경이 완료되었습니다.",
    "nickname": "habitpay"
  }
}
```

`message` 속성은 `data` 속성과 같은 레벨에 두어 API 처리 결과로 생성된 데이터와 프론트엔드 화면에 보여줄 메세지를 분리하고 싶은 목적에 부합하지 않아서 사용하지 않았다.

그리고 `RestControllerAdvice` 는 모든 response 를 감싸기 위해 사용할 수도 있지만, 공식문서([링크](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ControllerAdvice.html))에 따르면 예외처리를 목적으로 만들어진 것을 알 수 있다.

> Specialization of [`@Component`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html) for classes that declare [`@ExceptionHandler`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ExceptionHandler.html), [`@InitBinder`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/InitBinder.html), or [`@ModelAttribute`](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ModelAttribute.html) methods to be shared across multiple `@Controller` classes.
>

```java
@Target(TYPE)
@Retention(RUNTIME)
@Documented
@ControllerAdvice
@ResponseBody
public @interface RestControllerAdvice
```

`RestControllerAdvice` 는 `ControllerAdvice` 를 확장해서 만든 어노테이션인데, `ControllerAdvice` 는 `ExceptionHandler` 어노테이션과 함께 사용하기 위해 특화된 어노테이션이다.

```java
@ControllerAdvice
public class ExceptionHandlers {

    @ExceptionHandler(FileNotFoundException.class)
    public ResponseEntity handleFileException() {
        return new ResponseEntity(HttpStatus.BAD_REQUEST);
    }
}
```

위와 같이 `ControllerAdvice` 어노테이션을 클래스에 작성하면 `ExceptionHandler` 어노테이션이 있는 메서드는 response body 가 생성된다.

# 참고자료

- [스프링 API 공통 응답 포맷 개발하기](https://velog.io/@qotndus43/%EC%8A%A4%ED%94%84%EB%A7%81-API-%EA%B3%B5%ED%86%B5-%EC%9D%91%EB%8B%B5-%ED%8F%AC%EB%A7%B7-%EA%B0%9C%EB%B0%9C%ED%95%98%EA%B8%B0) [velog]