---
title: 프로그래머스 Level 2 - 다음 큰 숫자 (JavaScript)
date: 2021-11-24 19:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 다음 큰 숫자](https://programmers.co.kr/learn/courses/30/lessons/12911)

# 문제 설명

---

자연수 n이 주어졌을 때, n의 다음 큰 숫자는 다음과 같이 정의 합니다.

- 조건 1. n의 다음 큰 숫자는 n보다 큰 자연수 입니다.
- 조건 2. n의 다음 큰 숫자와 n은 2진수로 변환했을 때 1의 갯수가 같습니다.
- 조건 3. n의 다음 큰 숫자는 조건 1, 2를 만족하는 수 중 가장 작은 수 입니다.

예를 들어서 78(1001110)의 다음 큰 숫자는 83(1010011)입니다.

자연수 n이 매개변수로 주어질 때, n의 다음 큰 숫자를 return 하는 solution 함수를 완성해주세요.

## 제한사항

n은 1,000,000 이하의 자연수 입니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(n) {
  const binary = n.toString(2);
  const length = binary.length;
  const targetCnt = [...binary].filter((b) => +b === 1).length;

  for (let i = n + 1; i < 2 ** (length + 1); i++) {
    const nextBinary = i.toString(2);
    const cnt = [...nextBinary].filter((b) => +b === 1).length;
    if (targetCnt === cnt) {
      return i;
    }
  }
}
```

- 주어진 n 을 1씩 증가시키고, 2진수로 변환 했을 때 1의 개수가 일치하는 수가 다음 큰 수가 된다.
- 반복 횟수를 정하기 위해서 2진수 변환 자리수를 먼저 구했다.
  - 자연수를 2진수로 변환한 수의 길이는 다음과 같다.
  - $2^0 \le n \lt 2^1$ : 1자리 (1)
  - $2^1 \le n \lt 2^2$ : 2자리 (10 ~ 11)
  - $2^2 \le n \lt 2^3$ : 3자리 (100 ~ 111)
  - $2^{k-1} \le n \lt 2^k$ : k자리
- 즉, 2진수로 변환한 자리수(k)를 구하면, 다음 큰 수는 $2^{k + 1}$ 이전에 등장하게 된다.

## 👀참고한 풀이

```javascript
function solution(n, a = n + 1) {
  return n.toString(2).match(/1/g).length == a.toString(2).match(/1/g).length
    ? a
    : solution(n, a + 1);
}
```

정규 표현식과 재귀함수로 구현한 코드이다.

가독성을 고려해서 다음과 같이 수정해보았다.

```javascript
function solution(n, a = n + 1) {
  const currentBinaryLength = n.toString(2).match(/1/g).length;
  const nextBinaryLength = a.toString(2).match(/1/g).length;

  if (currentBinaryLength === nextBinaryLength) {
    return a;
  }

  return solution(n, a + 1);
}
```
