---
title: "C언어 서로 다른 구조체 포인터 캐스팅의 원리"
date: 2025-08-06 16:30:00 +0900
categories: [c]
tags: []
use_math: true
---

# 개요

C언어에서 서로 다른 구조체 포인터를 캐스팅할 때의 작동 원리를 정리한다.

이를 통해 C에서도 구조체 레이아웃을 이용해 객체 지향 언어의 ‘업캐스팅’과 유사한 동작을 구현할 수 있음을 확인할 수 있다.

# 분석 대상 코드

## 구조체 정의

서로 다른 멤버를 가진 구조체가 있다고 하자.

```c
typedef struct parent_s {
    struct parent_s *prev;
    struct parent_s *next;
} parent_t;

typedef struct child_s {
    struct child_s *prev;
    struct child_s *next;
    int data; // parent_t 구조체에는 존재하지 않음
} child_t;
```

## 캐스팅 시도 코드

아래 코드는 `child_t*`를 `parent_t*`로 캐스팅한 뒤 포인터 멤버 값을 출력한다.

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    child_t child;

    // child_t 초기화
    child.prev = NULL;
    child.next = calloc(1, sizeof(child_t));
    child.data = 10;

    child.next->prev = &child;
    child.next->next = NULL;
    child.next->data = 20;

    printf("=== 원본 child ===\n");
    printf("child.prev = %p\n", (void*)child.prev);
    printf("child.next = %p\n", (void*)child.next);
    printf("child.data = %d\n", child.data);
    printf("child.next->data = %d\n", child.next->data);

    // child_t를 parent_t 포인터로 캐스팅
    parent_t *parent_ptr = (parent_t *)&child;
    printf("\n=== 1단계: child_t -> parent_t 캐스팅 ===\n");
    printf("parent_ptr->prev = %p\n", (void*)parent_ptr->prev);
    printf("parent_ptr->next = %p\n", (void*)parent_ptr->next);

    return 0;
}
```

## 실행 결과

```
=== 원본 child_t ===
child.prev = (nil)
child.next = 0x57722c1732a0
child.data = 10
child.next->data = 20

=== child_t-> parent_t 캐스팅 ===
parent_ptr->prev = (nil)
parent_ptr->next = 0x57722c1732a0
```

`child.next` 와 `parent_ptr→next` 의 주소값이 동일함을 통해, 서로 다른 구조체 포인터 간 캐스팅이 동작했음을 확인할 수 있다.

# 작동 원리 분석

이 동작이 가능한 이유는 **두 구조체의 앞부분 메모리 레이아웃이 동일**하기 때문이다.

64비트 시스템 기준으로 포인터는 8바이트 크기를 갖는다.

```c
typedef struct parent_s {
    struct parent_s *prev; // 8바이트
    struct parent_s *next; // 8바이트
} parent_t;

typedef struct child_s {
    struct child_s *prev; // 8바이트
    struct child_s *next; // 8바이트
    int data; // 4바이트
} child_t;
```

메모리 배치의 앞부분 16바이트가 `child_t` 와 `parent_t` 가 서로 동일하다.

```
[child_t 메모리]
 ┌───────────┬───────────┬───────
 │ prev(ptr) │ next(ptr) │ data  │
 │   8Byte   │   8Byte   │ 4Byte │
 └───────────┴───────────┴───────

[parent_t 메모리]
 ┌───────────┬───────────
 │ prev(ptr) │ next(ptr) │
 │   8Byte   │   8Byte   │
 └───────────┴───────────
```

- 앞 16바이트(`prev`와 `next`)가 동일하므로 캐스팅 후에도 포인터 접근이 정상 동작
- 원본 메모리는 그대로 유지되므로 주소값이 일치함

# C++의 업캐스팅과 비교

C언어의 구조체 상속 기법은 C++의 업캐스팅과 유사하다.

```cpp
#include <iostream>
using namespace std;

// 부모 클래스
class Parent {
public:
    Parent* prev;
    Parent* next;

