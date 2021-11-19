---
title: 프로그래머스 Level 1 - 다트 게임 (JavaScript)
date: 2021-11-19 22:00:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 다트 게임](https://programmers.co.kr/learn/courses/30/lessons/17682)

# 문제 설명

문제 설명 생략

## 🙋‍♂️나의 풀이

카카오 문제답게 string manipulation 에는 정규 표현식을 사용하면 쉽게 풀 수 있다.

코드의 전체적인 흐름은 다음과 같다.

- 각 라운드의 결과를 토큰화하고, 각 라운드 별 점수를 로직에 맞게 처리하여 배열에 저장한다.
- 최종 점수를 구하기 위해 배열의 모든 수를 더한다.

### 작성 코드

```javascript
function solution(dartResult) {
  const regex = new RegExp(/(\d+\w[*#]?)/g, "g");
  const splitRegex = new RegExp(/\d+|\w|[*#]/, "g");
  const TYPES = ["S", "D", "T"];
  const tokens = dartResult.match(regex);
  const result = tokens.reduce(([...acc], token) => {
    const [num, type, option] = token.match(splitRegex);

    let curr = num ** (TYPES.indexOf(type) + 1);

    if (option === "#") {
      return [...acc, -curr];
    }

    if (option === "*") {
      return [...acc.slice(0, -1), acc.slice(-1) * 2, curr * 2];
    }

    return [...acc, curr];
  }, []);
  return result.reduce((acc, cur) => acc + cur);
}
```

세부적인 코드 흐름을 살펴보자.

1. 정규 표현식으로 각 라운드의 결과를 배열로 나눈다.

```javascript
'1D2S#10S' -> ['1D', '2S#', '10S']
```

2. 1번의 결과로 나온 배열에서 다시 토큰화를 해서 점수와 영역에 따른 보너스, 옵션을 변수에 저장한다.

```javascript
'1D' -> ['1', 'D']
'2S#' -> ['2', 'S', '#']
'10S' -> ['10', 'S']
```

3. 점수와 영역에 따른 보너스를 곱한다. 보너스는 배열에 저장된 인덱스 번호 + 1을 해서 제곱한다.

````javascript
'1D' -> 1 ** (TYPES.indexOf('D') + 1) -> 1 ** (1 + 1)
``2. 만약 옵션이 존재한다면, 각각의 옵션에 따라 계산을 진행한다.

```javascript
// 옵션이 #이면 음수로 바꾸어서 계산
if (option === "#") {
  return [...acc, -curr];
}

// 옵션이 *이면 이전 점수와 현재 점수에 2배를 한다.
// slice(0, -1)은 첫 번째 요소부터 n-1번째 요소까지 선택한다.
if (option === "*") {
  return [...acc.slice(0, -1), acc.slice(-1) * 2, curr * 2];
}

// 아무 옵션도 없으면 연산 결과를 배열에 추가한다.
return [...acc, curr];
````

4. 로직에 맞게 처리된 수들을 모두 더한다.

```javascript
return result.reduce((acc, cur) => acc + cur);
```

## 👀참고한 풀이

```javascript
function solution(dartResult) {
  const bonus = { S: 1, D: 2, T: 3 },
    options = { "*": 2, "#": -1, undefined: 1 };

  let darts = dartResult.match(/\d.?\D/g);

  for (let i = 0; i < darts.length; i++) {
    let split = darts[i].match(/(^\d{1,})(S|D|T)(\*|#)?/),
      score = Math.pow(split[1], bonus[split[2]]) * options[split[3]];

    if (split[3] === "*" && darts[i - 1]) darts[i - 1] *= options["*"];

    darts[i] = score;
  }

  return darts.reduce((a, b) => a + b);
}
```

- 보너스와 옵션에 대한 정보를 객체로 저장하였다. 조건문을 따로 쓰지 않아도 계산이 가능하다.
- `options` 에 `undefined` 는 배열에 옵션이 저장되지 않았을 때 반환되는 값이다.

### ⚙️ Refactoring

```javascript
function solution(dartResult) {
  const bonus = { S: 1, D: 2, T: 3 },
    options = { "*": 2, "#": -1, undefined: 1 };

  const tokens = dartResult.match(/\d.?\D/g);

  const splitRegex = new RegExp(/\d+|\w|[*#]/, "g");
  tokens.forEach((token, idx) => {
    const [score, type, option] = token.match(splitRegex);
    const sum = score ** bonus[type] * options[option];
    if (option === "*" && tokens[idx - 1]) {
      tokens[idx - 1] *= options[option];
    }
    tokens[idx] = sum;
  });

  return tokens.reduce((acc, cur) => acc + cur);
}
```

- 참고한 풀이에서 let 변수를 const로 변경하여 의도하지 않은 변수의 변경이 일어나지 않도록 했다.
- 점수, 영역, 옵션에 접근할 때 인덱스가 아닌 비구조 할당을 통해 변수로 저장했다.
