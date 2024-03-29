---
title: 프로그래머스 Level 2 - 점프와 순간이동 (JavaScript)
date: 2022-05-04 12:30:00 +0900
categories: [programmers]
tags: [level2, programmers, JavaScript]
use_math: true
---

> [프로그래머스 - Level2 점프와 순간 이동](https://programmers.co.kr/learn/courses/30/lessons/12980?language=javascript)

# 문제 설명

OO 연구소는 한 번에 K 칸을 앞으로 점프하거나, (현재까지 온 거리) x 2 에 해당하는 위치로 순간이동을 할 수 있는 특수한 기능을 가진 아이언 슈트를 개발하여 판매하고 있습니다. 이 아이언 슈트는 건전지로 작동되는데, 순간이동을 하면 건전지 사용량이 줄지 않지만, 앞으로 K 칸을 점프하면 K 만큼의 건전지 사용량이 듭니다. 그러므로 아이언 슈트를 착용하고 이동할 때는 순간 이동을 하는 것이 더 효율적입니다. 아이언 슈트 구매자는 아이언 슈트를 착용하고 거리가 N 만큼 떨어져 있는 장소로 가려고 합니다. 단, 건전지 사용량을 줄이기 위해 점프로 이동하는 것은 최소로 하려고 합니다. 아이언 슈트 구매자가 이동하려는 거리 N이 주어졌을 때, 사용해야 하는 건전지 사용량의 최솟값을 return하는 solution 함수를 만들어 주세요.

예를 들어 거리가 5만큼 떨어져 있는 장소로 가려고 합니다.아이언 슈트를 입고 거리가 5만큼 떨어져 있는 장소로 갈 수 있는 경우의 수는 여러 가지입니다.

- 처음 위치 0 에서 5 칸을 앞으로 점프하면 바로 도착하지만, 건전지 사용량이 5 만큼 듭니다.
- 처음 위치 0 에서 2 칸을 앞으로 점프한 다음 순간이동 하면 (현재까지 온 거리 : 2) x 2에 해당하는 위치로 이동할 수 있으므로 위치 4로 이동합니다. 이때 1 칸을 앞으로 점프하면 도착하므로 건전지 사용량이 3 만큼 듭니다.
- 처음 위치 0 에서 1 칸을 앞으로 점프한 다음 순간이동 하면 (현재까지 온 거리 : 1) x 2에 해당하는 위치로 이동할 수 있으므로 위치 2로 이동됩니다. 이때 다시 순간이동 하면 (현재까지 온 거리 : 2) x 2 만큼 이동할 수 있으므로 위치 4로 이동합니다. 이때 1 칸을 앞으로 점프하면 도착하므로 건전지 사용량이 2 만큼 듭니다.

위의 3가지 경우 거리가 5만큼 떨어져 있는 장소로 가기 위해서 3번째 경우가 건전지 사용량이 가장 적으므로 답은 2가 됩니다.

## 제한사항

- 숫자 N: 1 이상 10억 이하의 자연수
- 숫자 K: 1 이상의 자연수

# 🙋‍♂️나의 풀이

## 🤔문제 접근

처음에는 DFS 나 BFS 와 같은 탐색 문제으로 접근했으나, 제한 조건에 N 이 10 억 이하의 자연수라는 조건이 있어서 다른 분들의 해결방법을 참고해서 풀었다.

순간이동을 할 때는 건전지 사용량이 0 이기 때문에 순간이동을 많이 이용해야 건전지 사용량을 최소화 할 수 있다.

순간이동을 사용하면 (현재까지 온 거리) \* 2 만큼 이동할 수 있다. 그렇다면, 목적지를 2로 나누었을 때 나머지가 0 으로 나누어 떨어진다면 순간이동을 사용할 수 있다고 생각할 수 있다.

만약 N = 100 이라고 했을 때, 100 까지 도달하기 위해서는 0에서 어떻게든 50 까지 도달하면 된다. 50 에서는 순간이동을 해서 이동하면 되기 때문이다.

그리고 50 에 도달하기 위해서는 어떻게든 25 에 도달하면 된다.

하지만, 25 를 2 로 나누면 나머지가 0 으로 나누어 떨어지지 않는다. 그렇다면, 이 경우에는 24 까지 도달하고, **24 에서 1** 만큼 점프해서 25 에 도달했다고 생각하면 된다.

그렇다면 24 에 오기 위해서는 12 까지 오면 되고, 12 에 오기 위해서는 6 까지, 6 에 오기 위해서는 3 까지 오면 된다.

그리고 다시 3 에서는 2 로 나누어 떨어지지 않으므로 **2 에서는 3 까지** 점프를 1번 더 해서 도달하면 된다. 2 는 1 만큼, 그리고 **0에서 1까지**는 점프를 1번 \*\*\*\*해야 한다.

따라서 N = 100 이면 최소 3번의 점프를 사용하면 원하는 목적지에 도달할 수 있게 되는 것이다.

정리하자면, N 을 2로 나누었을 때 홀수라면 건전지를 1번 사용해서 짝수로 만들어주고, 그렇지 않으면 그대로 나누어주면 된다. 이 과정을 N 이 0이 될 때까지 반복하면 된다.

## ✍️작성 코드

```javascript
function solution(n) {
  let answer = 0;

  while (n !== 0) {
    if (Number.isInteger(n / 2)) {
      n /= 2;
    } else {
      n -= 1;
      answer += 1;
    }
  }

  return answer;
}
```

# 👀참고한 풀이

```javascript
function solution(n) {
  let len = n.toString(2);
  let count = 0;
  for (let x of len) {
    if (x === "1") count++;
  }
  return count;
}
```

N 을 2진법으로 만들고, 1의 개수를 세면 점프한 횟수와 동일하다는 것을 이용한 코드이다.

다음의 문제 조건이 2진법을 사용해도 풀이가 가능하도록 했다.

1. 현재 위치에서 (현재 위치 + 1) 로 이동하기 위해서는 1 비용이 든다.
2. 현재 위치에서 (현재 위치 \* 2) 로 이동하기 위해서는 0 비용이 든다.

N = 10 이라고 했을 때, 0 부터 시작한다고 해보자.

- **0(0) 에서 1(1) 으로 이동하기 위해 비용은 1 이 든다. (cost = 1)**
- 1(1)에서 2(10)으로 이동하기 위해 비용은 0 이 든다. (cost = 1)
- 2(10)에서 4(100)로 이동하기 위해 비용은 0 이 든다. (cost = 1)
- **4(100)에서 5(101)로 이동하기 위해 비용은 1 이 든다. (cost = 2)**
- 5(101)에서 10(1010)으로 이동하기 위해 비용은 0 이 든다. (cost = 2)

10진법 정수를 1 만큼 증가 시키기 위해서는 2진법 상으로 맨 마지막 자리를 1 로 증가 시켜주어야 한다. 그리고 10진법 정수를 2 배 증가 시키기 위해서는 2진법 상으로 0을 맨 오른쪽에 붙여주면 된다.

이와 같은 2진법의 연산 특징 때문에 N 을 2진법으로 나타냈을 때, 1 의 개수가 건전지를 사용한 횟수가 될 수 있는 것이다.

# 참고자료

- [[java] 프로그래머스 (점프와 순간 이동) Level 2](https://gre-eny.tistory.com/121) [티스토리]
