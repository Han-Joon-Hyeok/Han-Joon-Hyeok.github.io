---
title: 프로그래머스 Level 2 - 조이스틱 (JavaScript)
date: 2022-01-02 21:15:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 조이스틱](https://programmers.co.kr/learn/courses/30/lessons/42860)

# 문제 설명

---

조이스틱으로 알파벳 이름을 완성하세요. 맨 처음엔 A로만 이루어져 있습니다.ex) 완성해야 하는 이름이 세 글자면 AAA, 네 글자면 AAAA

조이스틱을 각 방향으로 움직이면 아래와 같습니다.

```
▲ - 다음 알파벳
▼ - 이전 알파벳 (A에서 아래쪽으로 이동하면 Z로)
◀ - 커서를 왼쪽으로 이동 (첫 번째 위치에서 왼쪽으로 이동하면 마지막 문자에 커서)
▶ - 커서를 오른쪽으로 이동
```

예를 들어 아래의 방법으로 "JAZ"를 만들 수 있습니다.

```
- 첫 번째 위치에서 조이스틱을 위로 9번 조작하여 J를 완성합니다.
- 조이스틱을 왼쪽으로 1번 조작하여 커서를 마지막 문자 위치로 이동시킵니다.
- 마지막 위치에서 조이스틱을 아래로 1번 조작하여 Z를 완성합니다.
따라서 11번 이동시켜 "JAZ"를 만들 수 있고, 이때가 최소 이동입니다.
```

만들고자 하는 이름 name이 매개변수로 주어질 때, 이름에 대해 조이스틱 조작 횟수의 최솟값을 return 하도록 solution 함수를 만드세요.

## 제한사항

- name은 알파벳 대문자로만 이루어져 있습니다.
- name의 길이는 1 이상 20 이하입니다.

## 🙋‍♂️나의 풀이

다른 분들의 여러 풀이를 참고해서 풀었지만, 가장 직관적으로 해결할 수 있는 풀이를 참고했다.

결과를 최솟값으로 만들기 위해서 고려해야 할 것은 크게 두 가지이다.

### 조이스틱의 상, 하 이동

첫 번째는 조이스틱의 상, 하 이동이다. 상, 하 이동은 알파벳을 바꾸는 조작이므로, A부터 오름차순으로 찾는 것이 빠른지, 아니면 Z부터 내림차순으로 찾는 것이 빠른지 확인한다.

```javascript
const changeCharToCode = (char) => {
  return char.charCodeAt();
};

const codeTable = {
  A: changeCharToCode("A"),
  Z: changeCharToCode("Z") + 1,
};
```

주어진 알파벳을 아스키 코드로 변환하는 함수와 `A` 의 아스키 코드, `Z` 의 아스키 코드를 해시 테이블 형태로 저장했다. 이때, `Z` 에 1 을 더하는 이유는 `A` 에서 `Z` 로 바꾸기 위해 필요한 횟수이기 때문이다.

```javascript
const countChangingChar = (char) => {
  const currCode = changeCharToCode(char);
  return Math.min(currCode - codeTable["A"], codeTable["Z"] - currCode);
};
```

주어진 이름을 앞에서부터 접근하며, 현재 알파벳을 아스키 코드로 변환한다. 그리고 `현재 알파벳`이 `A` 와 가까운지, `Z` 와 가까운지 판단하기 위해서, `현재 알파벳 아스키 코드 - A의 아스키 코드` 와 `Z의 아스키 코드 - 현재 알파벳 아스키 코드` 중 작은 값을 반환한다.

### 조이스틱의 좌, 우 이동

두 번째는 조이스틱을 좌, 우 이동이다. 만들고자 하는 문자열이 모두 연속된 A로만 이루어져 있다면, 오른쪽으로만 이동하는 것이 최소한의 움직임으로 문자열을 완성시킬 수 있다. 하지만, 그렇지 않은 경우에는 왼쪽으로 이동하는 것이 빠른 경우가 있다. 따라서 `좌 -> 우` 로 이동했을 때와 `우 -> 좌` 로 이동하는 경우의 횟수를 비교해서 최솟값을 찾아야 한다.

예를 들어, `BBBAABB` 라는 문자열을 입력 받은 경우라면 다음과 같이 이해할 수 있다.

![참고 : [뜬 눈으로 꾸는 꿈(티스토리)](https://bellog.tistory.com/152)](/assets/images/2022-01-02-programmers-joystick/image001.png)

_참고 : [뜬 눈으로 꾸는 꿈(티스토리)](https://bellog.tistory.com/152)_

초록색의 화살표대로 왼쪽에서 오른쪽으로만 움직이는 경우는 `문자열 길이 - 1` 이 전체 좌, 우 이동 횟수이다. 이 경우에는 값이 7 이 된다.

반대로, 주황색 화살표처럼 A 가 나타나기 전까지 오른쪽으로 진행하다가 다시 왼쪽으로 돌아가는 경우를 살펴보자.

- 1️⃣ : A 가 나오기 전까지 왼쪽에서 오른쪽으로 이동한다.
- 2️⃣ : A 를 마주치면 처음으로 돌아간다.
- 3️⃣ : 문자열의 끝에서 왼쪽으로 이동하면서 A 를 만나기 전까지 이동한다.

이렇게 이동을 하면 2 + 2 + 2 = 6 이 된다.

```javascript
let leastMoveCount = name.length - 1;
let nextIdx = 0;
```

왼쪽에서 오른쪽으로 계속 이동하는 경우를 최소 이동 횟수로 설정하고, 다음 문자열이 `A` 인지 확인하기 위해서 `nextIdx` 변수를 두었다.

```javascript
const totalCount = [...name].reduce((acc, char, idx) => {
  nextIdx = idx + 1;
  while (nextIdx < name.length && name.charAt(nextIdx) === "A") {
    nextIdx++;
  }
  leastMoveCount = Math.min(leastMoveCount, 2 * idx + (name.length - nextIdx));
  return acc + countChangingChar(char);
}, 0);
```

주어진 문자열을 `reduce` 로 순회하며 좌, 우 이동의 최솟값을 `leastMoveCount` 변수에 계속 계산하고, 상, 하 이동의 최솟값을 `countChangingChar` 함수를 사용하여 누적값을 계산하였다.

앞서 설명한 1️⃣, 2️⃣, 3️⃣ 은 위의 코드에서 각각 다음과 같다.

- 1️⃣ + 2️⃣ : `2 * idx`
- 3️⃣ : `name.length - nextIdx`

### 완성 코드

```javascript
function solution(name) {
  const changeCharToCode = (char) => {
    return char.charCodeAt();
  };

  const codeTable = {
    A: changeCharToCode("A"),
    Z: changeCharToCode("Z") + 1,
  };

  const countChangingChar = (char) => {
    const currCode = changeCharToCode(char);
    return Math.min(currCode - codeTable["A"], codeTable["Z"] - currCode);
  };

  let leastMoveCount = name.length - 1;
  let nextIdx = 0;

  const totalCount = [...name].reduce((acc, char, idx) => {
    nextIdx = idx + 1;
    while (nextIdx < name.length && name.charAt(nextIdx) === "A") {
      nextIdx++;
    }
    leastMoveCount = Math.min(leastMoveCount, 2 * idx + name.length - nextIdx);
    return acc + countChangingChar(char);
  }, 0);

  return totalCount + leastMoveCount;
}
```

# 참고자료

- [[프로그래머스] 조이스틱 - Python](https://bellog.tistory.com/152)
