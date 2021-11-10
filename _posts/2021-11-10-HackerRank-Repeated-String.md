---
title: HackerRank - Repeated String (JavaScript)
date: 2021-11-10 14:30:00 +0900
categories: [HackerRank]
tags: [HackerRank, javascript]
use_math: true
---

> [HackerRank - Repeated String](https://www.hackerrank.com/challenges/repeated-string/problem)

# Problem

There is a string, $s$ , of lowercase English letters that is repeated infinitely many times. Given an integer, $n$, find and print the number of letter `a`'s in the first $n$ letters of the infinite string.

## Constraints

- $1 \le |s| \le 100$
- $1 \le n \le 10^{12}$
- For 25% of the test cases, $n \le 10^6$

## 🙋‍♂️ Solution

몫과 나머지를 활용하면 풀 수 있는 문제이다.

처음에는 직접 문자열을 반복해서 만들었지만, 제한 조건에 보면 n의 크기만큼 문자열을 만들면 메모리의 범위를 벗어나서 오류가 나기 때문에 다른 방법으로 풀었다.

### 요구사항 파악

- 주어진 문자열 s는 길이가 n이 될 때까지 반복한다.
- 반복한 문자에서 a의 개수를 파악한다.

```javascript
s: abc;
n: 10;

abc / abc / abc / a;
```

- 문자열 내에서 a가 몇 번 반복되는 지 구한다.
- 반복 횟수는 `문자열의 길이 / n` 의 몫이고, 나머지 잘린 글자의 길이는 `문자열의 길이 % n`과 같다.
- 나머지 잘린 글자에서도 a가 몇 개 있는지 구한다.
- 따라서 합계인 (반복 횟수 \* a 반복 횟수) + (나머지 a 반복 횟수)를 구한다.

### 구현 코드

```javascript
function repeatedString(s, n) {
  // Write your code here
  const targetReducer = (acc, cur) => {
    if (cur === "a") {
      return acc + 1;
    }
    return acc;
  };
  const targetCnt = s.split("").reduce(targetReducer, 0);
  const repeatTime = Math.floor(n / s.length);
  const remainder = s
    .slice(0, n % s.length)
    .split("")
    .reduce(targetReducer, 0);

  const answer = targetCnt * repeatTime + remainder;

  return answer;
}
```

- `reduce` 를 사용해서 문자열에서 a의 개수를 구했다. 이를 위해 문자열을 배열로 변환하였다.

## 👀 Other Solution

```javascript
function repeatedString(s, n) {
  const aCount = (s.match(/a/g) || []).length;
  const quotient = Math.floor(n / s.length);
  const remainder = n % s.length;

  let result = aCount * quotient;

  for (let i = 0; i < remainder; i++) {
    if (s[i] === "a") result++;
  }

  return result;
}
```

- 정규 표현식을 활용해서 문자열에서 a의 개수를 구했다.
- `match` 메서드는 정규 표현식과 일치하는 요소를 Array로 반환한다. 만약, 없을 경우 null이 반환된다.
- 나머지 글자는 for 문에서 직접 문자열의 인덱스에 접근하여 a의 개수를 세는 방식으로 구현했다.
- 메서드를 많이 사용하지 않고도 간단하게 해결할 수 있다.
