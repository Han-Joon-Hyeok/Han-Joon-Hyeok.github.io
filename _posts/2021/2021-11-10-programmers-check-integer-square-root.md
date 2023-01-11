---
title: 프로그래머스 Level 1 - 정수 제곱근 판별 (JavaScript)
date: 2021-11-10 10:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 정수 제곱근 판별](https://programmers.co.kr/learn/courses/30/lessons/12934)

# 문제 설명

임의의 양의 정수 n에 대해, n이 어떤 양의 정수 x의 제곱인지 아닌지 판단하려 합니다.

n이 양의 정수 x의 제곱이라면 x+1의 제곱을 리턴하고, n이 양의 정수 x의 제곱이 아니라면 -1을 리턴하는 함수를 완성하세요.

## 제한사항

n은 1이상, 50000000000000 이하인 양의 정수입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(n) {
  const sqrt = Math.sqrt(n);
  const isInteger = sqrt % 1 === 0;

  if (isInteger) {
    return (sqrt + 1) ** 2;
  }

  return -1;
}
```

- `Math.sqrt` 메서드를 사용해서 n의 제곱근을 구한다.
- 만약, n의 제곱근이 정수가 아니라면 정수 x의 제곱근이 아니다.

## 👀참고한 풀이

```javascript
function nextSqaure(n) {
  switch (n % Math.sqrt(n)) {
    case 0:
      return Math.pow(Math.sqrt(n) + 1, 2);
    default:
      return -1;
  }
}
```

- switch ~ case 문으로 풀이한 방법이다.
- 제곱을 계산하는 `Math.pow` 메서드를 사용했다.

# 배운 점

## `Math.pow()`

> Math.pow(밑값, 지수)

만약, 밑값이 음수이고 지수가 정수가 아닌 경우에는 NaN을 반환한다.
