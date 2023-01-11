---
title: HackerRank - Sales by Match (JavaScript)
date: 2021-11-09 10:50:00 +0900
categories: [HackerRank]
tags: [HackerRank, javascript]
---

> [HackerRank - Sales by Match](https://www.hackerrank.com/challenges/sock-merchant/problem?filter=South%20Korea&filter_on=country&h_l=interview&page=2&playlist_slugs%5B%5D=interview-preparation-kit&playlist_slugs%5B%5D=warmup)

# Problem

There is a large pile of socks that must be paired by color. Given an array of integers representing the color of each sock, determine how many pairs of socks with matching colors there are.

## Constraints

- 1 ≤ n ≤ 100
- 1 ≤ ar[i] 100 where 0 ≤ i ≤ n

## 🙋‍♂️ Solution

```javascript
function sockMerchant(n, ar) {
  // Write your code here
  let answer = 0;
  const pairs = {};

  ar.map((cur) => (pairs[cur] = pairs[cur] + 1 || 1));
  for (const cnt of Object.values(pairs)) {
    const pair = Math.floor(cnt / 2);
    answer += pair;
  }
  return answer;
}
```

- 양말 종류 별로 개수를 키-값 형태로 객체에 저장한다.
- 양말의 개수를 2로 나누어 반내림을 하면 양말이 몇 켤레가 있는 지 구할 수 있다.
- 너무 어렵게 생각해서 풀었다. 좀 더 간단하게 풀어보자.

## 👀 Other Solution

```javascript
function sockMerchant(n, ar) {
  let pair = 0;
  // sort the array elements
  ar.sort();
  // iterate through the array and compare the elements
  for (let i = 0; i < n; i++) {
    if (ar[i] == ar[i + 1]) {
      // increment i iteration and add a pair
      i++;
      pair++;
    }
  }
  return pair;
}
```

- 배열을 순서대로 정렬한다. `sort` 를 사용할 때는 안전하게 콜백함수로 비교 함수를 넣어주는 것이 좋다.
- `for` 반복문을 돌리면서 현재 인덱스 === 다음 인덱스가 같은 값이면 양말 1켤레라는 의미이므로, 켤레 수 + 1 하고, 인덱스도 1을 올려줌으로써 다음 양말을 검사한다. 만약, 같지 않으면 인덱스는 추가로 올리지 않는다.

```javascript
// Example
arr =   [1, 1, 1, 2, 2, 3]
     i = 0  1  2  3  4  5

i = 0, arr[0] === arr[1] -> i++, pair++
i = 2, arr[2] !=== arr[3]
i = 3, arr[3] === arr[4] -> i++, pair++
i = 5, arr[5] !== arr[6] (undefined)

```
