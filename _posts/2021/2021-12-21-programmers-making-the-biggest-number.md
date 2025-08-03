---
title: 프로그래머스 Level 2 - 큰 수 만들기 (JavaScript)
date: 2021-12-21 22:00:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 큰 수 만들기](https://programmers.co.kr/learn/courses/30/lessons/42883?language=javascript#)

# 문제 설명

---

어떤 숫자에서 k개의 수를 제거했을 때 얻을 수 있는 가장 큰 숫자를 구하려 합니다.

예를 들어, 숫자 1924에서 수 두 개를 제거하면 [19, 12, 14, 92, 94, 24] 를 만들 수 있습니다. 이 중 가장 큰 숫자는 94 입니다.

문자열 형식으로 숫자 number와 제거할 수의 개수 k가 solution 함수의 매개변수로 주어집니다. number에서 k 개의 수를 제거했을 때 만들 수 있는 수 중 가장 큰 숫자를 문자열 형태로 return 하도록 solution 함수를 완성하세요.

## 제한사항

- number는 1자리 이상, 1,000,000자리 이하인 숫자입니다.
- k는 1 이상 `number의 자릿수` 미만인 자연수입니다.

## 🙋‍♂️나의 풀이

- 처음에는 주어진 숫자에서 `number.length - k` 개를 조합해서 푸는 문제로 생각했다. 하지만, 제한 조건에 숫자가 100만 자리 이하이기 때문에 경우의 수가 너무 많아지는 문제점이 있다.
- 다른 분들의 풀이를 참고하여 스택을 이용했다.

### 의사 코드

- `number` 를 앞에서부터 순회한다.
  - 스택에 순서대로 쌓는다.
  - 만약 스택의 마지막 요소가 현재 순회하고 있는 숫자보다 작고, 제거한 숫자의 개수가 0보다 크다면 스택의 마지막 요소를 스택에서 빼고, 제거해야 하는 개수 k를 1씩 뺀다. 이 과정을 스택의 마지막 요소가 현재 숫자보다 큰 경우까지 반복한다.
- 제거해야 하는 숫자의 개수 k가 0보다 클 수도 있다. 이는 마지막에 k개 만큼 필요하지 않은 요소가 쌓였다는 것을 의미한다.
  ```javascript
  // 예시
  // "18765432", 3
  // k     num    stack
  // 3      1     ['1']
  // 2      8     ['8']
  // 2      7     ['8', '7']
  // 2      6     ['8', '7', '6']
  // 2      5     ['8', '7', '6', '5']
  // 2      4     ['8', '7', '6', '5', '4']
  // 2      3     ['8', '7', '6', '5', '4', '3']
  // 2      2     ['8', '7', '6', '5', '4', '3', '2']
  // 2      1     ['8', '7', '6', '5', '4', '3', '2', '1']
  ```
  - `splice` 를 사용해서 `스택의 길이 - k` 인덱스부터 k개 만큼 제거한다.

### 작성 코드

```javascript
function solution(number, k) {
  const stack = [];

  for (const num of number) {
    while (k > 0 && stack[stack.length - 1] < num) {
      stack.pop();
      k--;
    }
    stack.push(num);
  }

  stack.splice(stack.length - k, k);

  return stack.join("");
}
```

## 참고자료

- [[JS] 프로그래머스 - 큰 수 만들기](https://taesung1993.tistory.com/46)
