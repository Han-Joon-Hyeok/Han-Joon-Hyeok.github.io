---
title: "정적 변수(static variable)란?"
date: 2022-06-14 16:09:00 +0900
categories: [c]
tags: []
---

# 정적 변수(static variable)

정적 변수는 프로그램이 실행되는 동안 계속 유지되는 변수이다.

지역 변수는 함수가 실행되는 동안 해당 스코프 안에서만 생성되고, 함수가 끝나면 파괴되는데, 이와 달리 정적 변수는 함수가 끝나도 값이 그대로 유지된다.

정적 변수를 선언하는 방법은 다음과 같다.

```c
static 자료형 변수명;
```

## 정적 변수의 특징

### 1. 초기화를 따로 하지 않아도 컴파일러에서 `0` 으로 초기화 한다.

```c
#include <stdio.h>

static int n;

int main(void)
{
	printf("n: %d\n", n);
	return (0);
}
```

실행 결과는 다음과 같다.

```c
n: 0
```

### 2. 정보를 숨기는 정보 은닉 효과

정적 변수는 다른 소스 파일에서 사용하지 못하기 때문에 선택적으로 정보를 숨길 수 있다.

```c
// print_number.c
#include <stdio.h>

static int n = 1;

void print_number()
{
	printf("n in print_number: %d\n", n);
}
```

```c
// main.c
#include <stdio.h>

extern int n;

int main(void)
{
	print_number();
	printf("n in main: %d\n", n);
	return (0);
}
```

위의 코드는 정적 변수 `n` 을 `print_number.c` 에서 선언하고, `main.c`에서 `extern` 키워드를 통해 변수 `n` 을 참조하는 코드이다.

하지만, 컴파일을 수행하면 다음과 같이 에러가 발생한다. 이는 정적 변수는 파일 외부에서 사용할 수 없기 때문이다.

```c
Undefined symbols for architecture x86_64:
  "_n", referenced from:
      _main in main-071264.o
     (maybe you meant: _print_number)
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

### 3. 프로그램이 종료되지 않는 이상 메모리에 남아있다.

```c
#include <stdio.h>

void	plus_number()
{
	static int	static_n = 0;
	int local_n = 0;

	static_n += 1;
	local_n += 1;

	printf("static_n: %d\n", static_n);
	printf("local_n : %d\n\n", local_n);
}

int	main(void)
{
	plus_number();
	plus_number();
	return (0);
}
```

실행 결과는 다음과 같다.

```c
static_n: 1
local_n : 1

static_n: 2
local_n : 1
```

정적으로 선언한 변수 `static_n` 는 함수를 처음 실행하고 나서도 값이 그대로 유지되어 두 번째 실행한 함수에 반영되는 것을 확인할 수 있다.

하지만, 지역 변수로 선언한 변수 `local_n` 은 함수가 종료되고 나서 값이 다시 초기화 되어 이전 함수 실행 결과값이 유지되지 않은 것을 확인할 수 있다.

## 정적 변수의 종류

### 1. 특정 함수 안에서 선언하는 경우 (내부 정적 변수)

특정 함수 안에서 선언한 정적 변수를 **내부 정적 변수** 라 한다. 함수가 여러 번 실행 되어도, 내부 정적 변수의 초기화는 한 번만 이루어진다.

```c
void	plus_number()
{
	static int	n = 0;  // 내부 정적 변수
	n += 1;
}

int	main(void)
{
	plus_number();
	plus_number();
}
```

내부 정적 변수는 해당 함수 안에서만 참조할 수 있으며, 외부 함수에서는 참조할 수 없다. 코드를 통해 차이점을 확인해볼 수 있다.

다음의 코드는 함수 내부에서 정적 변수를 참조하는 코드이다.

```c
#include <stdio.h>

void	plus_number()
{
	static int	n = 0;
	n += 1;
	printf("n: %d\n", n);
}

int	main(void)
{
	plus_number();
	plus_number();
	return (0);
}
```

출력 결과는 다음과 같다.

```c
n: 1
n: 2
```

그리고 다음의 코드는 함수 외부에서 내부 정적 변수를 참조하는 코드이다.

```c
#include <stdio.h>

void	plus_number()
{
	static int	n = 0;
	n += 1;
}

int	main(void)
{
	plus_number();
	plus_number();
	printf("n: %d\n", n);
	return (0);
}
```

컴파일 시, 아래와 같이 선언하지 않은 변수를 참조한다는 오류가 발생한다.

```c
error: use of undeclared identifier 'n'
        printf("n: %d", n);
												^
```

### 2. 프로그램 전체에서 선언하는 경우 (외부 정적 변수)

특정 함수가 아닌 프로그램 전체에서 사용할 수 있도록 선언한 변수를 **외부 정적 변수**라 한다.

```c
static int	n;     // 외부 정적 변수

void	plus_number()
{
	n += 1;
}

int	main(void)
{
	plus_number();
	plus_number();
	return (0);
}
```

내부 정적 변수와는 달리 프로그램 내부의 어느 함수에서든 참조할 수 있다.

```c
#include <stdio.h>

static int	n;

void	minus_number()
{
	n -= 1;
	printf("n in minus_number: %d\n", n);
}

void	plus_number()
{
	n += 1;
	printf("n in plus_number: %d\n", n);
}

int	main(void)
{
	printf("n in main: %d\n", n);
	plus_number();
	minus_number();
	return (0);
}
```

실행 결과는 다음과 같다.

```c
n in main: 0
n in plus_number: 1
n in minus_number: 0
```

# 전역 변수와 정적 변수의 차이?

전역 변수는 외부 소스 파일에서 사용할 수 있지만, 정적 변수는 선언된 소스 파일에서만 사용이 가능하다. 그래서 외부에 공개하고 싶지 않은 변수는 정적 변수로 선언하여 사용할 수 있다.

# 참고자료

- [정적 변수 선언하기](https://dojang.io/mod/page/view.php?id=690) [코딩도장]
- [C언어 static변수(정적변수)](https://m.blog.naver.com/dd1587/221106199316) [네이버 블로그]