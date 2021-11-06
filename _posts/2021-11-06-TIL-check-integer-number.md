---
title: TIL - JavaScript 정수인지 확인하는 방법
date: 2021-11-06 23:45:00 +0900
categories: [javascript]
tags: [javascript, TIL]
---

주어진 number가 정수인지 확인하는 방법은 두 가지 방법이 있다.

# `Number.isInteger()`

`isInteger` 메서드는 값이 정수이면 true, 아니면 false를 반환한다. 값이 `NaN` 이거나 `Infinity` 여도 false를 반환한다.

```javascript
const float = 1.4;
const int = 2;

console.log(Number.isInteger(float)); // false
console.log(Number.isInteger(int)); // true
```

# n % 1 === 0

정수는 1로 나눠도 나머지가 0이라는 성질을 이용한 방법이다.

```javascript
const float = 1.4;
const int = 2;

console.log(float % 1 === 0); // false
console.log(int % 1 === 0); // true
```

# 속도 비교

유의미한 속도 차이를 보이지 않는다. 아무거나 써도 된다.
