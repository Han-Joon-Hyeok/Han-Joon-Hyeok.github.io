---
title: "application/x-www-form-urlencoded 와 multipart/form-data 차이"
date: 2024-03-27 21:40:00 +0900
categories: [Web]
tags: []
---

# 개요

사용자가 업로드한 사진을 서버에 저장하려고 한다.

프론트에서 <form> 태그를 이용해서 POST 메서드로 서버에 데이터를 전송할 때 Request 의 header 의 Content-type 으로 x-www-form-urlencoded 또는 multipart/form-data 를 선택할 수 있다.

결론부터 말하자면 서버로 사진을 보내기 위해서는 multipart/form-data 를 이용해야 한다.

2가지의 차이를 알아보자.

# application/x-www-form-urlencoded

POST 메서드를 선택하면 기본값으로 설정되는 값이다.

아래와 같은 html 코드가 있다고 해보자.

```html
<form action="/submit" method="post">
  <input type="text" id="username" name="username" value="john" />
  <input type="password" id="password" name="password" value="123456" />
  <input type="submit" value="Submit" />
</form>
```

클라이언트가 서버로 보내는 request 는 아래와 같다.

```
POST /test HTTP/1.1
Host: foo.example
Content-Type: application/x-www-form-urlencoded
Content-Length: 29

username=john&password=123456
```

`키=값` 로 이루어진 튜플 형태로 request body 에 담기며, 튜플은 `&` 연산자로 구분된다.

여기서는 username 과 password 가 키, john 과 123456 이 값에 해당한다.

또한, URL 인코딩 처리 되는 것이 특징이다.

URL 인코딩이란 URL 에 포함된 숫자나 알파벳이 아닌 특수문자, 한글 등이 입력되었을 때 정해진 규칙에 따라 안전하게 변환해서 전송하는 방법이다.

규칙은 아래와 같다.

1. 스페이스는 + 로 인코딩 된다.
2. 영문자나 숫자가 아닌 문자는 % 와 두 개의 16진수 숫자로 인코딩 된다.

사용자가 입력한 값에 공백이 들어간다면 아래와 같이 + 가 추가될 것이다.

```
POST /test HTTP/1.1
Host: foo.example
Content-Type: application/x-www-form-urlencoded
Content-Length: 33

username=john+doe&password=123456
```

참고로 공백은 + 또는 %20 으로 인코딩 되는데, application/x-www-form-urlencoded 에서는 + 로 변환하고, URL 쿼리 스트링에는 %20 으로 변환한다.

예를 들어, `https://example.com/search?q=my search` 라는 URL 은 로 처리해서 `https://example.com/search?q=my%20search` 으로 변환된다.

URL 인코딩의 목적은 클라이언트와 서버가 문자열의 원래 형태를 잃지 않고 데이터를 정확하게 처리하기 위해서 사용한다.

문자열이 인코딩 되지 않으면 브라우저가 사용하는 Fragment Identifier 라는 예약된 문자와 충돌이 생기기 때문에 정확한 데이터 처리가 어려울 수 있다.

Fragment Identifier 란 브라우저에서 웹 페이지 내에서 특정 위치나 섹션을 가리키기 위해 사용하는 `#` 을 의미하며, `#` 이후의 문자열은 서버로는 전송되지 않는다.

예를 들어, 아래의 URL 이 있다고 해보자.

```
https://en.wikipedia.org/wiki/Coffee
```

History 라는 섹션으로 이동하면 브라우저에는 아래와 같이 마지막에 `#History` 가 붙는다.

```
https://en.wikipedia.org/wiki/Coffee#History
```

URL 인코딩이 이루어지지 않으면 어떤 일이 생기는 지 살펴보자.

구글에서 `C# Programming` 을 검색하면 아래와 같이 URL 이 생성될 것이다.

```
https://www.google.com/search?q=C# Programming
```

하지만 방금 살펴본 Fragment Identifier 에 의해 # 이후 문자는 무시하고 `C` 만 서버로 전송해서 `C` 를 검색한 결과를 보여주게 될 것이다.

따라서 정확한 데이터를 서버로 전송하고, 이를 서버가 인식하기 위해 URL 인코딩을 사용한다.

URL 인코딩을 사용하면 아래와 같이 # 은 %23 으로, 공백은 %20 으로 변환된다.

```
https://www.google.com/search?q=C%23%20Programming
```

이 방식은 간단한 텍스트를 전송하기에 적합하지만, 사진과 같은 이진 데이터를 전송하기에는 적합하지 않다.

이진 데이터에는 특수 문자도 포함되어 있는데, 특수 문자를 URL 인코딩 처리해서 보내면 원래 보내려던 것보다 훨씬 더 많은 문자가 포함되기 때문에 용량이 커지는 문제가 있다.

그래서 사용하는 것이 multipart/form-data 이다.

# multipart/form-data

이 유형은 form 태그 안에서 텍스트 뿐만 아니라 파일을 함께 전송할 때 사용한다.

form 태그에서 enctype 속성을 multipart/form-data 로 설정하면 사용할 수 있다.

```html
<form action="/submit" method="post" enctype="multipart/form-data">
  <input type="text" id="username" name="username" value="john" />
  <input type="file" id="photo" name="photo" accept="image/png" />
  <input type="submit" value="Submit" />
</form>
```

사용자가 username 을 입력하고 사진을 업로드 해서 서버로 전송하면 request 는 아래와 같다.

```
POST /submit HTTP/1.1
Host: example.com
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="username"

john
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="photo"; filename="example.png"
Content-Type: image/png

[Binary image data here]
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

request header 에는 Content-Type 이 multipart/form-data 로 설정되며, 세미콜론(;) 이후에는 form 태그의 input 들을 구분해주기 위한 경계(boundary)인 ----WebKitFormBoundary7MA4YWxkTrZu0gW 가 추가되었다.

맨 마지막 boundary 의 끝에 대시(-)가 2개 붙는 이유는 request body 의 마지막임을 알려주기 위해 사용한다.

multipart/form-data 를 이용하면 다양한 종류의 데이터를 한 번에 서버로 보낼 수 있다는 장점이 있다.

# 참고자료

- [Percent-encoding](https://en.wikipedia.org/wiki/Percent-encoding) [위키피디아]
- [x-www-form-urlencoded와 application/json의 차이 (HTTP Content-Type)](https://velog.io/@483759/x-www-form-urlencoded%EC%99%80-applicationjson%EC%9D%98-%EC%B0%A8%EC%9D%B4-HTTP-Content-Type) [velog]
- [POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST) [mdn]
- [URL Encoding 이란?](https://xpmxf4.tistory.com/15) [티스토리]
- [HTTP multipart/form-data 이해하기](https://lena-chamna.netlify.app/post/http_multipart_form-data/) [lena-chamna]
