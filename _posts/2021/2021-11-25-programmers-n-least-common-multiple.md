---
title: 프로그래머스 Level 2 - N개의 최소공배수 (JavaScript)
date: 2021-11-25 17:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 N개의 최소공배수](https://programmers.co.kr/learn/courses/30/lessons/12953)

# 문제 설명

---

두 수의 최소공배수(Least Common Multiple)란 입력된 두 수의 배수 중 공통이 되는 가장 작은 숫자를 의미합니다. 예를 들어 2와 7의 최소공배수는 14가 됩니다. 정의를 확장해서, n개의 수의 최소공배수는 n 개의 수들의 배수 중 공통이 되는 가장 작은 숫자가 됩니다. n개의 숫자를 담은 배열 arr이 입력되었을 때 이 수들의 최소공배수를 반환하는 함수, solution을 완성해 주세요.

## 제한사항

- arr은 길이 1이상, 15이하인 배열입니다.
- arr의 원소는 100 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

[프로그래머스 Level1 - 최대공약수와 최소공배수](https://han-joon-hyeok.github.io/posts/programmers-gcd-lcm/) 문제에서 이미 다루었던 개념인데, 조금만 더 생각해보면 되는 문제다.

- 1번째 수와 2번째 수의 최소공배수를 구하고, 구한 최소공배수와 3번째 수의 최소공배수를 구한다. 이런 방식으로 N번째 수까지 최소공배수를 구하면 된다.
- 이는 소인수분해를 이용해서 최소공배수를 찾는 것과 유사하다.

> $10 = 2 * 5$
> $12 = 2^2 * 3$

최소공배수 : $2^2 * 3 * 5 = 60$

>

- 중복되는 소인수는 지수가 큰 수만큼, 그리고 나머지 소인수를 모두 곱한다.

> $10 = 2 * 5$
> $12 = 2^2 * 3$
> $14 = 2 * 7$

최소공배수 : $2^2 * 3 * 5 * 7 = 420$

>

- 수가 3개 이상이라면 2개의 수의 최소공배수에 다른 수의 최소공배수를 누적해서 곱해나가는 것을 알 수 있다.

### 작성 코드

```javascript
function solution(arr) {
  const getGCD = (a, b) => {
    if (b === 0) return a;
    return getGCD(b, a % b);
  };

  const getLCM = (a, b) => {
    return (a * b) / getGCD(a, b);
  };

  const result = arr.reduce((LCM, curr) => getLCM(LCM, curr));

  return result;
}
```

- `reduce` 는 초기값을 인수로 전달하지 않으면 배열의 0번째 값을 accumulator 에 누적한다. 이를 이용해서 최소공배수를 누적해서 구했다.

## 👀참고한 풀이

```javascript
function nlcm(num) {
  return num.reduce((a, b) => (a * b) / gcd(a, b));
}

function gcd(a, b) {
  return a % b ? gcd(b, a % b) : b;
}
```

- 조금 더 짧게 구현한 코드이다. 로직은 같다.
