---
title: 프로그래머스 Level 2 - 행렬의 곱셈 (JavaScript)
date: 2021-11-22 11:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 행렬의 곱셈](https://programmers.co.kr/learn/courses/30/lessons/12949)

# 문제 설명

2차원 행렬 arr1과 arr2를 입력받아, arr1에 arr2를 곱한 결과를 반환하는 함수, solution을 완성해주세요.

## 제한사항

- 행렬 arr1, arr2의 행과 열의 길이는 2 이상 100 이하입니다.
- 행렬 arr1, arr2의 원소는 -10 이상 20 이하인 자연수입니다.
- 곱할 수 있는 배열만 주어집니다.

## 🙋‍♂️나의 풀이

처음에는 두 번째 행렬을 전치행렬로 바꾸어서 계산을 하려고 했지만, 흐름을 이해 못해서 결국 다른 사람들의 풀이를 보고 이해했다. 다시 풀어봐야 하는 문제.

### 작성 코드

```javascript
function solution(arr1, arr2) {
  const result = [];
  for (let i = 0; i < arr1.length; i++) {
    const row = [];
    for (let j = 0; j < arr2[0].length; j++) {
      let sum = 0;
      for (let k = 0; k < arr2.length; k++) {
        sum += arr1[i][k] * arr2[k][j];
      }
      row.push(sum);
    }
    result.push(row);
  }
  return result;
}
```

- 3중 반복문으로 푸는 방법이다.
- 외부 - 중간 - 내부의 구조라고 하면, 외부 반복문은 첫 번째 행렬의 행의 개수를 기준으로, 중간 반복문은 두 번째 행렬의 열의 개수를 기준으로, 내부 반복문은 두 번째 행렬의 행의 개수를 기준으로 한다.
- 그리고 다음의 그림과 같이 첫 번째 행렬의 행 만큼 연산을 반복한다.
  ![picture](/assets/images/2021-11-22-programmers-multiply-of-matrix/picture.png)

## 👀참고한 풀이

```javascript
function solution(arr1, arr2) {
  return arr1.map((row) =>
    arr2[0].map((x, y) => row.reduce((a, b, c) => a + b * arr2[c][y], 0))
  );
}
```

- map과 reduce를 이용해서 풀이한 코드이다.
- 3중 반복문의 동작 원리와 같다.
