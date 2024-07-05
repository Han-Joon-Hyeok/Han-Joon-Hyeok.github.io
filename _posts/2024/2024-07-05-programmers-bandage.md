---
title: "프로그래머스 Level 1 - [PCCP 기출문제] 1번 / 붕대 감기 (Java)"
date: 2024-07-05 16:40:00 +0900
categories: [programmers]
tags: [level1, programmers, Java]
use_math: true
---

> [프로그래머스 - Level1 [PCCP 기출문제] 1번 / 붕대 감기](https://school.programmers.co.kr/learn/courses/30/lessons/250137)
>

# 문제 설명

문제 설명 생략

# 🙋‍♂️나의 풀이

## 🤔문제 접근

- `attacks` 2중 배열의 맨 마지막 원소에는 마지막으로 공격하는 시간에 대한 정보를 얻을 수 있다.
- 반복문을 이용해서 1초부터 마지막 공격 시간까지 현재 시간을 1초씩 증가시킨다.
    - 매 초마다 몬스터의 공격 여부를 확인하고, 현재 체력을 업데이트한다.
    - 체력이 0 이하가 되면 -1 을 반환한다.
- `attacks` 는 2중 배열이기 때문에 편리하게 순회할 수 있도록 해당 배열의 데이터를 큐로 옮겼다. 그러면 매 초마다 맨 앞에 있는 원소만 확인하면 되는 편리함이 있다.

## ✍️작성 코드

```java
import java.util.Queue;
import java.util.LinkedList;
import java.util.Arrays;

class Solution {
    public int solution(int[] bandage, int health, int[][] attacks) {
        int consecutiveRecovery = 0;
        int initialHealth = health;
        int duration = bandage[0];
        int recovery = bandage[1];
        int bonusRecovery = bandage[2];
        int time = attacks[attacks.length - 1][0];
        Queue<int[]> queue = new LinkedList<>();

        for (int[] attack : attacks) {
            queue.add(attack);
        }

        for (int t = 1; t <= time; t++) {
            int attackTime = queue.peek()[0];
            int attackAmount = queue.peek()[1];

            if (attackTime == t) {
                health -= attackAmount;
                consecutiveRecovery = 0;
                queue.remove();
            } else {
                consecutiveRecovery += 1;
                health += recovery;
                if (consecutiveRecovery == duration) {
                    health += bonusRecovery;
                    consecutiveRecovery = 0;
                }
            }

            if (health > initialHealth) {
                health = initialHealth;
            }

            if (health <= 0) {
                return -1;
            }
        }

        return health;
    }
}
```

# 👀참고한 풀이

```java
class Solution {

    public int solution(int[] bandage, int health, int[][] attacks) {
        int cnt = bandage[0]; // 추가 체력 기준
        int now = health; // 현재 체력
        int std = 0; // 마지막으로 공격당한 시간

        int v1, v2; // 추가 체력 받을 수 있나?
        for (int[] atk: attacks) {
            if (now <= 0) {
                return -1;
            }

            v1 = atk[0] - std - 1; // 시간 차이
            v2 = v1 / cnt; // 추가 체력 회수

            // 맞기 직전까지의 체력 정산
            std = atk[0];
            now = Math.min(health, now + (v1 * bandage[1]));
            now = Math.min(health, now + (v2 * bandage[2]));

            now -= atk[1];
        }

        return now <= 0 ? -1 : now;
    }
}
```

- 시간을 1초씩 증가시키지 않고 `attacks` 의 배열만 순회하는 방법이다.
- 이 방법을 이용하면 반복문이 기존 방법보다 훨씬 빨리 끝나는 장점이 있다.
- `v1` 변수는 마지막 공격 받은 시점부터 이번에 공격 받은 시점의 시간 차이를 의미한다. 이를 이용하면 그 사이에 회복해야 하는 양을 쉽게 구할 수 있다.
- `v2` 변수는 마지막 공격 받은 시점부터 이번에 공격 받은 시점 시간 사이에 추가 회복양을 받을 수 있는 횟수를 의미한다.