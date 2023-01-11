---
title: 프로그래머스 Level 1 - 약수의 개수와 덧셈 (JavaScript)
date: 2021-11-14 20:30:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
math_use: true
---

> [프로그래머스 - Level1 약수의 개수와 덧셈](https://programmers.co.kr/learn/courses/30/lessons/77884)

# 문제 설명

두 정수 `left`와 `right`가 매개변수로 주어집니다. `left`부터 `right`까지의 모든 수들 중에서, 약수의 개수가 짝수인 수는 더하고, 약수의 개수가 홀수인 수는 뺀 수를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

1 ≤ `left` ≤ `right` ≤ 1,000

## 🙋‍♂️나의 풀이

### 요구사항 파악

- `left` 부터 1씩 증가 시키면서 약수의 개수를 구한다.
- 약수의 개수는 약수의 대칭성에 의해 1부터 `left` 의 제곱근까지만 계산을 진행한다.
- 이때, 약수인지 판별하는 방법은 수를 나눴을 때 나머지가 0이 되는 지로 확인한다.

### 작성 코드

```javascript
function solution(left, right) {
  let sum = 0;

  for (let num = left; num <= right; num++) {
    const sqrt = Math.sqrt(num);
    let cnt = 0;

    for (let i = 1; i <= sqrt; i++) {
      if (i === sqrt) {
        cnt++;
        continue;
      }
      if (num % i === 0) {
        cnt += 2;
      }
    }

    if (cnt % 2 === 0) {
      sum += num;
      continue;
    }

    sum -= num;
  }

  return sum;
}
```

- 제곱근으로 나눈 것과 반복문의 인덱스가 같을 때는 겹쳐서 추가되지 않도록 한번만 카운트 한다. 이외에는 카운트를 2개씩 올린다.

## 👀참고한 풀이

```javascript
function solution(left, right) {
  var answer = 0;
  for (let i = left; i <= right; i++) {
    if (Number.isInteger(Math.sqrt(i))) {
      answer -= i;
    } else {
      answer += i;
    }
  }
  return answer;
}
```

제곱근이 정수면 약수의 개수는 홀수이고, 실수면 짝수라는 성질을 이용한 것이다.

- n의 제곱근이 정수라는 것은 n은 어떤 정수의 제곱수라는 것이다.
- 예를 들어, 4는 $2^2$이고, $2^0, 2^1, 2^2$ 로 구성되어 있다.
- 결국 제곱수는 거듭제곱으로 구성되어 있고, 약수의 개수는 거듭제곱 수에 + 1을 한 것이다.

참고로 양의 약수의 개수는 각각의 소인수의 지수 + 1를 곱한 값이다.

- 예를 들어, $72 = 2^3 \times 3^2$ 인데, 지수가 0부터 n까지의 모든 경우의 수를 곱한다고 생각하면 된다.
- $2^0\times3^0, 2^0\times3^1, 2^0\times3^2 ... 2^3\times3^2$
- 따라서 72의 약수의 개수는 $(3+1)\times(2+1) = 12$

# 참고자료

- [자연수의 약수의 개수 구하기](https://calcproject.tistory.com/608)
- [양의 약수의 개수](https://www.youtube.com/watch?v=tAEMjkHJaI4)
