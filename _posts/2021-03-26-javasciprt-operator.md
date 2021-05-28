---
title: Javascript - 자바스크립트 연산자(Operator) 정리
date: 2021-03-26 23:40:00 +0900
categories: [javascript]
tags: [javascript]
---

> [드림코딩 - 자바스크립트 입문편(ES5+)](https://www.youtube.com/watch?v=OCCpGh4ujb8&list=PLv2d7VI9OotTVOL4QmPfvJWPJvkmv6h-2&index=3)를 공부하며 정리한 내용입니다.

# 1. String concatenation

`String` 자료형은 `+` 기호로 연결하여 출력할 수 있다.

``` js
console.log('my' + 'cat'); // mycat
console.log('1' + 2);  // 12 - 2는 자동으로 string으로 변환된다.
console.log(`string literals: 1 + 2 = ${1 + 2}`); // `(백틱)을 사용하면 +기호를 사용하지 않아도 편리하게 출력이 가능하다.

console.log("joon's study says \n\"hello, \tthere\""); // "(쌍따옴표) 자체를 출력하기 위해서는 해당 문자 앞에 \(백슬래시)를 붙여준다.
// joon's study says
// "hello,  there"
```

# 2. Numeric operators

숫자형 자료에 대한 연산은 사칙연산, 나머지, 지수가 가능하다.

``` js
console.log(1 + 1); // add(덧셈)
console.log(1 - 1); // subtract(뺄셈)
console.log(1 / 1); // divide(나누기)
console.log(1 * 1); // multiply(곱)
console.log(5 % 2); // remainder(나머지)
console.log(2 ** 3); //  exponentiation(지수)
```

# 3. Increment and decrement operators

`증감 연산자`는 연산을 더하거나 감소시킬 때 사용하는 연산자이다.
먼저 실행하는 `전위 연산자`와 나중에 연산을 실행하는 `후위 연산자`로 나뉘는데, 다른 언어에서 사용하는 방법과 비슷하다.

``` js
let counter = 2;
const preIncrement = ++counter;
// counter = counter + 1;
// preIncrement = counter; 
console.log(`counter : ${counter}, preIncrement : ${preIncrement}`);
// counter : 3, preIncrement = 3

const postIncrement = counter++;
// postIncrement = counter;
// counter = counter + 1; 
console.log(`counter : ${counter}, postIncrement : ${postIncrement}`);
// counter : 4, postIncrement = 3
```

# 4. Assignment operators

`대입 연산자`는 사칙연산을 실행함과 동시에 원하는 변수에 해당 연산에 대한 결과를 대입하는 연산자이다.

``` js
let x = 3;
let y = 6;
console.log(x += y); // x = x + y (9)
console.log(x -= y); // x = x - y (3)
console.log(x *= y); // x = x * y (18)
console.log(x /= y); // x = x / y (3)
```

# 5. Comparison operators 

`비교 연산자`는 숫자형 자료에 대해 크고 작음을 비교하는 연산자이다. 결과값은 `true` 또는 `false`로 반환된다.

``` js
console.log(10 < 6) // less than (false)
console.log(10 <= 6) // less than or equal (false)
console.log(10 > 6) // greater than (true)
console.log(10 >= 6) // greater than or equal (true)
```

# 6. Logical operator : ||(or), &&(and), !(not)

``` js
const value1 = false;
const value2 = 4 < 2;
function check(){
    for(let i = 0; i < 10; i++){
        console.log("😅");
    }
    return true;
}

// ||(or), finds the first truth value
console.log(`or : ${value1 || value2 || check()}`);
// 연산이 가장 오래 걸리는 함수는 가장 마지막에 실행되는 것이 좋다.

// &&(and), finds the first truth value
console.log(`and : ${value1 && value2 && check()}`);
// null 체크를 할 때도 많이 쓰임. 
// nullableObject && nullableObject.something

// !(not)
console.log(!value1);
```

# 7. Equality 
const stringFive = '5';
const numberFive = 5;

// == loose equality, with type conversion
console.log(stringFive == numberFive); // true
console.log(stringFive != numberFive); // false

// === strict equality, no type conversion
console.log(stringFive === numberFive); // false
console.log(stringFive !== numberFive); // true

console.log(stringFive == numberFive); // true
console.log(stringFive != numberFive); // false

// object equality by reference

const joon1 = { name : 'joon' };
const joon2 = { name : 'joon' };
const joon3 = joon1;

console.log(joon1 == joon2); // 다른 reference 값을 가지므로 false
console.log(joon1 == joon3); // 동일한 ref값을 가지므로 true
console.log(joon1 === joon2); // 똑같은 타입이더라도 다른 ref값이므로 false
console.log(joon1 === joon3); // 동일한 ref값을 가지므로 true

// equality - puzzler
console.log(0 == false); // true
console.log(0 === false); // false
console.log('' == false); // true
console.log('' === false); // false
console.log(null == undefined); // *true
console.log(null == undefined); // false

// 8. Conditional operators : if
// if, else if, else
const name = 'hi';
let msg;
if(name === 'joon'){
    msg = "Hi joon!"
} else if (name === 'coder'){
    msg = "You are awesome coder!"
} else{
    msg = "unknown";
}
console.log(msg)

// 9. Ternary operator: ?
// condition ? value1 : value2
console.log(name === 'joon' ? 'yes' : 'no');

// 10. Switch statement
// use for multiple if checks
// use for enum-like value check
// use for multiple type checks in TS
const browser = 'IE';
switch (browser) {
    case 'IE':
        console.log('Go Away!');
        break;
    case 'Chrome':
    case 'Firefox':
        console.log('love you!');
        break;
    default:
        console.log('same all!');
        break;
}

// 11. Loops
// while loop, while the condition is truthy,
// body code is executed.
let i = 3;
while (i > 0) {
    console.log(`while : ${i}`);
    i--;
}

// do while loop, body code is executed first,
// then check the condition
do {
    console.log(`do while: ${i}`);
    i--;
} while (i > 0);

// for loop, for(begin; condition; step)
for (i = 3; i > 0; i--){
    console.log(`for : ${i}`);
}

for (let i = 3; i > 0; i = i - 2){
    //inline variable declaration
    console.log(`inline variable for : ${i}`);
}

// nested loops
// 시간복잡도가 O(n^2)이므로 CPU에 부담을 준다. 따라서 가급적 사용X
for (let i = 0; i < 10; i++) {
    for (let j = 0; j < 10; j++) {
        console.log(`i: ${i}, j: ${j}`);
    }
}

// break, continue
// Q1. iterate from 0 to 10 and print only even numbers (use continue)

for (let i = 0; i < 11; i++){
    if (i % 2 === 0){
        console.log(`i : ${i}`);
    }
    else continue;
}

// Q2. iterate from 0 to 10 and print numbers until reaching 8 (use break)

for (let i = 0; i < 11; i++){
    if (i > 8){
        break
    } else {
        console.log(`i : ${i}`);
    }
}