---
title: 프로그래머스 Level 2 - 124 나라의 숫자 (JavaScript)
date: 2021-11-28 23:40:00 +0900
categories: [programmers]
tags: [level2, programmers, javascript]
use_math: true
---

> [프로그래머스 - Level2 다리를 지나는 트럭](https://programmers.co.kr/learn/courses/30/lessons/42583)

# 문제 설명

---

트럭 여러 대가 강을 가로지르는 일차선 다리를 정해진 순으로 건너려 합니다. 모든 트럭이 다리를 건너려면 최소 몇 초가 걸리는지 알아내야 합니다. 다리에는 트럭이 최대 bridge_length대 올라갈 수 있으며, 다리는 weight 이하까지의 무게를 견딜 수 있습니다. 단, 다리에 완전히 오르지 않은 트럭의 무게는 무시합니다.

예를 들어, 트럭 2대가 올라갈 수 있고 무게를 10kg까지 견디는 다리가 있습니다. 무게가 [7, 4, 5, 6]kg인 트럭이 순서대로 최단 시간 안에 다리를 건너려면 다음과 같이 건너야 합니다.

(예시 생략)

따라서, 모든 트럭이 다리를 지나려면 최소 8초가 걸립니다.

solution 함수의 매개변수로 다리에 올라갈 수 있는 트럭 수 bridge_length, 다리가 견딜 수 있는 무게 weight, 트럭 별 무게 truck_weights가 주어집니다. 이때 모든 트럭이 다리를 건너려면 최소 몇 초가 걸리는지 return 하도록 solution 함수를 완성하세요.

## 제한사항

- bridge_length는 1 이상 10,000 이하입니다.
- weight는 1 이상 10,000 이하입니다.
- truck_weights의 길이는 1 이상 10,000 이하입니다.
- 모든 트럭의 무게는 1 이상 weight 이하입니다.

## 🙋‍♂️나의 풀이

도저히 감이 안와서 다른 분들의 풀이를 참고했다.

### 작성 코드

```javascript
function solution(bridge_length, weight, truck_weights) {
  const bridge = Array(bridge_length).fill(0);
  let totalElapsedTime = 0;
  let currentBridgeWeights = 0;

  while (truck_weights.length) {
    currentBridgeWeights -= bridge.pop();

    const currentTruck = truck_weights[0];
    if (currentBridgeWeights + currentTruck <= weight) {
      bridge.unshift(truck_weights.shift());
      currentBridgeWeights += currentTruck;
    } else {
      bridge.unshift(0);
    }

    totalElapsedTime++;
  }

  return totalElapsedTime + bridge.length;
}
```

- 배열에 다리의 길이 만큼 0을 채우고, 맨 뒤에서 하나를 빼면, 맨 앞에서 하나를 추가하는 식으로 구현했다.
- 다리의 최대 하중을 넘지 않으면 대기하고 있는 트럭을 배열에 넣고, 반대의 경우에는 0을 넣는다.
- 대기하고 있던 트럭이 모두 올라간 상태라면, 즉 마지막 트럭이 올라간 상태라면 그동안의 경과 시간에 다리의 길이만큼 더한 값을 반환한다.

## 👀참고한 풀이

```javascript
function solution(bridge_length, weight, truck_weights) {
  // '다리'를 모방한 큐에 간단한 배열로 정리 : [트럭무게, 얘가 나갈 시간].
  let time = 0,
    qu = [[0, 0]],
    weightOnBridge = 0;

  // 대기 트럭, 다리를 건너는 트럭이 모두 0일 때 까지 다음 루프 반복
  while (qu.length > 0 || truck_weights.length > 0) {
    // 1. 현재 시간이, 큐 맨 앞의 차의 '나갈 시간'과 같다면 내보내주고,
    //    다리 위 트럭 무게 합에서 빼준다.
    if (qu[0][1] === time) weightOnBridge -= qu.shift()[0];

    if (weightOnBridge + truck_weights[0] <= weight) {
      // 2. 다리 위 트럭 무게 합 + 대기중인 트럭의 첫 무게가 감당 무게 이하면
      //    다리 위 트럭 무게 업데이트, 큐 뒤에 [트럭무게, 이 트럭이 나갈 시간] 추가.
      weightOnBridge += truck_weights[0];
      qu.push([truck_weights.shift(), time + bridge_length]);
    } else {
      // 3. 다음 트럭이 못올라오는 상황이면 얼른 큐의
      //    첫번째 트럭이 빠지도록 그 시간으로 점프한다.
      //    참고: if 밖에서 1 더하기 때문에 -1 해줌
      if (qu[0]) time = qu[0][1] - 1;
    }
    // 시간 업데이트 해준다.
    time++;
  }
  return time;
}
```

- 트럭 무게와 트럭이 빠져 나가는 시간을 배열에 함께 저장함으로써 다리 위에 트럭이 꽉 찬 경우에는 시간을 빠르게 뛰어 넘을 수 있도록 했다. 다른 코드보다 훨씬 빠른 성능을 보여주고 있다.
