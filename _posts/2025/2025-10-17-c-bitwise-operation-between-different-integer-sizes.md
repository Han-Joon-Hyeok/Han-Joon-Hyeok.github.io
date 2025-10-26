---
title: "[C언어] 자료형 크기 차이로 인한 비트 연산 오류 해결 방법"
date: 2025-10-17 09:40:00 +0900
categories: [c]
tags: []
use_math: true
---

# 개요

C언어에서 서로 다른 크기를 가진 자료형을 비트 연산할 때 발생할 수 있는 문제와 해결 방법을 정리했다.

이 글은 “[C언어 매크로 재정의 오류 원인과 해결 방법](https://han-joon-hyeok.github.io/posts/gcc-macro-redefined-error-fix)”의 후속 글이다.

# 문제 상황

AND 연산을 수행하는 매크로 함수에서, 매개변수의 자료형 크기 차이로 인해 의도치 않게 상위 32비트가 소실되는 문제가 발생했다.

```c
#define AND_BIT_OPERATION(a, b) ((a) &= ~(b))
```

이때 사용된 비트 상수는 다음과 같다. (0번째 비트는 가장 우측에 있는 비트를 의미한다.)

```c
// 32비트 크기 (BIT_31)
#define BIT_31 0x80000000

// 64비트 크기
unsigned long long data = 0xFFFFFFFFFFFFFFFFULL;
```

- `BIT_31`: 32비트 정수형의 최상위 비트(31번째 비트)가 1인 수
- `data`: 64비트 정수형의 최상위 비트(63번째 비트)가 1인 수

다음은 64비트 변수 `data`에서 특정 비트를 제거하려는 예시 코드이다.

```c
#include <stdio.h>

#define BIT_31 0x80000000
#define AND_BIT_OPERATION(a, b) ((a) &= ~(b))

int main() {
    unsigned long long data = 0xFFFFFFFFFFFFFFFFULL;

    printf("BIT_31 제거 전: 0x%016llX\n", data);

    AND_BIT_OPERATION(data, BIT_31);

    printf("BIT_31 제거 결과 : 0x%016llX\n", data);

    return 0;
}
```

## 코드 해석

`data` 변수는 64비트 크기의 자료형이며, 전체 64개 비트가 모두 1인  (`0xFFFFFFFFFFFFFFFF`)이다. 반면 `BIT_31`은 32비트 크기의 정수 상수이며, 전체 32비트 중 **맨 왼쪽(31번째)** 비트만 1인 수이다. 비트를 시각적으로 표현하면 다음과 같다.

```c
1111 1111 / 1111 1111 / ... / 1111 1111 1111 1111 // data 변수
0000 0000 / 0000 0000 / ... / 1000 0000 0000 0000 // BIT_31 변수
```

## 기대했던 결과

`AND_BIT_OPERATION(data, BIT_31)`은 내부적으로 다음 연산을 수행한다.

```c
data = data & (~BIT_31);
```

이 연산의 의도는 **BIT_31 위치의 비트만 0으로 만들고, 나머지는 그대로 유지하는 것**이다.

따라서 기대하는 결과는 다음과 같다.

```c
1111 1111 / 1111 1111 / ... / 1111 1111 1111 1111   // data 변수
1111 1111 / 1111 1111 / ... / 0111 1111 1111 1111   // ~BIT_31 변수
&=
1111 1111 / 1111 1111 / ... / 0111 1111 1111 1111   // 기대 결과
```

즉, 결과값은 `0xFFFFFFFF7FFFFFFF`이 되어야 한다.

## 실제 결과

하지만 실제 출력 결과는 다음과 같았다.

```c
BIT_31 제거 전 : 0xFFFFFFFFFFFFFFFF
BIT_31 제거 후 : 0x000000007FFFFFFF
```

상위 32비트(FFFFFFFF00000000)가 통째로 사라진 것이다.

# 원인 분석

핵심은 연산 순서와 ‘정수 승격’(integer promotions) + ‘일반 산술 변환’(usual arithmetic conversions)이다.

1. **단항 연산 `~`는 피연산자의 형에 먼저 적용**된다.

    `b`가 32비트 정수(대부분 `unsigned int`)이면, `~b`는 **32비트 범위에서만** 보수가 계산되어 결과가 `0x7FFFFFFF`(32비트) 가 된다. 이때 **상위 32비트는 존재하지 않는다.**

    ```c
    0111 1111 1111 1111   // ~b 변수(0x7FFFFFFF)
    ```

2. 그 다음 `&` 연산을 위해 **피연산자들의 형을 맞추는 단계**가 일어난다(usual arithmetic conversions).

    왼쪽 피연산자 `a`는 `unsigned long long`(64비트), 오른쪽 피연산자 `~b`는 32비트입니다. 따라서 `~b`가 **64비트로 승격**되는데, 이 값은 (unsigned이므로) **상위 32비트가 0으로 채워진 채** 64비트가 된다.

    ```c
    00000000 00000000 00000000 00000000 01111111 1111111 1111111 1111111   // 64비트 승격 시 상위 32비트 0
    ```

3. 결과적으로 `a & (~b)`는 **상위 32비트가 0인 마스크**와 AND 되는 형태가 되어, `a`의 **상위 32비트가 전부 0으로 소거**된다.

    ```c
    a(64bit)  = 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111
    승격된 ~b  = 00000000 00000000 00000000 00000000 01111111 11111111 11111111 11111111   // 64비트 승격 시 상위 32비트 0
    ------------------------------------------------ AND
    결과      = 00000000 00000000 00000000 00000000 01111111 11111111 11111111 11111111   // 상위 32비트가 0으로 소거
    ```


즉, `a`의 상위 32비트는 **남아 있어야 했지만**, `~b`가 **32비트에서 먼저 계산**된 뒤 **64비트로 승격될 때 상위가 0으로 채워져** AND 마스크의 상위가 모두 0이 되어버렸고, 그 결과 `a`의 상위 32비트 정보가 사라졌다.

정수 승격과 관련해서 [C99 표준](https://www.dii.uchile.cl/~daespino/files/Iso_C_1999_definition.pdf)(ISO/IEC 9899:1999)은 일반 산술 변환에서 피연산자 간 형을 맞추는 원칙을 다음과 같이 규정한다.

> Otherwise, if both operands have signed integer types or both have unsigned integer types, the operand with the type of lesser integer conversion rank is converted to the type of the operand with greater rank.
>
>
> —*ISO/IEC 9899:1999, 6.3.1.8 Usual arithmetic conversions*
>

즉, 위 규정에 따라 `a`가 `unsigned long long`(더 높은 rank), `~b`가 32비트 정수(더 낮은 rank)라면, `~b`는 **`a`의 형으로 변환**된다. `~b`가 **32비트에서 먼저 계산된 후** 64비트로 확장되므로, 확장 시 상위 32비트는 **0으로 채워진 값**이 된다. 따라서 최종 AND 마스크의 상위 32비트가 0이 되어 `a`의 상위 32비트가 모두 0으로 떨어진다.

# 문제 해결

자료형 크기를 일치시키면 문제를 해결할 수 있다. 즉, 매크로 연산 과정에서 `b` 를 `a` 와 동일한 자료형으로 변환하면 된다.

```c
#define AND_BIT_OPERATION(a, b) ((a) &= (~((typeof(a))b)))
```

1. **`(typeof(a)) (b)`**: `b`를 먼저 **a와 동일한 형(너비/부호)** 으로 변환한다.
2. **`~((typeof(a)) (b))`**: 이제 `~`가 **a와 같은 너비**에서 수행된다. 즉, 64비트 `a`라면 64비트 전체에 1이 “퍼진” 보수가 만들어진다.
    - 예: `~((unsigned long long)BIT_31) == 0xFFFFFFFF7FFFFFFFULL`
3. 마지막으로 `a & (64비트)`가 되어, **지우고 싶은 비트만 정확히 0**이 되고 상위 32비트는 그대로 유지된다.

## 수정된 코드

```c
#include <stdio.h>

#define BIT_31 0x80000000
#define AND_BIT_OPERATION(a, b) ((a) &= (~((typeof(a))b)))

int main() {
    unsigned long long data = 0xFFFFFFFFFFFFFFFFULL;

    printf("BIT_31 제거 전 : 0x%016llX\n", data);

    AND_BIT_OPERATION(data, BIT_31);

    printf("BIT_31 제거 후 : 0x%016llX\n", data);

    return 0;
}
```

## 수정 후 결과

```c
BIT_31 제거 전 : 0xFFFFFFFFFFFFFFFF
BIT_31 제거 후 : 0xFFFFFFFF7FFFFFFF
```

# 참고자료

- https://stackoverflow.com/questions/12081502/typeof-operator-in-c
- [ISO/IEC 9899:1999](https://www.dii.uchile.cl/~daespino/files/Iso_C_1999_definition.pdf)