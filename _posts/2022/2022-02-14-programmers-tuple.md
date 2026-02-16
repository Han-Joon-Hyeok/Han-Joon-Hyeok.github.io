---
title: 프로그래머스 Level 2 - 튜플 (JavaScript)
date: 2022-02-14 15:20:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 튜플](https://programmers.co.kr/learn/courses/30/lessons/64065)

# 문제 설명

---

생략

## 🙋‍♂️나의 풀이

### 🤔문제 접근

1. 주어진 문자열에서 원소를 감싸고 있는 부분 집합들을 뽑아낸다.
   - 예를 들어 {% raw %} `{{1}, {1,2,3}, {1,2}}` 이 있다면 `{1}`, `{1,2,3}`, `{1,2}` {% endraw %} 과 같이 분리한다.
2. 원소의 길이가 적은 순서대로 튜플이 구성되므로 문자열의 길이가 작은 순서대로 집합을 정렬한다.
   - {% raw %} `{1}`, `{1,2}`, `{1,2,3}` {% endraw %} 순서대로 집합을 정렬한다.
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
   입력 문자열 : {% raw %} "{{1,2,3},{2,1},{1,2,4,3},{2}}" {% endraw %}

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
