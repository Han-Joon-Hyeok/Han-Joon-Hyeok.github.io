---
title: 프로그래머스 Level 1 - 나머지가 1이 되는 수 찾기 (JavaScript)
date: 2021-11-13 16:25:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 나머지가 1이 되는 수 찾기](https://programmers.co.kr/learn/courses/30/lessons/87389)

# 문제 설명

자연수 `n`이 매개변수로 주어집니다. `n`을 `x`로 나눈 나머지가 1이 되도록 하는 가장 작은 자연수 `x`를 return 하도록 solution 함수를 완성해주세요. 답이 항상 존재함은 증명될 수 있습니다.

## 제한사항

3 ≤ `n` ≤ 1,000,000

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(n) {
  const result = [];
  for (let i = 2; i < n; i++) {
    if (n % i === 1) {
      result.push(i);
    }
  }

  return Math.min(...result);
}
```

- 2부터 n - 1까지 나누었을 때, 나머지가 1이 되는 수를 배열에 넣고, 가장 작은 값을 반환하도록 했다.

## 👀참고한 풀이

```javascript
function solution(n) {
  for (let i = 2; i < n; i++) {
    if (n % i === 1) {
      return i;
    }
  }
}
```

- 2부터 시작했을 때 가장 먼저 나머지가 1이 되는 수가 바로 가장 작은 수이다.
