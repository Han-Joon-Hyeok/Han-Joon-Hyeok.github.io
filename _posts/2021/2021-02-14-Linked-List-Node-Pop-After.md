---
title: 자료구조 - dummy head를 가지는 연결 리스트(Linked Lists) 노드 삭제
date: 2021-02-14 14:54:00 +0900
categories: [data structure]
tags: [data structure]
---

> [프로그래머스 - 어서와! 자료구조와 알고리즘은 처음이지?](https://programmers.co.kr/learn/courses/57)를 공부하며 정리한 내용입니다.

# 9강. dummy head를 가지는 연결 리스트 노드 삭제

# 연습문제

> 제 9 강에서 소개된 추상적 자료구조 LinkedList 는 dummy head node 를 가지는 연결 리스트입니다. 이 클래스의 아래와 같은 메서드들을, 강의 내용에 소개된 요구조건을 만족시키도록 구현하세요.
> ``` python
> popAfter()
> popAt()
> ```
> 이 때, popAt() 메서드의 구현에서는 popAfter() 를 호출하여 이용하도록 합니다. (그렇게 하지 않을 수도 있지만, 여기에서는 popAfter() 의 이용에 의해서 코드 구현이 보다 쉬워지는 것을 확인하기 위함입니다.)
> 초기 코드로 들어 있는 것은 solution() 함수를 포함하여 다른 부분은 수정하지 말고, def popAfter(self, prev): 와 def popAt(self, pos): 의 메서드 몸체만 구현하세요.
> 만약, popAt() 메서드에 인자로 주어진 pos 가 올바른 범위의 값을 가지지 않는 경우에는 IndexError exception 을 발생시키도록 합니다. 이렇게 하기 위한 코드는 raise IndexError 입니다.

## 나의 풀이

``` python
def popAfter(self, prev):
        # prev가 마지막 노드일 경우, 삭제할 다음 노드 자체가 없으므로 반환값은 None
        if prev.next == None:
            return None
        else:
            curr = prev.next
            answer = curr.data
            # 삭제하는 노드가 리스트의 맨 마지막 노드인 경우, tail을 prev로 조정
            if curr.next == None:
                self.tail = prev
                prev.next = None
            # 그 외의 경우
            else:
                prev.next = curr.next
        
        self.nodeCount -= 1
        curr = None
        return answer

    def popAt(self, pos):
        if pos < 1 or pos > self.nodeCount:
            raise IndexError
        else:
            prev = self.getAt(pos-1)
            return self.popAfter(prev)
```

### 피드백
- 3~4번 테스트 케이스가 자꾸 런타임 에러가 났는데, `class` 내부의 함수를 호출할 때 `self.함수명`이 아닌 `함수명`으로만 호출을 한 것이 원인이었다.
    - `prev = getAt(pos-1)`이 아니라 `prev = self.getAt(pos-1)`로 작성해야 한다.
- `popAt` 함수의 예외사항 조건에 `pos > self.nodeCount+1`이라고 생각했다. `popAfter` 함수에서 `prev가 마지막 노드`인 경우는 `self.nodeCount`가 `n+1`이라고 생각했기 때문이다. 하지만, `popAfter`는 `pos+1`번째 노드를 삭제하는 것이므로, `self.nodeCount`보다 큰 `pos`를 받아도 삭제할 `pos+1`번째 노드는 존재하지 않는다.
  - 그리고 `popAfter`의 아래 코드를 삭제해서 실행해도 정답으로 인정이 되었다.
   ``` python
    # prev가 마지막 노드일 경우, 삭제할 다음 노드 자체가 없으므로 반환값은 None
        if prev.next == None:
            return None
   ```
   - `prev`가 마지막 노드로 주어지는 경우(`pos+1`)는 아예 `popAt` 예외조건에서 걸러지므로, 어떠한 경우에도 실행되지 않기 때문이다.

### 개선한 정답

``` python
def popAfter(self, prev):
        # prev가 맨 마지막 노드인 경우를 고려 X
        curr = prev.next
        answer = curr.data

        # 삭제하는 노드가 리스트의 맨 마지막 노드인 경우, tail을 prev로 조정
        if curr.next == None:
            self.tail = prev
            prev.next = None
        # 그 외의 경우
        else:
            prev.next = curr.next
        
        self.nodeCount -= 1
        curr = None
        return answer

    def popAt(self, pos):
        if pos < 1 or pos > self.nodeCount:
            raise IndexError
        else:
            prev = self.getAt(pos-1)
            return self.popAfter(prev)
```

`popAfter`를 prev가 맨 마지막 노드인 경우에 사용할 수 있는지는 모르겠지만, 위와 같이 수정해도 정답은 인정되었다.

## 다른 사람의 풀이

``` python
def popAfter(self, prev):
        if prev == self.tail:
            return None
        curr = prev.next
        prev.next = curr.next
        if curr.next == None:
            self.tail = prev
        self.nodeCount -= 1
        return curr.data


    def popAt(self, pos):
        if pos < 1 or pos > self.nodeCount:
            raise IndexError
        return self.popAfter(self.getAt(pos-1))
```

### 1. `popAfter(self, prev)`

1. `prev`가 맨 마지막 노드인 경우 `None`을 리턴한다.
2. `prev.next = curr.next`를 먼저 설정한다. `curr`이 맨 마지막 노드인 경우에도 `curr.next = None`이므로 따로 `prev.next = None`으로 설정할 필요가 없는 것이다.

### 2. `popAt(self, pos)`

`popAfter`의 인자로 주어지는 `prev` 변수를 따로 사용하지 않고, 함수의 리턴값을 그대로 인자로 넘겨줌으로써 간결하게 코드를 작성하였다.

``` python
return self.popAfter(self.getAt(pos-1))
```