---
title: "[C] typeof 개념 정리 (GNU 확장형 타입 추론)"
date: 2025-11-02 21:20:00 +0900
categories: [c]
tags: []
use_math: true
---

# 개요

`typeof`는 GNU C 확장(GNU Extension)에서 제공하는 키워드로, 어떤 표현식이나 변수의 자료형(type)을 가져올 수 있게 해준다.

표준 C(ISO/IEC 9899)에는 포함되어 있지 않지만, GCC나 Clang처럼 GNU 확장을 지원하는 컴파일러에서는 널리 사용된다.

즉, typeof는 변수의 형(type)을 그대로 복사하는 기능이다.

```c
int a = 10;
typeof(a) b = 20;   // b는 int형이 된다.
```

이처럼 `typeof`는 컴파일 시점에 `a`의 형을 추론해서, `b`를 같은 형으로 선언한다.

# 문법

```c
typeof(식)
```

- 식(expression) 안에는 변수, 상수, 연산 결과 등 아무 표현식이 들어갈 수 있다.
- 컴파일러는 해당 식의 자료형을 추론(type deduction)하고, 그 결과를 `typeof(...)` 위치에 대체한다.

예를 들면 다음과 같다.

```c
double x;
typeof(x) y;        // y는 double형

typeof(1 + 2.0) z;  // 1 + 2.0 → double이므로 z도 double형
```

# 활용 예시

## 1. 변수 타입을 유지한 선언

```c
int count = 10;
typeof(count) backup = 0; // backup은 int형
```

타입을 하드코딩하지 않아도 되므로, 코드가 변경될 때 유지보수가 쉬워진다.

## 2. 구조체 변수 복제

```c
struct Point {
    int x, y;
};

struct Point p1 = {1, 2};
typeof(p1) p2 = {3, 4}; // p2도 struct Point형
```

`typedef`를 굳이 새로 선언하지 않아도 동일한 구조체를 손쉽게 복제할 수 있다.

## 3. 매크로에서 형 안정성 확보

매크로는 형을 모르는 텍스트 치환이기 때문에, 의도하지 않은 형 변환이 자주 일어난다. `typeof`를 사용하면 매개변수의 자료형을 유지하면서 안전하게 연산할 수 있다.

```c
#define SWAP(a, b) do {         \
    typeof(a) tmp = a;          \
    a = b;                      \
    b = tmp;                    \
} while (0)

int x = 10;
int y = 20;
SWAP(x, y);  // 정상 작동
```

이 경우 `a`와 `b`가 int, double, float 등 어떤 형이든 같은 자료형으로 교환된다.

# 주의할 점

## 1. 표준 C가 아니다

`typeof`는 **C99, C11, C17 표준에 포함되지 않은 비표준 확장 기능**이다.

즉, **MSVC(Microsoft Visual C)** 같은 일부 컴파일러에서는 사용할 수 없다.

GCC, Clang 계열에서는 사용할 수 있다.

> C++에서는 `decltype` 키워드가 동일한 역할을 수행한다.
>

## 2. 표현식이 평가되지 않는다

`typeof(expr)`는 **컴파일 시점에만 형을 추론**하며, 실제로 `expr`을 평가(evaluate)하지 않는다. 즉, 함수 호출식이라도 실행되지 않는다.

```c
int func() {
    printf("called\n");
    return 0;
}

typeof(func()) x; // "called"가 출력되지 않음
```

# 참고자료

- [GNU C Language Extensions – typeof](https://gcc.gnu.org/onlinedocs/gcc/Typeof.html)
- [Stack Overflow – What does typeof mean in C?](https://stackoverflow.com/questions/12081502/typeof-operator-in-c)
- [ISO/IEC 9899:2011 – C11 Standard](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf)