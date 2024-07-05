---
title: "프로그래머스 Level 1 - [PCCE 기출문제] 9번 / 이웃한 칸 (Java)"
date: 2024-07-04 09:50:00 +0900
categories: [programmers]
tags: [level1, programmers, Java]
use_math: true
---

> [프로그래머스 - Level1 [PCCE 기출문제] 9번 / 이웃한 칸](https://school.programmers.co.kr/learn/courses/30/lessons/250125?language=java#)
>

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

- n * n 정사각형 보드판에서 주어진 좌표의 상, 하, 좌, 우에 적힌 색깔을 확인해야 한다.
- 현재 좌표(w, h)를 기준으로 상, 하, 좌, 우의 위치를 찾기 위해 `directions` int 2중 배열을 선언했다.

    ```java
    static final int[][] directions = {
        //h, w
        {-1, 0},  // 상
        {1, 0},   // 하
        {0, -1},  // 좌
        {0, 1},   // 우
    };
    ```

    - 배열의 값은 [y, x] 순서로 넣었다.
- `directions` 배열을 순회하며 상, 하, 좌, 우의 좌표가 보드판의 길이를 벗어나지 않는지 확인한다.
- 보드판 내에 있는 좌표라면 색깔을 확인한다.

## ✍️작성 코드

```java
class Solution {
    static final int[][] directions = {
        //h, w
        {-1, 0},  // 상
        {1, 0},   // 하
        {0, -1},  // 좌
        {0, 1},   // 우
    };

    private boolean isOutOfRange(int x, int y, int boardLength) {
        if (x < 0 || x >= boardLength) {
            return true;
        }
        if (y < 0 || y >= boardLength) {
            return true;
        }
        return false;
    }

    public int solution(String[][] board, int h, int w) {
        int count = 0;
        int boardLength = board.length;
        String color = board[h][w];

        for (int idx = 0; idx < directions.length; idx += 1) {
            int x = w + directions[idx][1];
            int y = h + directions[idx][0];

            if (isOutOfRange(x, y, boardLength)) {
                continue;
            }

            String targetColor = board[y][x];

            if (targetColor.equals(color)) {
                count += 1;
            }
        }

        return count;
    }
}
```

# 👀참고한 풀이

```java
class Solution {
    public int solution(String[][] board, int h, int w) {
        int answer = 0;
        String sC = board[h][w];

        if(h > 0 && sC.equals(board[h-1][w])) answer++;
        if(h < board.length - 1 && sC.equals(board[h+1][w])) answer++;
        if(w > 0 && sC.equals(board[h][w-1])) answer++;
        if(w < board[h].length - 1 && sC.equals(board[h][w+1])) answer++;
        return answer;
    }
}
```

- 반복문 없이 조건문만을 이용해서 간단하게 해결한 코드다.
- 각 if 조건문의 첫 번째 조건이 보드판의 범위를 벗어나지 않는 지 확인하는 것이고, 두 번째 조건은 색깔을 확인하는 것이다.
- if 문은 상-하-좌-우 순서대로 좌표를 확인한다.