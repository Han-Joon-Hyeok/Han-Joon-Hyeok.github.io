---
title: 프로그래머스 Level 2 - 올바른 괄호 (JavaScript)
date: 2021-11-22 16:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 올바른 괄호](https://programmers.co.kr/learn/courses/30/lessons/12909)

# 문제 설명

---

괄호가 바르게 짝지어졌다는 것은 '(' 문자로 열렸으면 반드시 짝지어서 ')' 문자로 닫혀야 한다는 뜻입니다. 예를 들어

- "()()" 또는 "(())()" 는 올바른 괄호입니다.
- ")()(" 또는 "(()(" 는 올바르지 않은 괄호입니다.

'(' 또는 ')' 로만 이루어진 문자열 s가 주어졌을 때, 문자열 s가 올바른 괄호이면 true를 return 하고, 올바르지 않은 괄호이면 false를 return 하는 solution 함수를 완성해 주세요.

## 제한사항

- 문자열 s의 길이 : 100,000 이하의 자연수
- 문자열 s는 '(' 또는 ')' 로만 이루어져 있습니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(s) {
  let openCnt = 0;
  const result = [...s].reduce((sum, curr) => {
    if (curr === "(") {
      openCnt++;
      return sum;
    }
    if (curr === ")" && openCnt > 0) {
      openCnt--;
      return ++sum;
    }
  }, 0);

  return s.length / 2 === result ? true : false;
}
```

- 열린 괄호의 개수를 기준으로 괄호가 완전히 닫혔는지 확인했다.
- 문자열을 순서대로 탐색하다가 닫힌 괄호를 만났을 때, 현재 열린 괄호의 개수가 0보다 크다면 괄호 하나가 완전히 닫힌 것으로 판단한다. 그리고 열린 괄호의 개수를 하나 줄이고, 완전히 닫힌 괄호의 개수를 하나 추가한다.
- 만약 모든 괄호가 짝을 이루어 닫혀있다면, 문자열 길이의 절반과 괄호의 개수가 같아야 한다.

## 👀참고한 풀이

```javascript
function solution(s) {
  let answer = true;

  if (s.charAt(0) === ")" || s.charAt(s.length - 1) === "(") answer = false;

  const a = s.split("").filter((s) => s === "(").length;
  const b = s.split("").filter((s) => s === ")").length;

  if (a !== b) answer = false;

  let cntOpen = 0;

  for (let i = 0; i < s.length; i++) {
    if (s[i] === "(") cntOpen++;
    else cntOpen--;

    if (cntOpen < 0) answer = false;
  }

  return answer;
}
```

- Divide & Conquer 접근을 사용한 풀이이다. 이런 접근 방법도 좋은 것 같다.
- 코드를 개선하면 다음과 같이 할 수 있을 것 같다.

```javascript
function solution(s) {
  // 1번. 맨 처음이 닫는 괄호이거나, 맨 끝이 여는 괄호일 때
  if (s.charAt(0) === ")" || s.charAt(s.length - 1) === "(") return false;

  // 2번. 괄호의 개수가 다를 때
  const a = [...s].filter((s) => s === "(").length;
  const b = [...s].filter((s) => s === ")").length;

  if (a !== b) return false;

  // 3번. 닫는 괄호가 연속해서 나오는 경우
  let openCnt = 0;
  for (let i = 0; i < s.length; i++) {
    if (s[i] === "(") {
      openCnt++;
      continue;
    }
    openCnt--;
    if (openCnt < 0) return false;
  }

  return true;
}
```

- 총 3가지의 경우를 나누어서 생각하셨는데, 각각의 조건에서 만족을 하지 못한다면 바로 리턴을 해서 코드 실행 시간을 줄이고자 했다.
- 3번 케이스는 스택의 개념을 적용해서 푸는 것이다. 문자열이 여는 괄호면 스택에 넣고, 닫는 괄호면 스택에서 빼는 것인데, 스택의 바닥에서 빼려고 시도하면 false 를 반환하는 것과 같다.

# 참고자료

- [[프로그래머스] 올바른 괄호 | JavaScript](https://onlydev.tistory.com/73)
