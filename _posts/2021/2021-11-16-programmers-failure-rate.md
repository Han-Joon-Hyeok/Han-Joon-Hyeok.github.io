---
title: 프로그래머스 Level 1 - 실패율 (JavaScript)
date: 2021-11-16 12:25:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 실패율](https://programmers.co.kr/learn/courses/30/lessons/42889)

# 문제 설명

슈퍼 게임 개발자 오렐리는 큰 고민에 빠졌다. 그녀가 만든 프랜즈 오천성이 대성공을 거뒀지만, 요즘 신규 사용자의 수가 급감한 것이다. 원인은 신규 사용자와 기존 사용자 사이에 스테이지 차이가 너무 큰 것이 문제였다.

이 문제를 어떻게 할까 고민 한 그녀는 동적으로 게임 시간을 늘려서 난이도를 조절하기로 했다. 역시 슈퍼 개발자라 대부분의 로직은 쉽게 구현했지만, 실패율을 구하는 부분에서 위기에 빠지고 말았다. 오렐리를 위해 실패율을 구하는 코드를 완성하라.

- 실패율은 다음과 같이 정의한다.
  - 스테이지에 도달했으나 아직 클리어하지 못한 플레이어의 수 / 스테이지에 도달한 플레이어 수

전체 스테이지의 개수 N, 게임을 이용하는 사용자가 현재 멈춰있는 스테이지의 번호가 담긴 배열 stages가 매개변수로 주어질 때, 실패율이 높은 스테이지부터 내림차순으로 스테이지의 번호가 담겨있는 배열을 return 하도록 solution 함수를 완성하라.

## 제한사항

- 스테이지의 개수 N은 `1` 이상 `500` 이하의 자연수이다.
- stages의 길이는 `1` 이상 `200,000` 이하이다.
- stages에는 `1` 이상 `N + 1` 이하의 자연수가 담겨있다.
  - 각 자연수는 사용자가 현재 도전 중인 스테이지의 번호를 나타낸다.
  - 단, `N + 1` 은 마지막 스테이지(N 번째 스테이지) 까지 클리어 한 사용자를 나타낸다.
- 만약 실패율이 같은 스테이지가 있다면 작은 번호의 스테이지가 먼저 오도록 하면 된다.
- 스테이지에 도달한 유저가 없는 경우 해당 스테이지의 실패율은 `0` 으로 정의한다.

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(N, stages) {
  const stageFailureRate = {};

  for (let i = 1; i <= N; i++) {
    const participants = stages.filter((stage) => stage >= i).length;
    const fail = stages.filter((stage) => stage === i).length;
    const failureRate = fail / participants;
    stageFailureRate[i] = failureRate;
  }

  const result = Object.entries(stageFailureRate)
    .sort(([, a], [, b]) => b - a)
    .reduce((acc, [stage]) => [...acc, +stage], []);

  return result;
}
```

- 스테이지 통과한 사람과 실패한 사람들 `filter` 로 구한 다음, 각 스테이지 별 실패율을 객체에 저장했다.
- 객체를 `[key, value]` 형태로 바꾸고, 실패율을 내림차순으로 정렬했다. key는 string으로 저장되기 때문에 number로 형변환을 했다.
- 실행 속도가 5000ms 이상으로 느려지는 문제가 있다. 반복문 안에서 또 `filter` 로 반복을 하거나, 배열 안에서 `sort` 를 수행하고 나서 `reduce` 를 수행하면서 시간복잡도가 많이 증가했다.

## 👀참고한 풀이

```javascript
function solution(N, stages) {
  let stageCount = new Array(N);
  let failPer = [];
  stageCount.fill(0);

  let usersNum = stages.length;
  for (let val of stages) {
    stageCount[val - 1]++;
  }

  for (let i = 0; i < N; i++) {
    if (usersNum === 0) {
      failPer.push({ failper: 0, stageNum: i + 1 });
    } else {
      failPer.push({ failper: stageCount[i] / usersNum, stageNum: i + 1 });
    }
    usersNum -= stageCount[i];
  }

  failPer.sort((a, b) => {
    if (a.failper === b.failper) {
      return a.stageNum - b.stageNum;
    }
    return b.failper - a.failper;
  });

  return failPer.map((item) => {
    return item.stageNum;
  });
}
```

- 실행 속도가 빠른 코드를 참고했다.
- 배열에 각 스테이지 별 인원 수를 먼저 구하고, 실패율을 객체로 담아서 배열에 저장했다.
- 스테이지 별 인원만 체크하면 되기 때문에 속도가 비교적 빠르다.

## ⚙️ Refactoring

```javascript
function solution(N, stages) {
  const failureRateOfStage = [];
  const stageCount = new Array(N).fill(0);
  stages.forEach((stage) => stageCount[stage - 1]++);

  let usersCount = stages.length;
  for (let i = 0; i < N; i++) {
    failureRateOfStage.push({ stage: i + 1, rate: stageCount[i] / usersCount });
    usersCount -= stageCount[i];
  }

  failureRateOfStage.sort((a, b) => b.rate - a.rate);

  const result = failureRateOfStage.map((info) => info.stage);

  return result;
}
```

- 참고한 풀이에서 불필요한 로직을 제거해서 짧은 코드로 만들었다.

# 참고자료

- [객체를 value로 정렬하기](https://kyounghwan01.github.io/blog/JS/JSbasic/object-sort/#object-entries-reduce%E1%84%85%E1%85%B3%E1%86%AF-%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A1%E1%86%AB-%E1%84%87%E1%85%A1%E1%86%BC%E1%84%87%E1%85%A5%E1%86%B8)
