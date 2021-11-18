---
title: 프로그래머스 Level 1 - 비밀지도 (JavaScript)
date: 2021-11-18 17:00:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level1 비밀지도](https://programmers.co.kr/learn/courses/30/lessons/17681?language=javascript)

# 문제 설명

네오는 평소 프로도가 비상금을 숨겨놓는 장소를 알려줄 비밀지도를 손에 넣었다. 그런데 이 비밀지도는 숫자로 암호화되어 있어 위치를 확인하기 위해서는 암호를 해독해야 한다. 다행히 지도 암호를 해독할 방법을 적어놓은 메모도 함께 발견했다.

1. 지도는 한 변의 길이가 `n`인 정사각형 배열 형태로, 각 칸은 "공백"(" ") 또는 "벽"("#") 두 종류로 이루어져 있다.
2. 전체 지도는 두 장의 지도를 겹쳐서 얻을 수 있다. 각각 "지도 1"과 "지도 2"라고 하자. 지도 1 또는 지도 2 중 어느 하나라도 벽인 부분은 전체 지도에서도 벽이다. 지도 1과 지도 2에서 모두 공백인 부분은 전체 지도에서도 공백이다.
3. "지도 1"과 "지도 2"는 각각 정수 배열로 암호화되어 있다.
4. 암호화된 배열은 지도의 각 가로줄에서 벽 부분을 `1`, 공백 부분을 `0`으로 부호화했을 때 얻어지는 이진수에 해당하는 값의 배열이다.

(참고사진 생략)

네오가 프로도의 비상금을 손에 넣을 수 있도록, 비밀지도의 암호를 해독하는 작업을 도와줄 프로그램을 작성하라.

## 제한사항

입력으로 지도의 한 변 크기 `n` 과 2개의 정수 배열 `arr1`, `arr2`가 들어온다.

- 1 ≦ `n` ≦ 16
- `arr1`, `arr2`는 길이 `n`인 정수 배열로 주어진다.
- 정수 배열의 각 원소 `x`를 이진수로 변환했을 때의 길이는 `n` 이하이다. 즉, 0 ≦ `x` ≦ $2^n$ - 1을 만족한다.
  n

## 🙋‍♂️나의 풀이

### 요구사항 파악

- 구현해야 하는 기능을 다음과 같이 4가지로 파악했다.
  1. 정수를 2진수로 변환
  2. 1차원 배열을 2차원 배열로 변환
  3. 지도1과 지도2를 비교하여 원본 지도로 해독
  4. 해독한 지도에서 숫자를 문자열 및 공백으로 치환

### 작성 코드

```javascript
function solution(N, arr1, arr2) {
  const map1 = arr1.map((num) => convertToBinary(num, N));
  const map2 = arr2.map((num) => convertToBinary(num, N));

  const decodedMap = [];

  for (let i = 0; i < map1.length; i++) {
    let line = "";
    for (let j = 0; j < map2.length; j++) {
      const value1 = map1[i][j];
      const value2 = map2[i][j];
      if (value1 === 1 || value2 === 1) {
        line += "#";
        continue;
      }
      if (value1 === 0 && value2 === 0) {
        line += " ";
      }
    }
    decodedMap.push(line);
  }

  return decodedMap;
}

const convertToBinary = (num, N) => {
  const binary = [];
  while (num > 0) {
    const remainder = num % 2;
    num = Math.floor(num / 2);
    binary.push(remainder);
  }
  while (binary.length < N) {
    binary.push(0);
  }
  binary.reverse();
  return binary;
};
```

1. 정수를 2진수로 변환하기 위해 `convertToBinary` 함수를 별도로 작성했다.
   - 2로 나눈 나머지를 배열에 추가한 뒤, 거꾸로 배열을 뒤집으면 2진수 값을 구할 수 있다.
   - 이때, 지도의 길이보다 작은 배열이라면 0을 추가한다.
2. 원본 배열에서 `map` 함수를 사용하면 배열이 담긴 2차원 배열을 반환한다.
3. ~ 4. 2중 반복문을 사용해서 각 지도의 인덱스를 비교했다.
   - 둘 중 하나라도 1이면 벽이므로 #을 추가한다.
   - 둘 다 모두 0이면 공백이므로 " "을 추가한다.

## 👀참고한 풀이

[카카오에서 제공한 해설](https://tech.kakao.com/2017/09/27/kakao-blind-recruitment-round-1/)에서는 비트 연산을 묻는 문제라고 한다.

문제를 풀기 위해 필요한 개념을 하나씩 살펴보자.

### 1. 시프트 연산

시프트 연산자는 10진수의 수를 2진수로 변환하여 비트를 주어진 수만큼 좌,우로 밀어주는 연산자이다.

```javascript
9      = 01001
9 << 1 = 10010 = 18
9 >> 1 = 00100 = 4
```

- `<<` 좌측 시프트 연산은 n만큼 좌측으로 비트를 밀어주며, 우측에 생기는 빈 자리에는 0을 채운다. 원래 수에서 $2^n$ 만큼 곱해준다고 생각하면 된다.
- `>>` 우측 시프트 연산은 n만큼 우측으로 비트를 밀어주며, 밀린 $2^0$ 자리에서 벗어나는 비트는 버린다. 원래 수에서 $2^n$ 만큼 나누어주고, 반내림 한다고 생각하면 된다.

### 2. 비트 연산자

비트 연산자는 크게 두 가지가 있다.

- `&` : 두 수의 각 비트자리에서 모두 1이면 1을, 이 외에는 0을 반환
- `|` : 두 수의 각 비트자리에서 하나라도 1이면 1을 반환하고, 모두 0이면 0을 반환한다.

```javascript
9 = 01001
8 = 01000

9 & 8 = 01001
	01000
	--------
	01000 = 8

9 | 8 = 01001
	01000
	--------
	01001 = 9
```

### 3. n번째 비트가 1인지 확인하기

위의 개념들을 토대로 n번째 비트가 1인지 확인하는 방법은 다음과 같다.

(참고로 우측부터 0번째 비트이다.)

```javascript
// 2번째 비트가 1인지 확인
9 & (1 << 2)
9 & 4

  9 = 01001
& 4 = 00010
-----------
      00000 = 0

// 4번째 비트가 1인지 확인
9 & (1 << 4)
9 & 16

   9 = 01001
& 16 = 01000
------------
       01000 = 16

```

- n번째 비트가 1이면 0이 아닌 수를 반환
- n번째 비트가 0이면 0을 반환

### 4. | 연산자

문제에 둘 중 하나에서 벽이면 전체지도에서 벽이고, 모두 공백이면 전체에서 공백이라는 설명이 있다. 즉, `|` 을 이용하면 둘 중 하나라도 1이면 1을 반환하고, 모두 0이면 0을 반환하게 된다.

이를 바탕으로 코드를 작성하면 다음과 같다.

```javascript
function solution(n, arr1, arr2) {
  var answer = [];

  for (let i = 0; i < n; i++) {
    let num = "";

    for (let j = n - 1; j >= 0; j--) {
      if ((arr1[i] & (1 << j)) | (arr2[i] & (1 << j))) {
        num += "#";
      } else {
        num += " ";
      }
    }
    answer.push(num);
  }

  return answer;
}
```

---

### 다른 풀이

```javascript
function solution(n, arr1, arr2) {
  let result = arr1.map((a, i) =>
    (a | arr2[i])	// 비밀지도는 arr1[i] or arr2[i]
      .toString(2)	// 10진수는 2진수로
      .padStart(n, 0)	// 맨 앞 0 제거되지 않도록
      .replace(/0/g, " ")	// 0은 공백으로
      .replace(/1/g, "#")	// 1은 #으로
  );
  return result;
```

- 비트 연산자 `|` 를 사용해서 두 개의 지도를 비교했다.
- `Number.prototype.toString(n)` 은 n진수로 변환한다.
- `String.prototype.padStart(targetLength [, padString])` 은 목표 문자열의 길이보다 작으면 왼쪽부터 padString을 채워넣는다.
- 이후, 정규 표현식을 사용해서 원본 지도의 공백과 벽을 문자열로 만들었다.

---

```javascript
function solution(n, arr1, arr2) {
  let num1, num2, s;
  let answer = [];

  for (let i = 0; i < n; i++) {
    num1 = arr1[i];
    num2 = arr2[i];
    s = "";
    for (let j = 0; j < n; j++) {
      s = (num1 % 2) + (num2 % 2) ? "#" + s : " " + s;
      num1 = Math.floor(num1 / 2);
      num2 = Math.floor(num2 / 2);
    }
    answer.push(s);
  }
  return answer;
}
```

- 직접 2진수로 변환해서 푸는 방법도 있다.

# 참고자료

- [카카오 비밀지도](https://velog.io/@skyepodium/%EC%B9%B4%EC%B9%B4%EC%98%A4-%EB%B9%84%EB%B0%80%EC%A7%80%EB%8F%84-4r0ran2u)
- [[Level 1][카카오] 비밀지도(JavaScript)](https://bolob.tistory.com/entry/Level-1%EC%B9%B4%EC%B9%B4%EC%98%A4-%EB%B9%84%EB%B0%80%EC%A7%80%EB%8F%84JavaScript)
