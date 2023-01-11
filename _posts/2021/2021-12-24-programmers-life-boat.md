---
title: 프로그래머스 Level 2 - 구명보트 (JavaScript)
date: 2021-12-24 23:10:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 구명보트](https://programmers.co.kr/learn/courses/30/lessons/42885)

# 문제 설명

---

무인도에 갇힌 사람들을 구명보트를 이용하여 구출하려고 합니다. 구명보트는 작아서 한 번에 최대 **2명**씩 밖에 탈 수 없고, 무게 제한도 있습니다.

예를 들어, 사람들의 몸무게가 [70kg, 50kg, 80kg, 50kg]이고 구명보트의 무게 제한이 100kg이라면 2번째 사람과 4번째 사람은 같이 탈 수 있지만 1번째 사람과 3번째 사람의 무게의 합은 150kg이므로 구명보트의 무게 제한을 초과하여 같이 탈 수 없습니다.

구명보트를 최대한 적게 사용하여 모든 사람을 구출하려고 합니다.

사람들의 몸무게를 담은 배열 people과 구명보트의 무게 제한 limit가 매개변수로 주어질 때, 모든 사람을 구출하기 위해 필요한 구명보트 개수의 최솟값을 return 하도록 solution 함수를 작성해주세요.

## 제한사항

- 무인도에 갇힌 사람은 1명 이상 50,000명 이하입니다.
- 각 사람의 몸무게는 40kg 이상 240kg 이하입니다.
- 구명보트의 무게 제한은 40kg 이상 240kg 이하입니다.
- 구명보트의 무게 제한은 항상 사람들의 몸무게 중 최댓값보다 크게 주어지므로 사람들을 구출할 수 없는 경우는 없습니다.

## 🙋‍♂️나의 풀이

처음에는 스택을 이용해서 배열의 요소를 하나씩 조작하는 방식으로 접근했지만, 정확도는 낮고 효율성도 시간초과가 떠서 다른 분들의 풀이를 참고해서 해결했다.

### 알고리즘

- 주어진 배열을 내림차순(또는 오름차순) 정렬한다.
- 포인터를 두 개 사용하는데, 왼쪽은 첫 번째 인덱스를, 오른쪽은 마지막 인덱스를 가리킨다.
- 왼쪽 인덱스와 오른쪽 인덱스에 해당하는 사람들의 무게를 더했을 때 무게 제한 이하라면, 두 명을 모두 태워 보낼 수 있다는 의미이다. 그래서 오른쪽 포인터를 하나 감소시켜서 그 다음으로 몸무게가 높은 사람을 가리키도록 한다.
- 더했을 때 무게가 초과한다면 왼쪽 포인터에 있는 사람만 보낼 수 있다는 의미이므로 왼쪽 포인터만 하나 증가 시킨다.
- 이 과정을 두 인덱스가 같아질 때까지 반복한다.

### 내림차순 정렬 시

```JavaScript
function solution(people, limit) {
  let answer = 0;
  let leftIdx = 0;
  let rightIdx = people.length - 1;

  people.sort((a, b) => b - a);

  while (leftIdx <= rightIdx) {
    if (people[leftIdx] + people[rightIdx] <= limit) {
      rightIdx--;
    }
    leftIdx++;
    answer++;
  }

  return answer;
}
```

### 오름차순 정렬 시

오름차순으로 정렬한다면 무게 제한이 초과하지 않을 때만 왼쪽 포인터를 올려주고, 오른쪽 포인터를 하나씩 계속 감소시킨다.

```JavaScript
function solution(people, limit) {
  let count = 0;
  let leftIdx = 0;
  let rightIdx = people.length - 1;

  people.sort((a, b) => a - b);

  while (leftIdx <= rightIdx) {
    if (people[leftIdx] + people[rightIdx] <= limit) {
      leftIdx++;
    }
    rightIdx--;
    count++;
  }

  return count;
}
```
