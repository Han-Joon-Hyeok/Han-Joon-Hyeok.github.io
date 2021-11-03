---
title: 프로그래머스 Level 1 - 숫자 문자열과 영단어
date: 2021-11-03 16:45:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 숫자 문자열과 영단어](https://programmers.co.kr/learn/courses/30/lessons/81301)

# 문제 설명

네오와 프로도가 숫자놀이를 하고 있습니다. 네오가 프로도에게 숫자를 건넬 때 일부 자릿수를 영단어로 바꾼 카드를 건네주면 프로도는 원래 숫자를 찾는 게임입니다.다음은 숫자의 일부 자릿수를 영단어로 바꾸는 예시입니다.

- 1478 → "one4seveneight"
- 234567 → "23four5six7"
- 10203 → "1zerotwozero3"

이렇게 숫자의 일부 자릿수가 영단어로 바뀌어졌거나, 혹은 바뀌지 않고 그대로인 문자열 `s`가 매개변수로 주어집니다. `s`가 의미하는 원래 숫자를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- 1 ≤ `s`의 길이 ≤ 50
- `s`가 "zero" 또는 "0"으로 시작하는 경우는 주어지지 않습니다.
- return 값이 1 이상 2,000,000,000 이하의 정수가 되는 올바른 입력만 `s`로 주어집니다.

## 🙋‍♂️나의 풀이

- 영단어를 배열에 순서대로 저장하면 요소에 해당하는 인덱스가 곧 교체하는 숫자가 된다.
- `table` 배열의 모든 요소를 순회하며 해당 영단어를 모두 숫자로 바꾼다.
- `string` 으로 저장된 문자열을 `number` 형으로 변환한다.

```javascript
function solution(s) {
  const table = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
  ];

  table.forEach((eng, idx) => {
    const regex = new RegExp(eng, "g");
    s = s.replace(regex, idx);
  });

  return +s;
}
```

## 👀참고한 풀이

```javascript
function solution(s) {
  let numbers = [
    "zero",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
  ];
  var answer = s;

  for (let i = 0; i < numbers.length; i++) {
    let arr = answer.split(numbers[i]);
    answer = arr.join(i);
  }

  return Number(answer);
}
```

- 문자열이 저장된 배열을 순회하며 문자열에 해당하는 요소를 기준으로 `split` 하여 배열로 만든다.
  - 만약, `one32` 인 경우, `[one, 3, 2]`로 나뉜다.
- 앞 단계에서 수행한 배열을 인덱스로 `join` 하여 다시 문자열로 만든다.
  - `[one, 3, 2]`은 `132` 가 된다.
