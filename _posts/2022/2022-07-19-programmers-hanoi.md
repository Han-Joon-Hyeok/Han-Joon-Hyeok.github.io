---
title: 프로그래머스 Level 2 - 하노이의 탑 (JavaScript)
date: 2022-07-19 11:00:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 하노이의 탑](https://school.programmers.co.kr/learn/courses/30/lessons/12946)

# 문제 설명

하노이 탑(Tower of Hanoi)은 퍼즐의 일종입니다. 세 개의 기둥과 이 기동에 꽂을 수 있는 크기가 다양한 원판들이 있고, 퍼즐을 시작하기 전에는 한 기둥에 원판들이 작은 것이 위에 있도록 순서대로 쌓여 있습니다. 게임의 목적은 다음 두 가지 조건을 만족시키면서, 한 기둥에 꽂힌 원판들을 그 순서 그대로 다른 기둥으로 옮겨서 다시 쌓는 것입니다.

1. 한 번에 하나의 원판만 옮길 수 있습니다.
2. 큰 원판이 작은 원판 위에 있어서는 안됩니다.

하노이 탑의 세 개의 기둥을 왼쪽 부터 1번, 2번, 3번이라고 하겠습니다. 1번에는 n개의 원판이 있고 이 n개의 원판을 3번 원판으로 최소 횟수로 옮기려고 합니다.

1번 기둥에 있는 원판의 개수 n이 매개변수로 주어질 때, n개의 원판을 3번 원판으로 최소로 옮기는 방법을 return하는 solution를 완성해주세요.

## 제한사항

• n은 15이하의 자연수 입니다.

# 🙋‍♂️나의 풀이

## 🤔문제 접근

재귀를 사용하는 문제이다.

핵심적인 접근은 다음의 그림과 같다.

![hanoi.drawio.png](/assets/images/2022/2022-07-19-programmers-hanoi/hanoi.drawio.png)

큰 원판은 작은 원판보다 반드시 아래에 있어야 한다는 조건 때문에 작은 원판들은 출발지(from)에서 목적지(to)로 향할 때 반드시 경유지(by)가 있어야 한다.

이는 원판이 2개인 상황을 보면 쉽게 이해할 수 있다.

![hanoi.drawio (1).png](</assets/images/2022/2022-07-19-programmers-hanoi/hanoi.drawio%20(1).png>)

알고리즘은 다음과 같이 작동한다.

1. 남은 원판이 1개면 목적지에 옮긴다. (종료 조건)
2. 남은 원판이 N개 이면
   1. 1번 기둥에 남은 `N`개 중 `N-1`개를 2번 기둥에 옮긴다. (3번 기둥을 보조 기둥으로 사용)
   2. 1번 기둥에 남은 가장 큰 원판을 3번 기둥에 옮긴다.
   3. 2번 기둥에 남은 `N-1`개의 원판들을 3번 기둥에 옮긴다. (1번 기둥을 보조 기둥으로 사용)

의사 코드를 작성하면 다음과 같다.

```c
hanoi(n, from, to, by)
{
	if (n == 1)
	{
		move(from, to);
		return ;
	}
	hanoi(n - 1, from, by, to);
	move(from, to);
	hanoi(n - 1, by, to, from);
}
```

`move` 함수는 출발지에서 도착지로 원판을 옮겨주는 함수라 가정한다.

`n = 2` 인 경우에는 다음과 같이 작동할 것이다.

```c
hanoi(2, 1, 3, 2);		// 함수 시작
	hanoi(1, 1, 2, 3);
		 move(1, 2);	// 1번 기둥에서 2번 기둥으로 이동
	move(1, 3);		// 1번 기둥에서 3번 기둥으로 이동
	hanoi(1, 2, 3, 1);
		 move(2, 3)	// 2번 기둥에서 3번 기둥으로 이동
```

## ✍️작성 코드

```javascript
function solution(n) {
  const answer = [];
  const hanoi = (n, from, to, by) => {
    if (n === 1) {
      answer.push([from, to]);
      return;
    }
    hanoi(n - 1, from, by, to);
    answer.push([from, to]);
    hanoi(n - 1, by, to, from);
  };
  hanoi(n, 1, 3, 2);
  return answer;
}
```

# 참고자료

- [하노이탑 알고리즘](https://brunch.co.kr/@younggiseo/139) [브런치]
