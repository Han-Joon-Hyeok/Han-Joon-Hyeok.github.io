---
title: HackerRank - 2D Array - DS (JavaScript)
date: 2021-11-12 12:05:00 +0900
categories: [HackerRank]
tags: [HackerRank, javascript]
---

> [HackerRank - 2D Array - DS](https://www.hackerrank.com/challenges/2d-array/problem)

# Problem

- 6 x 6 2차원 배열이 주어짐
- hourglass(모래시계) 모양으로 이루어진 인덱스들의 합을 모두 구하고, 가장 큰 값을 반환

## 🙋‍♂️ Solution

2중 반복문을 사용할 줄 안다면 쉽게 풀 수 있는 문제이다.

```javascript
function hourglassSum(arr) {
  // Write your code here
  const result = [];
  for (let row = 0; row < arr.length - 2; row++) {
    for (let col = 0; col < arr[row].length - 2; col++) {
      const top = arr[row].slice(col, col + 3);
      const mid = arr[row + 1][col + 1];
      const bottom = arr[row + 2].slice(col, col + 3);
      const hourglass = [...top, mid, ...bottom];
      const sum = hourglass.reduce((acc, cur) => acc + cur, 0);
      result.push(sum);
    }
  }

  return Math.max(...result);
}
```

- 1행부터 4행까지 돌면서 모래시계 모양으로 이루어진 인덱스를 top, mid, bottom 변수로 설정하고, 이들을 다시 배열에 할당하였다.
- `reduce` 를 사용해서 모래시계의 인덱스 합을 구하고, 외부에 선언한 배열에 결과값을 추가했다.
