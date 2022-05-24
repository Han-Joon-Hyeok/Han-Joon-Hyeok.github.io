---
title: 프로그래머스 Level 2 - 삼각 달팽이 (JavaScript)
date: 2022-05-24 17:50:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 삼각 달팽이](https://programmers.co.kr/learn/courses/30/lessons/68645)

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

`n = 5` 일때, 다음과 같은 규칙을 발견할 수 있다.

![programmers_triangle_snail.drawio.png](/assets/images/2022-05-24-programmers-triangle-snail/programmers_triangle_snail.drawio.png)

1. 아래 방향으로 끝까지 도달할 때까지 `n` 개의 수를 채운다.
2. 오른쪽 방향으로 끝까지 도달할 때까지 `n - 1` 개의 수를 채운다.
3. 위 방향으로 끝까지 도달할 때 까지 `n - 2` 개의 수를 채운다.
4. `n = 0` 인 순간까지 위의 과정을 반복한다.

## ✍️작성 코드

우선 삼각형 모양의 2차원 배열을 만들었다.

```javascript
const triangle = Array.from(Array(n), () => {
  length += 1;
  return Array(length).fill(false);
});
```

`n = 5` 일 때, 저장된 값은 다음과 같다.

```javascript
[
  [false],
  [false, false],
  [false, false, false],
  [false, false, false, false],
  [false, false, false, false, false],
];
```

`pos` 객체에 2차원 배열의 행, 열 인덱스값, 남은 개수, 방향, 입력될 값을 저장했다.

```javascript
const pos = {
  direction: "D",
  col: 0,
  row: 0,
  remain: n,
  value: 1,
};
```

`pos.remain` 값이 `0` 이 될 때까지 행, 열 인덱스와 저장될 값을 바꾼다.

```javascript
while (pos.remain !== 0) {
  if (pos.direction === "D") {
    for (let i = 0; i < pos.remain; i++) {
      triangle[pos.col][pos.row] = pos.value;
      pos.col += 1;
      pos.value += 1;
    }
    pos.col -= 1;
    pos.row += 1;
    pos.direction = "R";
  } else if (pos.direction === "R") {
    for (let i = 0; i < pos.remain; i++) {
      triangle[pos.col][pos.row] = pos.value;
      pos.row += 1;
      pos.value += 1;
    }
    pos.col -= 1;
    pos.row -= 2;
    pos.direction = "U";
  } else {
    for (let i = 0; i < pos.remain; i++) {
      triangle[pos.col][pos.row] = pos.value;
      pos.col -= 1;
      pos.row -= 1;
      pos.value += 1;
    }
    pos.col += 2;
    pos.row += 1;
    pos.direction = "D";
  }
  pos.remain -= 1;
}
```

위의 과정을 거치면 다음과 같이 저장된다.

```javascript
[
  [1], 
  [2, 12], 
  [3, 13, 11], 
  [4, 14, 15, 10], 
  [5, 6, 7, 8, 9]
];
```

마지막으로 2차원 배열을 1차원 배열로 저장하기 위해 `reduce` 함수를 사용했다.

```javascript
return triangle.reduce((acc, curr) => {
  return [...acc, ...curr];
}, []);
```

완성한 코드는 다음과 같다.

```javascript
function solution(n) {
  let length = 0;
  const triangle = Array.from(Array(n), () => {
    length += 1;
    return Array(length).fill(false);
  });
  const pos = {
    direction: "D",
    col: 0,
    row: 0,
    remain: n,
    value: 1,
  };
  while (pos.remain !== 0) {
    if (pos.direction === "D") {
      for (let i = 0; i < pos.remain; i++) {
        triangle[pos.col][pos.row] = pos.value;
        pos.col += 1;
        pos.value += 1;
      }
      pos.col -= 1;
      pos.row += 1;
      pos.direction = "R";
    } else if (pos.direction === "R") {
      for (let i = 0; i < pos.remain; i++) {
        triangle[pos.col][pos.row] = pos.value;
        pos.row += 1;
        pos.value += 1;
      }
      pos.col -= 1;
      pos.row -= 2;
      pos.direction = "U";
    } else {
      for (let i = 0; i < pos.remain; i++) {
        triangle[pos.col][pos.row] = pos.value;
        pos.col -= 1;
        pos.row -= 1;
        pos.value += 1;
      }
      pos.col += 2;
      pos.row += 1;
      pos.direction = "D";
    }
    pos.remain -= 1;
  }
  return triangle.reduce((acc, curr) => {
    return [...acc, ...curr];
  }, []);
}
```

통과는 했지만, 테스트 7 ~ 9 번에서 실행시간이 지나치게 커져서 다른 분들의 코드를 참고해서 리팩토링 했다.

```
테스트 1 〉	통과 (0.43ms, 29.8MB)
테스트 2 〉	통과 (0.29ms, 30MB)
테스트 3 〉	통과 (0.30ms, 29.7MB)
테스트 4 〉	통과 (2.56ms, 34.5MB)
테스트 5 〉	통과 (2.80ms, 34.7MB)
테스트 6 〉	통과 (3.55ms, 35.2MB)
테스트 7 〉	통과 (2636.48ms, 119MB)
테스트 8 〉	통과 (2651.34ms, 119MB)
테스트 9 〉	통과 (2473.64ms, 133MB)
```

# ⚙️ 리팩토링

우선 삼각형 모양의 2차원 배열을 다음과 같이 수정했다.

```javascript
const triangle = Array(n)
  .fill()
  .map((_, i) => Array(i + 1).fill());
```

`n = 5` 일 때, 실행 결과는 다음과 같다.

```javascript
[
  [undefined],
  [undefined, undefined],
  [undefined, undefined, undefined],
  [undefined, undefined, undefined, undefined],
  [undefined, undefined, undefined, undefined, undefined],
];
```

그 다음, 행, 열 인덱스와 남은 개수, 값을 변수로 선언했다. 객체에 하나로 묶지 않은 이유는 코드의 가독성을 높이기 위함이다.

그리고 `row` 는 `-1` 로 선언했는데, 이후 반복문에서 전위 증가 연산자를 사용해야 인덱스 값이 최대 값을 넘어서지 않기 때문이다.

```javascript
let col = 0;
let row = -1;
let remain = n;
let value = 1;
```

아래의 반복문에서 아래, 오른쪽, 위 방향으로 인덱스 값을 바꾸며 값을 채워넣는다.

```javascript
while (remain > 0) {
  for (let i = 0; i < remain; i++) triangle[++row][col] = value++;
  for (let i = 0; i < remain - 1; i++) triangle[row][++col] = value++;
  for (let i = 0; i < remain - 2; i++) triangle[--row][--col] = value++;
  remain -= 3;
}
```

반복문을 처음 마치면 다음과 같이 삼각형 모양으로 값을 채워서 저장된다.

```javascript
[
  [1],
  [2, 12],
  [3, undefined, 11],
  [4, undefined, undefined, 10],
  [5, 6, 7, 8, 9],
];
```

그 다음 반복문에서는 다음과 같이 저장하고, 실행을 마친다.

```javascript
[
  [1], 
  [2, 12], 
  [3, 13, 11], 
  [4, 14, 15, 10], 
  [5, 6, 7, 8, 9]
];
```

마지막으로 2차원 배열을 `flat()` 함수를 이용해서 1차원 배열로 변환했다.

```javascript
return triangle.flat();
```

완성한 코드는 다음과 같다.

```javascript
function solution(n) {
  const triangle = Array(n)
    .fill()
    .map((_, i) => Array(i + 1).fill());
  let col = 0;
  let row = -1;
  let remain = n;
  let value = 1;
  while (remain > 0) {
    // 아래 방향
    for (let i = 0; i < remain; i++) triangle[++row][col] = value++;
    // 오른쪽 방향
    for (let i = 0; i < remain - 1; i++) triangle[row][++col] = value++;
    // 위 방향
    for (let i = 0; i < remain - 2; i++) triangle[--row][--col] = value++;
    remain -= 3;
  }
  return triangle.flat();
}
```

실행 결과는 다음과 같으며, 실행 속도가 확연히 빨라진 것을 확인했다.

```
테스트 1 〉	통과 (0.11ms, 30.1MB)
테스트 2 〉	통과 (0.12ms, 30MB)
테스트 3 〉	통과 (0.10ms, 30MB)
테스트 4 〉	통과 (1.98ms, 33.1MB)
테스트 5 〉	통과 (2.15ms, 33MB)
테스트 6 〉	통과 (1.14ms, 33.5MB)
테스트 7 〉	통과 (104.61ms, 84.8MB)
테스트 8 〉	통과 (103.23ms, 84.5MB)
테스트 9 〉	통과 (128.63ms, 76.4MB)
```

실행 속도는 `return` 할 때, `flat()` 함수를 사용할 때 더욱 빨라지는 것으로 확인했다. 처음 작성한 코드에서 `return` 시 `flat()` 함수로 바꿨을 때는 실행 결과는 다음과 같았다.

```
테스트 1 〉	통과 (0.28ms, 30.2MB)
테스트 2 〉	통과 (0.26ms, 30.2MB)
테스트 3 〉	통과 (0.27ms, 29.8MB)
테스트 4 〉	통과 (1.45ms, 33.4MB)
테스트 5 〉	통과 (1.44ms, 33.3MB)
테스트 6 〉	통과 (1.54ms, 33.3MB)
테스트 7 〉	통과 (119.14ms, 84.3MB)
테스트 8 〉	통과 (78.96ms, 84.2MB)
테스트 9 〉	통과 (83.76ms, 85.1MB)
```

# 참고자료

- [[알고리즘] 프로그래머스 - 삼각달팽이](https://velog.io/@dolarge/알고리즘-프로그래머스-삼각달팽이) [velog]
