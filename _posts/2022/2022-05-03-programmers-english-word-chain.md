---
title: 프로그래머스 Level 2 - 영어 끝말잇기 (JavaScript)
date: 2022-05-03 21:00:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 영어 끝말잇기](https://programmers.co.kr/learn/course)

# 문제 설명

1부터 n까지 번호가 붙어있는 n명의 사람이 영어 끝말잇기를 하고 있습니다. 영어 끝말잇기는 다음과 같은 규칙으로 진행됩니다.

1. 1번부터 번호 순서대로 한 사람씩 차례대로 단어를 말합니다.
2. 마지막 사람이 단어를 말한 다음에는 다시 1번부터 시작합니다.
3. 앞사람이 말한 단어의 마지막 문자로 시작하는 단어를 말해야 합니다.
4. 이전에 등장했던 단어는 사용할 수 없습니다.
5. 한 글자인 단어는 인정되지 않습니다.

다음은 3명이 끝말잇기를 하는 상황을 나타냅니다.

tank → kick → know → wheel → land → dream → mother → robot → tank

위 끝말잇기는 다음과 같이 진행됩니다.

- 1번 사람이 자신의 첫 번째 차례에 tank를 말합니다.
- 2번 사람이 자신의 첫 번째 차례에 kick을 말합니다.
- 3번 사람이 자신의 첫 번째 차례에 know를 말합니다.
- 1번 사람이 자신의 두 번째 차례에 wheel을 말합니다.
- (계속 진행)

끝말잇기를 계속 진행해 나가다 보면, 3번 사람이 자신의 세 번째 차례에 말한 tank 라는 단어는 이전에 등장했던 단어이므로 탈락하게 됩니다.

사람의 수 n과 사람들이 순서대로 말한 단어 words 가 매개변수로 주어질 때, 가장 먼저 탈락하는 사람의 번호와 그 사람이 자신의 몇 번째 차례에 탈락하는지를 구해서 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- 끝말잇기에 참여하는 사람의 수 n은 2 이상 10 이하의 자연수입니다.
- words는 끝말잇기에 사용한 단어들이 순서대로 들어있는 배열이며, 길이는 n 이상 100 이하입니다.
- 단어의 길이는 2 이상 50 이하입니다.
- 모든 단어는 알파벳 소문자로만 이루어져 있습니다.
- 끝말잇기에 사용되는 단어의 뜻(의미)은 신경 쓰지 않으셔도 됩니다.
- 정답은 [ 번호, 차례 ] 형태로 return 해주세요.
- 만약 주어진 단어들로 탈락자가 생기지 않는다면, [0, 0]을 return 해주세요.

# 🙋‍♂️ 나의 풀이

## 🤔 문제 접근

반복문을 사용해서 주어진 배열 `words` 를 순회하며 아래의 조건들을 통과하는 단어인지 검사한다.

1. 문자열의 길이가 1 이상인가?
2. 처음으로 등장하는 단어인가?
3. 이전 문자열의 맨 마지막 문자와 현재 문자열의 첫 번째 문자가 다른가?

위의 조건을 통과하지 못하는 단어를 발견하는 즉시, 반복문을 멈춘다. 그리고 해당 단어의 인덱스 값을 통해 현재 몇 번째 사람인지, 몇 번째 차례인지 구한다.

- 현재 몇 번째 사람인가? = (인덱스 % 사람 수) + 1
- 현재 몇 번째 차례인가? = (인덱스 / 사람 수)의 반내림 값 + 1
  - 만약 사람이 3명이고, 현재 인덱스 값이 4 라고 해보자. (3 / 4) = 1.xx 이기 때문에 소수점을 버리기 위해서 반내림 값을 이용해야 한다.

## ✍️ 작성 코드

```javascript
function solution(n, words) {
  const result = [0, 0];
  const spoken = new Set();
  let currentPerson = 0;
  let currentRound = 0;

  words.some((word, i, arr) => {
    currentPerson = (i % n) + 1;
    currentRound = i % n === 0 ? currentRound + 1 : currentRound;
    if (i === 0) spoken.add(word);
    else if (isAlreadySpoken(word, spoken) || isValidWord(arr[i - 1], word)) {
      result.splice(0, 2, currentPerson, currentRound);
      return true;
    } else spoken.add(word);
  });

  return result;
}

const isAlreadySpoken = (word, set) => {
  if (!set.has(word)) return false;
  return true;
};

const isValidWord = (prev, curr) => {
  if (prev[prev.length - 1] === curr[0]) return false;
  if (curr.length === 1) return false;
  return true;
};
```

위의 문제 접근과는 달리, 현재 몇 번째 사람인지와 현재 몇 번째 차례인지 구하는 로직이 다르다.

위의 코드는 다른 분들의 풀이를 보기 전에 작성한 코드이다.

첫 번째 단어이거나 처음 등장하는 단어이거나 유효한 단어는 `Set` 에 추가하도록 했다.

`some` 함수를 사용해서 유효하지 않거나 이전에 등장한 단어라면 바로 반복문을 탈출할 수 있도록 했다. `forEach` 함수에서는 `break` 를 할 수 있는 기능이 없기 때문에 `some` 함수를 사용했다.

# 👀 참고한 풀이

```javascript
function solution(n, words) {
  let answer = 0;
  words.reduce((prev, now, idx) => {
    answer =
      answer ||
      (words.slice(0, idx).indexOf(now) !== -1 || prev !== now[0]
        ? idx
        : answer);
    return now[now.length - 1];
  }, "");

  return answer ? [(answer % n) + 1, Math.floor(answer / n) + 1] : [0, 0];
}
```

짧은 코드로 문제를 잘 풀어냈다. 등장한 단어를 별도의 `Set` 에 추가하는 대신, 이전 단어의 맨 마지막 글자만 `reduce` 에 저장하여 현재 단어의 첫 글자와 비교했다.

하지만 위의 코드는 유효하지 않은 단어이거나, 이전에 등장했던 단어를 발견하는 순간 멈추지 않고, 배열의 끝까지 순회하는 문제가 있다.

# ⚙️ Refactoring

내가 작성한 코드에서 개선해야 하는 부분은 다음과 같다.

1. 등장한 단어를 다른 배열에 저장하는 것
   - `slice` 함수와 인덱스를 사용하면 별도로 배열에 저장하지 않고 이전에 등장한 단어인지 판단할 수 있다.
   - 이전 단어와 현재 단어를 비교하는 것도 글자를 전부 비교하는 것이 아니라 한 글자씩만 비교하면 된다.
2. 현재 몇 번째 사람, 몇 번째 차례인지 반복문을 돌 때마다 계산하는 것
   - 현재 인덱스 번호로도 충분히 계산이 가능하기 때문에 불필요한 연산이다.
3. 배열의 0번째 인덱스를 검사하는 것
   - 이 조건을 검사하기 때문에 별도의 배열에 저장하는 코드가 중복되었다.
   - 또한, 배열의 첫 번째 인덱스만 유효한 조건이기 때문에 나머지 인덱스에 대해서는 불필요한 연산이다.

참고한 코드에서 발견한 문제점을 고려하여 개선한 코드는 다음과 같다.

```javascript
function solution(n, words) {
  let answer = true;
  let idx = 1;

  for (; idx < words.length; idx++) {
    const prev = words[idx - 1];
    const curr = words[idx];
    if (!isValidWord(prev, curr) || isSpokenBefore(words.slice(0, idx), curr)) {
      answer = false;
      break;
    }
  }

  const currentPerson = (idx % n) + 1;
  const currentRound = Math.floor(idx / n) + 1;

  return answer ? [0, 0] : [currentPerson, currentRound];
}

const isValidWord = (prev, curr) => {
  if (prev[prev.length - 1] !== curr[0]) return false;
  if (curr.length === 1) return false;
  return true;
};

const isSpokenBefore = (arr, word) => {
  if (arr.indexOf(word) === -1) return false;
  return true;
};
```

`reduce` 대신 `for` 문을 사용하고, 유효하지 않은 단어이거나, 이전에 등장한 단어라면 `break` 를 사용해서 반복문을 탈출하도록 했다.

또한, 모든 단어가 문제 없이 잘 제시된 경우를 확인하기 위한 플래그 변수 `answer` 를 활용했다. 반복문이 끝나고 나서 문제 없이 진행됐다면 `[0, 0]` 을 반환하고, 그렇지 않다면 `[현재 사람 번호, 현재 차례]` 를 반환하도록 했다.
