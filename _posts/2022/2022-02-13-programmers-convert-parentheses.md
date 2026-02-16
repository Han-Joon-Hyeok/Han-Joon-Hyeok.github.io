---
title: 프로그래머스 Level 2 - 괄호 변환 (JavaScript)
date: 2022-02-13 21:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 괄호 변환](https://programmers.co.kr/learn/courses/30/lessons/60058)

# 문제 설명

---

생략

## 제한사항

생략

## 🙋‍♂️나의 풀이

stack을 활용해서 접근하면 되겠다는 생각은 했지만, 구체적인 구현 방법이 떠오르지 않아서 다른 분들의 풀이를 참고해서 풀었다.

### 🤔문제 접근

문제에서 이미 “균형잡힌 괄호 문자열"이 매개변수로 주어지기 때문에 “올바른 괄호 문자열"로 만드는 알고리즘을 그대로 구현하면 된다.

- 균형잡힌 괄호 문자열 : 열린 괄호와 닫힌 괄호의 개수가 일치(순서 상관 없음)
- 올바른 괄호 문자열 : 열린 괄호와 닫힌 괄호의 개수가 일치 + 순서도 올바르게 짝지어짐

### ✍️작성 코드

```javascript
function solution(p) {
  // 조건 1
  if (p.length === 0) return "";

  // 조건 2
  const [is_correct, pos] = check_correct(p);
  const u = p.slice(0, pos);
  const v = p.slice(pos);

  // 조건 3
  if (is_correct) return u + solution(v);

  // 조건 4
  let answer = "(" + solution(v) + ")";
  for (let i = 1; i < u.length - 1; i++) {
    answer += u[i] == "(" ? ")" : "(";
  }
  return answer;
}

const check_correct = (str) => {
  const stack = [];
  let result = true;
  let left = 0;
  let right = 0;

  for (let pos = 0; pos < str.length; pos++) {
    if (str[pos] === "(") {
      left += 1;
      stack.push(str[pos]);
    } else {
      right += 1;
      if (stack.length === 0) result = false;
      else stack.pop();
    }
    if (left === right) {
      return [result, pos + 1];
    }
  }
};
```

## 참고자료

- [알고리즘 :: 프로그래머스 :: 2020 카카오 :: 스택 :: 괄호 변환](https://velog.io/@embeddedjune/%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-2020-%EC%B9%B4%EC%B9%B4%EC%98%A4-%EC%8A%A4%ED%83%9D-%EA%B4%84%ED%98%B8-%EB%B3%80%ED%99%98)
- [[프로그래머스] 괄호 변환 - 자바스크립트](https://gobae.tistory.com/62)
