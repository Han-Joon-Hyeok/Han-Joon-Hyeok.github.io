---
title: "[Java Spring] path variable 사용 시 Security 설정 확인 사항"
date: 2024-05-21 22:50:00 +0900
categories: [java, spring]
tags: []
---

# 실행 환경

- OS: MacOS Sonoma 14.5
- Java: 17
- Spring Boot: 3.2.3

# 문제 상황

데이터를 조회하기 위해 컨트롤러에 아래와 같이 path variable 를 사용했다.

```java
@GetMapping("/challenge/{id}")
@ResponseStatus(HttpStatus.OK)
public ResponseEntity<?> getChallenge(@PathVariable("id") Long id) {
    log.info("[GET /challenge] id: {}", id);
    return ResponseEntity.status(HttpStatus.OK).body("hello");
}
```

컨트롤러가 작동하는지 확인하기 위해 `http://localhost:8080/challenge/1` 로 요청을 보냈다.

하지만 Google OAuth 로그인 페이지로 리다이렉트 되었다.

현재 진행하고 있는 프로젝트에서는 Spring Security 를 이용해서 Google OAuth 로그인을 구현했는데, Spring Security 에서 발생한 문제였다.

# 문제 원인

filterChain 의 인가를 담당하는 부분에서 `requestMatchers` 의 인자로 `/*` 였던 것이 문제였다.

```java
@Bean
SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http.cors(corsConfigurer -> corsConfigurer.configurationSource(corsConfigurationSource()))
            .csrf((csrf) -> csrf.disable())
            .headers((headerConfig) ->
                    headerConfig.frameOptions(frameOptionsConfig ->
                            frameOptionsConfig.disable()))
            .sessionManagement((session) -> session
                    .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests((authorizeRequests ->
                    authorizeRequests
                            .requestMatchers("/*").permitAll() // "/*" 가 문제가 된 원인
                            .anyRequest().authenticated()
            ))
            ...
}
```

와일드카드 문자나 문자열 리터럴 이용해서 파일의 경로를 표현하는 것을 glob(globals pattern)이라 한다.

와일드카드 문자 하나(`*`)는 `http://localhost:8080/challenge` 를 정상적으로 받아들이지만, `http://localhost:8080/challenge/1` 이나 `http://localhost:8080/challenge/abc/1` 는 받아들이지 못한다.

# 문제 해결

모든 경로에 대해서 허용하기 위해서는 와일드카드 두 개(`**`)를 사용해야 한다.

```java
@Bean
SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http.cors(corsConfigurer -> corsConfigurer.configurationSource(corsConfigurationSource()))
            .csrf((csrf) -> csrf.disable())
            .headers((headerConfig) ->
                    headerConfig.frameOptions(frameOptionsConfig ->
                            frameOptionsConfig.disable()))
            .sessionManagement((session) -> session
                    .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests((authorizeRequests ->
                    authorizeRequests
                            .requestMatchers("/**").permitAll() // "/**" 로 수정
                            .anyRequest().authenticated()
            ))
            ...
}
```

# 참고자료

- [What does the double-asterisk (\*\*) wildcard mean?](https://stackoverflow.com/questions/28176590/what-does-the-double-asterisk-wildcard-mean) [stackoverflow]
- [Glob 이란 무엇일까?](https://jake-seo-dev.tistory.com/128) [티스토리]
