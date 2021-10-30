---
title: 프로그래머스 Level 1 - 신규 아이디 추천 (Javascript)
date: 2021-10-29 22:00:00 +0900
categories: [programmers]
tags: [level1, programmers]
---
> [프로그래머스 - Level 1 신규 아이디 추천](https://programmers.co.kr/learn/courses/30/lessons/72410)

카카오에 입사한 신입 개발자 `네오`는 "카카오계정개발팀"에 배치되어, 카카오 서비스에 가입하는 유저들의 아이디를 생성하는 업무를 담당하게 되었습니다. "네오"에게 주어진 첫 업무는 새로 가입하는 유저들이 카카오 아이디 규칙에 맞지 않는 아이디를 입력했을 때, 입력된 아이디와 유사하면서 규칙에 맞는 아이디를 추천해주는 프로그램을 개발하는 것입니다.다음은 카카오 아이디의 규칙입니다.

- 아이디의 길이는 3자 이상 15자 이하여야 합니다.
- 아이디는 알파벳 소문자, 숫자, 빼기(``), 밑줄(`_`), 마침표(`.`) 문자만 사용할 수 있습니다.
- 단, 마침표(`.`)는 처음과 끝에 사용할 수 없으며 또한 연속으로 사용할 수 없습니다.

"네오"는 다음과 같이 7단계의 순차적인 처리 과정을 통해 신규 유저가 입력한 아이디가 카카오 아이디 규칙에 맞는 지 검사하고 규칙에 맞지 않은 경우 규칙에 맞는 새로운 아이디를 추천해 주려고 합니다.신규 유저가 입력한 아이디가 `new_id` 라고 한다면,

```jsx
1단계 new_id의 모든 대문자를 대응되는 소문자로 치환합니다.
2단계 new_id에서 알파벳 소문자, 숫자, 빼기(-), 밑줄(_), 마침표(.)를 제외한 모든 문자를 제거합니다.
3단계 new_id에서 마침표(.)가 2번 이상 연속된 부분을 하나의 마침표(.)로 치환합니다.
4단계 new_id에서 마침표(.)가 처음이나 끝에 위치한다면 제거합니다.
5단계 new_id가 빈 문자열이라면, new_id에 "a"를 대입합니다.
6단계 new_id의 길이가 16자 이상이면, new_id의 첫 15개의 문자를 제외한 나머지 문자들을 모두 제거합니다.
     만약 제거 후 마침표(.)가 new_id의 끝에 위치한다면 끝에 위치한 마침표(.) 문자를 제거합니다.
7단계 new_id의 길이가 2자 이하라면, new_id의 마지막 문자를 new_id의 길이가 3이 될 때까지 반복해서 끝에 붙입니다.
```

## 문제

신규 유저가 입력한 아이디를 나타내는 new_id가 매개변수로 주어질 때, "네오"가 설계한 7단계의 처리 과정을 거친 후의 추천 아이디를 return 하도록 solution 함수를 완성해 주세요.

## 제한사항

new_id는 길이 1 이상 1,000 이하인 문자열입니다.

new_id는 알파벳 대문자, 알파벳 소문자, 숫자, 특수문자로 구성되어 있습니다.

new_id에 나타날 수 있는 특수문자는

```
-_.~!@#$%^&*()=+[{]}:?,<>/
```

로 한정됩니다.

## 🙋‍♂️나의 풀이

- 단계별로 필요한 요구사항을 적용했다.
- 정규표현식과 일치하는 문자열은 `replace` 로 바꾸었다.
- 정규표현식 문법 검색 하면서 푸느라 시간이 오래 걸렸다. 간단한 정규표현식은 마음대로 쓸 수 있도록 연습 해야겠다.

```jsx
function solution(new_id) {
    let answer = '';
    // 1. 소문자 치환
    answer = new_id.toLowerCase();
    
    // 2. 특수문자 제거
    const regex = /([^a-z0-9-_.]*)/g;
    answer = answer.replace(regex,'')
    
    // 3. 마침표 2개 이상 제거
    const regexOfComma = /[.]{2,}/g;
    answer = answer.replace(regexOfComma, '.')
    
    // 4. 마침표가 처음이나 끝에 위치하면 제거
    const regexOfSideComma = /^[.]|[.]$/g;
    answer = answer.replace(regexOfSideComma, '')
    
    // 5. 빈 문자열이면 a 대입
    if(answer.length === 0){
        answer = 'a'
    }
    
    // 6. 16자 이상일 경우, 첫 15자를 제외하고 나머지 제거. 만약 마침표가 끝에 위치하면 마침표 제거
    if(answer.length >= 16){
        answer = answer.slice(0, 15)
        answer = answer.replace(regexOfSideComma, '')
    }
    
    // 7. 2자 이하일 경우, 마지막 문자를 3자가 될때까지 반복해서 붙이기
    if(answer.length <= 2){
        const lastWord = answer[answer.length - 1]
        while(answer.length < 3){
            answer += lastWord;
        }
    }
    
    return answer;
}
```

## 👀참고한 풀이

```jsx
function solution(new_id) {
    const answer = new_id
        .toLowerCase() // 1
        .replace(/[^\w-_.]/g, '') // 2
        .replace(/\.+/g, '.') // 3
        .replace(/^\.|\.$/g, '') // 4
        .replace(/^$/, 'a') // 5
        .slice(0, 15).replace(/\.$/, ''); // 6
    const len = answer.length;
    return len > 2 ? answer : answer + answer.charAt(len - 1).repeat(3 - len);
}
```

- 메서드 체이닝으로 깔끔하게 처리했다.
    - 2단계 : `\w` 는 `[0-9a-zA-Z]` 와 동일한 기능을 수행한다.
    - 5단계 : 빈 문자를 표현할 때 `^$` 를 사용할 수 있다.
    - 6단계 : `slice` 메서드는 마지막 인덱스가 문자열의 길이보다 커도 오류를 반환하지 않고 문자열 전체를 반환한다.
    - 7단계 : `charAt` 메서드로 마지막 문자열을 가져오고, `repeat` 메서드로 부족한 길이 만큼 문자열을 붙였다.

## 배운 내용

- 정규표현식을 사용하기 위한 `match`메서드는 매치 결과와 관련된 정보를 배열로 반환한다.

```jsx
var str = 'For more information, see Chapter 3.4.5.1';
var re = /see (chapter \d+(\.\d)*)/i;
var found = str.match(re);

console.log(found);

// logs [ 'see Chapter 3.4.5.1',
//        'Chapter 3.4.5.1',
//        '.1',
//        index: 22,
//        input: 'For more information, see Chapter 3.4.5.1' ]

// 'see Chapter 3.4.5.1'는 완전한 매치 상태임.
// 'Chapter 3.4.5.1'는 '(chapter \d+(\.\d)*)' 부분에 의해 발견된 것임.
// '.1' 는 '(\.\d)'를 통해 매치된 마지막 값임.
// 'index' 요소가 (22)라는 것은 0에서부터 셀 때 22번째 위치부터 완전 매치된 문자열이 나타남을 의미함.
// 'input' 요소는 입력된 원래 문자열을 나타냄.
```

> 참고 : [String.prototype.match() MDN](https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Global_Objects/String/match)

- 정규표현식에 `/g` 플래그를 사용하지 않으면 최초 검색 결과만 반환하고, 사용하면 모든 검색 결과를 반환한다.

```jsx
const str = 'abcabc';

// `g` 플래그 없이는 최초에 발견된 문자만 반환됩니다
str.match(/a/);
// ["a", index: 0, input: "abcabc", groups: undefined]

// `g` 플래그와 함께라면 모든 결과가 배열로 반환됩니다
str.match(/a/g);
// (2) ["a", "a"]
```

> 참고 : [정규표현식 완전정복](https://wormwlrm.github.io/2020/07/19/Regular-Expressions-Tutorial.html)