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