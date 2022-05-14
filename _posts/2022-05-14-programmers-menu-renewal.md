---
title: 프로그래머스 Level 2 - 메뉴 리뉴얼 (JavaScript)
date: 2022-05-14 15:30:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 메뉴 리뉴얼](https://programmers.co.kr/learn/courses/30/lessons/72411)

# 문제 설명

레스토랑을 운영하던 `스카피`는 코로나19로 인한 불경기를 극복하고자 메뉴를 새로 구성하려고 고민하고 있습니다.기존에는 단품으로만 제공하던 메뉴를 조합해서 코스요리 형태로 재구성해서 새로운 메뉴를 제공하기로 결정했습니다. 어떤 단품메뉴들을 조합해서 코스요리 메뉴로 구성하면 좋을 지 고민하던 "스카피"는 이전에 각 손님들이 주문할 때 가장 많이 함께 주문한 단품메뉴들을 코스요리 메뉴로 구성하기로 했습니다.단, 코스요리 메뉴는 최소 2가지 이상의 단품메뉴로 구성하려고 합니다. 또한, 최소 2명 이상의 손님으로부터 주문된 단품메뉴 조합에 대해서만 코스요리 메뉴 후보에 포함하기로 했습니다.

예를 들어, 손님 6명이 주문한 단품메뉴들의 조합이 다음과 같다면,(각 손님은 단품메뉴를 2개 이상 주문해야 하며, 각 단품메뉴는 A ~ Z의 알파벳 대문자로 표기합니다.)

| 손님 번호 | 주문한 단품메뉴 조합 |
| --------- | -------------------- |
| 1번 손님  | A, B, C, F, G        |
| 2번 손님  | A, C                 |
| 3번 손님  | C, D, E              |
| 4번 손님  | A, C, D, E           |
| 5번 손님  | B, C, F, G           |
| 6번 손님  | A, C, D, E, H        |

가장 많이 함께 주문된 단품메뉴 조합에 따라 "스카피"가 만들게 될 코스요리 메뉴 구성 후보는 다음과 같습니다.

| 코스 종류     | 메뉴 구성  | 설명                                                 |
| ------------- | ---------- | ---------------------------------------------------- |
| 요리 2개 코스 | A, C       | 1번, 2번, 4번, 6번 손님으로부터 총 4번 주문됐습니다. |
| 요리 3개 코스 | C, D, E    | 3번, 4번, 6번 손님으로부터 총 3번 주문됐습니다.      |
| 요리 4개 코스 | B, C, F, G | 1번, 5번 손님으로부터 총 2번 주문됐습니다.           |
| 요리 4개 코스 | A, C, D, E | 4번, 6번 손님으로부터 총 2번 주문됐습니다.           |

---

### **[문제]**

각 손님들이 주문한 단품메뉴들이 문자열 형식으로 담긴 배열 orders, "스카피"가 `추가하고 싶어하는` 코스요리를 구성하는 단품메뉴들의 갯수가 담긴 배열 course가 매개변수로 주어질 때, "스카피"가 새로 추가하게 될 코스요리의 메뉴 구성을 문자열 형태로 배열에 담아 return 하도록 solution 함수를 완성해 주세요.

## 제한사항

- orders 배열의 크기는 2 이상 20 이하입니다.
- orders 배열의 각 원소는 크기가 2 이상 10 이하인 문자열입니다.
  - 각 문자열은 알파벳 대문자로만 이루어져 있습니다.
  - 각 문자열에는 같은 알파벳이 중복해서 들어있지 않습니다.
- course 배열의 크기는 1 이상 10 이하입니다.
  - course 배열의 각 원소는 2 이상 10 이하인 자연수가 `오름차순`으로 정렬되어 있습니다.
  - course 배열에는 같은 값이 중복해서 들어있지 않습니다.
- 정답은 각 코스요리 메뉴의 구성을 문자열 형식으로 배열에 담아 사전 순으로 `오름차순` 정렬해서 return 해주세요.
  - 배열의 각 원소에 저장된 문자열 또한 알파벳 `오름차순`으로 정렬되어야 합니다.
  - 만약 가장 많이 함께 주문된 메뉴 구성이 여러 개라면, 모두 배열에 담아 return 하면 됩니다.
  - orders와 course 매개변수는 return 하는 배열의 길이가 1 이상이 되도록 주어집니다.

# 🙋‍♂️나의 풀이

조합으로 접근을 했지만, 도무지 풀리지 않아서 다른 분들의 풀이를 참고해서 풀었다.

## 🤔문제 접근

1. 세트 메뉴에 포함될 단품 메뉴의 개수에 따른 메뉴 조합을 만들어야 한다.

   예를 들어, “ABCD” 를 주문한 건에 대해 2가지 메뉴로 세트를 구성한다면 나올 수 있는 조합은 “AB”, “AC”, “AD”, “BC”, “BD”, “CD” 로 총 7가지다.

   모든 주문 건에 대해 메뉴의 개수에 따른 메뉴 조합을 다음과 같이 저장한다.

   ```javascript
   // 단품 메뉴가 2개인 경우
   {
   	AB: 2,
   	AC: 1,
   	AD: 1,
   	...
   }
   ```

   마찬가지로 `course` 에 담긴 모든 메뉴의 수만큼 조합을 구한다.

2. 메뉴 조합 중에서 가장 많이 카운트된 횟수가 2번 이상이라면, 가장 많이 카운트된 메뉴를 배열에 담는다.
3. 배열에 담긴 메뉴들을 알파벳 오름차순으로 정렬한다.

## ✍️작성 코드

```javascript
function solution(orders, course) {
  const answer = [];
  course.forEach((n) => {
    const result = {};
    let max = 0;

    orders.forEach((order) => {
      const combinations = getCombinations([...order], n);
      combinations.forEach((combination) => {
        const menu = combination.sort().join("");
        if (result[menu]) {
          result[menu] += 1;
          max = max < result[menu] ? result[menu] : max;
        } else result[menu] = 1;
      });
    });

    if (max >= 2)
      for (const [key, value] of Object.entries(result)) {
        if (value === max) answer.push(key);
      }
  });
  return answer.sort();
}

const getCombinations = (arr, selectNumber) => {
  const results = [];

  if (selectNumber === 1) {
    return arr.map((value) => [value]);
  }

  arr.forEach((fixed, index, origin) => {
    const rest = origin.slice(index + 1);
    const combinations = getCombinations(rest, selectNumber - 1);
    const attached = combinations.map((combination) => [fixed, ...combination]);

    results.push(...attached);
  });

  return results;
};
```

우선, 메뉴들의 조합을 구하기 위해서 `getCombinations` 함수를 작성했다.

```javascript
const getCombinations = (arr, selectNumber) => {
  const results = [];

  if (selectNumber === 1) {
    return arr.map((value) => [value]);
  }

  arr.forEach((fixed, index, origin) => {
    const rest = origin.slice(index + 1);
    const combinations = getCombinations(rest, selectNumber - 1);
    const attached = combinations.map((combination) => [fixed, ...combination]);

    results.push(...attached);
  });

  return results;
};
```

재귀적으로 조합을 구하는 코드이다. 해당 코드는 \***\*[JavaScript로 순열과 조합 알고리즘 구현하기](https://velog.io/@devjade/JavaScript%EB%A1%9C-%EC%88%9C%EC%97%B4%EA%B3%BC-%EC%A1%B0%ED%95%A9-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0)** 를 참고했다.

다음으로 메뉴의 조합을 객체 형태로 만들기 위해 다음과 같이 코드를 작성했다.

```javascript
course.forEach((n) => {
  const result = {};
  let max = 0;

  orders.forEach((order) => {
    const combinations = getCombinations([...order], n);
    combinations.forEach((combination) => {
      const menu = combination.sort().join("");
      result[menu] = (result[menu] || 0) + 1;
    });
  });

  max = Math.max(...Object.values(result));
  if (max >= 2)
    for (const [key, value] of Object.entries(result)) {
      if (value === max) answer.push(key);
    }
});
```

`max` 변수는 메뉴의 조합 중에서 가장 많이 주문된 메뉴의 횟수를 저장한다.

`combinations` 변수에는 `[['A', 'B'], ['B', 'C']...]` 와 같은 형태로 메뉴가 하나씩 담겨있다. `BC` 나 `CB` 는 모두 같아야 하기 때문에 `BC` 와 같이 오름차순으로 정렬할 필요가 있다.

```javascript
const menu = combination.sort().join("");
```

그러면 `menu` 변수에는 `AB`, `BC` 와 같은 string 형태로 데이터가 저장된다. 그리고 메뉴 조합을 객체에서 1씩 증가시켜 나가면, 다음과 같은 형태로 저장이 된다.

```javascript
{
	AB: 1,
	BC: 2,
	CD: 1,
	...
}
```

가장 많이 조합된 메뉴의 횟수를 구하기 위해서 다음과 같이 작성했다.

```javascript
max = Math.max(...Object.values(result));
```

그 다음, 가장 많이 조합된 메뉴의 횟수가 `max` 이므로, `max` 번 조합된 메뉴 모두 배열에 담았다. 이때, 세트 메뉴로 선정되기 위해서는 2번 이상 주문되어야 하는 조건을 넣어주었다.

```javascript
if (max >= 2)
  for (const [key, value] of Object.entries(result)) {
    if (value === max) answer.push(key);
  }
```

그러면 `answer` 변수에는 다음과 같이 데이터가 저장된다.

```javascript
["AB", "BC", "ABC", "BCD", ...]
```

최종 반환값에서도 메뉴들이 오름차순으로 정렬되어야 하기 때문에 정렬을 해서 반환한다.

```javascript
return answer.sort();
```

# 참고자료

- [(프로그래머스 JS KAKAO)메뉴 리뉴얼](https://eunchanee.tistory.com/383) [티스토리]
