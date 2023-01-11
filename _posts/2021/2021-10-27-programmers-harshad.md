---
title: 프로그래머스 Level 1 - 하샤드 수 (Javascript)
date: 2021-10-27 01:00:00 +0900
categories: [programmers]
tags: [level1, programmers]
---
> [프로그래머스 - Level 1 하샤드 수](https://programmers.co.kr/learn/courses/30/lessons/12947?language=javascript)

# 문제 설명
양의 정수 x가 하샤드 수이려면 x의 자릿수의 합으로 x가 나누어져야 합니다. 예를 들어 18의 자릿수 합은 1+8=9이고, 18은 9로 나누어 떨어지므로 18은 하샤드 수입니다. 자연수 x를 입력받아 x가 하샤드 수인지 아닌지 검사하는 함수, solution을 완성해주세요.

## 제한 조건
- `x` 는 1 이상, 10000 이하인 정수입니다.

## 입출력 예

|arr|return|
|---|---|
|10|true|
|12|true|
|11|false|
|13|false|

## 🙋‍♂️ 나의 풀이 (Javascript)

- 주어지는 정수 `x`의 자리 수를 먼저 구한다.
- `x`의 각 자리 수를 더한다.
- `x`를 각 자리 수를 더한 값으로 나머지를 구한다.

각 자리 수를 구하기 위해 직접 숫자를 대입해가며 귀납적으로 반복되는 규칙을 발견했다.

- n 번째 자리 : x / 10^n
- n-1 번째 자리 : x / 10^n-1 % 10^1
- n-2 번째 자리 : x / 10^n-2 % 10^1
- ...
- 1 번째 자리 : x % 10^1

효율적이지는 못하지만, 생각나는 대로 먼저 풀었던 방법이다.

``` javascript
// 1. x의 자리 수 구하기
let n = 0;
while(Math.floor( x/(10**n)) > 0){
    n++;
}

// 2. 각 자리 수를 더하기
let sum = 0;

for (let i = n; i > 0; i--){
    if(i === n){
        sum += Math.floor(x / (10**(i-1)))
    } else if ( i === 1) {
        sum += Math.floor(x % 10)
    } else {
        sum += Math.floor(( x / (10**(i-1)) ) % 10)
    }        
}

// 3. x를 2번에서 구한 합으로 나머지를 구해서 하샤드 수인지 판단하기
if( x % sum === 0){
    return true
} else {
    return false
}
```

## 👀 참고한 풀이

- `x`를 계속 10으로 나누고, 10으로 나눈 나머지가 결국 각 자리 수를 의미한다.
- 이때, `x`를 나눌 때는 반내림을 해서 구해야 정수 값을 얻을 수 있다.

```javascript
let sum = 0;
let num = x
while (x > 0){
    sum += x%10
    x = Math.floor(x/10)
}
if(num % sum === 0){
    return true
} else {
    return false
}
```