---
title: 프로그래머스 Level 2 - 교점에 별 만들기 (JavaScript)
date: 2022-05-27 14:20:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 교점에 별 만들기](https://programmers.co.kr/learn/courses/30/lessons/87377)

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

1. 직선을 2개씩 조합하는 모든 경우의 수를 구한다.
2. 각 조합마다 교점을 구한다.
   - 교점을 구하는 공식에 따라 계산
   - 계산 결과가 정수인 경우만 배열에 추가
3. 2차원 배열에 교점의 위치를 입력한다.
   - 2차원 배열의 크기를 구하기 위해서는 교점들의 x 값의 최솟값, 최댓값, y 값의 최솟값, 최댓값을 구한다.
   - 2차원 배열의 인덱스에는 음수가 올 수 없기 때문에 교점의 값을 2차원 배열 상에 나타낼 수 있도록 적절하게 변환해주어야 한다.

## ✍️작성 코드

### 실패한 코드

```javascript
function solution(line) {
  const answer = [];
  const max = {};
  const intersections = getIntersections(line);
  const board = initBoard(intersections, max);
  intersections.forEach((node) => {
    const [x, y] = node;
    board[max["y"] - y][max["x"] - x] = "*";
  });
  board.forEach((row) => answer.push(row.join("")));
  return answer;
}

const initBoard = (intersections, max) => {
  let [maxX, maxY] = intersections[0];
  let [minX, minY] = intersections[0];

  intersections.forEach((node) => {
    const [x, y] = node;
    if (x > maxX) maxX = x;
    if (x < minX) minX = x;
    if (y > maxY) maxY = y;
    if (y < minY) minY = y;
  });
  const width = maxX - minX;
  const height = maxY - minY;
  const board = Array.from(Array(height + 1), () => Array(width + 1).fill("."));
  max["x"] = maxX;
  max["y"] = maxY;
  return board;
};

const getIntersections = (arr) => {
  const result = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      const l1 = arr[i];
      const l2 = arr[j];
      const [a, b, e] = l1;
      const [c, d, f] = l2;
      const slope = a * d - b * c;
      if (slope) {
        const x = (b * f - e * d) / slope;
        const y = (e * c - a * f) / slope;
        if (Number.isInteger(x) && Number.isInteger(y)) result.push([x, y]);
      }
    }
  }
  return result;
};
```

교점을 구하고, 격자판에 입력하는 것까지는 큰 문제가 없었지만 여러 케이스에서 통과하지 못했다.

실행 결과는 다음과 같았다.

```
정확성: 31.0

테스트 1 〉	실패 (0.54ms, 30.1MB)
테스트 2 〉	실패 (8.21ms, 34.6MB)
테스트 3 〉	통과 (0.46ms, 29.7MB)
테스트 4 〉	실패 (29.71ms, 41.9MB)
테스트 5 〉	실패 (4.93ms, 32MB)
테스트 6 〉	실패 (2.43ms, 30.1MB)
테스트 7 〉	실패 (7.54ms, 33.5MB)
테스트 8 〉	실패 (0.49ms, 30.2MB)
테스트 9 〉	실패 (68.97ms, 37.1MB)
테스트 10 〉	실패 (66.15ms, 37MB)
테스트 11 〉	실패 (88.41ms, 36.9MB)
테스트 12 〉	실패 (67.05ms, 36MB)
테스트 13 〉	실패 (63.38ms, 37MB)
테스트 14 〉	실패 (39.38ms, 37MB)
테스트 15 〉	실패 (54.68ms, 35.9MB)
테스트 16 〉	실패 (51.55ms, 36.9MB)
테스트 17 〉	실패 (47.74ms, 37.1MB)
테스트 18 〉	실패 (47.44ms, 36MB)
테스트 19 〉	실패 (31.53ms, 36MB)
테스트 20 〉	실패 (53.65ms, 37MB)
테스트 21 〉	실패 (46.49ms, 37.1MB)
테스트 22 〉	통과 (0.44ms, 29.9MB)
테스트 23 〉	통과 (0.42ms, 29.9MB)
테스트 24 〉	통과 (0.43ms, 30MB)
테스트 25 〉	통과 (0.47ms, 29.9MB)
테스트 26 〉	통과 (0.45ms, 30MB)
테스트 27 〉	통과 (0.39ms, 30.1MB)
테스트 28 〉	통과 (0.39ms, 30MB)
테스트 29 〉	통과 (0.40ms, 29.8MB)
```

실패한 원인은 2차원 배열에서 위치를 입력할 때, `x` 값을 잘못 계산하고 있었다.

```javascript
intersections.forEach((node) => {
  const [x, y] = node;
  board[max["y"] - y][max["x"] - x] = "*";
});
```

예를 들어, 교점이 `(0, 4), (-4, -4), (4, -4), (4, 1), (-4, 1)` 이라고 할 때, x 값의 최댓값은 `4` , 최솟값은 `-4` , y 값의 최댓값은 `4` , 최솟값은 `-4` 이다.

2차원 배열의 크기는 x 축, y 축 각각 `최댓값 - 최솟값 + 1` 인데, `(-4, -4)` 좌표는 2차원 배열 상에서는 `board[8][0]` 이다.

그림으로 설명하면 다음과 같다.

![programmers-intersections-Page-1.drawio.png](/assets/images/2022/2022-05-27-programmers-intersection-stars/programmers-intersections-Page-1.drawio.png)

그래프 상에서는 위와 같은 위치이지만, 2차원 배열 상에서는 아래와 같다.

![programmers-intersections-Page-1.drawio (1).png](/assets/images/2022/2022-05-27-programmers-intersection-stars/programmers-intersections-Page-1.drawio (1).png)

그런데 2차원 배열에서 `x` 값을 `max[’x’] - x` 로 주게 되면, `4 - (-4) = 8` 이 되고, 따라서 2차원 배열에서 `board[8][8]` 에 저장된다.

![programmers-intersections-Page-1.drawio (2).png](/assets/images/2022/2022-05-27-programmers-intersection-stars/programmers-intersections-Page-1.drawio (2).png)

공교롭게도 다른 교점인 `(4, -4)` 의 계산 값이 `board[8][0]` 이 되었다. 즉, 원래 있어야 할 자리가 아닌 다른 자리에 저장 되었음에도 서로 마주보고 있는 교점이 있다면 일부 테스트 케이스에서는 통과를 한 것이다.

이러한 문제를 해결하기 위해 x 값을 `x - min['x']` 로 바꿔주었다. 그러면 `(-4, -4)` 가 `board[8][0]` 에 위치할 수 있게 된다.

### 성공한 코드

```javascript
function solution(line) {
  const answer = [];
  const max = {};
  const min = {};
  const intersections = getIntersections(line);
  const board = initBoard(intersections, max, min);
  intersections.forEach((node) => {
    const [x, y] = node;
    // x 의 좌표는 x - min['x']
    board[max["y"] - y][x - min["x"]] = "*";
  });
  board.forEach((row) => answer.push(row.join("")));
  return answer;
}

const initBoard = (intersections, max, min) => {
  let [maxX, maxY] = intersections[0];
  let [minX, minY] = intersections[0];

  intersections.forEach((node) => {
    const [x, y] = node;
    if (x > maxX) maxX = x;
    if (x < minX) minX = x;
    if (y > maxY) maxY = y;
    if (y < minY) minY = y;
  });

  const width = maxX - minX;
  const height = maxY - minY;
  const board = Array.from(Array(height + 1), () => Array(width + 1).fill("."));
  max["x"] = maxX;
  max["y"] = maxY;
  min["x"] = minX;
  min["y"] = minY;
  return board;
};

const getIntersections = (arr) => {
  const result = [];
  for (let i = 0; i < arr.length; i++) {
    for (let j = i + 1; j < arr.length; j++) {
      const l1 = arr[i];
      const l2 = arr[j];
      const [a, b, e] = l1;
      const [c, d, f] = l2;
      const slope = a * d - b * c;
      if (slope) {
        const x = (b * f - e * d) / slope;
        const y = (e * c - a * f) / slope;
        if (Number.isInteger(x) && Number.isInteger(y)) result.push([x, y]);
      }
    }
  }
  return result;
};
```

실행 결과는 다음과 같다.

```
테스트 1 〉	통과 (0.79ms, 30MB)
테스트 2 〉	통과 (7.81ms, 34.4MB)
테스트 3 〉	통과 (0.53ms, 29.9MB)
테스트 4 〉	통과 (18.11ms, 41.6MB)
테스트 5 〉	통과 (5.90ms, 33.5MB)
테스트 6 〉	통과 (2.56ms, 30.2MB)
테스트 7 〉	통과 (6.41ms, 34.2MB)
테스트 8 〉	통과 (0.51ms, 30.1MB)
테스트 9 〉	통과 (66.20ms, 37MB)
테스트 10 〉	통과 (40.88ms, 36.9MB)
테스트 11 〉	통과 (66.16ms, 37MB)
테스트 12 〉	통과 (44.26ms, 36.2MB)
테스트 13 〉	통과 (64.07ms, 37MB)
테스트 14 〉	통과 (40.29ms, 37MB)
테스트 15 〉	통과 (47.88ms, 35.9MB)
테스트 16 〉	통과 (52.45ms, 36.9MB)
테스트 17 〉	통과 (49.94ms, 37.2MB)
테스트 18 〉	통과 (47.29ms, 36.1MB)
테스트 19 〉	통과 (31.79ms, 36.1MB)
테스트 20 〉	통과 (56.02ms, 37.1MB)
테스트 21 〉	통과 (48.22ms, 37.1MB)
테스트 22 〉	통과 (0.64ms, 30MB)
테스트 23 〉	통과 (0.45ms, 30MB)
테스트 24 〉	통과 (0.43ms, 30MB)
테스트 25 〉	통과 (0.44ms, 30MB)
테스트 26 〉	통과 (0.46ms, 30MB)
테스트 27 〉	통과 (0.40ms, 30.1MB)
테스트 28 〉	통과 (0.45ms, 30.1MB)
테스트 29 〉	통과 (0.40ms, 30MB)
```

# 참고자료

- [[프로그래머스] 교점에 별 만들기 /JavaScript](https://leego.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EA%B5%90%EC%A0%90%EC%97%90-%EB%B3%84-%EB%A7%8C%EB%93%A4%EA%B8%B0-JavaScript) [티스토리]
