---
title: "[C언어] 매크로 재정의 오류 원인과 해결 방법 (GCC 전처리기 기준)"
date: 2025-10-14 14:40:00 +0900
categories: [c]
tags: []
use_math: true
---

# 실행 환경

- OS: Ubuntu 22.04
- Architecture: x86_64 (64-bit)
- GCC: 11.4.0

# 요약

동일한 이름의 매크로를 서로 다른 방식으로 정의하면 GCC 전처리기가 두 매크로를 동일하지 않은 토큰으로 판단해 `redefined` 오류가 발생한다.

안전하게 프로그램을 설계하려면 `#ifndef` 전처리기 사용 또는 헤더 파일 정의 원칙을 지키면 해결 가능하다.

# 문제 상황

make를 이용해서 컴파일을 수행하던 중, 매크로 상수가 재정의(redefined)되었다는 오류가 발생했다.

```bash
Compiling debug.c
debug.c:667:1: error: "BIT_0" redefined
In file included from include/sys_include.h:28,
                 from debug.c:27:
include/ipc_constant.h:690:1: error: this is the location of the previous definition
```

문제가 되는 코드를 확인해보니 다음과 같았다.

```c
// debug.c

// 생략

#define BIT_0  0x00000001
#define BIT_1  0x00000002
#define BIT_2  0x00000004
#define BIT_3  0x00000008
#define BIT_4  0x00000010
#define BIT_5  0x00000020
#define BIT_6  0x00000040
#define BIT_7  0x00000080
#define BIT_8  0x00000100

void func()
{
	// ..
}
```

```c
// ipc_constant.h

// if 0 부분은 이전에 사용하던 코드
#if 0
#define BIT_0  0x00000001
#define BIT_1  0x00000002
#define BIT_2  0x00000004
#define BIT_3  0x00000008
#define BIT_4  0x00000010
#define BIT_5  0x00000020
#define BIT_6  0x00000040
#define BIT_7  0x00000080
#define BIT_8  0x00000100

// else 부분은 새로 작성했지만, 오류가 발생한 코드
#else
#define BIT_0  (1ULL << (0))
#define BIT_1  (1ULL << (1))
#define BIT_2  (1ULL << (2))
#define BIT_3  (1ULL << (3))
#define BIT_4  (1ULL << (4))
#define BIT_5  (1ULL << (5))
#define BIT_6  (1ULL << (6))
#define BIT_7  (1ULL << (7))
#define BIT_8  (1ULL << (8))
```

# 문제 원인

macro 재정의(redefine)를 할 때, 토큰의 내용이 같아야만 오류가 발생하지 않는다. GCC 기준으로 아래의 macro들은 모두 동일한 토큰으로 인식하기 때문에 오류가 발생하지 않는다.

```c
#define FOUR (2 + 2)
#define FOUR         (2    +    2)
#define FOUR (2 /* two */ + 2)
```

컴파일러는 macro 값으로 할당된 공백, 주석은 무시한다.

> Whitespace appears in the same places in both. It need not be exactly the same amount of whitespace, though. Remember that comments count as whitespace.

[**3.8 Undefining and Redefining Macros**](https://gcc.gnu.org/onlinedocs/cpp/Undefining-and-Redefining-Macros.html)
>

하지만 아래의 macro들은 전처리기가 다른 토큰으로 인식하기 때문에 오류가 발생한다.

```c
#define FOUR (2 + 2)
#define FOUR ( 2+2 )
#define FOUR (2 * 2)
#define FOUR(score,and,seven,years,ago) (2 + 2)
```

> **If a macro is redefined with a definition that is not effectively the same as the old one, the preprocessor issues a warning and changes the macro to use the new definition.** If the new definition is effectively the same, the redefinition is silently ignored. This allows, for instance, two different headers to define a common macro. The preprocessor will only complain if the definitions do not match.

[**3.8 Undefining and Redefining Macros**](https://gcc.gnu.org/onlinedocs/cpp/Undefining-and-Redefining-Macros.html)
>

C표준(ISO/IEC 9899)에서도 아래와 같이 정의하고 있다. 동일한 이름으로 define이 된 경우, 할당된 값이 같아야만 재정의 될 수 있다고 설명한다.

> **An identifier currently defined as an object-like macro shall not be redefined by another `#define` preprocessing directive unless the second definition is an object-like macro definition and the two replacement lists are identical.** Likewise, an identifier currently defined as a function-like macro shall not be redefined by another `#define` preprocessing directive unless the second definition is a function-like macro definition that has the same number and spelling of parameters, and the two replacement lists are identical.

[**6.10.3 Macro replacement p2**](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf)
>

`ipc_constant.h` 파일에 `BIT_0` 부터 `BIT_8` 가 기존에 32비트 환경에서 사용하기 위해 16진수 값으로 32비트를 선언했었고, `debug.c` 파일에도 동일한 이름과 동일한 값으로 매크로가 정의되어 있었다.

그리고 64비트 환경에서도 정상적으로 동작하기 위해 `(1ULL << (N))` 과 같이 unsigned long long 자료형을 이용해서 값을 바꾸었다. 하지만 컴파일 시 아래와 같이 redefined 오류가 표시되며 컴파일이 실패한 것이다.

```bash
Compiling debug.c
debug.c:667:1: error: "BIT_0" redefined
In file included from include/sys_include.h:28,
                 from debug.c:27:
include/ipc_constant.h:690:1: error: this is the location of the previous definition
```

# 문제 해결 방법

## 1. 헤더 파일에서만 매크로 정의하기

헤더 파일에서만 매크로를 정의하는 것이 장기적인 유지보수 관점에서 좋다. 문제가 되었던 C 소스 코드의 매크로 상수는 누가 작성했는지 모르는 레거시 코드였는데, 어쩌다 현재까지 남아있는지는 아무도 모른다.

## 2. #ifndef 전처리 지시어 활용

또는 `#ifndef` 전처리 지시어를 사용하는 방법도 있다. `#ifndef` 를 사용하면 이전에 정의된 매크로가 있다면 다시 정의하지 않도록 막아준다. 간단한 예제는 아래와 같다.

```c
#include <stdio.h>

#define BIT 123

#ifndef BIT
#define BIT 456
#endif

int main(void)
{
    int x = BIT;

    printf("%d\n", x);

    return 0;
}
```

출력 결과는 아래와 같다.

```bash
123
```

`#ifndef` 를 사용했기 때문에 `BIT` 매크로 상수가 재정의되지 않았고, 최종적으로 재정의를 시도했던 456이 아닌 123이 변수 `x`에 저장된 것을 확인할 수 있다.

## 3. 64비트와 32비트 자료형 비트 연산 문제 해결

사실 macro redefined 문제는 64비트 자료형과 32비트 자료형 비트 연산을 하면서 생겼던 문제를 해결하기 위해 코드를 수정하는 과정에서 마주했던 것이다.

즉, 핵심 원인은 64비트와 32비트 자료형 간 비트 연산이었다. 이 부분은 내용이 길어져 별도 글에서 다루었다.

- [[C언어] 자료형 크기 차이로 인한 비트 연산 오류 해결 방법](https://han-joon-hyeok.github.io/posts/c-bitwise-operation-between-different-integer-sizes/)

# 참고자료

- https://gcc.gnu.org/onlinedocs/cpp/Undefining-and-Redefining-Macros.html
- https://stackoverflow.com/questions/60619149/can-i-redefine-a-macro-with-another-define-directive
- https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf
- https://stackoverflow.com/questions/5272825/detecting-64bit-compile-in-c