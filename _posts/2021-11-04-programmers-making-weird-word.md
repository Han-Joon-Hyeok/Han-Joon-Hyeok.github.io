---
title: 프로그래머스 Level 1 - 이상한 문자 만들기 (javascript)
date: 2021-11-04 10:00:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 이상한 문자 만들기](https://programmers.co.kr/learn/courses/30/lessons/12930)

# 문제 설명

문자열 s는 한 개 이상의 단어로 구성되어 있습니다. 각 단어는 하나 이상의 공백문자로 구분되어 있습니다. 각 단어의 짝수번째 알파벳은 대문자로, 홀수번째 알파벳은 소문자로 바꾼 문자열을 리턴하는 함수, solution을 완성하세요.

## 제한사항

- 문자열 전체의 짝/홀수 인덱스가 아니라, 단어(공백을 기준)별로 짝/홀수 인덱스를 판단해야합니다.
- 첫 번째 글자는 0번째 인덱스로 보아 짝수번째 알파벳으로 처리해야 합니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(s) {
  const words = s.split(" ");
  const convertedArr = words.map((word) => {
    let newWord = "";
    for (let i = 0; i < word.length; i++) {
      const isEven = i % 2 === 0;
      if (isEven) {
        newWord += word[i].toUpperCase();
      }
      if (!isEven) {
        newWord += word[i].toLowerCase();
      }
    }
    return newWord;
  });

  return convertedArr.join(" ");
}
```

- 단어를 공백 기준으로 `split` 하여 배열로 만든다.
- `map` 을 사용하여 각 단어들을 다시 반복문에 태운다. 인덱스가 짝수면 대문자, 홀수면 소문자로 변환하여 새로운 변수에 한 글자씩 추가한다.
- 추가한 단어를 `return` 하여 변환된 글자 배열을 생성한다.
- 앞 단계에서 반환된 글자 배열을 공백 한 칸으로 `join` 한다.

## 👀참고한 풀이

```javascript
function solution(s) {
  return s
    .toUpperCase()
    .replace(/(\w)(\w)/g, (word) => word[0] + word[1].toLowerCase());
}
```

- 정규표현식을 사용해서 앞에서부터 두 글자씩 잘라서 앞 글자는 대문자로, 뒤 글자는 소문자로 변환한다.
- 만약 글자 수가 홀수면, 마지막 한 글자는 선택되지 않는다.
- 어차피 마지막 글자는 홀수이기 때문에 초기에 단어를 모두 대문자로 변환하면 정규식에 의해 선택되지 않아도 된다.

# 배운 점

## `replace`

- `replace` 메서드는 다음과 같은 문법을 가지고 있다.

```javascript
var newStr = str.replace(regexp|substr, newSubstr|function)
```

- 만약, 첫 번째 인자에서 정규표현식을 사용하고, 두 번째 인자에 함수를 사용하면, 정규표현식에 match된 결과들이 인자로 넘어간다.

```javascript
const regex = /\d/g;
const str = "12Three4";
console.log(
  str.replace(regex, (char) => {
    console.log(char);
    return "_";
  })
);

// 숫자에 해당하는 글자만 출력 및 교체된다.
// 1
// 2
// 4
// __Three_
```

## `for ... of`

- `string` 은 iterable해서 `forEach` 문에 매개변수로 사용할 수 있을 거라 생각했지만, `Array` 에서만 사용 가능한 메소드이다. (Map, Set 등에서도 지원 가능)
- 만약 인덱스는 사용하지 않고, 개별 값만 사용한다면 `for ... of` 를 사용할 수 있다.

```javascript
const str = "abc";
for (const char of str) {
  console.log(char);
}

// a
// b
// c
```

- `for ... of` 반복문은 ES6에 추가된 새로운 컬렉션 전용 반복 구문이다. iterable을 순회하면서 각 요소를 변수에 할당한다.

```javascript
for (변수 선언문 of 이터러블) { ... }
```

- 컬렉션 객체가 `[Symbol.iterator]` 속성을 가지고 있어야 사용할 수 있다. 대표적으로 `Array`, `Map`, `Set`, `String`, `TypedArray`, `arguments` 객체 등이 포함된다.
- 내부적으로 iterator의 netx 메서드를 호출하여 iterable을 순회하고, next 메서드가 반환한 iterator result 객체의 value 프로퍼티 값을 for ... of 문의 변수에 할당한다.
- 그리고 iterator result 객체의 done 프로퍼티 값이 false이면 iterable의 순회를 계속하고, true이면 iterable의 순회를 중단한다.

```javascript
for (const item of [1, 2, 3]) {
  console.log(item);
}
// 1
// 2
// 3
```

- 내부 동작을 `for` 문으로 표현하면 다음과 같다.

```javascript
const iterable = [1, 2, 3];

const iterator = iterable[Symbol.iterator]();

for (;;) {
  const res = iterator.next();
  if (res.done) break;
  const item = res.value;
  console.log(item);
}

// 1
// 2
// 3
```

## `for ... in`

- `for ... in` 문은 객체의 모든 프로퍼티를 순회하며 열거한다.

```javascript
for (변수선언문 in 객체) { ... }
```

```javascript
const person = {
  name: "joon",
  address: "Seoul",
};

for (const key in person) {
  console.log(`${key} : ${person[key]}`);
}

// name : joon
// address : Seoul
```

- `for ... in` 문은 `in` 연산자처럼 순회 대상 객체의 프로퍼티 뿐만 아니라, 상속받은 프로토타입의 프로퍼티까지 열거한다. 하지만, 위의 예제에서는 `toString`과 같은 `Object.prototype`의 프로퍼티는 열거되지 않는다.

```javascript
const person = {
  name: "joon",
  address: "Seoul",
};

// Object.prototype의 프로퍼티를 열거함.
console.log("toString" in person);
// true
```

- 이는 `toString` 메서드가 열거할 수 없도록 정의된 프로퍼티이기 때문이다. 즉, `Object.prototype.string` 프로퍼티의 프로퍼티 어트리뷰트 [[Enumerable]] 값이 `false` 이기 때문이다.
- 객체의 프로토타입 체인 상에 존재하는 모든 프로토타입의 프로퍼티 중에서 프로퍼티 어트리뷰트 [[Enumeralbe]]의 값이 true인 프로퍼티를 순회하며 열거한다.

```javascript
const person = {
  name: "joon",
  address: "Seoul",
  __proto__: { age: 20 },
};

for (const key in person) {
  console.log(`${key} : ${person[key]}`);
}

// name : joon
// address : Seoul
// age : 20
```

- 이때, 프로퍼티 키가 Symbol인 프로퍼티는 열거하지 않는다.

```javascript
const sym = Symbol();
const obj = {
  a: 1,
  [sym]: 10,
};

for (const key in obj) {
  console.log(`${key} : ${obj[key]}`);
}

// a : 1
```

- 상속받은 프로퍼티는 제외하고 객체 자신의 프로퍼티만 열거하려면 `Object.prototype.hasOwnProperty` 메서드를 사용하여 객체 자신의 프로퍼티인지 확인해야 한다.

```javascript
const person = {
  name: "joon",
  address: "Seoul",
  __proto__: { age: 20 },
};

for (const key in person) {
  if (!person.hasOwnProperty(key)) continue;
  console.log(`${key} : ${person[key]}`);
}

// name : joon
// address : Seoul
```

- 가급적이면 배열에는 `for ... in` 문보다 일반적인 `for` 문이나 `for ... of` 또는 `Array.prototype.forEach` 메서드를 사용하기를 권장한다. 배열도 객체이기 때문에 프로퍼티와 상속받은 프로퍼티가 포함될 수 있다.

```javascript
const arr = [1, 2, 3];
arr.x = 10;

for (const i in arr) {
  // 프로퍼티 x도 출력된다.
  console.log(arr[i]); // 1 2 3 10
}

console.log(arr.length); // 3

// forEach 메서드는 요소가 아닌 프로퍼티는 제외한다.
arr.forEach((item) => console.log(item)); // 1 2 3

// for ... of는 변수 선언문에서 선언한 변수에 키가 아닌 값을 할당한다.
for (const value of arr) {
  console.log(value); // 1 2 3
}
```

## 궁금증

- `Array` 의 프로퍼티는 키로 인식되는 건가?
- 만약 그렇다면, `for ... of` 에는 키가 아닌 값을 할당하니까 프로퍼티 값은 출력되지 않는 건가??
