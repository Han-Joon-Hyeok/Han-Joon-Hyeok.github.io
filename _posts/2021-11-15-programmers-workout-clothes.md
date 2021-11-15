---
title: 프로그래머스 Level 1 - 체육복 (JavaScript)
date: 2021-11-15 15:35:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 체육복](https://programmers.co.kr/learn/courses/30/lessons/42862)

# 문제 설명

점심시간에 도둑이 들어, 일부 학생이 체육복을 도난당했습니다. 다행히 여벌 체육복이 있는 학생이 이들에게 체육복을 빌려주려 합니다. 학생들의 번호는 체격 순으로 매겨져 있어, 바로 앞번호의 학생이나 바로 뒷번호의 학생에게만 체육복을 빌려줄 수 있습니다. 예를 들어, 4번 학생은 3번 학생이나 5번 학생에게만 체육복을 빌려줄 수 있습니다. 체육복이 없으면 수업을 들을 수 없기 때문에 체육복을 적절히 빌려 최대한 많은 학생이 체육수업을 들어야 합니다.

전체 학생의 수 n, 체육복을 도난당한 학생들의 번호가 담긴 배열 lost, 여벌의 체육복을 가져온 학생들의 번호가 담긴 배열 reserve가 매개변수로 주어질 때, 체육수업을 들을 수 있는 학생의 최댓값을 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 전체 학생의 수는 2명 이상 30명 이하입니다.
- 체육복을 도난당한 학생의 수는 1명 이상 n명 이하이고 중복되는 번호는 없습니다.
- 여벌의 체육복을 가져온 학생의 수는 1명 이상 n명 이하이고 중복되는 번호는 없습니다.
- 여벌 체육복이 있는 학생만 다른 학생에게 체육복을 빌려줄 수 있습니다.
- 여벌 체육복을 가져온 학생이 체육복을 도난당했을 수 있습니다. 이때 이 학생은 체육복을 하나만 도난당했다고 가정하며, 남은 체육복이 하나이기에 다른 학생에게는 체육복을 빌려줄 수 없습니다.

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 여벌을 가져온 학생을 포함해서 앞, 뒤로 체육복을 잃어버렸다면 체육복을 빌려준다.
- 만약, 여벌을 가져온 학생도 도둑을 맞았다면, 다른 학생에게 빌려줄 수 없다.

### 작성 코드

```javascript
function solution(n, lost, reserve) {
  reserve.sort((a, b) => a - b);

  const ableToLend = reserve.reduce(([...acc], curr) => {
    const currIdx = lost.indexOf(curr);
    if (currIdx !== -1) {
      lost.splice(currIdx, 1);
      return [...acc];
    }
    return [...acc, curr];
  }, []);

  ableToLend.forEach((curr) => {
    const prev = curr - 1;
    const prevIdx = lost.indexOf(prev);
    if (prevIdx !== -1) {
      lost.splice(prevIdx, 1);
      return;
    }

    const next = curr + 1;
    const nextIdx = lost.indexOf(next);
    if (nextIdx !== -1) {
      lost.splice(nextIdx, 1);
    }
  });

  return n - lost.length;
}
```

- 여벌을 가져온 학생의 배열을 순서대로 정렬한다. (선택사항)
  - 만약, 여벌을 가져온 학생의 번호가 거꾸로 들어온다면 빌려주지 못하는 경우를 방지하기 위함이다.
    n : 5, [2, 4], [5, 3] → 테스트 케이스 18, 20번 해당
  - 이는 내가 작성한 코드에만 해당하는 사항이므로, 정렬하는 것은 선택사항이다.
- 여벌을 가져온 학생도 도둑을 맞았는 지 확인하고, 다른 학생들에게 체육복을 빌려줄 수 있는 학생들만 분리한다.
- 빌려줄 수 있는 학생을 순서대로 순회하며 앞, 뒤로 잃어버린 학생이 있다면 잃어버린 학생들 목록에서 제거한다.

## 👀참고한 풀이

```javascript
function solution(n, lost, reserve) {
  return (
    n -
    lost.filter((a) => {
      const b = reserve.find((r) => Math.abs(r - a) <= 1);
      if (!b) return true;
      reserve = reserve.filter((r) => r !== b);
    }).length
  );
}
```

- 2021년 11월 15일 기준으로 테스트 케이스를 전부 통과하지 못하지만, 논리적으로 잘 짜여진 코드라서 참고해보았다.
- 잃어버린 학생을 기준으로 앞 뒤로 여벌의 체육복이 있는 지 확인한다. 없으면 수업에 참여할 수 없으므로 넘어가고, 있다면 여벌을 가진 배열에서 빌려준 학생을 제거한다.
- 하지만, 위의 코드는 여벌을 가져온 학생이 도둑을 맞은 경우에도 자신이 입지 않고, 남에게 빌려주기 때문에 조건을 만족하지 못한다.

### Refactoring

```javascript
function solution(n, lost, reserve) {
  const ableToLend = reserve
    .filter((res) => lost.indexOf(res) === -1)
    .sort((a, b) => a - b);
  const wantToBorrow = lost
    .filter((lose) => reserve.indexOf(lose) === -1)
    .sort((a, b) => a - b);

  return (
    n -
    wantToBorrow.filter((lose) => {
      const target = ableToLend.find((res) => Math.abs(res - lose) === 1);
      if (!target) return true;
      ableToLend.splice(ableToLend.indexOf(target), 1);
    }).length
  );
}
```

현재 테스트 케이스에 맞추어 통과할 수 있도록 다시 코드를 작성해보았다.

- 여벌을 갖고 왔지만 도둑을 맞은 학생들은 각각의 배열에서 제거하고, 순서대로 정렬을 해주었다.
- 절댓값 차이가 1이 넘는 번호는 빌릴 수 없으므로, 해당 번호들의 개수를 전체 n에서 빼주었다.
- 절댓값 차이가 1인 번호는 빌렸으므로, 여벌을 가진 학생의 배열에서 빌려준 학생은 지워준다.
