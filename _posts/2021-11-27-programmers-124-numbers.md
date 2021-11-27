---
title: 프로그래머스 Level 2 - 124 나라의 숫자 (JavaScript)
date: 2021-11-27 23:30:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 124 나라의 숫자](https://programmers.co.kr/learn/courses/30/lessons/12899#)

# 문제 설명

---

24 나라가 있습니다. 124 나라에서는 10진법이 아닌 다음과 같은 자신들만의 규칙으로 수를 표현합니다.

1. 124 나라에는 자연수만 존재합니다.
2. 124 나라에는 모든 수를 표현할 때 1, 2, 4만 사용합니다.

(예시 생략)

자연수 n이 매개변수로 주어질 때, n을 124 나라에서 사용하는 숫자로 바꾼 값을 return 하도록 solution 함수를 완성해 주세요.

## 제한사항

n은 500,000,000이하의 자연수 입니다.

## 🙋‍♂️나의 풀이

3으로 나누어서 접근해야 하는 건 찾았지만, 다른 분들의 풀이를 참고해서 풀었다.

3진법 변환하는 것과 같지만, 나머지가 0 인 경우에 연산을 다르게 해주어야 한다.

```
// 3진법 변환 과정
n  n/3  n%3    result
1   0    1       1
2   0    2       2
3   1    0       10
4   1    1       11
5   1    2       12
6   2    0       20
```

- 나머지가 0인 경우, 이전 몫에서 + 1 씩 증가하는 것을 알 수 있다.
- 이 경우에서 몫에서 -1 을 하고 다시 나누면, 나머지는 3이 된다.

```
// 124 나라 변환 과정
n  n/3  n%3    result
1   0    1       1
2   0    2       2
3   1    0       (몫 - 1)
    0    3       3
4   1    1       11
5   1    2       12
6   2    0       (몫 - 1)
    1    3       13
```

- 몫이 0이 되면 반복을 멈추고, 마지막에 3을 모두 4로 변환한다.

### 작성 코드

```javascript
function solution(n) {
  let answer = "";

  while (n > 0) {
    let quotient = Math.floor(n / 3);
    let remainder = n % 3;
    if (remainder === 0) {
      quotient -= 1;
      remainder = 3;
    }
    answer = remainder + answer;

    if (quotient === 0) break;

    n = remainder === 3 ? quotient : Math.floor(n / 3);
  }

  return answer.replace(/3/g, "4");
}
```

## 👀참고한 풀이

```javascript
function solution(n) {
  let answer = "";
  const arr = [4, 1, 2];

  while (n > 0) {
    answer = arr[n % 3] + answer;
    n = Math.floor((n - 1) / 3);
  }

  return answer;
}
```

- 나머지에 따라 배열의 인덱스에서 숫자를 추가하도록 만든 코드이다.
- 반복문 안에서 n 을 n - 1 으로 빼는 이유는 나머지가 0 일때 몫을 -1 해주기 위함이다.
  - 만약 n이 6이라면, 나머지는 0이고, 몫은 2이다.
  - 이때, n을 5로 감소시키면 몫은 1이 되고, 몫을 다시 3 으로 나눈 나머지가 1 이 된다.
  - 나머지가 0이 아닐 때에도 n - 1 을 해주어도 다음 반복문에서 몫은 변하지 않는다.
  - 4 / 3 = (4 - 1) / 3 = 1
  - 5 / 3 = (5 - 1) / 3 = 1

# 참고자료

- [프로그래머스 - 124 나라의 숫자(Level 2)](https://minnnne.tistory.com/66)
