---
title: 프로그래머스 Level 2 - 소수 찾기 (JavaScript)
date: 2021-12-31 20:30:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 소수 찾기](https://programmers.co.kr/learn/courses/30/lessons/42839)

# 문제 설명

---

한자리 숫자가 적힌 종이 조각이 흩어져있습니다. 흩어진 종이 조각을 붙여 소수를 몇 개 만들 수 있는지 알아내려 합니다.

각 종이 조각에 적힌 숫자가 적힌 문자열 numbers가 주어졌을 때, 종이 조각으로 만들 수 있는 소수가 몇 개인지 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- numbers는 길이 1 이상 7 이하인 문자열입니다.
- numbers는 0~9까지 숫자만으로 이루어져 있습니다.
- "013"은 0, 1, 3 숫자가 적힌 종이 조각이 흩어져있다는 의미입니다.

## 🙋‍♂️나의 풀이

문제를 해결하기 위해 필요한 것 2가지이다.

1. 가능한 모든 숫자의 조합을 만들기 (순열)
2. 조합해서 만든 숫자가 소수인지 확인하기

### 1. 순열 (Permutation)

순열은 n개 중 r개를 순서대로 뽑아서 줄을 세우는 것이다.

예를 들어,`[1, 2, 3, 4]` 이 주어졌을 때, 3개를 뽑는 경우의 수를 구하기 위해서는 다음과 같은 의사코드를 작성할 수 있다.

```javascript
1(fixed) => permutation([2, 3, 4]) => 2(fixed) => permutation([3, 4]) => ...
2(fixed) => permutation([1, 3, 4]) => 1(fixed) => ...
3(fixed) => permutation([1, 2, 4]) => 1(fixed) => ...
4(fixed) => permutation([1, 2, 3]) => 1(fixed) => ...
```

숫자 하나를 고정하고, 나머지 숫자들에서 조합을 구한다. 그리고 이 과정을 재귀적으로 나머지 숫자들에서 조합을 진행한다. 재귀를 탈출하는 조건은 선택해야 하는 숫자가 1개일 때이다. 이때는 모든 배열의 원소를 선택해서 리턴한다.

```javascript
const getPermutations = (arr, selectNumber) => {
  const result = [];
  if (selectNumber === 1) return arr.map((v) => [v]);
  // ...
};
```

순열은 자기 자신을 제외한 모든 숫자를 포함해야 하기 때문에 다음과 같이 작성할 수 있다.

```javascript
arr.forEach((fixed, index, origin) => {
		const rest = [...origin.slice(0, index), ...origin.slice(index + 1)];
		// ...
}
```

재귀적으로 함수를 호출하고, 고정한 숫자 하나와 순열의 모든 경우를 하나의 배열에 합친다.

```javascript
arr.forEach((fixed, index, origin) => {
	const rest = [...origin.slice(0, index), ...origin.slice(index + 1)];
	const permutation = getPermutations(rest, selectNumber - 1);
	const attached = permutation.map(combination => [fixed, ...permutation]);
	result.push(attached);
}
```

완성된 코드는 다음과 같다.

```javascript
const getPermutations = (arr, selectNumber) => {
	const result = [];
	if (selectNumber === 1) return arr.map(v => [v]);

	arr.forEach((fixed, index, origin) => {
		const rest = [...origin.slice(0, index), ...origin.slice(index + 1)];
		const permutation = getPermutations(rest, selectNumber - 1);
		const attached = permutation.map(combination => [fixed, ...permutation]);
		result.push(attached);
	}

	return result;
}
```

### 2. 소수 판별하기

소수인지 판별하는 방법은 여러 방법이 있지만, 속도가 가장 빠른 것은 N을 2부터 N의 제곱근까지 나누었을 때, 나머지가 0이 하나라도 존재하지 않는 수를 확인하는 것이다. (참고자료 : [소수 판별 알고리즘](https://han-joon-hyeok.github.io/posts/TIL-check-prime-number/))

1은 소수가 아니므로 1인 경우와 나머지가 0인 경우에는 `false` 를 반환하도록 하고, 그렇지 않다면 `true` 를 반환한다.

```javascript
const checkPrimeNumber (number) {
    if (number < 2) return false;

    for (let i = 2; i <= Math.sqrt(number); i++) {
        const remainder = number % i;
        if (remainder === 0) return false;
    }
    return true
}
```

### 최종 코드

위의 과정을 거쳐서 1부터 숫자의 길이까지 n개를 뽑는 순열을 모두 구하고, 조합한 숫자가 소수인지 확인한다. `011` 이나 `11` 은 동일하기 때문에 `Set` 자료형을 사용해서 중복된 숫자가 없도록 했다.

```javascript
function solution(numbers) {
  const answer = new Set();

  for (let i = 1; i <= numbers.length; i++) {
    const permutation = [...getPermutation([...numbers], i)];
    const primeNumbers = permutation.filter((arr) => {
      const number = +arr.join("");
      const isPrimeNumber = checkPrimeNumber(number);
      return isPrimeNumber;
    });

    primeNumbers.forEach((arr) => {
      answer.add(+arr.join(""));
    });
  }
  return answer.size;
}

const checkPrimeNumber = (number) => {
  if (number < 2) return false;

  for (let i = 2; i <= Math.sqrt(number); i++) {
    const remainder = number % i;
    if (remainder === 0) return false;
  }
  return true;
};

const getPermutation = (arr, selectNumber) => {
  const results = [];
  if (selectNumber === 1) return arr.map((v) => [v]);
  else {
    arr.forEach((fixed, index, origin) => {
      const rest = [...origin.slice(0, index), ...origin.slice(index + 1)];
      const permutations = getPermutation(rest, selectNumber - 1);
      const attached = permutations.map((permutation) => [
        fixed,
        ...permutation,
      ]);
      results.push(...attached);
    });
  }

  return results;
};
```

# 참고자료

- [javascript로 순열과 조합 알고리즘 구하기](https://jun-choi-4928.medium.com/javascript%EB%A1%9C-%EC%88%9C%EC%97%B4%EA%B3%BC-%EC%A1%B0%ED%95%A9-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-21df4b536349)
- [[프로그래머스] 소수 찾기 (JavaScript) Level 2](https://pul8219.github.io/algorithm-problems/programmers-find-prime-numbers/)
