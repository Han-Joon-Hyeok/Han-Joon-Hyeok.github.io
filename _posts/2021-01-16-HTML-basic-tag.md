---
title: HTML 기초 태그 정리
date: 2021-01-16 09:00:00 +0900
categories: [html]
tags: [html]
---

> [생활코딩 - HTML](https://opentutorials.org/course/2039)을 공부하며 정리한 내용입니다.

# HTML 문법

본 포스팅에서는 HTML 태그에 대해 전부 설명하지 않았습니다.
복습을 하면서 필요한 내용만 기록해놓았으므로, 이 점 참고하셔서 읽어주시면 감사하겠습니다.

## `<a>`태그

a태그는 `anchor(닻)`의 맨 앞글자인 a를 의미한다. 즉, 특정 URL에 연결되어 있다는 것으로 해석할 수 있다.

`<a href="연결할 링크" target="_속성값" title="hover시 표시되는 문구">`

속성들의 순서는 전혀 상관없다. 

- target : 링크된 문서를 클릭했을 때, 문서가 열릴 위치를 명시해준다.
  |속성값|설명|
  |--|--|
  |_blank|링크된 문서를 새로운 윈도우나 탭에서 오픈함.|
  |_self(기본값)|링크된 문서를 링크가 위치한 현재 프레임에서 오픈함. 생략 가능. |
  |_parent|현재 프레임의 부모 프레임에서 오픈.|
  |_top|현재 윈도우 전체에서 오픈.|
  |프레임 이름|명시된 프레임에서 오픈. `<iframe>`과 함께 사용할 수 있지만, 최근에는 보안 문제로 사용하지 않는 것을 권장하고 있음.</iframe>|


## `<p>` 태그

`Paragraph`의 맨 앞 글자인 p를 따서 만든 태그로, 단락을 의미한다. 블록 요소이기 때문에 다음 요소에 대해서는 자동으로 줄 바꿈이 수행되며, `<br>`태그가 2번 들어간 효과와 동일하다.

```HTML
<p>안녕하세요</p>
<p>반갑습니다</p>
<p>또 만나요</p>

<!-- 결과 -->
안녕하세요

반갑습니다

또 만나요
```

## `<br>` 태그

`<br>`은 `A forced line-break`의 줄임말로, 1줄을 강제로 바꾸어버리는 태그이다. 위치에 상관없이 태그 내부, 태그 사이에서 모두 동일하게 적용할 수 있다. 태그를 연속해서 사용할 경우, 사용한 횟수만큼의 줄 간격이 벌어진다.

```HTML
<!-- 태그 사이에서 사용 -->
<a>foo</a><br>
<a>bar</a>

<!--결과-->
foo
bar

<!-- 태그 안에서 사용 -->
<a>foo<br>
bar
</a>

<!--결과-->
foo
bar

<!-- 여러 번 사용 -->
<a>foo</a><br><br><br><br>
<a>bar</a>

<!--결과-->
foo



bar
```
보통 하나의 단락을 표현할 때는 `<p>`태그를 사용하며, `<br>`을 이용한 단락 구분은 잘 사용하지 않는다.

만약 `<p>`태그의 단락 여백이 마음에 들지 않는다면, css의 `margin`이나 `padding` 속성값을 수정해서 조정할 수 있다.

### [참고] display 속성과 margin, padding 속성의 관계

블록 요소는 `margin`, `padding`이 모두 작동하지만, 

인라인 요소는 `margin-left`, `margin-right`는 작동하지만, `margin-top`, `margin-bottom`은 작동하지 않는다. 

![p태그_margin](https://user-images.githubusercontent.com/54902347/105321407-c2a5b480-5c0a-11eb-8f50-72248efaf0fb.png)


만약 인라인 요소에도 적용하고 싶다면, `display`속성을 `block`이나 `inline-block`으로 변경하면 된다.

## `<form>`태그

`<form>`태그는 웹 페이지에서 사용자가 정보를 입력한 정보를 서버로 보낼 수 있는 기능을 수행한다.

``` HTML
<form action="http://localhost/login.php">
   <input type="text" name="id">
   <input type="password" name="pw">
   <input type="text" name="username">
   <input type="submit">
</form>
```

`<form>`태그의 속성으로 `action`은 입력한 정보들을 어떤 링크로 전송할 것인지 결정하는 역할을 한다.

그래서 위의 링크로 전송을 하면 다음과 같은 링크가 만들어진다.

`http://localhost/login.php?id=아이디&pw=1234&username=한준혁`

여기서 `&(앰퍼샌드)`는 각각의 `input`태그들이 가진 `name`속성에 따라 구분하는 기호이고, 입력된 데이터는 `name값=입력값`으로 전송된다. `name` 속성은 서버에서 각각의 `input`태그들을 구분하는 기준이 된다.

추후에 상세히 서술하겠지만, 위와 같이 URL에 정보를 담아 서버에 보내는 것을 `GET` 방식이라고 한다. 이렇게 정보를 보내면 보안에 민감한 개인정보가 주소에 노출된다는 단점이 있다. 

따라서 이를 `POST`방식으로 전송하게 되면, `GET`이 HTTP 패킷의 header에 보내는 것과 달리 정보가 패킷의 body에 담기게 된다. 각각의 방식마다 장단점이 있으므로 상황에 맞게 사용을 하면 된다. `GET`과 `POST`에 대한 자세한 개념은 추후에 작성할 예정이다.

### `<select>` `<option>`태그

`<select>`와 `<option>`태그는 사용자가 값을 선택할 수 있도록 도와주는 태그이다.

``` HTML
<select name="color">
   <option value="red">빨강</option>
   <option value="blue">파랑</option>
   <option value="yellow">노랑</option>
</select>
```
![Select_Option](https://user-images.githubusercontent.com/54902347/105448160-1d95e500-5cb9-11eb-987d-3afbd2c9de2b.png)

콤보박스 형태로 만들어지며, `option`의 `value`속성은 태그 안에 적힌 텍스트 `빨강` 또는 `파랑`이 아닌 서버로 실제로 전달되는 값이다. 태그 사이에 적은 텍스트는 사용자에게 보여지는 텍스트이므로 잘 구분해서 사용해야 한다.

그리고 `<select>`에서 `multiple` 속성을 입력하면, 아래의 사진과 같이 여러 옵션을 선택할 수 있게 된다.

``` HTML
<select name="color" multiple>
   <option value="red">빨강</option>
   <option value="blue">파랑</option>
   <option value="yellow">노랑</option>
</select>
```

![Select_Multiple](https://user-images.githubusercontent.com/54902347/105448381-95640f80-5cb9-11eb-8c15-4c530d0ea8c2.png)

그러면 서버에서는 다음과 같이 2개의 옵션이 포함된 URL을 전달 받는다.

`http://localhost/select.php?color2=red&color2=blue`

### `<input>`태그

`<input>`태그는 사용자의 값을 입력 받는 기능을 수행한다.

- `hidden` 속성 : UI상에는 보이지 않지만, 서버로 전송해야 하는 값이 있을 때 사용한다. 폼 제출 시 사용자가 변경해서는 안 되는 데이터를 보낼 때 사용한다. 
  - 예를 들어, 업데이트 되어야 하는 데이터베이스의 레코드를 저장하거나, 고유한 보안 토큰 등을 서버로 보낼 때 사용할 수 있다.
  - 또 다른 예시로, 이전 요청처리에 대한 값을 다음 요청에서도 연속성을 갖기 위해 사용하며, 이는 세션으로 대체할 수 있다.
  ``` HTML
  <form action="hide.php">
      <input type="text" name="id">
      <input type="hidden" name="hide" value="I'm hide">
      <input type="submit">
  </form>
  ```
  위와 같이 입력하면 URL은 다음과 같이 완성된다.
  `http://localhost/hide.php?id=?hide="I'm hide"`

- 파일 업로드 : 다음과 같이 작성하면 파일 업로드 할 수 있는 input 태그가 만들어진다.

   ```HTML

   <form action="http://localhost/upload.php" method="post" enctype="multipart/form-data">
      <input type="file" name="profile">
      <input type="submit">
   </form>
   ```

   이때, 반드시 `<form>`태그의 `method`는 `post`, `enctype`은 `multipart/form-data`로 설정해야 한다.
   
   그리고 `<input>`태그에는 `name`속성이 설정되어 있어야 서버에서 정상적으로 처리가 가능하다.

### 새로운 제출양식들

HTML5에서부터 제출양식(form 태그)에서 사용할 수 있는 다양한 제출양식과 속성들이 추가되었다. 
#### `<input>` 태그

##### type

`type`에 새로운 값들을 입력받을 수 있게 되었다. 해당 타입들은 다음과 같다.

- color
- date
- month
- week
- time
- datetime
- datetime-local
- email
- number
- range
- search
- tel
- url

해당 속성들의 사용법은 필요할 때마다 검색해서 사용해보도록 하자.

##### 속성

- `autocomplete="on/off"` : form 태그 내부의 input 태그들이 갖는 자동완성기능을 설정하는 속성이다. 필요한  input 태그만 지정해서 사용할 수도 있다.
- `placeholder="사용자에게 보여질 텍스트"` : input 태그가 아무것도 입력되지 않았을 때, 사용자에게 보여지는 텍스트이다.
- `autofocus` : 페이지에 접속하면 특정 input 태그로 자동으로 포커싱이 맞춰지는 기능이다.
- `required` : 사용자가 반드시 입력을 해야 하는 항목을 설정할 수 있다.
- `pattern="정규식"` : 사용자가 지정한 정규식에 맞도록 입력했는 지 확인할 수 있다. 정규식에 대한 자세한 내용은 추후에 다룰 예정이다.

#### `<label>`태그

`<label>` 태그는 `<input>` 태그에 대한 설명을 붙여줄 때 사용하는데, `<label>`태그 안에 있는 텍스트를 클릭해도 `<input>` 태그에 마우스 포커싱이 옮겨지는 효과를 구현할 수 있어서 사용자의 편리성을 높일 수 있다.

```HTML
<form action="">
   <p>
      <label for="id_txt">ID : </label>
      <input id="id_txt" type="text" name="id">
   </p>
   <p>
      <label for="PW">PW : 
         <input id="PW" type="password" name="pwd">
      </label>
   </p>
   <p>
</form>
```
`<label>`과 `<input>`을 연결하기 위해서 전자에는 `for`속성값을, 후자에는 `id`속성값을 주면 된다.

만약 `<label>` 태그 안에 `<input>` 태그를 담는다면, 똑같은 효과를 내면서도 조금 더 간편하게 구현할 수 있다.

```HTML
<!-- label에 id 속성을 주지 않고도 똑같은 효과를 내는 방법 -->
<p>
   <label>
         <input type="checkbox" name="red"> 빨간색
   </label>
</p>
<p>
   <label>
         <input type="checkbox" name="blue">파란색
   </label>
</p>
```

#### GET과 POST 방식의 차이

`<form>` 태그에서 절대 빠질 수 없는 것이 GET과 POST 방식의 차이이다. 이에 대한 자세한 설명은 다른 문서에서 자세히 다루었다.

- [GET과 POST 방식의 차이](/_posts/2021-01-17-Comparison-of-GET-POST.md)


## `<iframe>` 태그

`<iframe>` 태그는 웹 페이지 안에 다른 웹 페이지를 삽입하는 태그이다. HTML4에서 등장하여 과거에는 많이 사용되었으나, iframe을 이용한 **해킹이나 정보 유출과 같은 보안 상의 문제**로 이제는 사용을 권장하지 않고 있다. 

iframe를 통해 불러오는 `HTML`, `CSS` 자체는 위험하지 않지만, `Javascript`나 `<form>`태그를 통해서 사용자가 의도하지 않은 행동을 유도할 수 있게 된다.

따라서 최신 버전인 HTML5에서는 자바스크립트의 실행과 폼 태그의 작동을 방지하기 위해서 `sandbox`라는 속성을 추가했다. 

```HTML
<iframe src="iframe_source.html" sandbox>
```

## `<video>` 태그

이미지를 삽입하는 것처럼 비디오 또한 삽입을 할 수 있도록 해주는 태그이다. 

![html video tag(1)](images/html_video_tag(1).png)

```HTML
<video width="400" controls autoplay>
   <source src="example.mp4">
   <source src="example.ogv">
</video>
```

비디오는 웹 브라우저마다 지원하는 동영상 포맷이 다르기 때문에 각 브라우저에 맞는 동영상을 등록하는 것이 중요하다. 이는 `<source>` 태그에서 동영상의 확장자로 설정을 할 수 있다. 최근에는 왠만한 브라우저에서 전부 지원을 하긴 하지만, 아래의 지원 목록을 참고해보도록 하자.

### 지원 브라우저 목록

<p align="center">
   <img src="images/html_video_tag(2).png">
   <p align="center">출처 : <a href="https://www.w3schools.com/tags/tag_video.asp">https://www.w3schools.com/</a></p>
</p>

### 속성 목록

<table>
   <tr>
      <th>속성</th>     
      <th>설명</th>   
   </tr>
   <tr>
      <td>autoplay</td>
      <td>재생 준비가 되면 자동으로 재생</td>
   </tr>
   <tr>
      <td>controls</td>
      <td>동영상 탐색 도구를 표시</td>
   </tr>
   <tr>
      <td>height / width</td>
      <td>높이 / 너비를 픽셀 단위로 설정</td>
   </tr>
   <tr>
      <td>loop</td>
      <td>영상을 반복 재생</td>
   </tr>
   <tr>
      <td>muted</td>
      <td>음소거 상태로 영상을 실행</td>
   </tr>
   <tr>
      <td>poster</td>
      <td>영상이 다운로드 중일 때 보여주는 사진 설정</td>
   </tr>
   <tr>
      <td>preload</td>
      <td>페이지가 로딩될 때 동영상을 같이 불러올 것인지 설정(auto, metadata, none으로 설정 가능)</td>
   </tr>
   <tr>
      <td>src</td>
      <td>영상 원본의 주소를 설정</td>
   </tr>
</table>

자세한 기능 사용방법은 아래의 링크를 참고하도록 하자.

[W3School HTML Video Tags](https://www.w3schools.com/tags/tag_video.asp)

# 브라우저 버전별 태그 사용 여부 확인하기

`Can I Use`라는 페이지에서 브라우저마다 HTML 태그를 사용할 수 있는 지 여부를 확인할 수 있다.

![Can I Use](images/html_can_i_use.png)

사실 개발할 때 자주 사용하는 태그는 정해져있지만, 브라우저마다 지원하는 태그가 다를 수 있으므로 정확한 데이터에 기반한 브라우저 지원 여부를 확인하는 습관을 가져보자.

[Can I Use](https://caniuse.com/)