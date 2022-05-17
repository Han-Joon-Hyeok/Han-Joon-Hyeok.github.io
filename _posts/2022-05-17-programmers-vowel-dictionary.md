---
title: 프로그래머스 Level 2 - 모음 사전 (JavaScript)
date: 2022-05-17 13:20:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 모음 사전](https://programmers.co.kr/learn/courses/30/lessons/84512)

# 문제 설명

사전에 알파벳 모음 'A', 'E', 'I', 'O', 'U'만을 사용하여 만들 수 있는, 길이 5 이하의 모든 단어가 수록되어 있습니다. 사전에서 첫 번째 단어는 "A"이고, 그다음은 "AA"이며, 마지막 단어는 "UUUUU"입니다.

단어 하나 word가 매개변수로 주어질 때, 이 단어가 사전에서 몇 번째 단어인지 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- word의 길이는 1 이상 5 이하입니다.
- word는 알파벳 대문자 'A', 'E', 'I', 'O', 'U'로만 이루어져 있습니다.

# 🙋‍♂️나의 풀이

## 🤔문제 접근

DFS 로 모든 경우의 수를 만들고, 그 중에서 `word` 의 인덱스를 찾아서 반환했다.

모든 경우의 수는 `5 * 5 * 5 * 5 * 5` + `5 * 5 * 5 * 5` + `5 * 5 * 5` + `5 * 5` + `5` = 3905 이기 때문에 시간 복잡도는 크게 고려하지 않아도 풀 수 있다.

문제를 푸는 다른 방법을 밑에서 소개하겠지만, 이 문제의 의도는 DFS 를 연습하는 것이라 생각해서 DFS 로 풀었다.

## ✍️작성 코드

```javascript
function solution(word) {
  const result = [];
  const str = "";
  for (let i = 1; i <= 5; i++) dfs(str, i, result);
  return result.sort().indexOf(word) + 1;
}

const dfs = (word, length, result) => {
  const vowels = [..."AEIOU"];
  if (length === word.length) {
    result.push(word);
    return;
  }
  vowels.forEach((vowel) => {
    dfs(word + vowel, length, result);
  });
};
```

우선, 순서에 상관없이 길이에 따른 모든 경우의 수를 조합한다.

```javascript
for (let i = 1; i <= 5; i++) dfs(str, i, result);
```

`dfs` 함수에서는 길이에 따른 모든 경우의 단어를 만든다.

```javascript
const dfs = (word, length, result) => {
  const vowels = [..."AEIOU"];
  if (length === word.length) {
    result.push(word);
    return;
  }
  vowels.forEach((vowel) => {
    dfs(word + vowel, length, result);
  });
};
```

함수 실행 결과는 다음과 같이 길이가 1인 단어부터 마지막으로 5인 단어까지 생성한다.

```
dfs("", 1, result)
	dfs("A", 1, result) -> result.push("A")
dfs("", 1, result)
	dfs("E", 1, result) -> result.push("E")
...
dfs("", 2, result)
	dfs("A", 2, result)
		dfs("AA", 2, result) -> result.push("AA")
	dfs("A", 2, result)
		dfs("AE", 2, result) -> result.push("AE")
	dfs("A", 2, result)
		dfs("AI", 2, result) -> result.push("AI")
...
dfs("", 5, result)
	dfs("A", 5, result)
		dfs("AA", 5, result)
			dfs("AAA", 5, result)
				dfs("AAAA", 5, result)
					dfs("AAAAA", 5, result) -> result.push("AAAAA")
```

`result` 에 저장되는 값은 다음과 같다.

```
[
	"A", "E", "I", "O", "U",
	"AA", "AE", "AI", "AO", "AU", ...
	"AAA", "AAE", "AAI", "AAO", "AAU", ...
	...
	"AAAAA", ... "UUUUU"
]
```

이를 `sort` 함수로 오름차순으로 정렬하면 다음과 같이 정렬된다.

```
[
	"A", "AA", "AAA", "AAAA", "AAAAA",
	"AAAAE", "AAAAI", "AAAAO", "AAAAU",
	"AAAE", ... "UUUUU"
]
```

그리고 `word` 의 인덱스를 찾아서 1을 더한 값을 반환한다. 1을 더하는 이유는 인덱스가 0 부터 시작하기 때문에 1부터 시작하는 순서에 맞추기 위함이다.

```javascript
return result.sort().indexOf(word) + 1;
```

# 👀참고한 풀이

```javascript
let idx = 0;
const result = {};
const vowels = [..."AEIOU"];

function solution(word) {
  dfs("", 0);
  return result[word];
}

const dfs = (word, length) => {
  if (length > 5) return;
  result[word] = idx++;
  vowels.forEach((vowel) => {
    dfs(word + vowel, length + 1);
  });
};
```

가능하면 전역변수는 사용하지 않는 것이 좋다고 생각한다. 하지만 위의 코드는 정렬을 하지 않고도 순서대로 문자를 만들면서, 객체에 인덱스 값을 바로 저장하기 때문에 직관적이라는 장점이 있다.

`result` 에 저장되는 값은 다음과 같다.

```javascript
{
  '': 0,
  A: 1,
  AA: 2,
  AAA: 3,
  AAAA: 4,
  AAAAA: 5,
  AAAAE: 6,
  AAAAI: 7,
  AAAAO: 8,
  AAAAU: 9,
  AAAE: 10,
  AAAEA: 11,
  AAAEE: 12,
  AAAEI: 13,
  AAAEO: 14,
	...
	UUUU: 3900,
  UUUUA: 3901,
  UUUUE: 3902,
  UUUUI: 3903,
  UUUUO: 3904,
  UUUUU: 3905
}
```

# 참고자료

- [[Programmers 위클리 챌린지 5주차] 모음 사전](https://jaimemin.tistory.com/m/1907) [티스토리]
