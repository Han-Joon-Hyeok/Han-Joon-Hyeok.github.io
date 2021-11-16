---
title: 프로그래머스 Level 1 - 모의고사 (JavaScript)
date: 2021-11-16 10:30:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 모의고사](https://programmers.co.kr/learn/courses/30/lessons/42840?language=javascript)

# 문제 설명

수포자는 수학을 포기한 사람의 준말입니다. 수포자 삼인방은 모의고사에 수학 문제를 전부 찍으려 합니다. 수포자는 1번 문제부터 마지막 문제까지 다음과 같이 찍습니다.

1번 수포자가 찍는 방식: 1, 2, 3, 4, 5, 1, 2, 3, 4, 5, ...2번 수포자가 찍는 방식: 2, 1, 2, 3, 2, 4, 2, 5, 2, 1, 2, 3, 2, 4, 2, 5, ...3번 수포자가 찍는 방식: 3, 3, 1, 1, 2, 2, 4, 4, 5, 5, 3, 3, 1, 1, 2, 2, 4, 4, 5, 5, ...

1번 문제부터 마지막 문제까지의 정답이 순서대로 들은 배열 answers가 주어졌을 때, 가장 많은 문제를 맞힌 사람이 누구인지 배열에 담아 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 시험은 최대 10,000 문제로 구성되어있습니다.
- 문제의 정답은 1, 2, 3, 4, 5중 하나입니다.
- 가장 높은 점수를 받은 사람이 여럿일 경우, return하는 값을 오름차순 정렬해주세요.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 정답과 학생들이 찍는 번호를 모두 비교한다.
- 가장 많이 맞춘 최댓값을 구하고, 학생들이 맞춘 정답 수와 최댓값을 비교한다.

### 작성 코드

```javascript
function solution(answers) {
  const students = [
    [1, 2, 3, 4, 5],
    [2, 1, 2, 3, 2, 4, 2, 5],
    [3, 3, 1, 1, 2, 2, 4, 4, 5, 5],
  ];
  const results = [];

  for (let i = 0; i < students.length; i++) {
    const student = students[i];
    const len = student.length;
    let cnt = 0;
    for (let j = 0; j < answers.length; j++) {
      const idx = j % len;
      if (answers[j] === student[idx]) {
        cnt++;
      }
    }
    results.push(cnt);
  }

  const max = Math.max(...results);
  const answer = results.reduce((acc, cur, idx) => {
    if (cur === max) return [...acc, idx + 1];
    return [...acc];
  }, []);

  return answer;
}
```

- 정답 수를 구하기 위해서 2중 반복문을 사용했다.
  - 문제의 정답은 학생의 패턴보다 길 수 있으므로, 인덱스를 패턴의 길이로 나눈 나머지로 패턴을 반복해서 탐색하도록 했다.
- 가장 많이 맞춘 학생을 찾기 위해 정답 수의 최댓값을 구했다.
- 그 다음, 학생들의 정답 수가 담긴 배열을 돌며, 최댓값과 같으면 인덱스 + 1을 해서 학생을 추가했다.

## 👀참고한 풀이

```javascript
function solution(answers) {
  var answer = [];
  var a1 = [1, 2, 3, 4, 5];
  var a2 = [2, 1, 2, 3, 2, 4, 2, 5];
  var a3 = [3, 3, 1, 1, 2, 2, 4, 4, 5, 5];

  var a1c = answers.filter((a, i) => a === a1[i % a1.length]).length;
  var a2c = answers.filter((a, i) => a === a2[i % a2.length]).length;
  var a3c = answers.filter((a, i) => a === a3[i % a3.length]).length;
  var max = Math.max(a1c, a2c, a3c);

  if (a1c === max) {
    answer.push(1);
  }
  if (a2c === max) {
    answer.push(2);
  }
  if (a3c === max) {
    answer.push(3);
  }

  return answer;
}
```

- `filter` 메서드를 사용해서 정답인 항목을 배열에 추가하고, 이 배열의 길이를 변수에 저장했다.
- 다만, 학생의 정답 패턴을 각각의 변수로 나누었는데, 나중에 학생이 늘어나면 모든 패턴을 변수에 저장하는 것은 비효율적이다. 배열 안에서 다시 배열을 선언하는 방식으로 관리를 하는 것이 확장성 측면에서는 좋아보인다.

## ⚙️ Refactoring

```javascript
function solution(answers) {
  const students = [
    [1, 2, 3, 4, 5],
    [2, 1, 2, 3, 2, 4, 2, 5],
    [3, 3, 1, 1, 2, 2, 4, 4, 5, 5],
  ];

  const results = students.map(
    (student) =>
      answers.filter((ans, idx) => ans === student[idx % student.length]).length
  );
  const max = Math.max(...results);
  const answer = results.reduce((acc, cur, idx) => {
    if (max === cur) return [...acc, idx + 1];
    return [...acc];
  }, []);

  return answer;
}
```

- 2중 for문 대신 `filter` 를 이용해서 정답을 구하는 방식으로 바꾸었다. 코드의 길이도 훨씬 짧아지고, 실행 속도도 미세하지만 더욱 빨라졌다.
