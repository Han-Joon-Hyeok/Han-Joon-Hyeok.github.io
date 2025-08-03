---
title: 프로그래머스 Level 2 - H-Index (JavaScript)
date: 2021-12-16 23:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 H-Index](https://programmers.co.kr/learn/courses/30/lessons/42747)

# 문제 설명

---

H-Index는 과학자의 생산성과 영향력을 나타내는 지표입니다. 어느 과학자의 H-Index를 나타내는 값인 h를 구하려고 합니다. 위키백과[1](https://programmers.co.kr/learn/courses/30/lessons/42747#fn1)에 따르면, H-Index는 다음과 같이 구합니다.

어떤 과학자가 발표한 논문 `n`편 중, `h`번 이상 인용된 논문이 `h`편 이상이고 나머지 논문이 h번 이하 인용되었다면 `h`의 최댓값이 이 과학자의 H-Index입니다.

어떤 과학자가 발표한 논문의 인용 횟수를 담은 배열 citations가 매개변수로 주어질 때, 이 과학자의 H-Index를 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 과학자가 발표한 논문의 수는 1편 이상 1,000편 이하입니다.
- 논문별 인용 횟수는 0회 이상 10,000회 이하입니다.

## 🙋‍♂️나의 풀이

정렬이 아닌 주어진 정의대로 문제를 해결했다.

- 주어진 배열에서 H-Index 가 가질 수 있는 최댓값은 배열의 최댓값과 같다.
- 0부터 배열의 최댓값까지 배열 내에 인용 횟수와 비교한다.
  - 현재 인덱스 값 이상으로 인용된 값의 개수를 구한다.
  - 만약, 현재 인덱스보다 인용된 횟수가 적다면 인덱스를 1 올려서 다음 반복문을 실행한다.
  - 현재 인덱스 미만으로 인용된 값의 개수를 구한다. 이 값이 `전체 배열의 길이 - 인덱스 값 이상 개수` 와 동일하다면 해당 인덱스가 H-Index 가 된다.

### 작성 코드

```javascript
function solution(citations) {
  let answer = 0;

  const max = Math.max(...citations);

  for (let i = 0; i <= max; i++) {
    const citationCnt = citations.filter((citation) => citation >= i).length;

    if (citationCnt < i) continue;

    const underCitation = citations.filter((citation) => citation < i).length;
    if (citations.length - citationCnt === underCitation) {
      answer = i;
    }
  }

  return answer;
}
```

- 정답은 맞혔으나, 반복문 내에서 filter 함수를 쓰기 때문에 시간이 오래 걸리는 문제점이 있다.

## 👀참고한 풀이

```javascript
function solution(citations) {
  citations.sort((a, b) => b - a);

  let i = 0;
  while (i + 1 <= citations[i]) {
    i++;
  }

  return i;
}
```

- 주어진 배열을 내림차순으로 정렬한다.
- `i + 1` 은 현재 논문과 순회를 마친 논문을 포함한 논문 n편을 의미한다. 인덱스가 0부터 시작하므로 +1을 한 것이다. (문제에서는 n을 전체 논문의 개수를 의미하지만, 여기서는 앞서 설명한 의미로 사용한다.)
- `citations[i]` 는 논문의 인용된 횟수, 즉 h 이다.
- 인덱스가 증가하면서 h번 이상 인용된 논문이 n편 이상인지 파악할 수 있다.

```javascript
// 원본 배열
// [3, 0, 6, 1, 5]

// 내림차순 정렬 후 배열
// [6, 5, 3, 1, 0]

//   i   i + 1    citations[i]
//   0     1           6
//   1     2           5
//   2     3           3
//   3     4           1     --> 반복문 조건 만족 X
```

- 예를 들어, `i` 값이 1일 때는 내림차순 정렬을 했기 때문에 5번 이상 인용된 논문의 개수가 2개라는 것을 알 수 있다.

## 참고자료

- [프로그래머스 문제 풀이 H-Index](https://gurumee92.tistory.com/177)
