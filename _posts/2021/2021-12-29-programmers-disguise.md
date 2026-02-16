---
title: 프로그래머스 Level 2 - 위장 (JavaScript)
date: 2021-12-29 20:20:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 위장](https://programmers.co.kr/learn/courses/30/lessons/42578#)

# 문제 설명

---

스파이들은 매일 다른 옷을 조합하여 입어 자신을 위장합니다.

예를 들어 스파이가 가진 옷이 아래와 같고 오늘 스파이가 동그란 안경, 긴 코트, 파란색 티셔츠를 입었다면 다음날은 청바지를 추가로 입거나 동그란 안경 대신 검정 선글라스를 착용하거나 해야 합니다.

(예시 생략)

스파이가 가진 의상들이 담긴 2차원 배열 clothes가 주어질 때 서로 다른 옷의 조합의 수를 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- clothes의 각 행은 [의상의 이름, 의상의 종류]로 이루어져 있습니다.
- 스파이가 가진 의상의 수는 1개 이상 30개 이하입니다.
- 같은 이름을 가진 의상은 존재하지 않습니다.
- clothes의 모든 원소는 문자열로 이루어져 있습니다.
- 모든 문자열의 길이는 1 이상 20 이하인 자연수이고 알파벳 소문자 또는 '\_' 로만 이루어져 있습니다.
- 스파이는 하루에 최소 한 개의 의상은 입습니다.

## 🙋‍♂️나의 풀이

카테고리를 해시 테이블로 구분한 다음, 각 카테고리에 속한 개수 만큼 곱해서 경우의 수를 구한 결과에 전체 옷의 개수를 더하려고 했다.

예를 들어, 모자가 3개, 안경이 2개면 경우의 수는 3 x 2 이고, 전체 옷의 개수는 5 이므로 6 + 5 = 11 로 생각했다.

하지만, 카테고리가 3개 이상이 되면 같은 논리를 적용할 수 없다. 모자가 2개, 안경 1개, 바지 1개라고 하면, 실제로 조합할 수 있는 경우의 수는 11 이지만, 위의 논리를 적용하면 4 + (2 x 1 x 1) = 6 이 된다.

다른 분들의 풀이를 참고해보니, 각 경우의 수마다 입지 않는 경우를 하나씩 추가해서 곱해주고, 마지막에 아무 것도 입지 않는 1가지 경우를 빼는 것으로 문제를 해결했다. 예를 들어 상의가 A개, 하의가 B개이면, 상의만 선택하고 하의를 선택하지 않는 경우와 하의만 선택하고 상의를 선택하지 않을 수도 있다. 그렇기에 (A+1) x (B+1) 의 경우의 수가 나오며, 이 경우의 수에는 아무 것도 선택하지 않는 경우도 포함되어 있으므로 -1 을 하는 것이다.

### 작성 코드

```javascript
function solution(clothes) {
  const HASH_TABLE = {};
  let answer = 1;

  clothes.forEach((cloth) => {
    const [item, category] = cloth;
    HASH_TABLE[category] = HASH_TABLE[category]
      ? [...HASH_TABLE[category], item]
      : [item];
  });

  for (const [key, value] of Object.entries(HASH_TABLE)) {
    answer *= value.length + 1;
  }

  return answer - 1;
}
```

## 👀참고한 풀이

```javascript
function solution(clothes) {
  return (
    Object.values(
      clothes.reduce((obj, [_, category]) => {
        obj[category] = obj[category] ? obj[category] + 1 : 1;
        return obj;
      }, {})
    ).reduce((acc, curr) => acc * (curr + 1), 1) - 1
  );
}
```

- `clothes` 의 카테고리 별 개수를 해시 테이블 형태로 만들기 위해 `reduce` 를 사용했다.
- `Object.values` 를 사용해서 각각의 키가 가진 값을 배열 형태로 반환한다. 즉, 카테고리 별 옷의 개수를 배열 형태로 반환하는 것이다.
- 그리고 다시 반환된 배열을 `reduce` 를 사용해서 `옷의 개수 + 1` 을 곱해주고, 마지막에 -1 을 했다.
