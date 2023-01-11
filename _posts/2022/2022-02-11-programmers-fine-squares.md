---
title: 프로그래머스 Level 2 - 멀쩡한 사각형 (JavaScript)
date: 2022-02-11 20:00:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 멀쩡한 사각형](https://programmers.co.kr/learn/courses/30/lessons/62048#)

# 문제 설명

---

가로 길이가 Wcm, 세로 길이가 Hcm인 직사각형 종이가 있습니다. 종이에는 가로, 세로 방향과 평행하게 격자 형태로 선이 그어져 있으며, 모든 격자칸은 1cm x 1cm 크기입니다. 이 종이를 격자 선을 따라 1cm × 1cm의 정사각형으로 잘라 사용할 예정이었는데, 누군가가 이 종이를 대각선 꼭지점 2개를 잇는 방향으로 잘라 놓았습니다. 그러므로 현재 직사각형 종이는 크기가 같은 직각삼각형 2개로 나누어진 상태입니다. 새로운 종이를 구할 수 없는 상태이기 때문에, 이 종이에서 원래 종이의 가로, 세로 방향과 평행하게 1cm × 1cm로 잘라 사용할 수 있는 만큼만 사용하기로 하였습니다.

가로의 길이 W와 세로의 길이 H가 주어질 때, 사용할 수 있는 정사각형의 개수를 구하는 solution 함수를 완성해 주세요.

## 제한사항

• W, H : 1억 이하의 자연수

## 🙋‍♂️나의 풀이

### 🤔문제 접근

처음에는 직선의 방정식을 활용해서 구하려고 했으나, 2시간 이상 고민해도 답이 안나와서 다른 분들의 풀이를 참고해서 풀었다.

문제 풀이의 핵심은 다음과 같다.

- 주어진 사각형을 유심히 살펴보면 동일한 패턴으로 사각형들이 잘리는 것을 발견할 수 있다.
- 주어진 2개의 정수로 구할 수 있는 것은 최대공약수, 최소공배수를 떠올릴 수 있다.
- 하나의 패턴에서 잘리는 사각형의 개수는 (N \* M - 1)개 이다.
- 발견한 규칙을 개별 패턴 사각형에서 전체로 적용하면 (가로 + 세로 - 최대공약수)와 동일하다는 것을 알 수 있다.
- 따라서 멀쩡한 사각형의 개수는 전체 사각형의 개수(`가로 * 세로`)에서 잘리는 사각형(`가로 + 세로 - 최대공약수`)를 뺀 값임을 알 수 있다.

### ✍️작성 코드

```jsx
function solution(w, h) {
  const [n1, n2] = swap_number(w, h);
  const GCD = get_gcd(n1, n2);
  return w * h - (w + h - GCD);
}

const get_gcd = (n1, n2) => {
  if (n2 === 0) return n1;
  return get_gcd(n2, n1 % n2);
};

const swap_number = (n1, n2) => {
  if (n1 < n2) {
    [n1, n2] = [n2, n1];
  }
  return [n1, n2];
};
```

- 최대공약수를 구하는 것은 유클리드 호제법을 사용해서 구했다.
  - 참고 자료 : [프로그래머스 Level1 - 최대공약수와 최소공배수 (JavaScript)](https://han-joon-hyeok.github.io/posts/programmers-gcd-lcm/)
- 유클리드 호제법에서 두 양의 정수 a, b가 있을 때, a > b 조건을 만족시켜주기 위해서 `swap_number` 함수를 사용하여 가로와 세로 중에서 큰 값이 먼저 오도록 하였다.

## 참고자료

- [[프로그래머스] 멀쩡한 사각형 (Java)](https://taesan94.tistory.com/55)
- [[프로그래머스] 멀쩡한 사각형 in python](https://leedakyeong.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EB%A9%80%EC%A9%A1%ED%95%9C-%EC%82%AC%EA%B0%81%ED%98%95-in-python)
