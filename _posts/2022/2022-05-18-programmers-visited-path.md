---
title: 프로그래머스 Level 2 - 방문 길이 (JavaScript)
date: 2022-05-18 16:30:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 방문 길이](https://programmers.co.kr/learn/courses/30/lessons/49994#)

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

문제 자체가 어렵지는 않았지만, 지나온 길을 어떻게 저장할 것인지가 가장 중요했던 문제다.

참고로 JavaScript 에서 배열끼리 비교를 한다면, 원하는 대로 되지 않을 것이다.

예를 들어, 다음과 같은 2차원 배열이 있다고 해보자.

```javascript
const arr = [[0, 0]]; // 2차원 배열
```

그리고 `[[0, 0]]` 을 새롭게 추가하고자 할 때, 다음과 같은 코드를 작성할 수 있을 것이다.

```javascript
if (arr.includes([0, 0]))
	// ...
```

하지만, if 문의 조건은 `false` 를 반환한다.

```javascript
console.log(arr.includes([0, 0])); // false
```

JavaScript 에서 배열은 객체이고, 객체는 각자 고유한 주소값을 가지기 때문에 위와 같은 결과가 나오는 것이다.

각각의 배열 내부에 있는 값은 모두 동일하지만, 배열이 가지고 있는 값은 사실 주소값이기 때문이다.

즉, 배열끼리 배열 내부의 값을 비교하는 것은 위와 같은 방법으로는 불가능 하다는 것이다. 그렇기 때문에 이 문제에서는 다른 방법으로 접근해야 한다.

## 🤔문제 접근

1. 현재 좌표를 저장한다.
2. 다음으로 이동할 수 있는 좌표인지 확인한다.
3. 이동할 수 있으면 가려는 길이 이동한 길인지 확인한다.
4. 처음 방문한 길이면 이동한 길에 추가하고, 이동 거리 + 1 을 한다.
5. 1 ~ 4를 명령어가 끝날 때 까지 반복한다.

## ✍️작성 코드

```javascript
function solution(dirs) {
  let answer = 0;
  const offset = {
    L: [-1, 0],
    R: [1, 0],
    U: [0, 1],
    D: [0, -1],
  };
  const visited = [];
  [...dirs].reduce(
    (pos, dir) => {
      const [x, y] = pos;
      const next = [x + offset[dir][0], y + offset[dir][1]];
      if (isMovable(next)) {
        const strPos = pos.join("");
        const strNext = next.join("");
        const strPath = strPos + strNext;
        const strReversePath = strNext + strPos;
        if (
          visited.includes(strPath) === false &&
          visited.includes(strReversePath) === false
        ) {
          visited.push(strPath);
          visited.push(strReversePath);
          answer += 1;
        }
        return next;
      }
      return pos;
    },
    [0, 0]
  );
  return answer;
}

const isMovable = (next) => {
  const [nextX, nextY] = next;
  if (nextX <= 5 && nextX >= -5 && nextY <= 5 && nextY >= -5) return true;
  return false;
};
```

우선 상하좌우로 이동할 수 있는 거리를 `offset` 에 저장했다.

```javascript
const offset = {
  L: [-1, 0],
  R: [1, 0],
  U: [0, 1],
  D: [0, -1],
};
```

이렇게 이동 거리를 객체로 관리하면 switch 문이나 if 문을 사용하지 않고도 다음 좌표를 계산하기 편리해진다.

```javascript
const [x, y] = pos;
const next = [x + offset[dir][0], y + offset[dir][1]];
```

`reduce` 함수를 사용해서 현재 위치를 `[0, 0]` 부터 시작해서 변경하도록 했다.

```javascript
[...dirs].reduce((pos, dir) => {
    ...
}, [0, 0])
```

`isMovable` 함수를 사용해서 다음 좌표가 이동할 수 있는지 확인했다.

```javascript
const isMovable = (next) => {
  const [nextX, nextY] = next;
  if (nextX <= 5 && nextX >= -5 && nextY <= 5 && nextY >= -5) return true;
  return false;
};
```

이동할 수 있으면 이동 경로를 구하기 위해 string 형태로 길을 만들었다. `현재 좌표` 와 `다음 좌표` 를 이어 붙인 문자열과 반대로 뒤집어서 `다음 좌표` 와 `현재 좌표` 를 이어 붙인 문자열 총 2개를 생성했다.

```javascript
const strPos = pos.join("");
const strNext = next.join("");
const strPath = strPos + strNext;
const strReversePath = strNext + strPos;
```

이동한 좌표가 `[0, 0]` 에서 `[0, 1]` 이라면 다음과 같은 값이 저장된다.

```javascript
strPath: "0001";
strReversePath: "0100";
```

만약, 처음 방문하는 길이라면 앞서 생성한 문자열 2개를 모두 `vistied` 배열에 저장한다.

```javascript
if (
  visited.includes(strPath) === false &&
  visited.includes(strReversePath) === false
) {
  visited.push(strPath);
  visited.push(strReversePath);
  answer += 1;
}
```

# ⚙️ 리팩토링

다른 분들의 풀이 중에서 이동한 경로를 두 좌표간의 거리에서 2로 나누어 저장한 코드가 있었다.

예를 들어, 출발 좌표가 `[0, 0]` 이고 도착 좌표가 `[0, 1]` 이면 다음과 같이 저장한다.

| 좌표        | x   | y   |
| ----------- | --- | --- |
| 출발        | 0   | 0   |
| 이동한 경로 | 0   | 0.5 |
| 도착        | 0   | 1   |

이 아이디어에서 착안하여 다음과 같이 리팩토링 했다.

```javascript
function solution(dirs) {
  let answer = 0;
  const offset = {
    L: [-1, 0],
    R: [1, 0],
    U: [0, 1],
    D: [0, -1],
  };
  const visited = [];
  [...dirs].reduce(
    (pos, dir) => {
      const [x, y] = pos;
      const next = [x + offset[dir][0], y + offset[dir][1]];
      if (isMovable(next)) {
        const path = `${(x + next[0]) / 2}/${(y + next[1]) / 2}`;
        if (visited.includes(path) === false) {
          visited.push(path);
          answer += 1;
        }
        return next;
      }
      return pos;
    },
    [0, 0]
  );
  return answer;
}

const isMovable = (next) => {
  const [nextX, nextY] = next;
  if (nextX <= 5 && nextX >= -5 && nextY <= 5 && nextY >= -5) return true;
  return false;
};
```

전체적인 흐름은 동일하지만, 경로를 저장하는 변수는 `path` 하나만 사용했다.

```javascript
const path = `${(x + next[0]) / 2}/${(y + next[1]) / 2}`;
if (visited.includes(path) === false) {
  visited.push(path);
  answer += 1;
}
```

`path` 변수에는 다음과 같이 값이 저장된다.

```
0/0.5
-0.5/1
-1/1.5
-0.5/2
0.5/2
1/1.5
```
