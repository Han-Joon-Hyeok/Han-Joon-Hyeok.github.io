---
title: 프로그래머스 Level 1 - 로또의 최고 순위와 최저 순위
date: 2021-11-03 15:45:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level 1 로또의 최고 순위와 최저 순위](https://programmers.co.kr/learn/courses/30/lessons/77484)

# 문제 설명

로또를 구매한 민우는 당첨 번호 발표일을 학수고대하고 있었습니다. 하지만, 민우의 동생이 로또에 낙서를 하여, 일부 번호를 알아볼 수 없게 되었습니다. 당첨 번호 발표 후, 민우는 자신이 구매했던 로또로 당첨이 가능했던 최고 순위와 최저 순위를 알아보고 싶어 졌습니다.알아볼 수 없는 번호를 `0`으로 표기하기로 하고, 민우가 구매한 로또 번호 6개가 `44, 1, 0, 0, 31 25`라고 가정해보겠습니다. 당첨 번호 6개가 `31, 10, 45, 1, 6, 19`라면, 당첨 가능한 최고 순위와 최저 순위의 한 예는 아래와 같습니다.

- 순서와 상관없이, 구매한 로또에 당첨 번호와 일치하는 번호가 있으면 맞힌 걸로 인정됩니다.
- 알아볼 수 없는 두 개의 번호를 각각 10, 6이라고 가정하면 3등에 당첨될 수 있습니다.
  - 3등을 만드는 다른 방법들도 존재합니다. 하지만, 2등 이상으로 만드는 것은 불가능합니다.
- 알아볼 수 없는 두 개의 번호를 각각 11, 7이라고 가정하면 5등에 당첨될 수 있습니다.
  - 5등을 만드는 다른 방법들도 존재합니다. 하지만, 6등(낙첨)으로 만드는 것은 불가능합니다.

민우가 구매한 로또 번호를 담은 배열 lottos, 당첨 번호를 담은 배열 win_nums가 매개변수로 주어집니다. 이때, 당첨 가능한 최고 순위와 최저 순위를 차례대로 배열에 담아서 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- lottos는 길이 6인 정수 배열입니다.
- lottos의 모든 원소는 0 이상 45 이하인 정수입니다.
  - 0은 알아볼 수 없는 숫자를 의미합니다.
  - 0을 제외한 다른 숫자들은 lottos에 2개 이상 담겨있지 않습니다.
  - lottos의 원소들은 정렬되어 있지 않을 수도 있습니다.
- win_nums은 길이 6인 정수 배열입니다.
- win_nums의 모든 원소는 1 이상 45 이하인 정수입니다.
  - win_nums에는 같은 숫자가 2개 이상 담겨있지 않습니다.
  - win_nums의 원소들은 정렬되어 있지 않을 수도 있습니다.

## 🙋‍♂️나의 풀이

- `lottos` 배열에서 정답 개수와 0의 개수를 구한다.
- 최대 개수는 정답 개수 + 0의 개수, 최소 개수는 정답 개수이다.
- 순위를 구하는 함수인 `getRank` 를 별도로 작성하여 최대, 최소 순위를 구했다.

```jsx
function solution(lottos, win_nums) {
  const answer_cnt = lottos.filter((lotto) => win_nums.includes(lotto)).length;
  const zero_cnt = lottos.filter((lotto) => lotto === 0).length;

  const max = getRank(answer_cnt + zero_cnt);
  const min = getRank(answer_cnt);

  return [max, min];
}

function getRank(cnt) {
  if (cnt < 1) {
    return 6;
  } else {
    return 7 - cnt;
  }
}
```

## 👀참고한 풀이

```jsx
function solution(lottos, win_nums) {
  const rank = [6, 6, 5, 4, 3, 2, 1];

  let minCount = lottos.filter((v) => win_nums.includes(v)).length;
  let zeroCount = lottos.filter((v) => !v).length;

  const maxCount = minCount + zeroCount;

  return [rank[maxCount], rank[minCount]];
}
```

- `rank` 배열에 정답 개수를 인덱스로 하여 각각 원소가 6위부터 1위까지 반환되도록 저장했다.
  - rank[정답수] = 순위
- 최대 정답 수는 최소 정답 수 + 0의 개수이다.
- 0의 개수를 세기 위해 사용한 `filter` 에서 `!v` 는 0이 `false`인 것을 이용한 것이다.
