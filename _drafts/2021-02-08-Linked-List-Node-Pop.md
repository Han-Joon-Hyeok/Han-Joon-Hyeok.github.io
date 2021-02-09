---
title: 자료구조 - 연결 리스트(Linked Lists) 노드 삭제
date: 2021-02-08 09:00:00 +0900
categories: [Data Structure]
tags: [Data Structure]
---

# 8강. 연결 리스트 노드 삭제하기

# 연습문제

> 제 8 강에서 소개된 추상적 자료구조 LinkedList 클래스의 메서드로서 popAt() 메서드를 강의 내용에 소개된 요구조건을 만족시키도록 구현하세요.
> 초기 코드로 들어 있는 것은 solution() 함수를 포함하여 다른 부분은 수정하지 말고, def popAt(self, pos): 의 메서드 몸체만 구현하세요.
> 만약, 인자로 주어진 pos 가 올바른 범위의 값을 가지지 않는 경우에는 IndexError exception 을 발생시키도록 합니다. 이렇게 하기 위한 코드는 raise IndexError 입니다.
> *** 2020년 3월 23일, 학습자의 질문에 답하면서 보니 특정한 경우의 정확성을 올바르게 검증하지 못하는 경우가 발견되어 테스트 케이스 4 번을 추가했습니다.

## 나의 풀이

케이스를 구분해서 접근해보았다.

1. 연결 리스트 길이가 1인 경우
   - 원소가 1개 존재하므로 `head = tail`이 된다. 
   - 따라서 `self.head.data`를 반환한다.
   - 그리고 `next`는 처음부터 존재하지 않았으므로, `head`와 `tail`만 `None`으로 바꿔준다.
2. 연결 리스트 길이가 2 이상인 경우
   1.  맨 앞의 원소인 경우
       - `curr`는 `self.head`이다. 
       - 따라서 `self.head.data`를 반환한다.
       - `self.head`는 그 다음 원소인 `curr.next`가 된다.
       - `curr.next`는 `None`가 된다.
   2. `2 ~ n`번째 원소인 경우
       - 함수를 최소한으로 사용하기 위해서 n번째가 아닌 n-1번째 원소를 구한다.
       - `prev = self.getAt(pos-1)`
      1. 마지막 원소인 경우
         - `curr = prev.next`
         - `self.tail`은 n-1번째 원소인 `prev`가 되어야 한다. `self.tail = prev`
         - 그리고 `prev`가 마지막 원소가 되므로 `prev.next = None`이다.
      2.  `2 ~ n-1` 번째 원소인 경우
        - `curr = self.getAt(pos)`
        - 이전 원소의 `next`와 현재 원소의 `next`만 변경해주면 된다.
        - `prev.next = curr.next`

다소 복잡하게 접근했지만, 결국 풀긴 풀었다.

``` python
def popAt(self, pos):
    if pos < 1 or pos > self.nodeCount:
            raise IndexError
            
    if self.nodeCount == 1: # 연결 리스트 길이가 1인 경우
        answer = self.head.data
        self.tail = None
        self.head = None
    else: # 연결 리스트 길이가 2 이상인 경우
        if pos == 1: # 맨 앞의 노드인 경우
            curr = self.head
            answer = curr.data
            self.head = curr.next
            curr.next = None
        else:   # 2번째 ~ 마지막 노드
            prev = self.getAt(pos-1)
            curr = prev.next
            answer = curr.data
            if pos == self.nodeCount: # 마지막 노드인 경우
                self.tail = prev
                prev.next = None
            else: # 2번째 ~ n-1번째 노드인 경우
                prev.next = curr.next
            
        curr = None
        self.nodeCount -= 1
        return answer

```

## 다른 사람의 풀이

``` python
def popAt(self, pos):
        if pos < 1 or pos > self.nodeCount:
            raise IndexError
        if pos == 1:
            curr = self.head
            self.head = curr.next
            if self.nodeCount == 1:
                self.tail = self.head
        else:
            prev = self.getAt(pos-1)
            curr = prev.next
            prev.next = curr.next
            if pos == self.nodeCount:
                self.tail = prev
        self.nodeCount -= 1
        return curr.data
```

### 1. 첫 번째 원소인 경우

- 반환하는 값은 `curr = self.head`의 `data`이다.
- 마찬가지로 `self.head`만 다음 원소인 `curr.next`로 지정한다.
- 만약 길이가 1인 연결 리스트인 경우에는, `self.head = self.tail` 상태가 된다.

### 2. 두 번째 이후 원소인 경우

- 맨 마지막 원소를 찾기 위해서는 `pos`로 주어진 원소를 찾으면 이전 원소에 대한 정보를 얻을 수 없다.
- 따라서 n-1번째를 구하기 위해 `prev = getAt(pos-1)`로 설정한다. 
- 그러면 마지막 원소도 자연스럽게 `curr = prev.next`로 구할 수 있다.
- 만약 마지막 원소일 경우에는 `self.tail`이 n-1번째인 `prev`로 설정한다.