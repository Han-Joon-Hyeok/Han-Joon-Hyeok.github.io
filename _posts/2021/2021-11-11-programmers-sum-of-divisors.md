---
title: 프로그래머스 Level 1 - 약수의 합 (JavaScript)
date: 2021-11-11 15:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 약수의 합](https://programmers.co.kr/learn/courses/30/lessons/12928)

# 문제 설명

정수 n을 입력받아 n의 약수를 모두 더한 값을 리턴하는 함수, solution을 완성해주세요.

## 제한사항

`n`은 0 이상 3000이하인 정수입니다.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 정수 x가 정수 n의 약수라고 했을 때, n을 x로 나눈 나머지는 0이 된다.
- 따라서 1부터 n까지 n을 나누었을 때, 나머지가 0인 수가 약수가 된다.

```javascript
function solution(n) {
  let sum = 0;
  for (let i = 0; i <= n; i++) {
    const isDivisor = n % i === 0;
    if (isDivisor) {
      sum += i;
    }
  }
  return sum;
}
```

## 👀참고한 풀이

```javascript
function solution(n) {
  let sum = 0;
  for (let i = 1; i <= Math.sqrt(n); i++) {
    const isDivisor = n % i === 0;
    if (isDivisor) {
      const remainder = n / i === i ? 0 : n / i;
      sum += i + remainder;
    }
  }
  return sum;
}
```

- 약수의 대칭성을 이용해서 제곱근으로 반복 횟수를 줄였다. (참고자료 : [소수 판별 알고리즘](https://han-joon-hyeok.github.io/posts/TIL-check-prime-number/))
- 예컨대, n이 16이고 i가 2이면 2와 짝을 이루는 8도 함께 더하는 식으로 진행한다.
- 이때, 제곱을 해서 n이 나오는 경우에는 같은 수를 2번 더하는 것이므로, 한번만 더해주도록 한다.