    Parent() : prev(nullptr), next(nullptr) {}

    void link(Parent* p) {
        this->next = p;
        if (p) p->prev = this;
    }
};

// 자식 클래스
class Child : public Parent {  // 상속
public:
    int data;

    Child(int d = 0) : Parent(), data(d) {}

    void printData() {
        cout << "Child data: " << data << endl;
    }
};

int main() {
    Child c1(42);          // data = 42
    Child* childPtr = &c1; // 원래 포인터
    Parent* parentPtr = childPtr; // 업캐스팅

    // 포인터 주소 출력
    cout << "Child pointer (Child*):  " << (void*)childPtr << endl;
    cout << "Parent pointer (Parent*): " << (void*)parentPtr << endl;

    // 데이터 접근 비교
    cout << "Child data via Child*:  " << childPtr->data << endl;
    cout << "Child data via Parent*: "
         << ((Child*)parentPtr)->data << endl; // 다운캐스팅 후 접근

    // 포인터 멤버 prev/next 비교
    parentPtr->prev = nullptr;
    parentPtr->next = nullptr;
    cout << "prev pointer via Child*:  " << (void*)childPtr->prev << endl;
    cout << "prev pointer via Parent*: " << (void*)parentPtr->prev << endl;
}
```

출력 시 `Child*`와 `Parent*` 주소가 동일하게 나타난다.

```
Child pointer (Child*):  0x7ffee8d3a8b0
Parent pointer (Parent*): 0x7ffee8d3a8b0
Child data via Child*:  42
Child data via Parent*: 42
prev pointer via Child*:  0x0
prev pointer via Parent*: 0x0
```

두 언어에서 상속을 하는 방법과 특징을 정리하면 아래와 같다.

| 언어 | 방법 | 특징 |
| --- | --- | --- |
| C | 구조체 포인터 캐스팅 | 메모리 레이아웃 동일 시 안전 |
| C++ | 상속 + 업캐스팅 | 타입 호환을 컴파일러가 보장 |

# 다운캐스팅

마찬가지로 C 구조체를 이용해 다운캐스팅도 가능하다. 업캐스팅한 포인터를 다시 원래 구조체 타입으로 변환하면, 동일한 메모리 영역을 참조하므로 원래 값이 그대로 유지된다.

```cpp
int main() {
    child_t child;

    // child_t 초기화
    child.prev = NULL;
    child.next = calloc(1, sizeof(child_t));
    child.data = 10;

    child.next->prev = &child;
    child.next->next = NULL;
    child.next->data = 20;

    // child_t를 parent_t 포인터로 캐스팅
    parent_t *parent_ptr = (parent_t *)&child;

    // parent_t 포인터를 다시 child_t 포인터로 캐스팅
    child_t *child_ptr = (child_t *)parent_ptr;
    printf("\n=== parent_t -> child_t 다운캐스팅 ===\n");
    printf("child_ptr->data = %d\n", child_ptr->data);
    printf("child_ptr->next->data = %d\n", child_ptr->next->data);
```

출력 결과는 다음과 같다.

```
=== parent_t -> child_t 다운캐스팅 ===
child_ptr->data = 10
child_ptr->next->data = 20
```

업캐스팅 후 다운캐스팅을 수행해도 메모리 주소가 변하지 않기 때문에`data`와 `next->data`는 원래 값 그대로 유지된다. 단, 원래부터 `parent_t` 타입으로 선언된 객체를 `child_t`로 다운캐스팅하면 정의되지 않은 동작(Undefined Behavior, UB)이 발생할 수 있으므로 주의해야 한다.

# 주의 사항

- 구조체 레이아웃이 변경되면 캐스팅 동작이 보장되지 않는다.
- 구조체 상속 기법은 유지보수 시 신중하게 사용해야 한다.

# 참고자료

- [C언어에서 OOP 하기(2) - 상속](https://jtrimind.github.io/oop/oop-in-c-02/) [github.io]