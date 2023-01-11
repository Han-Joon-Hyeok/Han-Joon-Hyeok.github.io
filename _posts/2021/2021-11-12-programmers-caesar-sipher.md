---
title: 프로그래머스 Level 1 - 시저 암호 (JavaScript)
date: 2021-11-12 12:05:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 시저 암호](https://programmers.co.kr/learn/courses/30/lessons/12926?language=javascript)

# 문제 설명

어떤 문장의 각 알파벳을 일정한 거리만큼 밀어서 다른 알파벳으로 바꾸는 암호화 방식을 시저 암호라고 합니다. 예를 들어 "AB"는 1만큼 밀면 "BC"가 되고, 3만큼 밀면 "DE"가 됩니다. "z"는 1만큼 밀면 "a"가 됩니다. 문자열 s와 거리 n을 입력받아 s를 n만큼 민 암호문을 만드는 함수, solution을 완성해 보세요.

## 제한사항

- 공백은 아무리 밀어도 공백입니다.
- s는 알파벳 소문자, 대문자, 공백으로만 이루어져 있습니다.
- s의 길이는 8000이하입니다.
- n은 1 이상, 25이하인 자연수입니다.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 주어진 문자열을 배열로 만든다.
- string을 ASCII 코드로 변환한 다음, 공백이면 그대로 반환한다.
  - 문자가 대문자 Z보다 작았고, 밀린 문자가 대문자 Z의 ASCII 코드 값보다 커진 경우, 대문자 A로 돌아가서 시작하도록 한다.
  - 비슷하게 밀린 문자가 소문자 z보다 커지면, 소문자 a로 돌아가서 시작하도록 한다.
- 거리만큼 밀어준 ASCII 코드를 다시 문자로 반환하고, 배열을 문자열로 합친다.

### 작성 코드

```javascript
function solution(s, n) {
  const space = 32;
  const A = 65;
  const Z = 90;
  const a = 97;
  const z = 122;

  return s
    .split("")
    .map((char) => {
      const charCode = char.charCodeAt(0);
      if (charCode === space) {
        return " ";
      }
      const newChar = charCode + n;
      if (charCode <= Z && newChar > Z) {
        return String.fromCharCode(newChar - Z + A - 1);
      }
      if (newChar > z) {
        return String.fromCharCode(newChar - z + a - 1);
      }
      return String.fromCharCode(newChar);
    })
    .join("");
}
```

- ASCII 코드를 직접 사용하다 보니까 코드가 길어지고 복잡해졌다.

## 👀참고한 풀이

```javascript
function solution(s, n) {
  const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  const lower = upper.toLowerCase();

  return s
    .split("")
    .map((char) => {
      if (char === " ") {
        return " ";
      }

      const charArr = upper.includes(char) ? upper : lower;

      let index = charArr.indexOf(char) + n;
      if (index >= charArr.length) {
        index -= charArr.length;
      }

      return charArr[index];
    })
    .join("");
}
```

- 대문자와 소문자를 상수로 미리 선언해주었다.
- 문자가 대문자인지 소문자인지 판단하고, 밀린 문자의 인덱스가 문자열의 길이보다 커지면, 문자열의 길이만큼 빼준다.

# 배운 점

## `String.fromCharCode()`

UTF-16 코드 유닛의 시퀀스로부터 문자열을 생성하여 반환한다.

가능한 값의 범위는 0부터 65535(0xFFFF) 까지이다.

### 구문

> String.fromCharCode(num1, num2, ...)

### 예시

```javascript
String.fromCharCode(65, 66, 67); // "ABC"
```

## `String.prototype.charCodeAt()`

주어진 인덱스에 대해 UTF-16 코드를 나타내는 0부터 65535 사이의 정수를 반환한다.

인덱스 범위를 벗어나면 `NaN` 을 반환한다.

### 구문

> str.charCodeAt(index)

### 예시

```javascript
"abc".charCodeAt(0); // 97
"abc".charCodeAt(1); // 98
"abc".charCodeAt(2); // 99
"abc".charCodeAt(3); // NaN
```
