---
title: 프로그래머스 Level 2 - 튜플 (JavaScript)
date: 2022-02-14 15:20:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 튜플](https://programmers.co.kr/learn/courses/30/lessons/64065)

# 문제 설명

---

셀수있는 수량의 순서있는 열거 또는 어떤 순서를 따르는 요소들의 모음을 튜플(tuple)이라고 합니다. n개의 요소를 가진 튜플을 n-튜플(n-tuple)이라고 하며, 다음과 같이 표현할 수 있습니다.

- (a1, a2, a3, ..., an)

튜플은 다음과 같은 성질을 가지고 있습니다.

1. 중복된 원소가 있을 수 있습니다. ex : (2, 3, 1, 2)
2. 원소에 정해진 순서가 있으며, 원소의 순서가 다르면 서로 다른 튜플입니다. ex : (1, 2, 3) ≠ (1, 3, 2)
3. 튜플의 원소 개수는 유한합니다.

원소의 개수가 n개이고, **중복되는 원소가 없는** 튜플 `(a1, a2, a3, ..., an)`이 주어질 때(단, a1, a2, ..., an은 자연수), 이는 다음과 같이 집합 기호 '{', '}'를 이용해 표현할 수 있습니다.

- {{a1}, {a1, a2}, {a1, a2, a3}, {a1, a2, a3, a4}, ... {a1, a2, a3, a4, ..., an}}

예를 들어 튜플이 (2, 1, 3, 4)인 경우 이는

- {{2}, {2, 1}, {2, 1, 3}, {2, 1, 3, 4}}

와 같이 표현할 수 있습니다. 이때, 집합은 원소의 순서가 바뀌어도 상관없으므로

- {{2}, {2, 1}, {2, 1, 3}, {2, 1, 3, 4}}
- {{2, 1, 3, 4}, {2}, {2, 1, 3}, {2, 1}}
- {{1, 2, 3}, {2, 1}, {1, 2, 4, 3}, {2}}

는 모두 같은 튜플 (2, 1, 3, 4)를 나타냅니다.

특정 튜플을 표현하는 집합이 담긴 문자열 s가 매개변수로 주어질 때, s가 표현하는 튜플을 배열에 담아 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- s의 길이는 5 이상 1,000,000 이하입니다.
- s는 숫자와 '{', '}', ',' 로만 이루어져 있습니다.
- 숫자가 0으로 시작하는 경우는 없습니다.
- s는 항상 중복되는 원소가 없는 튜플을 올바르게 표현하고 있습니다.
- s가 표현하는 튜플의 원소는 1 이상 100,000 이하인 자연수입니다.
- return 하는 배열의 길이가 1 이상 500 이하인 경우만 입력으로 주어집니다.

## 🙋‍♂️나의 풀이

### 🤔문제 접근

1. 주어진 문자열에서 원소를 감싸고 있는 부분 집합들을 뽑아낸다.
   - 예를 들어`{{1}, {1,2,3}, {1,2}}` 이 있다면 `{1}`, `{1,2,3}`, `{1,2}` 과 같이 분리한다.
2. 원소의 길이가 적은 순서대로 튜플이 구성되므로 문자열의 길이가 작은 순서대로 집합을 정렬한다.
   - `{1}`, `{1,2}`, `{1,2,3}` 순서대로 집합을 정렬한다.
3. 정렬한 순서대로 집합들을 순회하며 원소가 중복되지 않도록 stack에 넣는다.

### ✍️작성 코드

```javascript
function solution(s) {
  const stack = [];
  const regex = /[{w+}]/g;
  const groups = s.split(regex).filter(is_dilimiter).sort(sort_by_length);

  groups.forEach((group) => {
    const elements = group.split(",");
    elements.forEach((elem) => {
      if (!stack.includes(+elem)) stack.push(+elem);
    });
  });

  return stack;
}

const is_dilimiter = (char) => {
  if (char === "" || char === ",") return false;
  return true;
};

const sort_by_length = (a, b) => {
  return a.length - b.length;
};
```

1. 정규 표현식을 사용해서 중괄호를 제거한다.

   ```javascript
   const regex = /[{w+}]/g;
   const groups = s.split(regex);
   ```

   ```
   입력 문자열 : "{{1,2,3},{2,1},{1,2,4,3},{2}}"

   [
     '',        '',
     '1,2,3',   ',',
     '2,1',     ',',
     '1,2,4,3', ',',
     '2',       '',
     ''
   ]
   ```

2. 빈 문자열과 콤마를 제거한다.

   ```javascript
   const groups = s.split(regex).filter(is_dilimiter);

   const is_dilimiter = (char) => {
     if (char === "" || char === ",") return false;
     return true;
   };
   ```

   ```
   [ '1,2,3', '2,1', '1,2,4,3', '2' ]
   ```

3. 문자열의 길이가 작은 순서대로 오름차순 정렬한다.

   ```javascript
   const groups = s.split(regex).filter(is_dilimiter).sort(sort_by_length);

   const sort_by_length = (a, b) => {
     return a.length - b.length;
   };
   ```

   ```
   [ '2', '2,1', '1,2,3', '1,2,4,3' ]
   ```

4. 각 집합을 순회하며 중복되는 수를 제외하고 stack에 순서대로 넣는다.

   ```javascript
   groups.forEach((group) => {
     const elements = group.split(",");
     elements.forEach((elem) => {
       if (!stack.includes(+elem)) stack.push(+elem);
     });
   });
   ```

   ```
   [2, 1, 3, 4]
   ```
