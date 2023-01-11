---
title: 프로그래머스 Level 2 - 가장 큰 정사각형 찾기 (JavaScript)
date: 2021-11-26 20:00:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 가장 큰 정사각형 찾기](https://programmers.co.kr/learn/courses/30/lessons/12905)

# 문제 설명

---

1와 0로 채워진 표(board)가 있습니다. 표 1칸은 1 x 1 의 정사각형으로 이루어져 있습니다. 표에서 1로 이루어진 가장 큰 정사각형을 찾아 넓이를 return 하는 solution 함수를 완성해 주세요. (단, 정사각형이란 축에 평행한 정사각형을 말합니다.)

## 제한사항

- 표(board)는 2차원 배열로 주어집니다.
- 표(board)의 행(row)의 크기 : 1,000 이하의 자연수
- 표(board)의 열(column)의 크기 : 1,000 이하의 자연수
- 표(board)의 값은 1또는 0으로만 이루어져 있습니다.

## 🙋‍♂️나의 풀이

[땅따먹기 문제](https://han-joon-hyeok.github.io/posts/programmers-hopscotch/)처럼 DP로 접근해야겠다고 생각했지만, 규칙을 찾지 못해서 다른 분들의 풀이를 참고해서 풀었다.

### 작성 코드

```javascript
function solution(board) {
  const ROWS = board.length;
  const COLS = board[0].length;

  for (let row = 1; row < ROWS; row++) {
    for (let col = 1; col < COLS; col++) {
      if (board[row][col] !== 0) {
        board[row][col] =
          Math.min(
            board[row - 1][col - 1],
            board[row - 1][col],
            board[row][col - 1]
          ) + 1;
      }
    }
  }

  const max = board.reduce((acc, curr) => Math.max(acc, ...curr), 0);

  return max * max;
}
```

규칙은 다음과 같다.

- 전체 배열을 돌면서 $(i, j)$ 위치의 값을 왼쪽 $(i, j-1)$, 왼쪽 대각선 위 $(i-1, j-1)$, 위쪽 $(i-1, j)$ 값 중 최솟값 + 1 을 갱신한다. $(i, j \ge 1)$

```javascript
[
  [0, 1],
  [1, 1],
];
```

- 위의 배열에서 구할 수 있는 최대 정사각형의 한 변의 길이는 1 이다.
- 최솟값은 0 이기 때문에 (1, 1) 자리에는 0 + 1 을 수행한다.

```javascript
[
  [0, 1, 1],
  [1, 1, 1],
];
```

- 위의 배열에서 최대 정사각형의 한 변의 길이는 2 가 된다.
- (2, 2) 자리에서 구할 수 있는 최솟값은 모두 1 이기 때문에 해당 자리를 2 로 갱신한다.
- 이러한 과정을 통해 한 변의 길이가 1인 정사각형부터 시작해서 변의 길이가 1 씩 길어지는 정사각형을 발견할 수 있다.
- 만약 0 을 만나게 된다면 해당 자리는 변이 이어지지 않는 것이므로 별 다른 수행 없이 지나간다.

```javascript
// 원본 배열
[
  [0, 1, 1, 1],
  [1, 1, 1, 1],
  [1, 1, 1, 1],
];
```

```javascript
// 규칙 적용 후 배열
[
  [0, 1, 1, 1], // -> 1행은 2행이 존재하지 않는다면 최대 변의 길이는 1밖에 안됨
  [1, 1, 2, 2],
  [1, 2, 2, 3],
]; // -> 정사각형의 최대 변의 길이는 모든 행에서 최댓값인 수가 됨
```

- 위와 같은 규칙을 적용해서 예제에서 주어진 배열에서 탐색한 결과이다.
- 결국 정사각형의 한 변의 길이가 가질 수 있는 최댓값은 변경된 배열에서 모든 배열 중에서 최댓값을 찾으면 된다.

# 참고자료

- [[프로그래머스] 가장 큰 정사각형 찾기 | JavaScript](https://onlydev.tistory.com/65)
- [[프로그래머스] 가장 큰 정사각형 찾기 - C++](https://donggoolosori.github.io/2020/12/20/pgmsquare/)
