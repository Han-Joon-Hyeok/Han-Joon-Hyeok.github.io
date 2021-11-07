---
title: 프로그래머스 Level 1 - 소수 만들기 (javascript)
date: 2021-11-07 21:25:00 +0900
categories: [programmers]
tags: [level1, programmers, javascript]
---

> [프로그래머스 - Level1 소수 만들기](https://programmers.co.kr/learn/courses/30/lessons/12977)

# 문제 설명

주어진 숫자 중 3개의 수를 더했을 때 소수가 되는 경우의 개수를 구하려고 합니다. 숫자들이 들어있는 배열 nums가 매개변수로 주어질 때, nums에 있는 숫자들 중 서로 다른 3개를 골라 더했을 때 소수가 되는 경우의 개수를 return 하도록 solution 함수를 완성해주세요.

## 제한사항

- nums에 들어있는 숫자의 개수는 3개 이상 50개 이하입니다.
- nums의 각 원소는 1 이상 1,000 이하의 자연수이며, 중복된 숫자가 들어있지 않습니다.

## 🙋‍♂️나의 풀이

3중 반복문을 사용해서 배열에서 3개 요소를 더한 다음, 소수인지 확인하는 구조로 작성했다.

- 소수를 확인할 때는 제곱근을 활용하면 조금 더 빠르게 확인할 수 있다. (참고 : [소수 판별 알고리즘](https://han-joon-hyeok.github.io/posts/TIL-check-prime-number/))

```jsx
function solution(nums) {
  const result = [];

  const isPrimeNumber = (n) => {
    for (let i = 2; i <= Math.sqrt(n); i++) {
      if (n % i === 0) return false;
    }
    return true;
  };

  const size = nums.length;

  for (let i = 0; i < size; i++) {
    for (let j = i + 1; j < size; j++) {
      for (let k = j + 1; k < size; k++) {
        const num = nums[i] + nums[j] + nums[k];
        if (isPrimeNumber(num)) {
          result.push(num);
        }
      }
    }
  }

  return result.length;
}
```

## 👀참고한 풀이

```jsx
function solution(nums) {
  const combis = getCombination(nums, 3);
  const elementSum = getElmentSum(combis);
  const prime = getPrimeNumList(Math.max(...elementSum));

  return elementSum.filter((el) => prime[el] !== 0).length;
}

function getCombination(arr, len = arr.length) {
  if (len === 1) return arr.map((el) => [el]);

  const combis = [];

  arr.forEach((curr, idx) => {
    const smallerCombis = getCombination(arr.slice(idx + 1), len - 1);

    smallerCombis.forEach((smallerCombi) => {
      combis.push([curr, ...smallerCombi]);
    });
  });

  return combis;
}

function getElmentSum(comb) {
  return comb.map((el) => el.reduce((a, b) => a + b));
}

function getPrimeNumList(num) {
  const prime = [];

  for (let i = 2; i <= num; i += 1) {
    prime.push(i);
  }

  for (let i = 2; i <= Math.sqrt(num); i += 1) {
    if (prime[i] === 0) continue;

    for (let j = i + i; j <= num; j += i) {
      prime[j] = 0;
    }
  }

  return prime;
}
```

- 함수를 여러 개로 나누어서 깔끔하게 작성하셨다.
- 내부 작동 로직을 아직 이해 못했다. 다시 공부할 때 제대로 이해해야겠다.

## 느낀 점

- 처음엔 조합으로 접근했는데, 조합 구현하는 로직을 제대로 이해하지 못해서 시간이 오래 걸렸다. 제대로 이해하고 넘어가야겠다.
  - [JavaScript로 순열과 조합 알고리즘 구현하기](https://jun-choi-4928.medium.com/javascript%EB%A1%9C-%EC%88%9C%EC%97%B4%EA%B3%BC-%EC%A1%B0%ED%95%A9-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-21df4b536349)
