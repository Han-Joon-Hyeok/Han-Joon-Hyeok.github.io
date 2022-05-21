---
title: 프로그래머스 Level 2 - 게임 맵 최단거리 (JavaScript)
date: 2022-05-19 16:30:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 게임 맵 최단거리](https://programmers.co.kr/learn/courses/30/lessons/1844#)

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

### 1️⃣ DFS (실패 : 정확성 OK, 효율성 0점)

처음에는 DFS 로 접근해서 풀었다.

`(0, 0)` 좌표에서 `(n, m)` 까지는 가기 위해서는 좌상단에서 우하단으로 가기 때문에 `우, 하, 상, 좌` 순으로 방향을 탐색했다.

```javascript
const offset = {
  0: [1, 0], // 우
  1: [0, 1], // 하
  2: [0, -1], // 상
  3: [-1, 0], // 좌
};

function solution(maps) {
  const pos = [0, 0];
  const mapLength = [maps[0].length - 1, maps.length - 1];
  const [mapX, mapY] = mapLength;
  const visited = Array.from(Array(maps.length), () =>
    Array(maps[0].length).fill(10000)
  );
  dfs(maps, visited, pos, 0, mapLength);
  if (visited[mapY][mapX] === 10000) return -1;
  return visited[mapY][mapX];
}

const dfs = (maps, visited, pos, move, mapLength) => {
  const [x, y] = pos;
  const [mapX, mapY] = mapLength;
  move += 1;
  visited[y][x] = move;
  for (let i = 0; i < 4; i++) {
    const next = [x + offset[i][0], y + offset[i][1]];
    const [nextX, nextY] = next;
    if (
      nextX >= 0 &&
      nextX <= mapX &&
      nextY >= 0 &&
      nextY <= mapY &&
      visited[nextY][nextX] > move &&
      maps[nextY][nextX] === 1
    )
      dfs(maps, visited, next, move, mapLength);
  }
};
```

미로에서 지나온 길을 기록하는 `visited` 변수에는 이동한 거리를 저장하도록 했다. 초기값을 `10000` 으로 설정하는 이유는 이동한 거리보다 훨씬 큰 값으로 설정한 것인데, 다음과 같은 조건을 사용하기 위해서다.

```javascript
visited[nextY][nextX] > move;
```

이 조건을 사용하면 이미 지나온 길이라도 이전에 탐색했던 경로의 거리가 길다면 다시 한번 탐색할 수 있다.

실제로 `visited` 변수에 저장되는 값은 다음과 같다.

| 1🏃‍♂️ | 10000 | 10000 | 10000 | 10000 |
| 2🏃‍♂️ | 10000 | 10000 | 10000 | 10000 |
| 3🏃‍♂️ | 10000 | 7🏃‍♂️ | 8🏃‍♂️ | 9🏃‍♂️ |
| 4🏃‍♂️ | 5🏃‍♂️ | 6🏃‍♂️ | 10000 | 10🏃‍♂️ |
| 10000 | 10000 | 10000 | 10000 | 11🏃‍♂️ |

위의 표는 출구를 찾은 상황에서 저장된 값을 표현한 것이다.

하지만, 위의 코드에서는 가능한 모든 분기에 대해 탐색하기 때문에 거리가 `7` 인 시점과 `9` 인 시점에서 다시 한번 경로를 탐색하게 된다.

가장 최근에 방문했던 `9` 부터 다시 탐색하면 다음과 같이 진행한다.

| 1 | 10000 | 13🏃‍♂️ | 12🏃‍♂️ | 11🏃‍♂️ |
| 2 | 10000 | 14🚥 | 10000 | 10🏃‍♂️ |
| 3 | 10000 | 7 | 8 | 9👆 |
| 4 | 5 | 6 | 10000 | 10 |
| 10000 | 10000 | 10000 | 10000 | 11 |

이동한 거리가 `14` 인 시점에서는 `(3,3)` 인 `7` 로 이동하고 싶어도 새로운 분기의 시작점인 `9` 부터 이동한 거리가 처음 이동했던 거리보다 더 길기 때문에 더 이상 탐색을 할 수 없게 된다.

그 다음으로 `7` 인 시점에서 다시 탐색을 진행하면 다음과 같은 값이 저장된다.

| 1 | 10000 | 9🏃‍♂️ | 10🏃‍♂️ | 11🚥 |
| 2 | 10000 | 8🏃‍♂️ | 10000 | 10 |
| 3 | 10000 | 7👆 | 8 | 9 |
| 4 | 5 | 6 | 10000 | 10 |
| 10000 | 10000 | 10000 | 10000 | 11 |

마찬가지로 이전에 탐색했던 경로보다 거리가 더 길기 때문에 `(5,0)` 위치인 `11` 에서 더 이상 탐색을 진행하지 못한다.

이렇게 모든 경우의 수를 탐색하다가 `visited` 에서 탈출하는 위치의 값이 `10000` 이라면 출구가 없다는 뜻이므로 `-1` 을 반환했다. 반대로 출구가 있으면 해당 위치에 저장된 값을 반환하도록 했다.

### DFS 문제점?

하지만, DFS 는 2가지 단점 때문에 이 문제에서 요구하는 정답을 만족할 수 없다.

첫째, DFS 는 모든 가능한 경우의 수를 탐색하기 때문에 미로의 크기가 커질 경우 연산 횟수가 기하급수적으로 늘어나기 때문에 실행 시간도 같이 증가한다.

예를 들어, 다음과 같은 미로가 있다고 해보자.

| 1 🏃‍♂️ | | 1 | 1 | 1 | | 1 | 1 | 1 | | |
| 1 | | 1 | | 1 | | 1 | | 1 | | |
| 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| | | 1 | | 1 | | 1 | | 1 | | 1 |
| | | 1 | 1 | 1 | | 1 | 1 | 1 | | 1 👑 |

첫 번째 갈림길인 `(3, 3)` 지점에서 선택할 수 있는 경로의 수는 3가지다. 그리고 두 번째 갈림길인 `(7, 3)` 에서도 선택할 수 있는 경로의 수는 3가지다. 따라서 도착 지점인 `(9, 6)` 까지 도달하는 모든 경우의 수는 $3^2 = 9$ 이다. 만약, 갈림길이 2개가 아니라 1000 개면 경로의 수는 $3^{1000}$ 이 될 것이다.

둘째, DFS 는 최단 거리를 보장하지 못한다. 사실 위와 같은 코드에서는 해를 발견하면 바로 종료하는 것이 아니라, 모든 경우의 수를 탐색하기 때문에 완전 탐색에 가깝다. 하지만 해를 발견하면 종료하는 DFS 에서는 발견한 해가 최적해라는 것을 보장하지는 않는다.

예를 들어, 다음과 같은 미로가 있다고 해보자. 이때, 해를 찾으면 다른 유망한 경로는 찾지 않고 바로 종료한다고 가정한다.

| 1 🏃‍♂️ | | 1 | 1 | 1 |
| 1 | | 1 | | 1 |
| 1 | | 1 | 1 | 1 |
| 1 | 1 | 1 | | 1 |
| | | 1 | 1 | 1 👑 |

탐색하는 순서가 `상 - 우 - 하 - 좌` 순이라면, 다음과 같이 탐색할 것이다.

| 1 🏃‍♂️ | | 1 | 1 | 1 |
| 2 🏃‍♂️ | | 1 | | 1 |
| 3 🏃‍♂️ | | 7 🏃‍♂️ | 8 🏃‍♂️ | 9 🏃‍♂️ |
| 4 🏃‍♂️ | 5 🏃‍♂️ | 6 🏃‍♂️ | | 10 🏃‍♂️ |
| | | 1 | 1 | 11 🏃‍♂️ |

만약, 탐색하는 순서가 `하 - 우 - 상 - 좌` 순이라면, 다음과 같이 탐색할 것이다.

| 1 🏃‍♂️ | | 1 | 1 | 1 |
| 2 🏃‍♂️ | | 1 | | 1 |
| 3 🏃‍♂️ | | 1 | 1 | 1 |
| 4 🏃‍♂️ | 5 🏃‍♂️ | 6 🏃‍♂️ | | 1 |
| | | 7 🏃‍♂️ | 8 🏃‍♂️ | 9 🏃‍♂️ |

이를 통해 탐색하는 순서에 따라 해가 바뀔 수 있으며, 발견한 해가 반드시 최적해가 아니라는 것을 알 수 있다.

따라서 최단 거리를 찾기 위해서는 DFS 보다는 BFS 를 사용한다.

### 2️⃣ BFS (성공)

일반적으로 DFS 에서는 재귀와 스택을 사용하고, BFS 에서는 반복문과 큐를 사용한다.

```javascript
function solution(maps) {
  const mapLength = [maps[0].length - 1, maps.length - 1];
  const result = bfs(maps, mapLength);
  return result ? result : -1;
}

const bfs = (maps, mapLength) => {
  const offset = {
    0: [1, 0], // 우
    1: [0, 1], // 하
    2: [0, -1], // 상
    3: [-1, 0], // 좌
  };
  const [mapX, mapY] = mapLength;
  const queue = [[0, 0]];
  const visited = Array.from(Array(maps.length), () =>
    Array(maps[0].length).fill(false)
  );
  while (queue.length) {
    const [x, y] = queue.shift();
    if (visited[y][x] === true) continue;
    if (x === mapX && y === mapY) {
      return maps[y][x];
    }
    visited[y][x] = true;
    for (let i = 0; i < 4; i++) {
      const next = [x + offset[i][0], y + offset[i][1]];
      if (isMovable(maps, visited, next, mapLength)) {
        maps[next[1]][next[0]] = maps[y][x] + 1;
        queue.push(next);
      }
    }
  }
};

const isMovable = (maps, visited, next, mapLength) => {
  const [nextX, nextY] = next;
  const [mapX, mapY] = mapLength;
  if (nextX >= 0 && nextX <= mapX && nextY >= 0 && nextY <= mapY)
    if (maps[nextY][nextX] === 1 && visited[nextY][nextX] === false)
      return true;
  return false;
};
```

`visited` 변수에는 2차원 배열로 방문 여부를 저장하도록 했고, 원본 `maps` 에는 이동 가능한 지점에 현재까지 이동한 거리를 저장하도록 했다.

문제에서 주어진 예시로 BFS 를 한다면 `maps` 변수에는 다음과 같이 저장된다.

| 1 🏃‍♂️ | | 9 | 10 | 11 |
| 2 | | 8 | | 10 🛑 |
| 3 | | 7 💦 | 8 | 9 💦 |
| 4 | 5 | 6 | | 10 |
| | | | | 11 👑 |

DFS 는 여러 경로 중 하나를 선택해서 끝까지 파고 다시 돌아오는 것이고, BFS 는 액체가 퍼지듯이 각각의 분기점에서 동시에 퍼져나가는 방식으로 진행한다.

참고로 `visited` 변수를 만들기 위해 다음과 같은 코드를 사용했다.

```javascript
const visited = Array.from(Array(maps.length), () =>
  Array(maps[0].length).fill(false)
);
```

위의 코드는 2차원 배열을 만드는 코드이다. 길이가 `maps.length` 인 Array 를 만들고, 그 배열 안의 요소를 `maps[0].length` 길이만큼 `false` 로 채워진 1차원 배열을 저장한다. 실행 결과는 다음과 같다.

```javascript
// 5x5 2차원 배열 생성
[
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
  [false, false, false, false, false],
];
```

# DFS, BFS 정리

문제에서 요구하는 조건에 따라 DFS, BFS 를 적절하게 선택해서 사용해야 한다.

- DFS
  - 모든 경우의 수를 구해야 하는 경우
  - 검색 대상의 규모가 큰 경우
- BFS
  - 최단 거리를 구해야 하는 경우
  - 검색 대상의 규모가 작고, 검색 시작 지점으로부터 원하는 대상이 멀지 않은 경우

## DFS 장단점

### 장점

1. BFS 에 비해 저장 공간이 적어도 된다. 백트래킹 대상 노드만 저장한다.
2. 찾아야 하는 노드가 깊을 단계에 있고, 좌측에 있으면 유리하다.

### 단점

1. 해가 아닌 경로가 매우 깊다면, 해당 경로로 빠졌다가 나오는데 시간이 오래 걸릴 수 있다.
2. 발견한 해가 최적해를 보장하지 않는다.

## BFS 장단점

### 장점

1. 해가 되는 경로가 여러 개여도 최단 경로를 보장한다.
2. 최단 경로가 존재한다면, 경로가 무한히 깊어져도 반드시 최단 경로를 찾을 수 있다.
3. 노드 수가 적고 깊이가 얕은 해가 존재하면 유리하다.

### 단점

1. DFS 에 비해 큰 저장공간이 필요하다. 재귀호출을 사용하는 DFS 와 달리 큐를 이용해서 다음 탐색할 노드를 저장하기 때문에 노드의 수가 많을 수록 필요없는 노드들까지 저장해야 한다.
2. 노드의 수가 늘어나면 탐색 해야 하는 노드가 많아지기 때문에 비효율적이다.

# 참고자료

- [[Programmers] - 게임 맵 최단거리 (찾아라 프로그래밍 마에스터) with Python](https://jayb-log.tistory.com/240) [티스토리]
- [[프로그래머스] 게임 맵 최단거리 - JavaScript](https://velog.io/@tnehd1998/프로그래머스-게임-맵-최단거리-JavaScript) [velog]
- [DFS vs BFS](https://velog.io/@vagabondms/DFS-vs-BFS) [velog]
- [[Javascript] 2차원 배열 만들기 (feat. Array.from())](https://velog.io/@rhkrgudwh/Javascript-2차원-배열-만들기-feat.-Array.from) [velog]
