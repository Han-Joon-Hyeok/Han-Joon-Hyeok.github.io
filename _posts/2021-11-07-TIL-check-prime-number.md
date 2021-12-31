---
title: TIL - 소수 판별 알고리즘 (JavaScript)
date: 2021-11-07 20:30:00 +0900
categories: [javascript]
tags: [javascript, TIL]
use_math: true
---

# 소수 (prime number)

소수란 1과 자기 자신으로만 나누어 떨어지는 1보다 큰 정수를 의미한다. 즉, 소수의 약수는 1과 자기 자신만 존재한다.

소수를 구하기 위한 방법 3가지를 소개해보고자 한다.

## 알고리즘 1

위의 정의에 따르면 정수 n이 소수이기 위해서는 2부터 n-1까지 순서대로 n을 나누었을 때, 하나라도 나머지가 0이 아니어야 한다.

```jsx
const checkPrimeNumber = (n) => {
  for (let i = 2; i < n; i++) {
    if (n % i === 0) return false;
  }
  return true;
};

console.log(checkPrimeNumber(97)); // true
console.log(checkPrimeNumber(98)); // false
```

위와 같은 방식으로 구현하면 알고리즘의 시간 복잡도는 `O(n)` 이 된다.

## 알고리즘 2

두 번째 방법은 n의 절반까지만 확인하는 방법이다.

만약, n이 80이면 자기 자신을 제외하고 40을 초과하는 숫자에서 나눴을 때, 나머지가 0이 되는 숫자가 나올 수 없다. 즉, n/2을 초과하는 수로 나누면 정확하게 나누어 떨어지는 것이 불가능하다는 것이다.

```jsx
const checkPrimeNumber = (n) => {
  for (let i = 2; i <= n / 2; i++) {
    if (n % i === 0) return false;
  }
  return true;
};
```

이 방식을 사용하면 최대 N/2번 조회하며, 시간복잡도는 상수를 제외하므로 `O(n)` 이 된다.

## 알고리즘 3

마지막으로 소개하는 방법은 n의 제곱근을 이용하는 방법이다. 이는 약수의 대칭성을 이용하는 방법이며, 알고리즘 2의 방법을 조금 더 응용한 것이다.

- 합성수 n을 약수의 곱으로 표현하면 `a * b` 와 같이 표현할 수 있다.
- 두 약수의 관계가 a ≥ b 이면, a ≥ $\sqrt{n}$ 이고, b ≤ $\sqrt{n}$ 이다.
- 그러면 $\sqrt{n}$ 까지만 확인하면 b가 약수로서 걸리고, 소수인지 확인할 수 있게 된다.

예를 들어 n이 20이라고 해보자.

- 20의 약수는 1, 2, 4, 5, 10, 20 이다.
- 20을 약수의 곱으로 표현하면 `20 * 1`, `10 * 2`, `5 * 4` 이다.
- $\sqrt{20}$ = 4.xxxx 이므로 4까지만 검사해도 약수의 대칭성에 의해 5, 10, 20은 20의 약수인 것이 보장된다.

```jsx
const checkPrimeNumber = (n) => {
  for (let i = 2; i <= Math.sqrt(n); i++) {
    if (n % i === 0) return false;
  }
  return true;
};

console.log(checkPrimeNumber(97)); // true
console.log(checkPrimeNumber(98)); // false
```

시간복잡도는 $O(\sqrt{n})$ 이 된다.

# 참고자료

- [소수 (1) - 소수 판별하기](https://gusdnd852.tistory.com/30)
- [에라토스테네스의 체](https://www.youtube.com/watch?v=5ypkoEgFdH8)

## 관련 문제

- [프로그래머스 소수 만들기](https://programmers.co.kr/learn/courses/30/lessons/12977)
