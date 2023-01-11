---
title: 프로그래머스 Level 1 - 내적 (javascript)
date: 2021-11-06 11:30:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 내적](https://programmers.co.kr/learn/courses/30/lessons/70128)

# 문제 설명

길이가 같은 두 1차원 정수 배열 a, b가 매개변수로 주어집니다. a와 b의 [내적](https://en.wikipedia.org/wiki/Dot_product)을 return 하도록 solution 함수를 완성해주세요.

이때, a와 b의 내적은 `a[0]*b[0] + a[1]*b[1] + ... + a[n-1]*b[n-1]` 입니다. (n은 a, b의 길이)

## 제한사항

- a, b의 길이는 1 이상 1,000 이하입니다.
- a, b의 모든 수는 -1,000 이상 1,000 이하입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(a, b) {
  return a.reduce((acc, cur, idx) => acc + cur * b[idx], 0);
}
```

- `reduce` 를 사용해서 간단하게 풀었다. 어렵지 않은 문제다.

## 👀참고한 풀이

```javascript
function solution(a, b) {
  let sum = 0;
  for (let i = 0; i < a.length; i++) {
    sum += a[i] * b[i];
  }
  return sum;
}
```

- 기본에 충실한 풀이이다. 함수형 프로그래밍에는 `reduce` 와 같은 함수를 적절히 사용하는 것이 훨씬 가독성이 좋다.
