---
title: TIL - JavaScript Sort에 대해 알아보자
date: 2021-11-06 23:55:00 +0900
categories: [javascript]
tags: [javascript, til]
---

프로그래머스에서 문자열 정렬 문제를 푸는데, `sort` 를 실행해도 순서가 바뀌지 않아서 당황했다.

```javascript
const arr = ["a", "c", "b"];
arr.sort((a, b) => a - b);
console.log(arr); // ['a', 'c', 'b']
```

결론부터 말하자면, 위의 코드에서 콜백 함수로 들어간 표현식은 숫자 배열을 오름차순으로 정렬할 때 사용하는 것이다.

# `Arraay.prototype.sort()`

`sort` 는 배열에 있는 내용들을 **문자열로 자동 변환**하고, [유니코드 코드 포인트](https://d2.naver.com/helloworld/19187)의 순서대로 정렬한다.

## 문자열 정렬

문자열 정렬은 내부 콜백함수에 값을 넣지 않아도 오름차순으로 정렬된다.

```javascript
const eng = ["c", "b", "a"];
const kor = ["티스토리", "다음", "네이버"];

console.log(eng.sort()); // ['a', 'b', 'c']
console.log(kor.sort()); // ['네이버', '다음', '티스토리']
```

내림차순 정렬은 다음과 같다.

```javascript
const eng = ["a", "b", "c"];

// 1
eng.sort().reverse();

// 2
eng.sort((a, b) => (a > b ? -1 : 1));

// 3
eng.sort((a, b) => b.localeCompare(a));

// ['c', 'b', 'a']
```

모두 같은 결과를 반환하지만, 첫 번째 방법인 `sort().reverse()` 가 크롬을 제외하고 두 번째 방법보다 가장 빠른 성능을 보인다.

- `localeCompare()` 메서드는 문자열과 문자열을 비교하고, 비교 결과를 number로 반환한다.
- 예시 : `a.localCompare(b)` 의 반환값
  - -1 : a가 b보다 작을 때
  - 0 : a와 b가 같을 때
  - 1 : a가 b보다 클 때

> 참고 : [Sorting strings in descending order in Javascript (Most efficiently)?](https://stackoverflow.com/questions/52030110/sorting-strings-in-descending-order-in-javascript-most-efficiently/52030179)

## 숫자 정렬

숫자 정렬을 할 때는 다음과 같이 작성한다.

```javascript
const nums = [100, 3, 2, 99];

// 오름차순 정렬
nums.sort((a, b) => a - b); // [2, 3, 99, 100]

// 내림차순 정렬
nums.sort((a, b) => b - a); // [100, 99, 3, 2]
```

- 만약, 콜백 함수를 별도로 작성하지 않고 사용한다면 다음과 같은 결과가 나온다.

```javascript
const nums = [100, 3, 2, 99];

nums.sort();
// [100, 2, 3, 99]
```

- 기본적으로 배열의 요소들을 모두 문자열로 변환하고, 유니코드 코드 포인트를 기준으로 정렬을 하기 때문에 값이 낮은 100이 2보다 앞에 오게 되는 것이다.
- 문자열 '1'의 유니코드 코드 포인트는 `U+0031`, 문자열 '2'의 유니코드 코드 포인트는 `U+0032` 이다.
- 이런 현상을 방지하기 위해서는 메서드에 **비교 함수를 인수로 전달**해야 한다.
- 비교 함수는 양수나 음수 또는 0을 반환해야 한다.
  - 음수 : 비교 함수의 첫 번째 인수를 우선 정렬
  - 0 : 정렬하지 않음
  - 양수 : 두 번째 인수를 우선 정렬

---

참고로 `sort` 메서드는 [quicksort](https://ko.wikipedia.org/wiki/%ED%80%B5_%EC%A0%95%EB%A0%AC) 알고리즘을 사용했었으나, ECMAScript 2019(ES10)에서는 [timesort](https://en.wikipedia.org/wiki/Timsort) 알고리즘을 사용하도록 바뀌었다.

> 참고 : [배열의 sort()에 대해 알아보기](https://tonks.tistory.com/124)
