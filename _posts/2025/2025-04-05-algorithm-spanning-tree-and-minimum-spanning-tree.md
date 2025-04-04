---
title: "[알고리즘] 신장 트리와 최소 비용 신장 트리 (feat. 프림 알고리즘)"
date: 2025-04-05 08:30:00 +0900
categories: [Algorithm]
tags: []
---

# 신장 트리(Spnning tree)

신장 트리는 다음과 같은 조건을 만족하는 그래프를 의미한다.

1. 연결 그래프의 부분 그래프이며, 모든 노드를 포함한다.
2. 모든 노드가 적어도 하나의 간선에 연결되어 있다.
3. 사이클이 존재하지 않는다.

그래프에서 말하는 사이클이란 특정 노드에서 출발하여 다시 처음 출발했던 곳으로 되돌아 갈 수 있는 것을 의미한다.

예를 들어, 아래의 사진에서 노드 `a` 에서 출발하면 다시 `a` 로 돌아오는 것을 의미한다.

![1.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/1.png)

신장 트리는 연결 그래프의 일부분으로서, 여러 개가 존재할 수 있다.

![2.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/2.png)

위와 같은 연결 그래프가 있을 때, 신장 트리는 다음과 같이 여러 개로 존재할 수 있다.

![3.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/3.png)

> 💡 참고로 “신장 트리”는 ‘spanning tree’ 를 번역한 것이며, `span` 은 ‘뻗어나가다' 라는 의미를 가지고 있다. 이를 그래프에 적용하면 자기 자신으로 돌아오지 않고, 다른 노드로 쭉쭉 뻗어나간다는 의미로 “신장 트리"라고 부르는 것 같다.
>

# 최소 신장 트리(Minimum Spanning Tree)

최소 신장 트리는 트리를 구성하는 간선들의 가중치를 합한 값이 최소가 되는 신장 트리를 의미한다.

가중치는 거리, 시간, 비용 등으로 바꾸어서 해석할 수 있다.

최소 신장 트리는 모든 노드가 서로 연결되어 있으면서, 연결된 경로가 최소가 되도록 하는 문제에 많이 사용된다. 실생활에서는 다음과 같은 문제에 적용할 수 있다.

- 도로 건설 (도시를 모두 연결하고, 도로 길이는 최소로 하기)
- 전기 회로 (단자들을 모두 연결하고, 전선의 길이를 최소로 하기)
- 통신 (전화선의 길이가 최소가 되도록 전화 케이블 망을 구성하기)
- 배관 (파이프를 모두 연결하고, 파이프의 총 길이가 최소가 되도록 하기)

최소 신장 트리를 구하기 위해 사용하는 알고리즘은 대표적으로 **프림(Prim)** **알고리즘**과 **크루스칼(Kruskal) 알고리즘**이 있다.

두 알고리즘 모두 **그리디(greedy) 기법**으로 구현이 되어 있다. 그리디는 각 단계에서 최선의 선택이 최종적으로 최선의 결과가 아닐 수 있음에도 불구하고, 마지막까지 최선의 결과를 가지고 간다는 것을 전제한다. 그래서 근시안적으로 각 단계마다 최선의 선택을 하고, 장기적인 결과를 고려하지 않기 때문에 욕심쟁이 기법으로도 불린다.

## 프림 알고리즘(Prim algorithm)

프림 알고리즘은 하나의 노드를 선택하고, 다른 노드까지 도달하는 데 비용이 최소가 되는 노드를 선택해서 트리를 만든다.

다음과 같은 흐름으로 트리를 생성한다.

1. 임의의 노드를 선택해서 `T` 에 추가한다. (`T` 는 알고리즘을 수행하며 생성된 최소 신장 트리를 의미함)
2. `T` 에 포함된 노드와 `T` 에 포함되지 않은 노드 사이의 간선 중 가중치가 최소인 간선을 찾는다.
3. 간선에 연결된 두 노드 중에서 `T` 에 포함되지 않았던 노드를 `T` 에 추가한다.
4. 모든 노드가 `T` 에 포함될 때까지 2 ~ 3 과정을 반복한다.

아래와 같은 무방향 가중치 그래프가 있다고 해보자.

![4.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/4.png)

먼저 트리의 시작점을 노드 `a` 로 설정하고 `T` 에 추가한다.

![5.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/5.png)

노드 `a` 와 연결된 간선 중에서 가중치가 최소인 노드 `b` 와 연결된 간선(2)를 선택하고, 노드 `b` 를 `T` 에 추가한다.

![6.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/6.png)

`T` 에 포함된 노드 `a`, `b` 와 연결된 나머지 노드 사이에서 가중치가 가장 최소인 노드 `c` 를 연결한다.

![7.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/7.png)

`T` 에 포함된 노드 `a`, `b`, `c` 중에서 가중치가 최소인 간선은 4이다. `a <-> c` 와 `c <-> d` 가중치는 4로 모두 같은 상황인데, `a <-> c` 간선을 선택하면 다음과 같이 사이클이 발생한다.

![8.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/8.png)

따라서 사이클이 발생하지 않기 위해서 `c <-> d` 간선을 선택하고, 노드 `d` 를 `T` 에 추가한다.

![9.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/9.png)

다음으로 가중치가 가장 낮은 `d <-> e` 간선을 선택한다.

![10.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/10.png)

마지막으로 `e <-> f` 간선을 선택한다.

![11.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/11.png)

최종적으로 완성된 최소 신장 트리는 다음과 같다. 가중치의 합은 2 + 3 + 4  + 1 + 4 = 14 이다.

![12.png](/assets/images/2025/2025-04-05-algorithm-spanning-tree-and-minimum-spanning-tree/12.png)

# 참고 자료

- [[자료구조] 신장 트리, 최소 비용 신장 트리 (Spanning Tree)](https://choidev-1.tistory.com/139) [티스토리]
- [크루스칼 알고리즘(Kruskal Algorithm)](https://m.blog.naver.com/ndb796/221230994142) [네이버 블로그]
- [신장 트리와 최소 비용 신장 트리](https://kingpodo.tistory.com/49) [티스토리]
- [최소 신장 트리(프림 알고리즘)](https://kingpodo.tistory.com/50) [티스토리]
- [최소 신장 트리(크루스칼 알고리즘)](https://kingpodo.tistory.com/51) [티스토리]
- [프림 알고리즘 ( Prim's algorithm )](https://www.weeklyps.com/entry/%ED%94%84%EB%A6%BC-%EC%95%8C%EA%B3%A0%EB%A6%AC%EC%A6%98-Prims-algorithm) [티스토리]