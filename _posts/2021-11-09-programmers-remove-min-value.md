---
title: 프로그래머스 Level 1 - 제일 작은 수 제거하기 (JavaScript)
date: 2021-11-08 09:50:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 제일 작은 수 제거하기](https://programmers.co.kr/learn/courses/30/lessons/12935)

# 문제 설명

정수를 저장한 배열, arr 에서 가장 작은 수를 제거한 배열을 리턴하는 함수, solution을 완성해주세요. 단, 리턴하려는 배열이 빈 배열인 경우엔 배열에 -1을 채워 리턴하세요. 예를들어 arr이 [4,3,2,1]인 경우는 [4,3,2]를 리턴 하고, [10]면 [-1]을 리턴 합니다.

## 제한사항

- arr은 길이 1 이상인 배열입니다.
- 인덱스 i, j에 대해 i ≠ j이면 arr[i] ≠ arr[j] 입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(arr) {
  if (arr.length === 1) {
    return [-1];
  }

  const min = Math.min(...arr);
  const idx = arr.indexOf(min);
  arr.splice(idx, 1);

  return arr;
}
```

- 배열에서 제일 작은 수의 인덱스를 찾은 다음, 해당 숫자를 제거했다.
- 처음에는 내림차순 정렬을 한 뒤, 맨 마지막 인덱스를 제거하는 코드로 작성했더니 테스트 케이스에서 통과하지 못했다.
- 혹시나 해서 배열에 최솟값이 여러 개인 경우를 살펴보니, 제한 사항에는 배열 내에 같은 값은 존재하지 않는다고 나와있었다.
- 어떤 분께서 정렬을 함부로 하면 안되는 이유에 대해 설명해주셨다.

> 배열은 통계 자료와 같은 개념으로 사용할 수 있다.
> 예컨대, 월 평균 기온을 보여주려고 할 때, 정렬을 해서 보여준다면 "봄, 여름, 가을, 겨울" 순서가 보장되지 않는다.
> 따라서 정렬을 하지 않은 순차적인 데이터 그 자체가 의미 있는 데이터일 수도 있다.

## 👀참고한 풀이

```javascript
function solution(arr) {
  var min = arr.reduce((p, c) => Math.min(p, c));
  var r = arr.filter((v) => v != min);
  r = r.length == 0 ? [-1] : r;
  return r;
}
```

- `reduce` 를 사용해서 배열 내에 최솟값을 반복적으로 탐색한 다음, `filter` 로 원본 배열에서 최솟값이 아닌 값만 걸러낸다.
