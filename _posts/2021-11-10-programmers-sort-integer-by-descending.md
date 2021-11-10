---
title: 프로그래머스 Level 1 - 정수 내림차순으로 배치하기 (JavaScript)
date: 2021-11-10 10:20:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 정수 내림차순으로 배치하기](https://programmers.co.kr/learn/courses/30/lessons/12933)

# 문제 설명

함수 solution은 정수 n을 매개변수로 입력받습니다. n의 각 자릿수를 큰것부터 작은 순으로 정렬한 새로운 정수를 리턴해주세요. 예를들어 n이 118372면 873211을 리턴하면 됩니다.

## 제한사항

`n`은 1이상 8000000000 이하인 자연수입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(n) {
  const numbers = n.toString().split("");
  numbers.sort((a, b) => b - a);
  return +numbers.join("");
}
```

- 숫자를 배열로 나누기 위해서 string으로 형변환을 하고, `split` 을 한다.
- 내림차순으로 `sort` 메서드를 사용한다.
- 배열을 하나의 문자열로 합치기 위해 `join` 메서드를 사용하고, string을 number로 형변환 하기 위해 변수 앞에 단항 더하기 연산자 `+` 를 붙인다.

> 참고자료 : [단항 더하기 (+)](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/Unary_plus)

## 👀참고한 풀이

```javascript
function solution(n) {
  const numbers = [];
  while (n > 0) {
    numbers.push(n % 10);
    n = Math.floor(n / 10);
  }
  numbers.sort((a, b) => b - a);
  return +numbers.join("");
}
```

- 숫자를 10으로 나눈 나머지는 맨 마지막 숫자가 된다.
- 그 다음 숫자를 다시 10으로 나눈 다음, 반내림을 하고 계속 10으로 나눈 나머지를 배열에 추가한다.

```javascript
n        n % 10    Math.floor(n / 10)
12345      5              1234
1234       4              123
123        3              12
12         2              1
1          1              0

[5, 4, 3, 2, 1]
```
