---
title: 자료구조 - 연결 리스트(Linked Lists)
date: 2021-02-07 09:00:00 +0900
categories: [data structure]
tags: [data structure]
---

> [프로그래머스 - 어서와! 자료구조와 알고리즘은 처음이지?](https://programmers.co.kr/learn/courses/57)를 공부하며 정리한 내용입니다.

# 7강. 연결 리스트(Linked Lists)

![Linked List(1)](/assets/images/2021/2021-02-07-Linked-List/linked-list(1).jpg)

`연결 리스트(Linked List)`는 선형 구조 리스트 한 종류이다. 연결 리스트는 `선형 리스트`와는 달리 순서가 차례대로 늘어서있는 것이 아니라, 앞에 있는 데이터가 뒤에 이어지는 데이터를 가리키는 형태로 구성되어있다.

## 선형 리스트와 비교

|항목|배열|연결 리스트|
|--|--|--|
|저장 공간|연속한 위치|임의의 위치|
|특정 원소 지칭|매우 간편 `O(1)`|선형 탐색과 비슷 `O(n)`|

## 연결 리스트의 구성

![Linked List(2)](/assets/images/2021/2021-02-07-Linked-List/linked-list(2).jpg)

연결 리스트에 포함된 각각의 아이템을 `노드(Node)`라고 한다. 노드에는 `데이터`와 다음 데이터를 가리키는 `링크`가 함께 들어있다. 노드 내의 데이터는 문자열, 레코드, 또 다른 연결 리스트(2차원 연결 리스트)가 될 수 있다.

![Linked List(3)](/assets/images/2021/2021-02-07-Linked-List/linked-list(3).jpg)


연결 리스트의 가장 맨 앞에 위치하는 아이템을 `헤드(Head)`라고 부르고, 맨 마지막에 위치한 아이템을 `테일(Tail)`, 꼬리라고 부른다.

# 추상적 자료구조 (Abstract Data Structures)

`추상적 자료구조`는 자료구조의 내부 구조를 숨기고, 외부에서는 아래의 2가지를 보여준다.

1. Data(데이터)
   - 정수, 문자열, 레코드 ...
2. A set of operations(연산)
   - 삽입, 삭제, 순회, 정렬, 탐색 ...

## 연산 정의

추상적 자료구조로 수행할 수 있는 연산을 자세히 나열하자면 다음과 같다.

1. 특정 원소 참조 (k번째)
2. 리스트 순회
3. 리스트 길이 구하기
4. 원소 삽입
5. 원소 삭제
6. 두 리스트 합치기

# 파이썬으로 연결 리스트 구현하기

## 노드 클래스

![Linked List(4)](/assets/images/2021/2021-02-07-Linked-List/linked-list(4).jpg)

``` python
class Node:
    def __init__(self,item):
        self.data = item
        self.next = None
```

노드 클래스를 구성하고, 생성자에는 기본적으로 `data`와 다음 노드를 가리키는 `next` 변수를 생성해준다. 이때, 처음 생성한 노드에는 다음 노드가 없기 때문에 기본적으로 `None`으로 설정을 해준다.

## 연결 리스트(Linked List) 클래스

![Linked List(5)](/assets/images/2021/2021-02-07-Linked-List/linked-list(5).jpg)

```Python
class LinkedList:
    def __init__(self):
        self.nodeCount = 0
        self.head = None
        self.tail = None
```

연결 리스트도 마찬가지로 처음에 빈 연결리스트를 만들고, `head`와 `tail`은 아무것도 가리키지 않도록 변수를 생성해준다.

## 특정 원소 참조

``` python
def getAt(self, pos):
    if pos <=0 or pos > self.nodeCount:
        return None
    i = 1
    curr = self.head
    while i < pos:
        curr = curr.next
        i += 1
    return curr
```
함수의 인자로 주어지는 `pos`는 `position`의 줄임말로, 이 함수는 특정 위치에 존재하는 원소를 찾기 위한 함수이다. 

![getAt(1)](/assets/images/2021/2021-02-07-Linked-List/getAt(1).png)

위와 같은 연결 리스트가 있다고 해보자. 

우선, 연결 리스트에서는 원소의 인덱스를 `0`이 아닌 `1`부터 사용한다. 이때, `0`은 다른 목적에 사용하기 위함이니 다음에 자세히 살펴보도록 하자.

`if pos <= 0 or pos > self.nodeCount` 조건을 보면,

1. 주어진 위치가 `0` 이하이거나, 
2. 주어진 위치가 노드의 개수를 초과할 때

로 해석할 수 있다. 즉, 연결 리스트 범위 내에서 존재하지 않는 인덱스를 참조하려고 하는 경우에는 `None`을 리턴해주는 것이다.

다음으로 위의 조건을 만족하는 연결 리스트 범위 내의 인덱스라면, 현재 인덱스를 `i = 1`로 설정해준다. 그러면 현재 `curr(current)` 변수는 연결 리스트의 처음인 노드이므로 `curr = self.head` 로 설정한다. 

![getAt(2)](/assets/images/2021/2021-02-07-Linked-List/getAt(2).png)

`while i < pos`는 탐색하고자 하는 인덱스 `pos`에 도달하기 전까지 반복문을 수행한다는 의미이다. 

그래서 인덱스 값이 `pos`에 도달하기 전까지는 `curr` 변수에 그 다음 노드 `curr.next`를 가리킨다.

![getAt(3)](/assets/images/2021/2021-02-07-Linked-List/getAt(3).png)

여기서 의아할 수 있는 점이, `next` 변수는 `Node` 클래스에 속해있는데, `LinkedList`의 변수인 `curr`가 어떻게 `Node` 클래스의 변수값을 가질 수 있냐는 것이다. 해당 강의를 듣는 다른 수강생들도 이 부분에 대해서 많이 궁금해하고, 이해하지 못해서 질문을 많이 올렸다.

하지만, 여기서는 **각 노드들은 서로 연결되어 있고, 하나의 연결 리스트로 구성되어 있다**고 가정하여 설명을 진행한다고 답변을 달아두었다. 각각의 클래스가 서로의 변수를 사용하려면 객체를 생성해야 하는데, 이러한 과정은 잠시 생략하고 이해해보자. 

아무튼 위와 같은 과정을 반복해서 원하는 위치의 인덱스를 찾아나갈 수 있을 것이다.

# 연습 문제 : 연결 리스트 순회

## 문제 설명

> 제 7 강에서 소개된 추상적 자료구조로 LinkedList 라는 이름의 클래스가 정의되어 있다고 가정하고, 이 리스트를 처음부터 끝까지 순회하는 메서드 traverse() 를 완성하세요.
> 메서드 traverse() 는 리스트를 리턴하되, 이 리스트에는 연결 리스트의 노드들에 들어 있는 데이터 아이템들을 연결 리스트에서의 순서와 같도록 포함합니다. 예를 들어, LinkedList L 에 들어 있는 노드들이 43 -> 85 -> 62 라면, 올바른 리턴 값은 [43, 85, 62] 입니다.
> 이 규칙을 적용하면, 빈 연결 리스트에 대한 순회 결과로 traverse() 메서드가 리턴해야 할 올바른 결과는 [] 입니다.
> [참고] 실행 을 눌렀을 때 통과하는 것은 아무 의미 없습니다.

## 나의 풀이

- 리스트의 처음부터 마지막까지 전부 탐색해야 한다.
- 현재 위치를 `curr`로 설정하고, 맨 처음 시작은 `head`부터 시작한다.
- 빈 연결 리스트가 아니거나, 모든 노드에 대한 탐색이 끝나면 `curr`에는 `None`이 담길 것이다.
- 따라서 반복문을 수행하며 현재 위치에 담긴 `data`를 리스트에 `append`하고, 현재 위치를 다음 노드를 가리키도록 한다.

``` python
class Node:
    def __init__(self, item):
        self.data = item
        self.next = None

class LinkedList:
    def __init__(self):
        self.nodeCount = 0
        self.head = None
        self.tail = None

    def getAt(self, pos):
        if pos < 1 or pos > self.nodeCount:
            return None
        i = 1
        curr = self.head
        while i < pos:
            curr = curr.next
            i += 1
        return curr

    def traverse(self):
        answer = []
        curr = self.head
        while curr != None:
            answer.append(curr.data)
            curr = curr.next
        return answer


# 이 solution 함수는 그대로 두어야 합니다.
def solution(x):
    return 0
```

사실 `getAt()` 메소드에서 `curr = curr.next`가 어떻게 성립 가능한 지 몰라서 한참을 헤맸었다. 그래서 다른 사람들의 풀이와 질문들을 먼저 살펴보면서 이해를 했다. 

노드끼리는 연결되어있다고 가정했다는 걸 미리 알려줬으면 조금 더 좋았을 것 같다는 아쉬움이 남는다.

## 다른 사람의 풀이

``` python
 def traverse(self):
        if self.nodeCount ==0:
            return []
        else: 
            answer = []
            current_node = self.head
            while current_node is not None:
                answer.append(current_node.data)
                current_node = current_node.next
            return answer
```

- `nodeCount`를 가장 먼저 파악해서, 빈 연결 리스트면 바로 빠져나올 수 있도록 작성하였다. 나머지는 비슷한 논리로 풀어나갔다. 

## 주의할 점

``` python
def traverse(self):
    answer = []
    i = 1
    while i <= self.nodeCount:
        answer.append(self.getAt(i))
    return answer
```

위와 같이 `getAt()` 메소드를 사용해서 하게 되면 시간복잡도는 $O(n^2)$으로 바뀐다. 

`while` 순환문의 반복 횟수는 리스트의 길이인 `n`과 같지만, 내부에서 실행되는 `getAt(i)`는 리스트의 처음부터 `i`번째 노드까지 링크를 따라가므로 `i`회 링크 따라가기 반복을 하기 때문이다. 