---
title: "[Spring] DTO 입력 값 검증하기 (Bean Validation 활용)"
date: 2024-12-29 18:10:00 +0900
categories: [Java, Spring]
tags: []
---

# 개요

컨트롤러에서 DTO를 통해 전달받는 클라이언트의 요청의 입력 값에 제약 조건을 설정하기 위해 Spring Bean Validation을 활용하는 방법을 정리했습니다.

# 도입 배경

프론트엔드에서 작성된 게시물 본문의 길이는 최대 1,000자까지만 제한하는 규칙을 정했습니다. 이를 처리하기 위해 백엔드에서 아래와 같은 DTO를 통해 요청을 받습니다.

```java
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class AddPostRequest {
  private String content;
}
```

컨트롤러는 아래와 같습니다.

```java
@PostMapping("/challenges/{id}/posts")
public SuccessResponse<List<String>> createPost(
  @RequestBody AddPostRequest request,
  @PathVariable("id") Long id,
  @AuthenticationPrincipal CustomUserDetails user) {
  return challengePostCreationService.createPost(request, id, user.getMember());
}
```

문자열 길이 검증 로직을 서비스 계층에 추가할 수도 있지만, 컨트롤러에서 미리 검증하는 방식을 채택했습니다. 컨트롤러에서 입력 값에 대한 제약 조건(길이, 값의 크기, 문자열 형식 등)을 검사하고, 서비스에서는 DB에서 조회한 데이터와 비교하는 것과 같은 비즈니스 로직을 담당하여 계층 별로 역할을 나눔으로써 검증 위치를 쉽게 파악하고자 했습니다.

# 적용 방법

## 1. 의존성 추가

의존성 관리 파일(`build.gradle`)에 Bean Validation 관련 의존성을 추가합니다.

```groovy
dependencies {
  implementation 'org.springframework.boot:spring-boot-starter-validation'
}
```

## 2. 어노테이션 추가

### DTO

DTO 클래스에 검증용 어노테이션을 추가합니다.

```java
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddPostRequest {
  @Size(max = 1000, message = "본문 길이는 최대 {max}자 입니다.") // @Size 어노테이션 추가
  private String content;
}
```

문자열 길이를 제한하기 위해 `@Size` 어노테이션을 사용합니다. 또한, `message` 속성을 통해 입력 값이 1,000자를 초과할 경우 클라이언트에 전달할 메시지를 정의할 수 있습니다. `{max}` 는 `max` 속성 값을 문자열에 대입하며, 위의 코드에서는 “본문 길이는 최대 1000자 입니다.”라는 문자열을 생성합니다.

공식 문서에서 `@Size` 어노테이션은 문자열에 대한 검증을 담당한다고 나와있습니다.

> public @interface Size
>
> The annotated element size must be between the specified boundaries (included).
>
> Supported types are:
>
> - `CharSequence` (length of character sequence is evaluated)
> - `Collection` (collection size is evaluated)
> - `Map` (map size is evaluated)

참고로, `@Max` 와 `@Min` 어노테이션은 숫자 데이터의 크기를 검증하는 데 사용됩니다.

> public @interface Min
>
> The annotated element must be a number whose value must be higher or equal to the specified minimum.
>
> Supported types are:
>
> - `BigDecimal`
> - `BigInteger`
> - `byte`, `short`, `int`, `long`, and their respective wrappers

### Controller

컨트롤러 매개변수에 `@Valid` 어노테이션을 추가합니다.

```java
@PostMapping("/challenges/{id}/posts")
public SuccessResponse<List<String>> createPost(
  @Valid @RequestBody AddPostRequest request, // @Valid 어노테이션 추가
  @PathVariable("id") Long id,
  @AuthenticationPrincipal CustomUserDetails user) {
  return challengePostCreationService.createPost(request, id, user.getMember());
}
```

## 3. Exception Handler 추가 (선택)

오류가 발생한 경우 클라이언트에게 `ErrorResponse` 라는 클래스를 생성하여 응답하고 있습니다.

```java
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ErrorResponse {
  private String code;
  private String message;
}
```

클라이언트는 아래와 같은 JSON 형식으로 응답을 받습니다.

```json
{
  "code": "BAD_REQUEST",
  "message": "본문 길이는 최대 1000자 입니다."
}
```

Bean Validation은 제약 조건을 위반한 경우 `MethodArgumentNotValidException` 예외를 발생시킵니다. 따라서 `@RestControllerAdvice` 어노테이션을 적용한 Handler 클래스에 아래와 같이 작성했습니다.

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleMethodArgumentNotValidException(
        MethodArgumentNotValidException ex) {
        final ErrorResponse response = ErrorResponse.of("BAD_REQUEST",
            ex.getBindingResult().getAllErrors().get(0).getDefaultMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
}
```

## 4. 테스트 코드 작성 (선택)

프로젝트에서 Spring REST Docs를 사용하고 있으므로, 아래와 같은 방식으로 테스트 코드를 작성했습니다.

```java
@Test
@WithMockOAuth2User
@DisplayName("챌린지 게시물 생성 - 게시물 길이 초과 (400 Bad Request)")
void challengePostCreationContentLengthTooLongException() throws Exception {

    // given
    AddPostRequest invalidRequest = AddPostRequest.builder()
        .content("A".repeat(1001)) // 본문 길이 초과
        .build();

    // when
    ResultActions result = mockMvc.perform(post("/api/challenges/{id}/posts", 1L)
        .header(HttpHeaders.AUTHORIZATION, AUTHORIZATION_HEADER_PREFIX + "ACCESS_TOKEN")
        .content(objectMapper.writeValueAsString(invalidRequest))
        .contentType(MediaType.APPLICATION_JSON));

    // then
    result.andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.message").value("본문 길이는 최대 1000자 입니다."))
        .andDo(document("challenge/challenge-post-creation-content-length-too-long-exception",
            requestHeaders(
                headerWithName(HttpHeaders.AUTHORIZATION).description("액세스 토큰")
            ),
            responseFields(
                fieldWithPath("code").description("오류 응답 코드"),
                fieldWithPath("message").description("오류 메세지")
            )
        ));
}
```

# 참고자료

- [[Spring Boot] DTO에서 Validation 처리하기](https://velog.io/@joeun-01/Spring-Boot-DTO에서-Validation-처리하기) [velog]
- [Spring Boot에서 DTO 검증하기](https://tecoble.techcourse.co.kr/post/2020-09-20-validation-in-spring-boot/) [Techoble]
- [[Spring Boot] Validation @Max 와 @Size의 차이](https://readinggeneral.tistory.com/entry/Spring-Boot-Validation-Max-%EC%99%80-Size%EC%9D%98-%EC%B0%A8%EC%9D%B4) [티스토리]
- [[Spring] Bean validation 응답 메시지 커스텀 하기 (ResponseEntityExceptionHandler)](https://velog.io/@dhk22/Spring-Bean-validation-응답-메시지-커스텀-하기-ResponseEntityExceptionHandler) [velog]
- [Jakarta Bean Validation API](https://jakarta.ee/specifications/bean-validation/3.0/apidocs/)
