---
title: 프로그래머스 Level 1 - 시저 암호 (JavaScript)
date: 2021-11-12 12:05:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
math_use: true
---

> [프로그래머스 - Level1 부족한 금액 계산하기](https://programmers.co.kr/learn/courses/30/lessons/82612)

# 문제 설명

새로 생긴 놀이기구는 인기가 매우 많아 줄이 끊이질 않습니다. 이 놀이기구의 원래 이용료는 price원 인데, 놀이기구를 N 번 째 이용한다면 원래 이용료의 N배를 받기로 하였습니다. 즉, 처음 이용료가 100이었다면 2번째에는 200, 3번째에는 300으로 요금이 인상됩니다.

놀이기구를 count번 타게 되면 현재 자신이 가지고 있는 금액에서 얼마가 모자라는지를 return 하도록 solution 함수를 완성하세요.

단, 금액이 부족하지 않으면 0을 return 하세요.

## 제한사항

- 놀이기구의 이용료 price : 1 ≤ price ≤ 2,500, price는 자연수
- 처음 가지고 있던 금액 money : 1 ≤ money ≤ 1,000,000,000, money는 자연수
- 놀이기구의 이용 횟수 count : 1 ≤ count ≤ 2,500, count는 자연수

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 놀이기구를 탑승한 횟수만큼 금액을 곱한 결과를 합으로 더한다.
- 만약, 가진 돈이 지불해야 하는 금액보다 크거나 같다면 0을 반환한다.
- 그렇지 않으면, 차이를 절대값으로 반환한다.

### 작성 코드

```javascript
function solution(price, money, count) {
  let sum = 0;
  for (let i = 0; i < count; i++) {
    sum += (i + 1) * price;
  }
  if (money >= sum) {
    return 0;
  }
  const diff = Math.abs(money - sum);

  return diff;
}
```

## 👀참고한 풀이

```javascript
function solution(price, money, count) {
  const tmp = (price * count * (count + 1)) / 2 - money;
  return tmp > 0 ? tmp : 0;
}
```

- 가우스 공식을 이용해서 간단하게 풀었다.
- 가우스 공식은 등차수열의 합공식이다.
  - 1부터 100까지 더하기 위해서 대칭되는 숫자끼리 더한다.
  - (1 + 100) + (2 + 99) ... (50+ 51) → 50묶음
  - 따라서 $50 * 101$ 으로 구할 수 있다.
  - 이를 공식으로 수식화 하면 $\frac12 * n * (a_n + a_{n+1})$ 이다.

# 참고자료

- [등차수열 합공식의 가우스](https://tyrannohaha.com/entry/%EC%88%98%ED%95%99%EC%9E%90-%EC%9D%B4%EC%95%BC%EA%B8%B02-%EB%93%B1%EC%B0%A8%EC%88%98%EC%97%B4-%ED%95%A9%EA%B3%B5%EC%8B%9D%EC%9D%98-%EA%B0%80%EC%9A%B0%EC%8A%A4)
