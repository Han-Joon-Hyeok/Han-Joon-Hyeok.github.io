---
title: 프로그래머스 Level 2 - 스킬트리 (JavaScript)
date: 2021-11-24 19:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
---

> [프로그래머스 - Level2 스킬트리](https://programmers.co.kr/learn/courses/30/lessons/49993)

# 문제 설명

---

선행 스킬이란 어떤 스킬을 배우기 전에 먼저 배워야 하는 스킬을 뜻합니다.

예를 들어 선행 스킬 순서가 `스파크 → 라이트닝 볼트 → 썬더`일때, 썬더를 배우려면 먼저 라이트닝 볼트를 배워야 하고, 라이트닝 볼트를 배우려면 먼저 스파크를 배워야 합니다.

위 순서에 없는 다른 스킬(힐링 등)은 순서에 상관없이 배울 수 있습니다. 따라서 `스파크 → 힐링 → 라이트닝 볼트 → 썬더`와 같은 스킬트리는 가능하지만, `썬더 → 스파크`나 `라이트닝 볼트 → 스파크 → 힐링 → 썬더`와 같은 스킬트리는 불가능합니다.

선행 스킬 순서 skill과 유저들이 만든 스킬트리[1](https://programmers.co.kr/learn/courses/30/lessons/49993#fn1)를 담은 배열 skill_trees가 매개변수로 주어질 때, 가능한 스킬트리 개수를 return 하는 solution 함수를 작성해주세요.

## 제한사항

- 스킬은 알파벳 대문자로 표기하며, 모든 문자열은 알파벳 대문자로만 이루어져 있습니다.
- 스킬 순서와 스킬트리는 문자열로 표기합니다.
  - 예를 들어, `C → B → D` 라면 "CBD"로 표기합니다
- 선행 스킬 순서 skill의 길이는 1 이상 26 이하이며, 스킬은 중복해 주어지지 않습니다.
- skill_trees는 길이 1 이상 20 이하인 배열입니다.
- skill_trees의 원소는 스킬을 나타내는 문자열입니다.
  - skill_trees의 원소는 길이가 2 이상 26 이하인 문자열이며, 스킬이 중복해 주어지지 않습니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```javascript
function solution(skills, skill_trees) {
  const result = [];
  for (let i = 0; i < skill_trees.length; i++) {
    const skill_tree = skill_trees[i];
    let prev_idx = skill_tree.indexOf(skills[0]);
    let isAvailable = true;
    for (let j = 1; j < skills.length; j++) {
      const curr = skills[j];
      const skill_index = skill_tree.indexOf(curr);
      if (prev_idx === -1 && skill_index >= 0) {
        isAvailable = false;
        break;
      }
      if (prev_idx !== -1 && skill_index !== -1 && prev_idx > skill_index) {
        isAvailable = false;
        break;
      }
      prev_idx = skill_index;
    }
    result.push(isAvailable);
  }

  return result.filter((v) => v).length;
}
```

복잡하긴 하지만, 경우의 수를 나누어서 생각했다.

1. 이전 선행 스킬이 찍히지 않았는데 다음 스킬을 찍은 경우
2. 이전 선행 스킬과 현재 스킬을 모두 찍었지만, 현재 스킬이 먼저 찍힌 경우

2가지 경우에 대해 잡아내는 것을 2중 반복문으로 구현했다.

## 👀참고한 풀이

```javascript
function solution(skill, skill_trees) {
  var answer = 0;
  var regex = new RegExp(`[^${skill}]`, "g");

  return skill_trees
    .map((x) => x.replace(regex, ""))
    .filter((x) => {
      return skill.indexOf(x) === 0 || x === "";
    }).length;
}
```

사실 처음에 정규 표현식을 쓰면 풀릴 것 같다는 생각이 들었는데, 어떻게 사용해야 할 지 몰라서 다른 방식을 선택했다.

- 정규 표현식으로 스킬 트리에서 선행 스킬이 아닌 스킬들을 모두 공백으로 바꾼다.
- 그 결과로 선행 스킬들이 찍힌 순서가 나온다.

```javascript
// skill: "CBD"
const arr = ["BACDE", "CBADF", "AECB", "BDA", "XYZ"];

// 정규 표현식 적용 후
const filterd = ["BCD", "CBD", "CB", "BD", ""];
```

- 선행 스킬들이 제대로 찍혔다면 스킬의 맨 처음부터 찍혀야 하고, 이를 인덱스로 찾아보면 0 이 나와야 한다.
- 또는 선행 스킬을 아예 찍지 않는 경우도 있는데, 정규 표현식을 적용한 결과는 공백이 반환된다.

```javascript
// 인덱스 탐색 결과
[-1, 0, 0, 1, 0];
```

- 여기서 빈 문자열(`''`)의 인덱스는 항상 0 이 반환된다. 쉽게 생각하면, 모든 문자열의 사이에는 빈 문자열이 포함되었다고 생각하면 된다.
- `indexOf` 메서드는 가장 먼저 찾은 요소를 반환하는데, 빈 문자열은 어디에나 존재하기 때문에 가장 먼저 발견할 수 있는 인덱스는 0이 된다.

```javascript
const str = "foo";
console.log(str.substring(0, 0)); // ''
console.log(str.substring(1, 1)); // ''
console.log(str.substring(2, 2)); // ''
```

- 문자열을 한 글자씩 나눌 때, `split('')` 을 사용하는 것과 같은 원리라고 생각하면 된다.

```javascript
const str = "foo";
const arr = str.split("");

console.log(arr); // ['f', 'o', 'o']
```

- `indexOf()` 대신 `startsWith()` 메서드를 사용해도 좋다.
