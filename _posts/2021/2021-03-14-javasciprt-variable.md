---
title: Javascript - 자바스크립트 변수에 대해 알아보자
date: 2021-03-14 23:00:00 +0900
categories: [javascript]
tags: [javascript]
---

> [드림코딩 - 자바스크립트 입문편(ES5+)](https://www.youtube.com/watch?v=OCCpGh4ujb8&list=PLv2d7VI9OotTVOL4QmPfvJWPJvkmv6h-2&index=3)를 공부하며 정리한 내용입니다.

# 1. `use strict`

- Vanilla JS를 사용할 경우 `'use strict'`를 스크립트 최상단에 선언하는 것을 권장한다.
- 문법적으로 맞지 않거나, 변수가 선언되지 않았음에도 정상적으로 처리되는 상황을 방지해준다.

# 2. Variable(변수)

## Block scope 

- 블록 단위로 선언된 부분은 지역변수로 할당된다.
- 따라서 블록 외부에서 해당 변수를 접근하는 것은 불가능하다.

``` javascript
let globalName = 'this is a global name';

// 지역변수로 선언되는 블록
{
    let job = 'dev';
    console.log(job); // dev
    job = 'consult';
    console.log(job); // consult
    
    // 전역 변수는 블록 내부에서도 호출 가능
    console.log(globalName); // this is a global name
}

// job은 지역변수이기 때문에 블록 외부에서 호출 불가
console.log(job); 
// Uncaught ReferenceError : job is not defined
```

- 전역 변수는 항상 실행되는 순간부터 메모리에 탑재되기 때문에 최소한으로 선언한다.
- 가능하면 class, function, if, for 등 필요한 부분에서만 정의하는 것이 권장된다.

## 변수 선언 방식

### 1. `let`

- ES6에서 등장한 변수 타입이다. 
  - mutable - 변하기 쉬운 특성을 가지고 있다.

``` javascript
let name = 'joon';
console.log(name); // joon
name = 'hello';
console.log(name);  // hello
```

### 2. `var` (사용하지 않는 것을 권장)
- 호이스팅(`Hoisting`)으로 인해 변수를 선언하기 전에 값을 할당해도 문제가 발생X
  - 호이스팅 : 어느 위치에 선언했든지 상관없이 항상 선언을 제일 위로 끌어올려주는 것.
- block scope을 철저히 무시하므로 사용 X

- 아래의 문장을 실행하면 변수는 정의되었으나, 값이 들어가있지 않았다는 `undefined`이 출력된다.

``` javascript
console.log(age); // undefined
age = 4;
console.log(age); // 4
var age;
```

- block scope를 무시하는 경우
``` javascript
{
    country = 'Seoul';
    var country;
}

console.log(country) // Seoul
```

### 3. `Const`
- `Constant` : 상수, 변하지 않는 형태를 의미한다. r(read only)
  -  값을 가리키고 있는 포인터가 잠겨있는 변수. (`immutable`)
- `Immutable`한 변수의 장점은 다음과 같다.
  1. `security` : 한번 작성한 코드를 누군가 임의로 수정할 수 없도록 방지
  2. `thread safety` : 다양한 thread가 같은 변수를 사용할 때, 값을 변하지 않도록 방지
  3. `reduce human mistakes` : 다른 개발자가 코드를 변경할 때도 실수를 방지

### 참고
- Immutable한 데이터 타입은 데이터 변경이 불가능하며 대표적으로 다음과 같다.
  - `primitive types`(원시 자료형) : `int`, `boolean`, `float` 등
  - `frozen objects` : 동결 객체 (i.e. `object.freeze()`)
- Mutable한 데이터 타입은 데이터 변경이 가능하다.
  - 자바스크립트에 모든 객체는 Mutable하다.

# 3. 변수 타입 (Variable Types)

1. `primitive, single item` : 더 이상 작은 단위로 쪼개질 수 없는 한 가지의 아이템
  - number, string, boolean, null, undefined, symbol
2. `object, box container` : single item을 여러 개로 묶어서 한 단위로 관리할 수 있는 단위
3. `function, first-class function` : function도 변수에 할당 가능하고, 해당 변수를 인자로 넘길 수도 있고, 리턴 타입으로도 함수를 사용할 수 있다.

## 원시 자료형 (`primitive`)

### `number`
- C나 Java와 달리 실수, 정수에 상관없이 number라는 데이터 타입에 동적으로 값을 할당할 수 있음.

``` javascript
const count = 12; // integer
const size = 12.1; // decimal number
console.log(`value : ${count}, type : ${typeof count}`); // value : 12, type : number
console.log(`value : ${size}, type : ${typeof size}`);   // value : 12.1, type : number
```

- 특별한 경우의 `number`
  - infinity, -infinity, NaN
  - 유효한 값을 연산하지 않는 경우에 다음과 같은 결과가 발생한다. 

``` javascript
const infinity = 1 / 0;
const negativeInfinity = -1 / 0;
const nAn = 'not a number' / 2;

console.log(infinity); // Infinity
console.log(negativeInfinity); // -Infinity
console.log(nAn); // Nan (Not a Number)
``` 

### `bigInt` 
- 최근에 새로 나왔지만, 아직 사용하지는 않음. (Chrome, Firefox에서만 지원)

``` javascript
const bigInt = 12312412412431234n;
console.log(`value : ${bigInt}, type : ${typeof bigInt}`); 
// -> value : 12312412412431234, type : bigint
```

### string

``` javascript
const char = 'c';
const youtube = 'youtube';
const greeting = 'hello ' + youtube; // + 기호로 string끼리 결합하는 것이 가능
console.log(`value : ${greeting}, type : ${typeof greeting}`);
// -> value : hello, youtube, type : string

// template literals : 백틱(`) 기호를 사용해서 + 연산자 없이 간편하게 string과 변수를 함께 출력가능
const helloYoutube = `hi ${youtube}!`;
console.log(`value : ${helloYoutube}, type : ${typeof helloYoutube}`);
// -> value : hi youtube!, type : string
```

### boolean
- `false` : 0, null, undefined, Nan, ''
- `true` : false가 아닌 모든 것들

``` javascript
const canRead = true;
const compare = 3 < 1; // false
console.log(`value : ${canRead}, type : ${typeof canRead}`);
console.log(`value : ${compare}, type : ${typeof compare}`);

