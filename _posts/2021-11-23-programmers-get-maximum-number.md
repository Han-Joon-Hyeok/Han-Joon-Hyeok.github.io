---
title: 프로그래머스 Level 2 - 가장 큰 수 (JavaScript)
date: 2021-11-23 21:10:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 가장 큰 수](https://programmers.co.kr/learn/courses/30/lessons/42746#)

# 문제 설명

---

0 또는 양의 정수가 주어졌을 때, 정수를 이어 붙여 만들 수 있는 가장 큰 수를 알아내 주세요.

예를 들어, 주어진 정수가 [6, 10, 2]라면 [6102, 6210, 1062, 1026, 2610, 2106]를 만들 수 있고, 이중 가장 큰 수는 6210입니다.

0 또는 양의 정수가 담긴 배열 numbers가 매개변수로 주어질 때, 순서를 재배치하여 만들 수 있는 가장 큰 수를 문자열로 바꾸어 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- numbers의 길이는 1 이상 100,000 이하입니다.
- numbers의 원소는 0 이상 1,000 이하입니다.
- 정답이 너무 클 수 있으니 문자열로 바꾸어 return 합니다.

## 🙋‍♂️나의 풀이

### 작성 코드

케이스를 3가지로 나누어서 풀었다.

```javascript
function solution(numbers) {
  numbers.sort((a, b) => {
    const A = a + "";
    const B = b + "";

    const Ahead = A.charAt(0);
    const Bhead = B.charAt(0);

    if (Ahead > Bhead) return -1;
    if (Ahead === Bhead) {
      const C = +(A + B);
      const D = +(B + A);
      if (C > D) return -1;
      if (C < D) return 1;
    }
    if (Ahead < Bhead) return 1;
  });

  return Math.max(...numbers) === 0 ? "0" : numbers.join("");
}
```

- 숫자를 문자열로 변환한다.
- 숫자의 가장 왼쪽 자리 수를 비교한다.
  - 큰 수는 앞으로, 작은 수는 뒤로 보낸다.
  ```javascript
  [5, 78];
  // 785 --> O
  // 578 --> X
  ```
- 가장 왼쪽 자리 수가 같으면 두 수를 이어 붙였을 때를 비교한다.
  - 마찬가지로 큰 수는 앞으로, 작은 수는 뒤로 보낸다.
  ```javascript
  [1, 10];
  // 110 ---> O
  // 101 ---> X
  ```
- 만약, 0 으로만 이루어진 배열이라면 최댓값도 0이므로 0을 반환한다.

## 👀참고한 풀이

```javascript
function solution(numbers) {
  var answer = numbers
    .map((v) => v + "")
    .sort((a, b) => (b + a) * 1 - (a + b) * 1)
    .join("");

  return answer[0] === "0" ? "0" : answer;
}
```

사실 케이스를 나누지 않아도, 두 수를 앞 뒤로 붙여서 더 큰 수를 앞으로 보내면 된다.

```javascript
[6, 10, 2];
// 6, 10 vs 10, 6 --> 6, 10
// 10, 2 vs 2, 10 ---> 2, 10
// 따라서 [6, 2, 10]이 가장 큰 수를 반환한다.
```

## sort 작동 방식

JavaScript 의 sort 작동 방식은 두 인자를 뺄셈 연산을 했을 때, **양수**가 나오면 자리를 바꾼다고 생각하면 쉽다.

- `a - b` : 연산 결과가 0보다 크다는 것은 a가 b보다 크다는 것을 의미한다. 따라서 a가 b보다 클 때만 자리를 바꾸고, 큰 수를 뒤로 보내는 것이기 때문에 **오름차순 정렬**을 수행한다.
- `b - a` : 마찬가지로 b가 a보다 클 때만 0보다 커지므로, 큰 수인 b를 앞으로 보내고, a를 뒤로 보내게 된다. 따라서 **내림차순 정렬**을 수행한다.

```javascript
// 1. a - b 연산
// 연산의 결과가 항상 음수이므로 자리를 바꾸지 않는다.
[1, 2, 3].sort((a, b) => a - b); // [1, 2, 3]
```

```javascript
// 2. b - a 연산
// 연산의 결과가 항상 양수이므로 자리를 바꾼다.
[1, 2, 3].sort((a, b) => b - a); // [3, 2, 1]
```

# 참고자료

- [[Javascript] sort() 동작 방식 (내부 알고리즘)](https://noirstar.tistory.com/359)
