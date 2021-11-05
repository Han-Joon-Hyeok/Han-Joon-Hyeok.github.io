---
title: 프로그래머스 Level 1 - 없는 숫자 더하기 (javascript)
date: 2021-11-05 21:25:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 없는 숫자 더하기](https://programmers.co.kr/learn/courses/30/lessons/86051)

# 문제 설명

0부터 9까지의 숫자 중 일부가 들어있는 배열 `numbers`가 매개변수로 주어집니다. `numbers`에서 찾을 수 없는 0부터 9까지의 숫자를 모두 찾아 더한 수를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- 1 ≤ `numbers`의 길이 ≤ 9
- 0 ≤ `numbers`의 모든 수 ≤ 9
- `numbers`의 모든 수는 서로 다릅니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(numbers) {
  let result = 0;
  const compare = [...Array(10).keys()];

  compare.forEach((number) => {
    const isExist = numbers.includes(number);
    if (!isExist) {
      result += number;
    }
  });

  return result;
}
```

- 그렇게 어려운 문제는 아니었는데, 너무 복잡하게 생각했다.
- 0부터 9까지 비교할 배열 `compare`을 만든다.
- `compare` 를 순회하며 `numbers` 에 포함되지 않는다면 해당 숫자를 더한다.

## 👀참고한 풀이

```javascript
function solution(numbers) {
  let cnt = 0;
  for (let i = 0; i < 10; i++) {
    if (!numbers.includes(i)) cnt += i;
  }
  return cnt;
}
```

- 간단하게 for문을 사용해서 풀었다.

```javascript
function solution(numbers) {
  return 45 - numbers.reduce((cur, acc) => cur + acc, 0);
}
```

- 0부터 9까지 합은 45이므로 배열의 수를 모두 더한 다음에 빼면 없는 숫자들의 합이 된다.

# 배운 점

## Array 생성자

- 전달된 인수에 따라 length 프로퍼티 값이 인수인 배열을 생성한다.

```javascript
const arr = new Array(10);

console.log(arr); // [empty * 10]
console.log(arr.length); // 10
```

- 이때, 생성된 배열은 희소 배열이다. length 프로퍼티 값은 0이 아니지만, 실제로 배열의 요소는 존재하지 않는다.
- Array 생성자 함수는 `new` 연산자와 함께 호출되지 않아도 일반 함수로서 호출해도 배열을 생성하는 생성자 함수로 동작한다. 이는 Array 생성자 함수 내부에서 `new.target` 을 확인하기 때문이다.

### 밀집 배열과 희소 배열

> 참고자료 : [자바스크립트 배열은 배열이 아니다](https://poiemaweb.com/js-array-is-not-arrray)

**밀집 배열(dense array)**

- 일반적으로 배열은 메모리 공간에 빈틈없이 연속적으로 나열된 자료 구조를 의미한다.
- 배열의 요소는 하나의 타입으로 통일 되어 있고, 서로 연속적으로 인접해있는데, 이를 **밀집 배열(dense array)**이라 한다.
- 배열의 요소는 동일한 크기를 가지고, 연속적으로 이어져 있으므로 인덱스를 통해 단 한번의 연산으로 임의의 요소에 빠르게 접근(random access)할 수 있다.

**희소 배열(sparse array)**

- 반면, 자바스크립트의 배열은 일반적인 의미의 배열과는 다르다.
- 결론부터 말하자면, 배열은 일반적인 배열의 동작을 흉내낸 특수한 객체이다.
- 배열의 요소를 위한 각각의 메모리 공간이 동일한 크기를 가지지 않아도 되고, 연속적으로 이어져 있지 않을 수도 있다. 이를 **희소 배열(sparse array)**라 한다.

```javascript
console.log(Object.getOwnPropertyDescriptor([1, 2, 3])));
/*
{
  '0': { value: 1, writable: true, enumerable: true, configurable: true },
  '1': { value: 2, writable: true, enumerable: true, configurable: true },
  '2': { value: 3, writable: true, enumerable: true, configurable: true },
  length: { value: 3, writable: true, enumerable: false, configurable: false }
}
*/
```

- 이처럼 자바스크립트 배열은 해시 테이블로 구현된 객체이다. 인덱스를 프로퍼티 키로 가지며, length 프로퍼티를 갖는 특수한 객체이다.
- 즉, 자바스크립트 배열의 요소는 사실 프로퍼티 값이다. 자바스크립트에서 사용할 수 있는 모든 값은 객체의 프로퍼티 값이 될 수 있으므로 어떤 타입의 값이라도 배열의 요소가 될 수 있다.

```javascript
const arr = [
  "string",
  10,
  true,
  null,
  undefined,
  NaN,
  Infinity,
  [],
  {},
  function () {},
];
```

일반적인 배열과 자바스크립트 배열의 장단점은 다음과 같다.

- 일반적인 배열
  - 장점 : 인덱스로 배열 요소에 빠르게 접근
  - 단점 : 특정 요소 탐색 또는 요소 삽입이나 삭제는 효율이 낮음
- 자바스크립트 배열
  - 장점 : 특정 요소 탐색 또는 요소 삽입이나 삭제는 빠름
  - 단점 : 인덱스로 접근하는 경우에는 느림

이처럼 인덱스로 배열 요소에 접근할 때 일반적인 배열보다 느리다는 단점을 보완하기 위해 모던 자바스크립트 엔진은 배열을 일반 객체와 구별하여 보다 배열처럼 동작하도록 최적화해서 구현했다.

### new.target

> 참고자료 : 모던 자바스크립트 Deep Dive

생성자 함수가 new 연산자 없이 호출되는 것을 방지하기 위해서 ES6에서 new.target을 지원한다.

함수 내부에서 new.target을 사용하면 new 연산자와 함께 생성자 함수로 호출되었는지 확인할 수 있다.

new.target은 this와 유사하게 생성자인 모든 함수 내부에서 암묵적인 지역 변수와 같이 사용되며, 메타 프로퍼티라고 부른다. 참고로 IE에서는 이를 지원하지 않는다.

new 연산자와 함께 생성자 함수로서 호출되면, 함수 내부의 new.target은 함수 자신을 가리킨다. new 연산자 없이 일반 함수로 호출된 함수 내부의 new.target은 undefined이다.

따라서 함수 내부에서 new.target을 사용해서 new 연산자와 생성자 함수로서 호출했는지 확인하고, 그렇지 않은 경우에는 new 연산자와 함께 재귀 호출을 통해 생성자 함수로서 호출할 수 있다.

```javascript
function Circle(radius) {
  if (!new.target) {
    return new Circle(radius);
  }
  this.radius = radius;
  this.getDiameter = function () {
    return 2 * this.radius;
  };
}

/* new 연산자 없이 생성자 함수를 호출해도 
   new.target을 통해 생성자 함수로서 호출된다. */
const circle = Circle(5);
console.log(cirlce.getDiameter()); // 10
```

## Array.prototype.keys()

- 앞에서 살펴본 것처럼 배열은 객체처럼 작동하며, 인덱스를 프로퍼티 키로 갖는다.
- `keys()` 는 배열의 각 인덱스를 키 값으로 가진 `Array Iterator`를 반환한다.

```javascript
const arr = ["a", "b", "c"];
console.log(arr.keys()); // Array Iterator {}
console.log([...arr.keys()]); // [0, 1, 2]
```

## Array.prototype.includes()

- 처음엔 `indexOf` 를 사용했는데, 이 메서드는 대상을 찾지 못하면 `-1` 을 반환한다.
- 하지만, `includes` 는 반환값이 `boolean` 이기 때문에 조건문에서 활용하기 좋다.
