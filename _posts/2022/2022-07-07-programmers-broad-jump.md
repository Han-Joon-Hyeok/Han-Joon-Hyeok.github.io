---
title: 프로그래머스 Level 2 - 멀리 뛰기 (JavaScript)
date: 2022-07-07 12:20:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 멀리 뛰기](https://school.programmers.co.kr/learn/courses/30/lessons/12914#)

# 문제 설명

효진이는 멀리 뛰기를 연습하고 있습니다. 효진이는 한번에 1칸, 또는 2칸을 뛸 수 있습니다. 칸이 총 4개 있을 때, 효진이는

(1칸, 1칸, 1칸, 1칸)

(1칸, 2칸, 1칸)

(1칸, 1칸, 2칸)

(2칸, 1칸, 1칸)

(2칸, 2칸)

의 5가지 방법으로 맨 끝 칸에 도달할 수 있습니다. 멀리뛰기에 사용될 칸의 수 n이 주어질 때, 효진이가 끝에 도달하는 방법이 몇 가지인지 알아내, 여기에 1234567를 나눈 나머지를 리턴하는 함수, solution을 완성하세요. 예를 들어 4가 입력된다면, 5를 return하면 됩니다.

## 제한사항

n은 1 이상, 2000 이하인 정수입니다.

# 🙋‍♂️나의 풀이

## 🤔문제 접근

처음에는 DFS로 접근했지만, 시간 초과가 발생해서 동적 계획법(Dynamic Programming)으로 풀었다.

이 문제는 2 x n 타일링 문제와 지문만 다를 뿐 문제에서 요구하는 사항은 동일하다.

동적 계획법에 대한 설명은 [2 x n 타일링](https://han-joon-hyeok.github.io/posts/programmers-2xn-tiling/) 게시물에 자세히 작성했다.

## ✍️작성 코드

```javascript
function solution(n) {
  if (n === 1 || n === 2) return n;
  const dp = Array(n).fill(0);
  const mod = 1234567;
  dp[0] = 1;
  dp[1] = 2;
  for (let i = 2; i < n; i++) {
    dp[i] = (dp[i - 1] + dp[i - 2]) % mod;
  }
  return dp[n - 1];
}
```

JavaScript 에서 1차원 배열의 최대 크기는`unsigned int` 의 최댓값(약 42억)과 동일하다.

그래서 값을 저장하기 위한 배열의 크기를 미리 `n` 으로 설정해도 크게 상관없다.
