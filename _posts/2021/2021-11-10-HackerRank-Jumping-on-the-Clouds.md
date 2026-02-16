---
title: HackerRank - Jumping on the Clouds (JavaScript)
date: 2021-11-10 14:40:00 +0900
categories: [hackerrank]
tags: [hackerrank, javascript]
use_math: true
---

> [HackerRank - Jumping on the Clouds](https://www.hackerrank.com/challenges/jumping-on-the-clouds/problem)

# Problem

There is a new mobile game that starts with consecutively numbered clouds. Some of the clouds are thunderheads and others are cumulus. The player can jump on any cumulus cloud having a number that is equal to the number of the current cloud plus  or . The player must avoid the thunderheads. Determine the minimum number of jumps it will take to jump from the starting postion to the last cloud. It is always possible to win the game.

For each game, you will get an array of clouds numbered  if they are safe or  if they must be avoided.

## Constraints

- $2 \le n \le 100$
- $c[i] \in \{0, 1\}$
- $c[0] = c[n-1] = 0$

## 🙋‍♂️ Solution

### 요구사항 파악

- 주어진 배열에서 1은 번개가 있다는 것을 의미한다.
- 이동은 1칸 또는 2칸만 할 수 있다.
- 만약, 다음 위치에 번개가 있다면 번개를 피해서 2칸 이동 하고, 이는 1번 점프한 것으로 간주한다.
- 반복은 배열의 길이 - 1 까지만 진행한다. 만약, 배열의 길이만큼 반복한다면 배열의 끝에 도착해서도 점프를 하기 때문이다.

파악한 조건을 토대로 두 가지 방법으로 풀어보았다.

### 1. 번개의 위치를 별도의 배열로 생성

```javascript
function jumpingOnClouds(c) {
  // Write your code here
  let jumpCount = 0;
  const thunderPosition = c
    .map((val, idx) => {
      if (val !== 0) return idx;
      return 0;
    })
    .filter((val) => val);

  for (let i = 0; i < c.length - 1; i++) {
    const isOnThunder = thunderPosition.includes(i + 2);
    if (!isOnThunder) {
      i++;
    }
    jumpCount++;
  }
  return jumpCount;
}
```

- 주어진 배열에서 1이 위치한 인덱스를 `thunderPosition` 배열로 만든다.
- 현재 인덱스 + 2를 했을 때, 번개가 없다면 인덱스를 하나 더 올려서 2칸 이동하도록 한다.

하지만, 굳이 이렇게 별도로 번개의 위치를 배열로 만들지 않아도 풀 수 있다.

### 2. 배열 내에서 번개 위치 피하기

```javascript
function jumpingOnClouds(c) {
  // Write your code here
  let jumpCount = 0;

  for (let i = 0; i < c.length - 1; i++) {
    const canDoubleJump = c[i + 2] === 0;
    if (canDoubleJump) {
      i++;
    }
    jumpCount++;
  }

  return jumpCount;
}
```

- 만약, 현재 위치에서 2칸 이동했을 때 번개가 없다면 2칸을 옮긴다.

반복문을 종료하는 조건만 잘 파악하면 어렵지 않은 문제다.
