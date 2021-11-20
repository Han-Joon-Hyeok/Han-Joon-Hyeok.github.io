---
title: 프로그래머스 Level 2 - 숫자의 표현 (JavaScript)
date: 2021-11-21 00:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 숫자의 표현](https://programmers.co.kr/learn/courses/30/lessons/12924#)

# 문제 설명

Finn은 요즘 수학공부에 빠져 있습니다. 수학 공부를 하던 Finn은 자연수 n을 연속한 자연수들로 표현 하는 방법이 여러개라는 사실을 알게 되었습니다. 예를들어 15는 다음과 같이 4가지로 표현 할 수 있습니다.

- 1 + 2 + 3 + 4 + 5 = 15
- 4 + 5 + 6 = 15
- 7 + 8 = 15
- 15 = 15

자연수 n이 매개변수로 주어질 때, 연속된 자연수들로 n을 표현하는 방법의 수를 return하는 solution를 완성해주세요.

## 제한사항

n은 10,000 이하의 자연수 입니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(n) {
  let point = 1;
  let sum = 0;
  let cnt = 0;
  for (let i = 1; point <= n; ) {
    sum += i;
    if (sum === n) {
      cnt++;
      sum = 0;
      i = ++point;
      continue;
    }
    if (sum > n) {
      i = ++point;
      sum = 0;
      continue;
    }
    i++;
  }
  return cnt;
}
```

1. 기준점(`point`)을 1로 설정하고, 순서대로 1씩 늘리면서 합을 더한다.
2. 합이 n과 같으면 카운트를 하나 올리고, 합을 초기화 한다. 그리고 기준점에서 +1 한다.
   - 만약 합이 n보다 크면 시작한 수에서 연속해서 더해도 n을 만들 수 없으므로, 합을 0으로 초기화 하고, 기준점 +1 한다.
3. 이 과정을 반복하다가 기준점이 n과 같아지면 반복을 종료한다.

이해를 돕기 위한 예시는 다음과 같다.

```javascript
// n = 10
point: 1
i: 1, sum: 1
i: 2, sum: 3
i: 3, sum: 6
i: 4, sum: 10 -> cnt++, point++, sum = 0

point: 2
i: 2, sum: 2
i: 3, sum: 5
i: 4, sum: 9
i: 5, sum: 14 -> point++, sum = 0

point: 3
i: 3, sum: 3
i: 4, sum: 7
i: 5, sum: 12 -> point++, sum = 0

// 위의 과정 반복
...

point: 10
i: 10, sum: 10 -> cnt++, 반복종료
```

## 👀참고한 풀이

```javascript
function solution(n) {
  var answer = 0;
  function re(current, sum) {
    if (sum === n) return true;
    if (sum > n) return false;
    return re(current + 1, sum + current);
  }
  for (let i = 1; i <= n; i++) {
    if (re(i, 0)) answer++;
  }
  return answer;
}
```

- 재귀함수를 이용한 풀이이다.
- 내가 작성한 코드를 재귀적으로 생각하면 이렇게 구현할 수 있다.

```javascript
function solution(num) {
  var answer = 0;

  for (var i = 1; i <= num; i++) {
    if (num % i == 0 && i % 2 == 1) answer++;
  }
  return answer;
}
```

- 정수론 정리에 의하면, 주어진 자연수를 연속된 자연수의 합으로 표현하는 방법의 수는 주어진 수의 홀수 약수의 개수와 같다고 한다.

```javascript
// n = 4
약수: 1 2 4
홀수인 약수: 1
연속된 자연수의 합: 4

// n = 9
약수: 1 3 9
홀수인 약수: 1 3 9
연속된 자연수의 합: 2+3+4 / 4+5 / 9
```

- 실제로 많이 쓸 수 있는 공식인지는 모르겠지만, 새롭게 하나 배운 걸로 만족해야지.

# 참고자료

- [Level2. 프로그래머스 숫자의 표현- JavaScript](https://webigotr.tistory.com/315)
