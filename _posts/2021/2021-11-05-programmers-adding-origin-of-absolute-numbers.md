---
title: 프로그래머스 Level 1 - 음양 더하기 (javascript)
date: 2021-11-05 21:40:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 음양 더하기](https://programmers.co.kr/learn/courses/30/lessons/76501?language=javascript)

# 문제 설명

어떤 정수들이 있습니다. 이 정수들의 절댓값을 차례대로 담은 정수 배열 absolutes와 이 정수들의 부호를 차례대로 담은 불리언 배열 signs가 매개변수로 주어집니다. 실제 정수들의 합을 구하여 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- absolutes의 길이는 1 이상 1,000 이하입니다.
  - absolutes의 모든 수는 각각 1 이상 1,000 이하입니다.
- signs의 길이는 absolutes의 길이와 같습니다.
  - `signs[i]` 가 참이면 `absolutes[i]` 의 실제 정수가 양수임을, 그렇지 않으면 음수임을 의미합니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(absolutes, signs) {
  return absolutes.reduce(
    (acc, cur, idx) => (signs[idx] ? acc + cur : acc - cur),
    0
  );
}
```

- 숫자와 부호의 순서가 같다는 점을 이용해서 인덱스를 동시에 사용하는 방향으로 생각했다.
- `reduce` 를 사용하면 누적 값, 현재 값, 인덱스를 동시에 사용할 수 있다. 이때, 초기 값은 0을 설정해야 배열의 모든 요소를 순회하며 계산을 수행한다.
- 만약, 초기값을 설정하지 않으면 첫 번째 인덱스에 해당하는 요소를 바로 누적 값으로 설정하는데, 이럴 경우 음수 처리를 제대로 못하는 문제가 있다.

```javascript
// absoultes: [1, 2, 3]
// signs: [false, false, true]
function solution(absolutes, signs) {
  return absolutes.reduce((acc, cur, idx) => {
    console.log(`acc : ${acc}, cur : ${cur}, idx : ${idx}`);
    return signs[idx] ? acc + cur : acc - cur;
  });
}

/*
acc : 1, cur : 2, idx : 1
	-> 1을 -1로 저장하지 않아서 의도한 대로 계산이 수행되지 않았다.
acc : -1, cur : 3, idx : 2
*/
```

- 부호가 양이면 누적 값에서 더해주고, 음이면 누적 값에서 빼준다.

## 👀참고한 풀이

```javascript
function solution(absolutes, signs) {
  let answer = 0;
  absolutes.forEach((v, i) => {
    if (signs[i]) {
      answer += v;
    } else {
      answer -= v;
    }
  });
  return answer;
}
```

- `forEach` 문을 사용해서 양수면 더해주고, 음수면 빼는 식으로 구현했다.
