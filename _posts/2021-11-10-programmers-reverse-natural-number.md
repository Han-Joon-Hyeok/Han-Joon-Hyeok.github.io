---
title: 프로그래머스 Level 1 - 자연수 뒤집어 배열로 만들기 (JavaScript)
date: 2021-11-10 10:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 자연수 뒤집어 배열로 만들기](https://programmers.co.kr/learn/courses/30/lessons/12932)

# 문제 설명

자연수 n을 뒤집어 각 자리 숫자를 원소로 가지는 배열 형태로 리턴해주세요. 예를들어 n이 12345이면 [5,4,3,2,1]을 리턴합니다.

## 제한사항

n은 10,000,000,000이하인 자연수입니다.

## 🙋‍♂️나의 풀이

두 가지 풀이를 할 수 있다.

### 1. 나머지를 이용한 풀이

```javascript
function solution(n) {
  const answer = [];
  while (n > 0) {
    answer.push(n % 10);
    n = Math.floor(n / 10);
  }
  return answer;
}
```

- n을 10으로 나눈 나머지는 맨 마지막 한 자리 정수이다.
- n을 다시 10으로 나누어서 나머지를 배열에 추가한다.
- 정수 내림차순으로 배치하기 문제와 접근 개념은 같다.

### 2. 배열로 만들어서 거꾸로 뒤집기

```javascript
function solution(n) {
  return n
    .toString()
    .split("")
    .reverse()
    .map((num) => +num);
}
```

- string으로 변환하고 배열로 만든다.
- 그 다음 거꾸로 뒤집고, string 요소를 number로 형변환한다.
