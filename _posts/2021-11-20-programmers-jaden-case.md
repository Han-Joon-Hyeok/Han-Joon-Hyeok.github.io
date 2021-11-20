---
title: 프로그래머스 Level 2 - JadenCase 문자열 만들기 (JavaScript)
date: 2021-11-20 20:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 JadenCase 문자열 만들기](https://programmers.co.kr/learn/courses/30/lessons/12951#)

# 문제 설명

JadenCase란 모든 단어의 첫 문자가 대문자이고, 그 외의 알파벳은 소문자인 문자열입니다. 문자열 s가 주어졌을 때, s를 JadenCase로 바꾼 문자열을 리턴하는 함수, solution을 완성해주세요.

## 제한사항

- s는 길이 1 이상인 문자열입니다.
- s는 알파벳과 공백문자(" ")로 이루어져 있습니다.
- 첫 문자가 영문이 아닐때에는 이어지는 영문은 소문자로 씁니다. ( 첫번째 입출력 예 참고 )

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(s) {
  const words = s.toLowerCase().split(" ");
  const jadenCase = words.map((word) => {
    const chars = word.split("");
    const head = chars[0];
    if (typeof head === "string") {
      chars.unshift(head.toUpperCase());
    }
    return chars.join("");
  });
  return jadenCase.join(" ");
}
```

맨 첫 글자의 타입을 확인하는 코드를 추가하기 전까지 계속 런타임 에러가 떴다.

이유는 공백에 접근할 때, 괄호표기법으로 접근하면 `undefined` 를 반환하기 때문이었다.

### string.charAt(n) vs string[n]

문자열의 인덱스에 접근하는 방법은 두 가지가 있다.

1. string[n] : 괄호표기법(Bracket Notation)으로 접근한다.
2. charAt(n) : `charAt` 메서드를 활용해서 접근한다.

두 방법의 차이점은 공백에 접근할 때 1번은 `undefined` 를 반환하고, 2번은 빈 문자를 반환한다는 것이다.

```javascript
const str = "";
console.log(str[0]); // undefined
console.log(str.charAt(0)); // ''
```

그리고 `charAt` 메서드는 매개변수를 Number 로 암묵적 타입 변환을 수행하지만, 괄호표기법은 그렇지 않다.

- Falsy 값(NaN, undefined ... )은 0으로, true 값은 1로 변환이 된다.

```javascript
"hello"[NaN]; // undefined
"hello".charAt(NaN); // 'h'

"hello"[undefined]; // undefined
"hello".charAt(undefined); // 'h'

"hello"[null]; // undefined
"hello".charAt(null); // 'h'

"hello"[true]; // undefined
"hello".charAt(true); // 'e'

"hello"["a"]; // undefined
"hello".charAt("a"); // 'h'
// Number('a') => NaN
// 따라서, 문자열도 Falsy이기 때문에 0을 반환한다.

"hello"["00"]; // undefined
"hello".charAt("00");
// return 'h' because it will try to convert `00` to number first

"hello"[1.5]; // undefined
"hello".charAt(1.23);
// return 'e' because it will round 1.23 to the number 1
```

## 👀참고한 풀이

```javascript
function solution(s) {
  return s
    .split(" ")
    .map((v) => v.charAt(0).toUpperCase() + v.substring(1).toLowerCase())
    .join(" ");
}
```

# 참고자료

- [string.charAt(i) vs string[i]](https://thisthat.dev/string-char-at-vs-string-bracket-notation/)
