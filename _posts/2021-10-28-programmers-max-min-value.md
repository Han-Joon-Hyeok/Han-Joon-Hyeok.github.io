---
title: 프로그래머스 Level 2 - 최댓값과 최솟값 (Javascript)
date: 2021-10-28 22:00:00 +0900
categories: [programmers]
tags: [level2, programmers]
---
> [프로그래머스 - Level 2 최댓값과 최솟값](https://programmers.co.kr/learn/courses/30/lessons/12939)

# 문제

문자열 s에는 공백으로 구분된 숫자들이 저장되어 있습니다. str에 나타나는 숫자 중 최소값과 최대값을 찾아 이를 "(최소값) (최대값)"형태의 문자열을 반환하는 함수, solution을 완성하세요.

예를 들어, s가 "1 2 3 4"라면 "1 4"를 리턴하고, "-1 -2 -3 -4"라면 "-4 -1"을 리턴하면 됩니다.

## 제한조건

s에는 둘 이상의 정수가 공백으로 구분되어 있습니다.

|s|return|
|---|---|
|"1 2 3 4"|"1 4"|
|"-1 -2 -3 -4"|"-4 -1"|
|"-1 -1"|"-1 -1"|

## 🙋‍♂️나의 풀이

- 주어지는 문자열을 `split`으로 배열을 만들고, 각 원소들을 `string`에서 `number` 형으로 변환한다.
- 최댓값과 최솟값을 배열의 첫 번째 요소로 설정한다.
- 배열의 두 번째 요소부터 탐색하며 최댓값과 최솟값을 비교한다.

```javascript
function solution(s) {
    let answer = '';
    const arr = s.split(" ").map(x => +x)
    let max = arr[0]
    let min = arr[0]
    for(let i = 1; i < arr.length; i++){
        if(arr[i] >= max){
            max = arr[i]
        }
        if(arr[i] <= min){
            min = arr[i]
        }
    }
    answer = `${min} ${max}`
    return answer;
}
```

## 👀참고한 풀이

```javascript
function solution(s) {
		const arr = s.split(' ');
    return Math.min(...arr) + ' ' + Math.max(...arr)
}
```

- 스프레드 연산자를 사용해서 배열 안의 최댓값과 최솟값을 구한다.
- `Math.min` 은 파라미터를 콤마로 구분해서 받기 때문에 스프레드 연산자를 사용할 수 있다. `Math.max` 도 마찬가지다.

```javascript
Math.min(1, 2, 3) // 1
Math.max(1, 2, 3) // 3
```