// -> value : true, type : boolean
// -> value : false, type : boolean

// null : 텅텅 비어있는 값이 할당된 상태.
let nothing = null;
console.log(`value : ${nothing}, type : ${typeof nothing}`);
// -> value : null, type : object

// undefined : 변수가 선언은 되었으나 값이 할당되지 않은 상태.
let x;
console.log(`value : ${x}, type : ${typeof x}`);
// -> value : undefined, type : undefined
```

### symbol
- 객체마다 고유한 식별자를 생성

``` javascript
const symbol1 = Symbol('id');
const symbol2 = Symbol('id');
console.log(`symbol1 === symbol2 : ${symbol1 === symbol2}`);
// -> symbol1 === symbol2 : false

// 동일한 string으로 생성할 경우 for을 사용
const gSymbol1 = Symbol.for('id');
const gSymbol2 = Symbol.for('id');
console.log(`gSymbol1 === gSymbol2 : ${gSymbol1 === gSymbol2}`);
// -> gSymbol1 === gSymbol2 : true

// symbol값 출력 시에는 string으로 변환 후 출력
console.log(`value : ${symbol1.description}, type : ${typeof symbol1}`);
// -> value : id, type : symbol
```

# 5. Dynamic type : dynamically typed language
- 자바스크립트는 변수를 선언할 때 데이터 타입을 선언하지 않고도 런타임 시 할당된 값에 따라 데이터 타입을 결정한다.

``` javascript
let text = 'hello';
console.log(text.charAt(0)); 
// h

console.log(`value : ${text}, type : ${typeof text}`); 
// value : hello, type : string

text = 1;
console.log(`value : ${text}, type : ${typeof text}`);
// value : 1, type : number

text = '7' + 5;
console.log(`value : ${text}, type : ${typeof text}`);
// value : 75, type : string

text = '8' / '2';
console.log(`value : ${text}, type : ${typeof text}`);
// value : 4, type : number

console.log(text.charAt(0)); 
// text.charAt is not a function
```

## object, real-life object, data structure
``` javascript
const joon = {
    name : 'joon',
    age : 20
};
console.log(`var : joon.age, value : ${joon.age}`);
// -> var : joon.age, value : 20
``` 
- const로 선언된 joon이라는 객체는 다른 객체로 변경 불가능.
- `joon`이 가리키고 있는 메모리의 포인터는 잠겨 있어서 재할당 불가.
- 아래처럼 다른 객체로 변경하는 것은 불가.

``` javascript
joon = {
    name : 'han',
    country : 'korea'
}
// -> Uncaught TypeError: Assignment to constant variable
```

- but, 객체 내부의 변수는 접근이 가능하다

``` javascript
joon.age = 21;
console.log(`var : joon.age, value : ${joon.age}`);
// -> var : joon.age, value : 21

console.log(`joon.name.length : ${joon.name.length}`);
// -> joon.name.length : 4
```