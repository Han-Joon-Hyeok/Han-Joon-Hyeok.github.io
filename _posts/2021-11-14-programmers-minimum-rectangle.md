---
title: 프로그래머스 Level 1 - 최소직사각형 (JavaScript)
date: 2021-11-14 17:55:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 최소직사각형](https://programmers.co.kr/learn/courses/30/lessons/86491)

# 문제 설명

명함 지갑을 만드는 회사에서 지갑의 크기를 정하려고 합니다. 다양한 모양과 크기의 명함들을 모두 수납할 수 있으면서, 작아서 들고 다니기 편한 지갑을 만들어야 합니다. 이러한 요건을 만족하는 지갑을 만들기 위해 디자인팀은 모든 명함의 가로 길이와 세로 길이를 조사했습니다.

( ... 예시 생략 ... )

모든 명함의 가로 길이와 세로 길이를 나타내는 2차원 배열 sizes가 매개변수로 주어집니다. 모든 명함을 수납할 수 있는 가장 작은 지갑을 만들 때, 지갑의 크기를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- sizes의 길이는 1 이상 10,000 이하입니다.
  - sizes의 원소는 [w, h] 형식입니다.
  - w는 명함의 가로 길이를 나타냅니다.
  - h는 명함의 세로 길이를 나타냅니다.
  - w와 h는 1 이상 1,000 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 가로나 세로는 언제든 바꿀 수 있다.
- 모든 명함 중에서 가로든 세로든 각각 가장 긴 길이를 구해야 한다.

### 작성 코드

```javascript
function solution(sizes) {
  const x = [];
  const y = [];

  sizes.map((size) => {
    size.sort((a, b) => a - b);
    x.push(size[0]);
    y.push(size[1]);
  });

  return Math.max(...x) * Math.max(...y);
}
```

- 내부 배열을 오름차순으로 정렬한 뒤, 별도의 배열에 추가했다.
- 각각의 배열에서 가장 큰 값을 구한 다음 곱해주었다.

## 👀참고한 풀이

```javascript
function solution(sizes) {
  const [hor, ver] = sizes.reduce(
    ([h, v], [a, b]) => [
      Math.max(h, Math.max(a, b)),
      Math.max(v, Math.min(a, b)),
    ],
    [0, 0]
  );
  return hor * ver;
}
```

- 두 값 중에서 큰 값과 작은 값을 나눈다.
- 그리고 각각 분류된 값들 중에서 가장 큰 값을 accumulator 값에 갱신한다.
