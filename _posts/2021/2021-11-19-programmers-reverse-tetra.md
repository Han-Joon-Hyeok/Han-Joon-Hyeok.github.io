---
title: 프로그래머스 Level 1 - 3진법 뒤집기 (JavaScript)
date: 2021-11-19 22:00:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 3진법 뒤집기](https://programmers.co.kr/learn/courses/30/lessons/68935)

# 문제 설명

자연수 n이 매개변수로 주어집니다. n을 3진법 상에서 앞뒤로 뒤집은 후, 이를 다시 10진법으로 표현한 수를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

n은 1 이상 100,000,000 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

JavaScript 의 내장 함수를 이용해서 진법을 변환하는 풀이와 직접 3진법으로 변환하는 풀이를 해보았다.

### 내장 함수 이용한 풀이

```javascript
function solution(n) {
  return parseInt([...n.toString(3)].reverse().join(""), 3);
}
```

- `Number.toString([N진수])` : 숫자를 입력한 진수로 변환한 string을 반환한다. 진수를 생략하면 10진수로 변환한다.
- 전개 구문을 사용해서 배열로 뒤집고, 다시 문자열로 합친다.
- `Number.parseInt(string, [N진수])` : string을 N진수에서 1정수(10진수)로 계산한 값을 반환한다.

### 3진법으로 직접 변환한 풀이

```javascript
function solution(n) {
  const tetra = [];
  while (n > 0) {
    const remainder = n % 3;
    tetra.push(remainder);
    n = Math.floor(n / 3);
  }
  tetra.reverse();
  let sum = 0;
  for (let i = 0; i < tetra.length; i++) {
    sum += tetra[i] * 3 ** i;
  }
  return sum;
}
```

- 정수를 3진법으로 만들기 위해서는 3으로 나눈 나머지를 배열에 추가한다. 이때, 변환된 수는 거꾸로 저장되므로 `reverse` 메서드를 사용해서 원래대로 만들어준다.

```javascript
// EX
n = 45

3 |45
  ----
   15 ... 0
    5 ... 0
    2 ... 1

// 배열에 저장되는 순서는 가장 먼저 연산된 수부터 저장된다.
```

- 각 자리의 수를 $3^0$ 부터 $3^{n-1}$ (n은 배열의 길이) 까지 곱한 결과를 모두 더한다.
- 그러면 거꾸로 뒤집은 상태에서 10진법으로 변환한 것과 같게 된다.

## 👀참고한 풀이

```javascript
function solution(n) {
  const answer = [];
  while (n !== 0) {
    answer.unshift(n % 3);
    n = Math.floor(n / 3);
  }
  return answer.reduce((acc, v, i) => acc + v * Math.pow(3, i), 0);
}
```

- 3진법으로 변환한 풀이를 조금 더 간단하게 줄인다면 위의 코드와 같다.
- 배열의 맨 앞에 나머지를 추가해서 별도로 배열을 뒤집어주지 않았다.
- `reduce` 를 활용해서 각 자리수에 맞게 곱해주었다.
