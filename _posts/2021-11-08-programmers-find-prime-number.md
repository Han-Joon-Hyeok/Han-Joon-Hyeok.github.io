---
title: 프로그래머스 Level 1 - 소수 찾기 (JavaScript)
date: 2021-11-07 21:25:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 소수 찾기](https://programmers.co.kr/learn/courses/30/lessons/12921)

# 문제 설명

1부터 입력받은 숫자 n 사이에 있는 소수의 개수를 반환하는 함수, solution을 만들어 보세요.

소수는 1과 자기 자신으로만 나누어지는 수를 의미합니다.(1은 소수가 아닙니다.)

## 제한사항

n은 2이상 1000000이하의 자연수입니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(n) {
  const sieve = [];

  for (let i = 2; i <= n; i++) {
    sieve[i] = i;
  }

  for (let j = 2; j <= n; j++) {
    if (sieve[j] === 0) continue;
    for (let k = j + j; k <= n; k += j) {
      sieve[k] = 0;
    }
  }

  return sieve.filter((el) => el).length;
}
```

에라토스테네스의 체를 이용해서 풀었다.

- 배열에는 2부터 n까지 채운다. 이때, 배열의 0번, 1번 인덱스는 `undefined`로 배열에 채워진다.
- 배열을 순회하며 해당 값의 배수에 해당하는 모든 수를 0으로 표시해서 지웠다는 표시를 한다.
- 만약 값이 0이라면 이미 지웠다는 것이므로 `continue`를 실행한다.
- falsy 값(undefined, null, 0 등)이 아닌 값을 `filter` 를 사용해서 새로운 배열로 만들고, 해당 배열의 길이를 반환한다.

## 👀참고한 풀이

```javascript
function solution(n) {
  const s = new Set();
  for (let i = 3; i <= n; i += 2) {
    s.add(i);
  }
  s.add(2);
  for (let j = 3; j < Math.sqrt(n); j++) {
    if (s.has(j)) {
      for (let k = j * 2; k <= n; k += j) {
        s.delete(k);
      }
    }
  }
  return s.size;
}
```

Set을 이용해서 풀이한 코드이다. Array를 사용했을 때 보다 속도는 느리지만, 인덱스가 아닌 값으로 접근하므로 직관적인 장점이 있다.

- 2를 제외한 짝수는 모두 소수가 아니므로 3부터 시작해서 홀수만 Set에 추가한다. 이후 2를 Set에 추가한다.
- 약수의 대칭성에 의해 정수 n보다 작은 수들은 $\sqrt{n}$ 까지만 보아도 소수가 아닌 수들이 걸러진다. (참고자료 : [소수 판별 알고리즘](https://han-joon-hyeok.github.io/posts/TIL-check-prime-number/))
- 3부터 시작해서 Set에 값이 있으면 해당 값의 배수들을 모두 지운다. 만약, 이미 지워졌으면 다음 루프로 넘어간다.

## 참고자료

- [에라토스테네스의 체를 이용한 특정 수까지의 소수 집합 구하기](https://secjong.tistory.com/12)
- [에라토스테네스의 체](https://www.youtube.com/watch?v=5ypkoEgFdH8)
