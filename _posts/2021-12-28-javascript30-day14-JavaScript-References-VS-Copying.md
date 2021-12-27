---
title: Javascript30 - Day 14 JavaScript References VS Copying
date: 2021-12-27 23:50:00 +0900
categories: [javascript]
tags: [javascript30, javascript]
---

> [Javascript30](https://javascript30.com/)

# 학습 내용

자바스크립트에서 변수에 할당된 값을 복사할 때 얕은 복사(shallow copy)가 이루어지는 경우와 깊은 복사 (deep copy)가 이루어지는 경우를 이해한다.

## 원시 타입 데이터

객체를 제외한 나머지 원시 타입 데이터(string, number, boolean 등)는 다른 변수에 값을 복사하고 원본 변수의 값을 변경해도 전혀 영향을 미치지 않는다. 즉, 두 변수는 서로 독립적인 상태가 되는 것이며, 이는 깊은 복사(deep copy)에 해당한다.

```javascript
let age = 100;
let age2 = age;
console.log(age, age2); // 100, 100

age = 200;
console.log(age, age2); // 200, 100
```

## 객체의 얕은 복사 (Shallow Copy)

원시 타입을 제외한 모든 데이터 타입은 객체이다. 배열도 객체에 해당하는데, 객체는 기본적으로 참조 형태로 값이 전달된다. 다시 말해서, 데이터 자체를 복사해서 넘기는 것이 아닌 원본 데이터의 주소값을 전달하는 것이다. 그래서 다른 변수에 객체 변수를 할당하고, 어떤 변수에서든 객체에 발생하는 변경 내용이 모두 공유된다.

```javascript
// 배열의 얕은 복사
const players = ["Wes", "Sarah", "Ryan", "Poppy"];
const team = players;

players[3] = "Han";

console.log(players); // ['Wes', 'Sarah', 'Ryan', 'Han']
console.log(team); // ['Wes', 'Sarah', 'Ryan', 'Han']
```

일반 객체도 동일하게 적용된다.

```javascript
const person = {
  name: "joon",
  age: 100,
};

const obj1 = person;

obj1.name = "han";

console.log(person); // {name: 'han', age: 100}
console.log(obj1); // {name: 'han', age: 100}
```

## 배열의 깊은 복사 (Deep Copy)

배열을 완전히 독립적인 변수에 담고 싶을 때는 다음과 같은 방법을 사용할 수 있다.

### 1) 스프레드 연산자

```javascript
// 배열의 스프레드 연산자 (ES6)
const players = ["Wes", "Sarah", "Ryan", "Poppy"];
const spread = [...players];

players[3] = "joon";

console.log(players); // ['Wes', 'Sarah', 'Ryan', 'joon']
console.log(spread); // ['Wes', 'Sarah', 'Ryan', 'Poppy']
```

### 2) Array.prototype.slice()

```javascript
const players = ["Wes", "Sarah", "Ryan", "Poppy"];
const slice = players.slice();
```

`slice()` 메서드에 인수를 넣지 않고 실행하면 배열의 모든 요소를 포함한 새로운 배열을 반환한다.

### 3) Array.from()

```javascript
const players = ["Wes", "Sarah", "Ryan", "Poppy"];
const from = Array.from(players);
```

## 객체의 깊은 복사 (Deep Copy)

객체는 다음과 같은 방법으로 깊은 복사를 수행할 수 있다.

### 1) 스프레드 연산자

```javascript
// 객체의 스프레드 연산자 (ES9)

const person = {
  name: "joon",
  age: 100,
};

const spread = { ...person };

person.name = "han";

console.log(person); // {name: 'han', age: 100}
console.log(spread); // {name: 'joon', age: 100}
```

### 2) Object.assign(target, ...sources)

```javascript
const person = {
  name: "joon",
  age: 100,
};

const assign = Object.assign({}, person, { address: "Seoul" });

console.log(assign); // {name: 'joon', age: 100', address: 'Seoul'}
```

위의 예시에서는 빈 객체에 `person` 객체와 새로운 데이터를 함께 복사했다.

### 3) JSON.parse(JSON.stringify(obj))

앞선 두 가지 방법은 중첩 객체에 대해서는 얕은 복사를 수행한다.

```javascript
const person = {
  name: "joon",
  age: 100,
  social: {
    instagram: "@joonsta",
  },
};

const spread = { ...person };

person.social.instagram = "@hansta";

console.log(person.social.instagram); // "@hansta"
console.log(spread.social.instagram); // "@hansta"
```

중첩 객체까지 복사하기 위해서는 다음과 같은 방법을 사용할 수 있다.

```javascript
const person = {
  name: "joon",
  age: 100,
  social: {
    instagram: "@joonsta",
  },
};

const json = JSON.parse(JSON.stringify(person));

person.social.instagram = "@hansta";

console.log(person.social.instagram); // "@hansta"
console.log(json.social.instagram); // "@joonsta"
```

`JSON.stringify(obj)` 는 객체를 string 형태로 변환한다.

```javascript
const person = {
  name: "joon",
  age: 100,
  social: {
    instagram: "@joonsta",
  },
};

console.log(JSON.stringify(person));
// '{"name":"joon","age":100,"social":{"instagram":"@joonsta"}}'
```

`JSON.parse(string)` 은 string 을 JSON 형태의 객체로 변환한다.

```javascript
const person = {
  name: "joon",
  age: 100,
  social: {
    instagram: "@joonsta",
  },
};
const stringify = JSON.stringify(person);
const parse = JSON.parse(stringify);

console.log(parse);
// {name: 'joon', age: 100, social: {…}}
```
