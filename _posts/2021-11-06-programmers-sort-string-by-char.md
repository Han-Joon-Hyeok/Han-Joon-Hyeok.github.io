---
title: 프로그래머스 Level 1 - 문자열 내 마음대로 정렬하기 (javascript)
date: 2021-11-06 23:55:00 +0900
categories: [programmers]
tags: [level1, programmers]
---

> [프로그래머스 - Level1 문자열 내 마음대로 정렬하기](https://programmers.co.kr/learn/courses/30/lessons/12915)

# 문제 설명

문자열로 구성된 리스트 strings와, 정수 n이 주어졌을 때, 각 문자열의 인덱스 n번째 글자를 기준으로 오름차순 정렬하려 합니다. 예를 들어 strings가 ["sun", "bed", "car"]이고 n이 1이면 각 단어의 인덱스 1의 문자 "u", "e", "a"로 strings를 정렬합니다.

## 제한사항

- strings는 길이 1 이상, 50이하인 배열입니다.
- strings의 원소는 소문자 알파벳으로 이루어져 있습니다.
- strings의 원소는 길이 1 이상, 100이하인 문자열입니다.
- 모든 strings의 원소의 길이는 n보다 큽니다.
- 인덱스 1의 문자가 같은 문자열이 여럿 일 경우, 사전순으로 앞선 문자열이 앞쪽에 위치합니다.

## 🙋‍♂️나의 풀이

```javascript
function solution(strings, n) {
  const swaps = strings.map((string) => {
    const split = string.split("");
    const pop = split.splice(n, 1);
    split.unshift(pop);
    return split.join("");
  });

  swaps.sort();

  const result = swaps.map((string) => {
    const split = string.split("");
    const shift = split.shift();
    split.splice(n, 0, shift);
    return split.join("");
  });

  return result;
}
```

- 문자열을 `split` 으로 전부 쪼개서 배열로 만든다. 그 다음, n번째에 해당하는 글자를 배열의 맨 앞으로 보낸다.
- 그러면 `sort` 를 실행할 때, 맨 앞에 있는 글자를 기준으로 오름차순 정렬이 실행된다.
- 정렬이 끝나면, 다시 맨 앞에 있는 글자를 원래의 위치에 넣어준다.

---

제출 후 컴파일된 코드는 다음과 같다.

```javascript
function solution(strings, n) {
  var answer = [];
  var str_arr = [];

  for (var i = 0; i < strings.length; i++) {
    var word = strings[i];
    str_arr.push(word[n] + word);
  }

  str_arr.sort();

  for (var i = 0; i < strings.length; i++) {
    var word = str_arr[i].substring(1);
    answer.push(word);
  }

  return answer;
}
```

- n번째에 해당하는 글자를 배열에서 제거하지 않고, 맨 앞에 추가해서 정렬해도 동일한 결과가 나온다.
- 그러면 배열로 쪼개서(`split`), 문자열을 잘라내고(`splice`), 배열에 추가하는(`unshift`) 과정이 없어도 된다.

---

### 개선한 코드

```javascript
function solution(strings, n) {
  const swaps = strings.map((string) => {
    const char = string[n];
    return `${char}${string}`;
  });

  swaps.sort();

  const result = swaps.map((string) => string.substring(1));

  return result;
}
```

속도는 다음과 같다.

```javascript
테스트 1 〉	통과 (0.07ms, 30.3MB)
테스트 2 〉	통과 (0.09ms, 30.1MB)
테스트 3 〉	통과 (0.12ms, 30.1MB)
테스트 4 〉	통과 (0.11ms, 30.2MB)
테스트 5 〉	통과 (0.10ms, 29.9MB)
테스트 6 〉	통과 (0.11ms, 30MB)
테스트 7 〉	통과 (0.10ms, 30.2MB)
테스트 8 〉	통과 (0.11ms, 30.1MB)
테스트 9 〉	통과 (0.08ms, 30.5MB)
테스트 10 〉	통과 (0.11ms, 30MB)
테스트 11 〉	통과 (0.08ms, 30.2MB)
테스트 12 〉	통과 (0.10ms, 30MB)
```

## 👀참고한 풀이

```javascript
function solution(strings, n) {
  // strings 배열
  // n 번째 문자열 비교
  return strings.sort((s1, s2) =>
    s1[n] === s2[n] ? s1.localeCompare(s2) : s1[n].localeCompare(s2[n])
  );
}
```

- n번째 알파벳이 같은 경우에는 문자열 전체를 기준으로 오름차순 정렬하고, 다른 경우에는 n번째 알파벳을 기준으로 오름차순 정렬을 수행한다.
- 짧은 코드이긴 하지만, `localeCompare` 의 수행속도가 느리다는 단점이 있다.

```javascript
테스트 1 〉	통과 (6.46ms, 31.3MB)
테스트 2 〉	통과 (6.43ms, 31.1MB)
테스트 3 〉	통과 (172.43ms, 31.1MB)
테스트 4 〉	통과 (5.73ms, 30.7MB)
테스트 5 〉	통과 (0.43ms, 31MB)
테스트 6 〉	통과 (0.25ms, 31.1MB)
테스트 7 〉	통과 (0.25ms, 31.3MB)
테스트 8 〉	통과 (0.41ms, 31.3MB)
테스트 9 〉	통과 (0.26ms, 31.2MB)
테스트 10 〉	통과 (0.28ms, 30.9MB)
테스트 11 〉	통과 (0.29ms, 31.3MB)
테스트 12 〉	통과 (0.28ms, 31.2MB)
```
