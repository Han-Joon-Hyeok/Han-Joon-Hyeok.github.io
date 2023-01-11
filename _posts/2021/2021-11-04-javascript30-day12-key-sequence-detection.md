---
title: Javascript30 - Day 12 Key Sequence Detection
date: 2021-11-04 23:20:00 +0900
categories: [javascript]
tags: [javascript30, javascript]
---

> [Javascript30](https://javascript30.com/)

# 구현 내용

- `KONAMI CODE`는 게임 제작사인 KONAMI의 게임에서 특정 키를 입력하면 치트가 발동하는 조건이다.
  ```javascript
  위 위 아래 아래 좌 우 좌 우 b a
  ```
- 특정 키를 연속해서 입력했을 때, 페이지 내에 특별한 효과가 발동하게 한다.
- 여기서는 `cornify` 라는 [라이브러리](https://github.com/Cornify/Cornify)를 사용해서 비밀키를 입력하면 아기자기한 유니콘 그림들이 화면에 랜덤으로 등장한다.

## 구현 화면

![screenshot](/assets/images/2021-11-04-javascript30-day12-key-sequence-detection/screenshot.gif)

## 구현 코드 (JavaScript)

```javascript
const SECRET_KEY = "joon";
const pressed = [];

const handleKeyDown = (e) => {
  const { key } = e;

  pressed.push(key);

  if (pressed.length === SECRET_KEY.length + 1) {
    pressed.shift();
  }

  if (pressed.join("") === SECRET_KEY) {
    cornify_add();
  }
};

window.addEventListener("keydown", handleKeyDown);
```

- 키가 눌리면 `pressed` 배열에 추가한다.
- 비밀키의 길이보다 커질 경우, 가장 먼저 눌린 키를 제거하기 위해 `shift` 메서드를 사용한다.
- 만약, 연속해서 입력된 키가 비밀키와 일치한다면, 특정 효과를 실행한다.

```javascript
const SECRET_KEY = "joon";
const pressed = [];

const handleKeyDown = (e) => {
  const { key } = e;

  pressed.push(key);
  pressed.splice(-SECRET_KEY.length - 1, pressed.length - SECRET_KEY.length);

  if (pressed.join("") === SECRET_KEY) {
    cornify_add();
  }
};

window.addEventListener("keydown", handleKeyDown);
```

- 위의 코드는 `shift` 메서드 대신 `splice` 메서드를 사용한 코드이다.
- `splice` 메서드의 시작 인덱스는 입력된 값의 절대값이 배열의 길이보다 클 경우, 0으로 설정된다.
- 입력된 키의 배열 길이가 비밀키 길이보다 같거나 작을 때는 제거할 요소가 음수로 지정되지만, 커지는 경우에는 제거 요소가 1로 설정된다.
- 즉, 입력된 키의 배열은 비밀키의 길이만큼 최근에 입력된 순서대로 자르는 것이며, 쉽게 생각하면 가장 먼저 입력된 키 하나만 제거하는 것이라고 생각할 수 있다.
