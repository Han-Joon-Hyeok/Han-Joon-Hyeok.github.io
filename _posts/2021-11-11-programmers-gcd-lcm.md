---
title: 프로그래머스 Level 1 - 최대공약수와 최소공배수 (JavaScript)
date: 2021-11-11 15:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 최대공약수와 최소공배수](https://programmers.co.kr/learn/courses/30/lessons/12940)

# 문제 설명

두 수를 입력받아 두 수의 최대공약수와 최소공배수를 반환하는 함수, solution을 완성해 보세요. 배열의 맨 앞에 최대공약수, 그다음 최소공배수를 넣어 반환하면 됩니다. 예를 들어 두 수 3, 12의 최대공약수는 3, 최소공배수는 12이므로 solution(3, 12)는 [3, 12]를 반환해야 합니다.

## 제한사항

두 수는 1이상 1000000이하의 자연수입니다.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 최대공약수는 두 정수를 나누었을 때, 나머지가 0인 약수 중에서 가장 큰 값을 의미한다.
- 최소공배수는 두 정수의 곱을 최대공약수로 나눈 값이다. (참고자료 : [최소공배수 성질](https://namu.wiki/w/%EC%B5%9C%EC%86%8C%EA%B3%B5%EB%B0%B0%EC%88%98#s-4))
  - 두 정수 a, b의 최대공약수를 $G$ 라고 해보자.
  - 그리고 서로소인 정수 m, n에 대해 $a = Gm$, $b = Gn$ 이 성립한다.
  - 그러면 최소공배수는 두 정수의 최대공약수와 서로소인 약수들을 모두 곱한 값과 같으므로, $lcm(a,b) = Gmn$ 이 성립한다.
  - $ab = G^2mn$ 이므로, 따라서 $\frac{ab}G = Gmn = lcm(a,b)$ 이 된다.

### 작성 코드

```javascript
function solution(n, m) {
  const numbers = [n, m];
  numbers.sort((a, b) => a - b);
  const [min, max] = numbers;

  let arr = [];
  for (let i = 1; i <= min; i++) {
    if (min % i === 0 && max % i === 0) {
      arr.push(i);
    }
  }

  const GCD = Math.max(...arr);
  const LCM = (min * max) / GCD;

  return [GCD, LCM];
}
```

- 두 정수 n, m을 배열로 받은 다음, 작은 수와 큰 수를 구분하기 위해서 오름차순으로 정렬을 했다.
- 최대공약수는 1부터 시작해서 두 정수를 나눈 나머지가 0인 값을 배열에 추가한 다음, 배열에서 가장 큰 값을 반환했다.

## 👀참고한 풀이

```javascript
function solution(n, m) {
  const getGCD = (a, b) => {
    if (b === 0) return a;
    return getGCD(b, a % b);
  };

  const getLCM = (a, b) => {
    return (a * b) / getGCD(a, b);
  };

  return [getGCD(n, m), getLCM(n, m)];
}
```

최대공약수는 [유클리드 호제법](https://namu.wiki/w/%EC%9C%A0%ED%81%B4%EB%A6%AC%EB%93%9C%20%ED%98%B8%EC%A0%9C%EB%B2%95)으로 구할 수 있다.

- 유클리드 호제법은 정수 a와 b가 있을 때, a를 b로 나눈 `a = q * b + r` 에서 a와 b의 최대공약수가 b와 r의 최대공약수와 같다는 것이다. (q는 몫, r은 나머지)
  ```javascript
  a = (q1 * b) + r1
  b = (q2 * r1) + r2
  r1 = (q3 * r2) + r3
  ...
  rn-1 = (qn-1 * rn) + rn+1
  rn = (qn * rn+1) + 0
  ```
- b와 r의 최대공약수를 구하기 위해 다시 b를 r로 나누는데, 이 과정을 반복하다가 나머지가 0이 되는 시점의 b가 최대공약수이다.
- 이 과정을 반복하기 위해 재귀함수를 사용하는데, 종료 조건은 나머지가 0일 때, 나누는 값($r_{n+1}$)을 반환한다.

# 참고자료

- [최소공배수](https://namu.wiki/w/%EC%B5%9C%EC%86%8C%EA%B3%B5%EB%B0%B0%EC%88%98)
- [유클리드 호제법](https://namu.wiki/w/%EC%9C%A0%ED%81%B4%EB%A6%AC%EB%93%9C%20%ED%98%B8%EC%A0%9C%EB%B2%95)
  - [증명과정](https://www.youtube.com/watch?v=J5Yl2kHPAY4)
  - [고1 수학 문제 참고](https://www.youtube.com/watch?v=jGTbfHto3Uw)
