---
title: 프로그래머스 Level 1 - 콜라 문제 (JavaScript)
date: 2022-12-19 09:30:00 +0900
categories: [programmers]
tags: [level1, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level1 콜라 문제](https://school.programmers.co.kr/learn/courses/30/lessons/132267#)

# 문제 설명

설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

문제의 지문이 길었지만, 문제에서 요구하는 바는 지문의 하단에 나와있었다.

나눗셈을 통한 몫과 나머지를 이해한다면 쉽게 풀 수 있는 문제다.

교환에 필요한 콜라병은 `a` , 교환에서 받을 수 있는 콜라병은 `b`, 현재 가지고 있는 콜라병은 `n` 이라 해보자.

```javascript
a = 2;
b = 1;
n = 20;
```

위와 같은 조건일 때, 받을 수 있는 콜라병은 19병이다.

교환은 여러 번 이루어질 수 있는데, 한 번 교환할 때 받을 수 있는 콜라병의 개수는

- 현재 가지고 있는 콜라병에서 교환에 필요한 콜라병을 나눈 몫에
- 교환에서 받을 수 있는 콜라병의 개수를 곱하면 된다.

```javascript
교환 받은 콜라병 = (n / a) * b
```

교환을 마치고 나서 현재 가지고 있는 콜라병 개수를 업데이트 해주어야 한다.

현재 가지고 있는 콜라병의 개수는

- 교환을 하지 못한 콜라병과
- 교환 받은 콜라병을 합친 것이다.

교환을 하지 못한 콜라병의 개수는 아래와 같이 구할 수 있다.

```javascript
교환을 하지 못한 콜라병 = (n % a)
```

이를 토대로 수도 코드를 작성했다.

### 1. 수도 코드 작성

```javascript
while (현재 가지고 있는 콜라병 >= 교환에 필요한 콜라병)
{
	교환 받은 콜라병 = (현재 가지고 있는 콜라병 / 교환에 필요한 콜라병)
	현재 가지고 있는 콜라병 = (교환 전에 가지고 있던 콜라병 % 교환에 필요한 콜라병) + 교환 받은 콜라병
	교환 누적 콜라병 += 교환 받은 콜라병
}
```

### 2. 매개변수 이름 바꾸기

매개변수 이름이 `a`, `b`, `n` 으로 주어지는데, 의미가 담긴 이름으로 바꾸었다.

```javascript
function solution(neededBottle, returnedBottle, currentBottleCount) {
	...
}
```

코드가 길어졌을 때 의미가 없는 변수를 보면 어떤 값을 가지고 있는지 헷갈릴 수 있다.

그래서 시간이 흘러 다시 코드를 읽었을 때도 이해할 수 있는 변수명으로 바꿔서 코드를 작성했다.

### 3. JavaScript 몫 구하기

위에서 작성한 수도 코드에 맞추어 코드를 작성했지만, 프로그램이 종료되지 않고 무한 반복되고 있었다.

반복문에서 임의로 break 를 걸어 나가도록 해보니, `교환 받은 콜라병` 의 개수를 구할 때 문제가 있었다.

C언어와 달리 JavaScript 에서는 나누기 연산을 하면 소수점 자리를 포함한 계산 결과를 반환한다.

```c
// C언어 나눗셈 연산
int a = 1 / 2;
printf("%d\n", a); // 0
```

```javascript
// JavaScript 나눗셈 연산
a = 1 / 2;
console.log(a); // 0.5
```

따라서 JavaScript 에서 몫을 구하기 위해서는 소수점을 반내림 해주어야 한다.

나는 `Math.floor` 함수를 사용해서 몫을 구했다.

```javascript
a = 1 / 2;
console.log(Math.floor(a)); // 0
```

## ✍️작성 코드

```javascript
function solution(neededBottle, returnedBottle, currentBottleCount) {
  let answer = 0;
  let getBottle = 0;

  while (currentBottleCount >= neededBottle) {
    getBottle = Math.floor(currentBottleCount / neededBottle) * returnedBottle;
    currentBottleCount = (currentBottleCount % neededBottle) + getBottle;
    answer += getBottle;
  }
  return answer;
}
```
