---
title: 프로그래머스 Level 2 - 수식 최대화 (JavaScript)
date: 2022-05-28 16:50:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 수식 최대화](https://programmers.co.kr/learn/courses/30/lessons/67257)

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

다른 분들의 코드를 참고해서 작성했다.

1. 연산자의 모든 조합을 생성한다.
    - 연산자는 `+`, `-`, `*` 뿐이고, 생성 가능한 모든 경우의 수는 6가지다.
2. 정규 표현식으로 연산자와 피연산자를 분리한다.
    - `split` 함수에 정규 표현식을 전달한다.
3. 1번에서 생성한 조합의 연산자 우선 순위에 따라 계산 결과를 저장한다.
4. 연산 결과의 절댓값이 가장 큰 값을 반환한다.

## ✍️작성 코드

우선, 연산자의 조합 가능한 모든 6가지 경우의 수를 다음과 같이 선언했다.

경우의 수가 적기 때문에 재귀 함수로 모든 조합을 생성하기 보단 직접 선언해주었다.

```javascript
const combinations = [
    ['+', '-', '*'],
    ['+', '*', '-'],
    ['*', '+', '-'],
    ['*', '-', '+'],
    ['-', '+', '*'],
    ['-', '*', '+'],
];
```

그리고 연산자에 따라 계산을 수행할 객체 `operators` 를 선언했다.

이 객체 안에 함수를 선언한 이유는 `eval` 함수를 사용하지 않기 위해서다.

`eval` 함수는 문자열로 표현된 값을 실행문으로 변환하는 함수이다.

하지만, `eval` 함수는 보안, 성능, 디버깅의 어려움의 이유로 사용을 금지하고 있다. 

```javascript
const operators = {
    '+': (a, b) => a + b,
    '-': (a, b) => a - b,
    '*': (a, b) => a * b
}
```

연산자와 피연산자를 구분하기 위한 정규 표현식 객체를 생성했다.

함수에 직접 정규 표현식을 입력하지 않는다면, `new RegExp` 생성자로 정규 표현식 객체를 생성해서 전달해야 한다.

```javascript
const regex = new RegExp(/(\D)/);
```

`\D` 는 숫자가 아닌 것을 의미하고, `(\D)` 와 같이 소괄호로 묶으면 소괄호 안에 매칭된 결과를 모두 기억한다.

소괄호의 유무에 따른 실행 결과는 다음과 같다.

```javascript
const string = "12+34"
console.log(string.split(/\D/))    // ["12", "34"]
console.log(string.split(/(\D)/))  // ["12", "+", "34"]
```

모든 경우의 수에 대해 연산자의 우선 순위대로 연산을 수행한다.

```javascript
for (const comb of combinations) {
    const result = expression.split(regex);
    for (const operator of comb) {
        while (result.includes(operator)) {
            const i = result.indexOf(operator);
            const calculation = operators[operator](+result[i - 1], +result[i + 1])
            result.splice(i - 1, 3, calculation)
        }
    }
    answer.push(Math.abs(result));
}
```

예를 들어, `expression` 이 `123+456-789` 이면 `result` 변수에는 다음과 같이 저장된다.

```javascript
["123", "+", "456", "-", "789"];
```

현재 확인하고 있는 연산자에 따라 연산자의 앞, 뒤로 놓인 피연산자에 맞는 연산을 수행한다.

```javascript
const i = result.indexOf(operator);
const calculation = operators[operator](+result[i - 1], +result[i + 1])
```

그 다음 `result` 배열에서 연산을 수행한 연산자와 피연산자는 지우고, 그 자리에 연산을 수행한 결과를 넣는다.

```javascript
result.splice(i - 1, 3, calculation)
```

모든 연산자에 대해 연산이 끝나면, 절댓값을 붙여서 `answer` 배열에 추가한다.

```javascript
answer.push(Math.abs(result));
```

최종적으로 완성한 코드는 다음과 같다.

```javascript
function solution(expression) {
    const answer = []
    const combinations = [
        ['+', '-', '*'],
        ['+', '*', '-'],
        ['*', '+', '-'],
        ['*', '-', '+'],
        ['-', '+', '*'],
        ['-', '*', '+'],
    ];
    const operators = {
        '+': (a, b) => a + b,
        '-': (a, b) => a - b,
        '*': (a, b) => a * b
    }
    const regex = new RegExp(/(\D)/);
    for (const comb of combinations) {
        const result = expression.split(regex);
        for (const operator of comb) {
            while (result.includes(operator)) {
                const i = result.indexOf(operator);
                const calculation = operators[operator](+result[i - 1], +result[i + 1])
                result.splice(i - 1, 3, calculation)
            }
        }
        answer.push(Math.abs(result));
    }
    return Math.max(...answer);
}
```

# 참고자료

- [[프로그래머스] 수식 최대화 - javascript](https://yoon-dumbo.tistory.com/entry/%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EC%88%98%EC%8B%9D-%EC%B5%9C%EB%8C%80%ED%99%94-javascript) [티스토리]
- [[JavaScript] 프로그래머스 수식 최대화 LEVEL2](https://velog.io/@johnyejin/JavaScript-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EC%88%98%EC%8B%9D-%EC%B5%9C%EB%8C%80%ED%99%94-LEVEL2) [velog]
- [Javascript - 스크립트 코드를 실행시키는 eval() 사용 방법을 알아보자](https://7942yongdae.tistory.com/149) [티스토리]
- [[JavaScript]eval 함수의 문제점](https://developer-talk.tistory.com/271) [티스토리]
- [Regular Expression - Groups and ranges](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions/Groups_and_Ranges) [MDN]