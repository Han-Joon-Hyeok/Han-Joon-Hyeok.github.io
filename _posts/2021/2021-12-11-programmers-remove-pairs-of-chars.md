---
title: 프로그래머스 Level 2 - 짝지어 제거하기 (JavaScript)
date: 2021-12-11 23:20:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 짝지어 제거하기](https://programmers.co.kr/learn/courses/30/lessons/12973#)

# 문제 설명

---

짝지어 제거하기는, 알파벳 소문자로 이루어진 문자열을 가지고 시작합니다. 먼저 문자열에서 같은 알파벳이 2개 붙어 있는 짝을 찾습니다. 그다음, 그 둘을 제거한 뒤, 앞뒤로 문자열을 이어 붙입니다. 이 과정을 반복해서 문자열을 모두 제거한다면 짝지어 제거하기가 종료됩니다. 문자열 S가 주어졌을 때, 짝지어 제거하기를 성공적으로 수행할 수 있는지 반환하는 함수를 완성해 주세요. 성공적으로 수행할 수 있으면 1을, 아닐 경우 0을 리턴해주면 됩니다.

예를 들어, 문자열 S = `baabaa` 라면

b *aa* baa → *bb* aa → *aa* →

의 순서로 문자열을 모두 제거할 수 있으므로 1을 반환합니다.

## 제한사항

- 문자열의 길이 : 1,000,000이하의 자연수
- 문자열은 모두 소문자로 이루어져 있습니다.

## 🙋‍♂️나의 풀이

### 처음 시도한 코드

처음에는 문자열의 앞에서부터 순서대로 다음 문자열과 동일하면 제거하고, 다시 맨 처음부터 검사를 하는 방식으로 구현했다. 하지만 시간 초과가 나서 다른 분들의 풀이를 참고해서 풀었다.

```javascript
function solution(s) {
  let idx = 0;
  while (idx < s.length) {
    let curr = s.charAt(idx);
    let next = s.charAt(idx + 1);

    if (curr === next) {
      s = s.slice(0, idx) + s.slice(idx + 2);
      idx = 0;
      continue;
    }

    idx++;
  }

  return s.length === 0 ? 1 : 0;
}
```

### 작성 코드

스택을 이용해서 해결한 코드이다. 문자열을 앞에서부터 끝까지 탐색을 하면서 스택의 맨 마지막 요소와 동일하면 스택에서 빼고, 다르면 스택에 집어 넣는다. 탐색이 끝나고 스택에 요소가 남아있다면 짝이 지어지지 않은 문자열이 있다는 의미가 된다.

중위 표기법을 후위 표기법으로 바꾸는 것과 비슷한 것 같다.

```javascript
function solution(s) {
  const stack = [];

  for (let i = 0; i < s.length; i++) {
    const curr = s.charAt(i);
    if (stack[stack.length - 1] === curr) {
      stack.pop();
    } else {
      stack.push(curr);
    }
  }

  return stack.length === 0 ? 1 : 0;
}
```
