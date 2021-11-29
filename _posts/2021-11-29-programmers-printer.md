---
title: 프로그래머스 Level 2 - 124 나라의 숫자 (JavaScript)
date: 2021-11-29 23:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 프린터](https://programmers.co.kr/learn/courses/30/lessons/42587)

# 문제 설명

---

일반적인 프린터는 인쇄 요청이 들어온 순서대로 인쇄합니다. 그렇기 때문에 중요한 문서가 나중에 인쇄될 수 있습니다. 이런 문제를 보완하기 위해 중요도가 높은 문서를 먼저 인쇄하는 프린터를 개발했습니다. 이 새롭게 개발한 프린터는 아래와 같은 방식으로 인쇄 작업을 수행합니다.

```
1. 인쇄 대기목록의 가장 앞에 있는 문서(J)를 대기목록에서 꺼냅니다.
2. 나머지 인쇄 대기목록에서 J보다 중요도가 높은 문서가 한 개라도 존재하면 J를 대기목록의 가장 마지막에 넣습니다.
3. 그렇지 않으면 J를 인쇄합니다.
```

예를 들어, 4개의 문서(A, B, C, D)가 순서대로 인쇄 대기목록에 있고 중요도가 2 1 3 2 라면 C D A B 순으로 인쇄하게 됩니다.

내가 인쇄를 요청한 문서가 몇 번째로 인쇄되는지 알고 싶습니다. 위의 예에서 C는 1번째로, A는 3번째로 인쇄됩니다.

현재 대기목록에 있는 문서의 중요도가 순서대로 담긴 배열 priorities와 내가 인쇄를 요청한 문서가 현재 대기목록의 어떤 위치에 있는지를 알려주는 location이 매개변수로 주어질 때, 내가 인쇄를 요청한 문서가 몇 번째로 인쇄되는지 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 현재 대기목록에는 1개 이상 100개 이하의 문서가 있습니다.
- 인쇄 작업의 중요도는 1~9로 표현하며 숫자가 클수록 중요하다는 뜻입니다.
- location은 0 이상 (현재 대기목록에 있는 작업 수 - 1) 이하의 값을 가지며 대기목록의 가장 앞에 있으면 0, 두 번째에 있으면 1로 표현합니다.

## 🙋‍♂️나의 풀이

다른 분의 풀이를 참고해서 풀었다.

### 작성 코드

```javascript
function solution(priorities, location) {
  const sequence = [];
  const start = [];
  const priorities_dict = {};

  priorities.forEach((priority, idx) => {
    priorities_dict[idx] = priority;
    start.push(idx);
  });

  while (start.length) {
    const currentMaxPriority = Math.max(...priorities);
    if (currentMaxPriority > priorities_dict[start[0]]) {
      start.push(start.shift());
    } else {
      sequence.push(start[0]);
      const value = priorities_dict[start.shift()];
      const idx = priorities.indexOf(value);
      priorities.splice(idx, 1);
    }
  }

  return sequence.indexOf(location) + 1;
}
```

- 인쇄 전 인덱스와 중요도를 해쉬 테이블로 저장하고, 인덱스를 배열에 저장하여 작업 대기열을 만든다.
- 중요도가 담긴 배열에서 최댓값을 찾는다.
  - 만약, 현재 작업 대기열의 맨 첫 번째에 있는 인덱스에 해당하는 값보다 크다면, 작업 대기열의 맨 첫 번째 요소를 맨 뒤로 보낸다.
  - 그렇지 않다면, 인쇄가 완료된 순서를 저장하는 배열에 맨 첫 번째 인덱스를 저장한다. 그리고 해당 값을 중요도가 저장된 배열에서 제거한다.
- 모든 작업이 끝나면, 문서가 인쇄된 순서가 저장된 배열에서 요청한 문서의 인덱스를 찾고, 그 값이 위치한 인덱스 + 1 을 반환한다.

## 👀참고한 풀이

```javascript
function solution(priorities, location) {
  var list = priorities.map((t, i) => ({
    my: i === location,
    val: t,
  }));
  var count = 0;
  while (true) {
    var cur = list.splice(0, 1)[0];
    if (list.some((t) => t.val > cur.val)) {
      list.push(cur);
    } else {
      count++;
      if (cur.my) return count;
    }
  }
}
```

- 해쉬 테이블에 boolean 값으로 내가 요청한 문서인지 여부와 중요도를 저장하였다.
- `map` 으로 객체를 반환할 때는 그룹 연산자에 해당하는 소괄호를 씌워주어야 한다.
- `some` 함수를 사용해서 현재 맨 첫 번째 문서의 중요도보다 큰 값이 있는 경우에는 첫 번째 문서를 맨 뒤로 보낸다.
- 아닌 경우에는 출력을 했다는 표시를 위해 카운트를 올린다. 그리고 만약 내가 요청한 문서라면 카운트를 반환하여 반복문을 빠져나온다.
