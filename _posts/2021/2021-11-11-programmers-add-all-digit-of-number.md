---
title: 프로그래머스 Level 1 - 자릿수 더하기 (JavaScript)
date: 2021-11-11 15:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 자릿수 더하기](https://programmers.co.kr/learn/courses/30/lessons/12931)

# 문제 설명

자연수 N이 주어지면, N의 각 자릿수의 합을 구해서 return 하는 solution 함수를 만들어 주세요.예를들어 N = 123이면 1 + 2 + 3 = 6을 return 하면 됩니다.

## 제한사항

N의 범위 : 100,000,000 이하의 자연수

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 정수 n을 10으로 나눈 나머지는 맨 마지막 자리 수이다.
- n을 10으로 나누고 반내림을 하고, 다시 10으로 나눈 나머지를 더한다.

```javascript
function solution(n) {
  let sum = 0;
  while (n > 0) {
    const digit = n % 10;
    n = Math.floor(n / 10);
    sum += digit;
  }
  return sum;
}
```

[자연수 뒤집어 배열로 만들기](https://han-joon-hyeok.github.io/posts/programmers-reverse-natural-number/) 문제와 접근 방법은 같다.

## 👀참고한 풀이

```javascript
function solution(n) {
  return n
    .toString()
    .split("")
    .reduce((acc, cur) => (acc += +cur), 0);
}
```

- 숫자를 문자열로 변환하고, 다시 배열로 변환해서 모든 요소를 더하는 방법이다.
- 처음에 이 방법도 떠올렸는데, 제한 조건에서 N의 범위가 100,000,000이하의 자연수라서 배열의 범위가 벗어날 것 같았다. 검색해보니 배열의 길이는 최대 $2^{32} - 1$ (4,294,967,295) 까지 가질 수 있다고 한다.

> 참고 : [Array.length](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/Array/length)
