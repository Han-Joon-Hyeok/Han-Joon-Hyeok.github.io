---
title: "프로그래머스 Level 0 - 평행 (Java)"
date: 2024-07-09 15:00:00 +0900
categories: [programmers]
tags: [level1, programmers, Java]
use_math: true
---
> [프로그래머스 - Level0 평행](https://school.programmers.co.kr/learn/courses/30/lessons/120875?language=java#)
>

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

- 점을 각각 a, b, c, d 이라 하고, 각 점을 이어서 직선 2개를 만들 수 있는 경우의 수는 총 3가지이다.
    1. (a - b) 와 (c - d)
    2. (a - c) 와 (b - d)
    3. (a - d) 와 (b - c)
- 3가지 경우의 수에서 각 점들을 이은 직선들의 기울기를 비교한다.
- 주어진 점의 개수는 4개로 일정하기 때문에 하드 코드를 할 수도 있었지만, 최대한 하드 코드 없이 풀고자 했다.
    - 점의 좌표가 배열로 주어지는데, 배열의 인덱스를 이용해서 직선의 기울기를 구한다.

    ```jsx
    [[1, 1], [2, 2], [3, 3], [4, 4]]
    //  0       1       2       3
    ```

    - 위와 같은 인덱스로 주어지는데, 인덱스의 쌍으로 비교할 직선의 기울기를 작성하면 아래와 같다.

    ```jsx
    (0 - 1), (2 - 3)
    (0 - 2), (1 - 3)
    (0 - 3), (1 - 2)
    ```

    - 위의 인덱스 쌍에서 규칙을 발견할 수 있었다.
        - 좌측의 인덱스 쌍은 0 을 고정하고 1 부터 3 까지 증가시킨다.
        - 우측의 인덱스 쌍은 반복문을 이용하면 만들 수 있는 쌍이다.
    - 조금 억지로 갖다붙인 규칙같지만, 아무튼 코드로 작성했다.

## ✍️작성 코드

```java
import java.util.List;
import java.util.ArrayList;

class Solution {
    public int solution(int[][] dots) {
        List<Double> slopes1 = new ArrayList<>();
        List<Double> slopes2 = new ArrayList<>();

        for (int idx = 1; idx < dots.length; idx += 1) {
            int dx = dots[idx][0] - dots[0][0];
            int dy = dots[idx][1] - dots[0][1];
            slopes1.add((double) dy / dx);
        }

        for (int idx = 3; idx >= 2; idx -= 1) {
            for (int idx2 = idx - 1; idx2 >= 1; idx2 -= 1) {
                int dx = dots[idx][0] - dots[idx2][0];
                int dy = dots[idx][1] - dots[idx2][1];
                slopes2.add((double) dy / dx);
            }
        }

        Double[] arr1 = slopes1.toArray(new Double[slopes1.size()]);
        Double[] arr2 = slopes2.toArray(new Double[slopes2.size()]);

        for (int idx = 0; idx < arr1.length; idx += 1) {
            if (arr1[idx].equals(arr2[idx])) {
                return 1;
            }
        }

        return 0;
    }
}
```

- 특정 테스트 케이스 하나만 통과하지 않았는데, 직선의 기울기가 실수인 경우였다.
- 실수로 변환하기 위해서 `(double) dy / dx` 와 같이 작성해주어야 한다.

# 👀참고한 풀이

```java
class Solution {
    int[][] dots;

    public int solution(int[][] dots) {
        this.dots = dots;
        if (isParallel(0, 1, 2, 3)) return 1;
        if (isParallel(0, 2, 1, 3)) return 1;
        if (isParallel(0, 3, 1, 2)) return 1;
        return 0;
    }

    boolean isParallel(int a, int b, int c, int d) {
        int x = (dots[a][0] - dots[b][0]) * (dots[c][1] - dots[d][1]);
        int y = (dots[a][1] - dots[b][1]) * (dots[c][0] - dots[d][0]);
        return x == y;
    }
}
```

- 훨씬 깔끔하고 간단하게 해결한 코드다.
- 두 직선이 평행하다면 두 직선의 기울기도 같을 것이다.
    - 즉, (y2 - y1) / (x2 - x1) = (y4 - y3) / (x4 - x3) 라는 식이 성립한다.
    - 분모를 없애고 식을 정리하면 (y2 - y1) * (x4 - x3) = (y4 - y3) * (x2 - x1) 이 된다.
    - 이 식을 이용해서 `isParallel` 이라는 함수를 만든 것이다.