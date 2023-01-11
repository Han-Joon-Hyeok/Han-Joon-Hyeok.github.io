---
title: 프로그래머스 Level 2 - 땅따먹기 (JavaScript)
date: 2021-11-25 17:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 땅따먹기](https://programmers.co.kr/learn/courses/30/lessons/12913#)

# 문제 설명

---

땅따먹기 게임을 하려고 합니다. 땅따먹기 게임의 땅(land)은 총 N행 4열로 이루어져 있고, 모든 칸에는 점수가 쓰여 있습니다. 1행부터 땅을 밟으며 한 행씩 내려올 때, 각 행의 4칸 중 한 칸만 밟으면서 내려와야 합니다. **단, 땅따먹기 게임에는 한 행씩 내려올 때, 같은 열을 연속해서 밟을 수 없는 특수 규칙이 있습니다.**

예를 들면,

| 1 | 2 | 3 | 5 |

| 5 | 6 | 7 | 8 |

| 4 | 3 | 2 | 1 |

로 땅이 주어졌다면, 1행에서 네번째 칸 (5)를 밟았으면, 2행의 네번째 칸 (8)은 밟을 수 없습니다.

마지막 행까지 모두 내려왔을 때, 얻을 수 있는 점수의 최대값을 return하는 solution 함수를 완성해 주세요. 위 예의 경우, 1행의 네번째 칸 (5), 2행의 세번째 칸 (7), 3행의 첫번째 칸 (4) 땅을 밟아 16점이 최고점이 되므로 16을 return 하면 됩니다.

## 제한사항

- 행의 개수 N : 100,000 이하의 자연수
- 열의 개수는 4개이고, 땅(land)은 2차원 배열로 주어집니다.
- 점수 : 100 이하의 자연수

## 🙋‍♂️나의 풀이

처음에는 각 행에서 가장 큰 값을 선택하는 그리디 알고리즘으로 구현했지만, 결국 다른 분들의 풀이를 참고해서 DP(Dynamic Programming) 로 해결했다.

### Dynamic Programming

동적 계획법은 하나의 문제는 단 한 번만 풀도록 하는 알고리즘이다.

일반적으로 피보나치 수열을 재귀함수로 구현하는 경우, 다음과 같이 구현할 수 있다.

```javascript
function fibo(n) {
  if (n == 1) return 1;
  if (n == 2) return 1;
  return fibo(n - 1) + fibo(n - 2);
}
```

하지만 위의 코드는 계산 횟수가 $2^n$ 만큼 증가하는 문제점을 가지고 있다. 이는 이미 구했던 값을 따로 저장하지 않고, 다시 값을 구하려고 하기 때문에 생기는 문제이다. 작동 과정을 간략하게 표현하면 다음과 같다.

```javascript
fibo(5) = fibo(4) + fibo(3)
fibo(5) = (fibo(3) + fibo(2)) + (fibo(2) + fibo(1))
fibo(5) = ((fibo(2) + fibo(1)) + fibo(2)) + (fibo(2) + fibo(1))
```

이처럼 이미 값을 구한 값에 대해서 다시 계산을 하는 것은 비효율적이다.

이러한 문제를 해결하기 위해서 계산한 결과를 저장하는 메모이제이션(Memoization)을 도입한 것이 동적 계획법이다.

동적 계획법의 알고리즘은 다음과 같다.

1. 문제를 부분 문제로 나눈다.
2. 가장 작은 문제의 해를 구한 뒤, 테이블에 저장한다.
3. 테이블에 저장된 데이터로 전체 문제의 해를 구한다.

피보나치 수열을 동적 계획법으로 작성하면 다음과 같다.

```javascript
const arr = [];

function fibo(n) {
  if (n === 1) return 1;
  if (n === 2) return 1;
  if (arr[n]) return arr[n];
  arr[n] = fibo(n - 1) + fibo(n - 2);
  return arr[n];
}
```

### 작성 코드

```javascript
function solution(land) {
  for (let i = 1; i < land.length; i++) {
    const previousRow = land[i - 1];
    const previousMax = Math.max(...previousRow);
    const previousColumn = previousRow.indexOf(previousMax);
    const currentRow = land[i];
    for (
      let currentColumn = 0;
      currentColumn < currentRow.length;
      currentColumn++
    ) {
      if (currentColumn === previousColumn) {
        const sliced = [
          ...previousRow.slice(0, previousColumn),
          ...previousRow.slice(previousColumn + 1),
        ];
        currentRow[currentColumn] += Math.max(...sliced);
        continue;
      }
      currentRow[currentColumn] += previousMax;
    }
  }

  return Math.max(...land[land.length - 1]);
}
```

- 2중 반복문을 사용해서 이전 행에서 열이 같지 않은 최댓값을 현재 행에 모두 더하도록 했다.
  - 외부 반복문은 행의 개수만큼, 내부 반복문은 열의 개수만큼 반복
  - 부분합을 구하기 위해서는 2행부터 시작해야 한다.

```
// 원본 배열
[1, 2, 3, 5]
[5, 6, 7, 8] --> 2행부터 부분합 구하기 시작
[4, 3, 2, 1]

// 부분합
[1, 2, 3, 4]
[10, 11, 12, 12]
[16, 15, 14, 13] --> 마지막 배열의 최댓값만 반환하면 됨
```

- 현재 행의 열이 이전 행의 최댓값의 열과 같으면 이전 행에서 해당 열만 제외해서 slice 해서 하나로 합친 뒤, 최댓값을 구했다.

## 👀참고한 풀이

```javascript
function solution(land) {
  return Math.max(
    ...land.reduce(
      (a, c) => {
        return [
          c[0] + Math.max(a[1], a[2], a[3]),
          c[1] + Math.max(a[0], a[2], a[3]),
          c[2] + Math.max(a[0], a[1], a[3]),
          c[3] + Math.max(a[0], a[1], a[2]),
        ];
      },
      [0, 0, 0, 0]
    )
  );
}
```

- 열이 4개라서 가능한 풀이지만, `reduce` 를 사용하면 간단하게 표현할 수 있다.

```javascript
function solution(land) {
  let max = 0; //최대값
  let idx = 0; //최대값의 인덱스

  for (let i = 1; i < land.length; i++) {
    max = Math.max(...land[i - 1]);
    idx = land[i - 1].indexOf(max);
    land[i - 1][idx] = 0; //최대값을 0으로 재할당 => 동일한 인덱스일 때 2번째 최대값으로 처리
    land[i] = land[i].map(
      (v, j) => (v += j == idx ? Math.max(...land[i - 1]) : max)
    );
  }

  return Math.max(...land[land.length - 1]);
}
```

- 최댓값과 최댓값의 인덱스를 전역 변수로 저장하고, 이전 행의 최댓값을 0으로 바꾸어서 2번째 최댓값을 구할 수 있도록 했다.

# 참고자료

- [피보나치 수열과 프로그래머스 땅따먹기 문제로 알아보는 Dynamic Programming (동적 프로그래밍)](https://shanepark.tistory.com/183)
  - 자바로 코드가 작성되어 있긴 하지만, 설명을 자세하게 해주셔서 이해하기 쉬웠다.
- [안경잡이 개발자 20. 다이나믹 프로그래밍 (Dynamic Programming)](https://blog.naver.com/ndb796/221233570962)
