---
title: 프로그래머스 Level 2 - 카펫 (JavaScript)
date: 2021-12-30 21:00:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 카펫](https://programmers.co.kr/learn/courses/30/lessons/42842)

# 문제 설명

---

Leo는 카펫을 사러 갔다가 아래 그림과 같이 중앙에는 노란색으로 칠해져 있고 테두리 1줄은 갈색으로 칠해져 있는 격자 모양 카펫을 봤습니다.

(사진 생략)

Leo는 집으로 돌아와서 아까 본 카펫의 노란색과 갈색으로 색칠된 격자의 개수는 기억했지만, 전체 카펫의 크기는 기억하지 못했습니다.

Leo가 본 카펫에서 갈색 격자의 수 brown, 노란색 격자의 수 yellow가 매개변수로 주어질 때 카펫의 가로, 세로 크기를 순서대로 배열에 담아 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 갈색 격자의 수 brown은 8 이상 5,000 이하인 자연수입니다.
- 노란색 격자의 수 yellow는 1 이상 2,000,000 이하인 자연수입니다.
- 카펫의 가로 길이는 세로 길이와 같거나, 세로 길이보다 깁니다.

## 🙋‍♂️나의 풀이

그림을 직접 그리면서 이해를 하니까 생각보다 쉽게 풀렸다.

다음과 같은 과정을 거쳐서 답을 구했다.

1. 카펫의 세로는 무조건 3 이상이다.
   - 노란색 격자가 중앙에 있고, 노란색 격자를 둘러싼 갈색 격자는 무조건 1칸씩 차지하려면 만족해야 하는 조건이다.
2. 카펫의 모양을 만족하는 가로, 세로의 길이는 `(가로 - 2) * (세로 - 2) === 노란색 격자 개수` 을 만족해야 한다.
3. 만들어질 수 있는 모든 가로, 세로 길이의 경우를 구하기 위해 전체 격자 개수의 약수들을 구한다.
   - 예를 들어, 갈색 격자 24개, 노란색 격자 24개일 때, 전체 격자의 개수는 48이다. 48의 약수 중에서 약수끼리 곱했을 때 48이 나오는 약수의 쌍을 구한다.
   - [1, 48], [2, 24], ..., [48, 1]
4. 약수의 쌍을 구하기 위해 전체 격자 개수를 3 부터 전체 격자 개수의 제곱근까지 나눈 나머지를 구한다. 나머지가 0이 아니라면 약수가 아니므로 다음 수로 넘어간다.

   - 약수의 쌍을 전체 격자 개수의 제곱근까지만 구하는 이유는 약수의 대칭성에 근거한다. 이로 인해 훨씬 빠르게 약수의 쌍을 구할 수 있다. (참고자료 : [소수 판별 알고리즘](https://han-joon-hyeok.github.io/posts/TIL-check-prime-number/))

5. 1번과 2번의 조건을 만족하는 순서쌍을 반환한다.

### 작성 코드

```javascript
function solution(brown, yellow) {
  const TOTAL = brown + yellow;

  for (let height = 3; height <= Math.sqrt(TOTAL); height++) {
    const remainder = TOTAL % height;

    if (remainder !== 0) continue;

    const width = TOTAL / height;
    if ((width - 2) * (height - 2) === yellow) {
      return [width, height];
    }
  }
}
```
