---
title: "[C언어] printf 서식 지정자와 정밀도, width 탐구"
date: 2022-08-10 21:50:00 +0900
categories: [c]
tags: [c]
use_math: true
---

# 들어가며

C언어의 printf 함수는 다양한 서식 지정자와 함께 여러 옵션을 함께 사용해서 데이터를 원하는 대로 출력할 수 있다.

이 글은 서식 지정자에 대한 설명보다는 정밀도와 width를 서식 지정자와 활용했을 때 어떤 결과가 나오는 지 다양한 케이스를 바탕으로 정리하였다.

서식 지정자를 모두 살펴볼 수는 없기에 여기서는 `%s`(문자열), `%d`(int형), `%x` (16진수)만 다룬다.

# 정밀도와 서식 지정자

정밀도(precision)은 서식 지정자에 따라 다른 출력 결과가 나온다.

## %s (문자열)

```c
printf("%.0s", "hello");
printf("%.1s", "hello");
printf("%.4s", "hello");
printf("%.5s", "hello");
printf("%.6s", "hello");
printf("%.100s", "hello");
```

출력 결과는 다음과 같다.

```c
 
h
hell
hello
hello
hello
```

케이스를 나누면 다음과 같다.

### 1. 정밀도가 문자열의 길이보다 작은 경우

문자열의 맨 왼쪽부터 정밀도만큼 출력한다.

```c
printf("%.0s", "hello");
printf("%.1s", "hello");
printf("%.4s", "hello");
```

그래서 정밀도가 0이면 아예 출력하지 않는 것이다.

```c
 
h
hell
```

### 2. 정밀도가 문자열의 길이와 같거나 큰 경우

```c
printf("%.5s", "hello");
printf("%.6s", "hello");
printf("%.100s", "hello");
```

이 경우에는 문자열을 모두 출력한다.

```c
hello
hello
hello
```

## %d (정수)

```c
printf("%.0d\n", 0);
printf("%.0d\n", 1);
printf("%.0d\n", 1234);
printf("%.0d\n", -1234);

printf("%.1d\n", 0);
printf("%.1d\n", 1);
printf("%.1d\n", 1234);
printf("%.1d\n", -1234);

printf("%.5d\n", 0);
printf("%.5d\n", 1);
printf("%.5d\n", 1234);
printf("%.5d\n", -1234);
```

출력 결과는 다음과 같다.

```c
 
1
1234
-1234
0
1
1234
-1234
00000
00001
01234
-01234
```

케이스를 나누면 다음과 같다.

### 1. 정밀도가 0인 경우

```c
printf("%.0d\n", 0);
printf("%.0d\n", 1);
printf("%.0d\n", 1234);
printf("%.0d\n", -1234);
```

양의 정수, 음의 정수는 그대로 출력하지만, 0은 출력하지 않는다.

```c
 
1
1234
-1234
```

### 2. 정밀도가 숫자의 길이보다 작거나 같은 경우

```c
printf("%.1d\n", 0);
printf("%.1d\n", 1);
printf("%.1d\n", 1234);
printf("%.1d\n", -1234);
```

정밀도와 상관없이 숫자를 그대로 출력한다.

```c
0
1
1234
-1234
```

### 3. 정밀도가 숫자의 길이보다 큰 경우

```c
printf("%.5d\n", 0);
printf("%.5d\n", 1);
printf("%.5d\n", 1234);
printf("%.5d\n", -1234);
```

왼쪽에서부터 (정밀도 - 숫자의 길이)만큼 0을 채운다.

```c
00000
00001
01234
-01234
```

## %x (16진수)

```c
printf("%.0x\n", 0);
printf("%.0x\n", 1);
printf("%.0x\n", 1234);
printf("%.0x\n", -1234);

printf("%.1x\n", 0);
printf("%.1x\n", 1);
printf("%.1x\n", 1234);
printf("%.1x\n", -1234);

printf("%.5x\n", 0);
printf("%.5x\n", 1);
printf("%.5x\n", 1234);
printf("%.5x\n", -1234);
```

출력 결과는 다음과 같다.

```c
 
1
4d2
fffffb2e
0
1
4d2
fffffb2e
00000
00001
004d2
fffffb2e
```

케이스를 나누면 다음과 같다.

### 1. 정밀도가 0인 경우

```c
printf("%.0x\n", 0);
printf("%.0x\n", 1);
printf("%.0x\n", 1234);
printf("%.0x\n", -1234);
```

%d 와 마찬가지로 0은 출력하지 않고, 들어온 수를 그대로 16진수로 변환한다.

다만, 음의 정수는 unsigned int형으로 변환한 값으로 출력된다. 16진수 fffffb2e 는 10진수로 4294966062 이기 때문이다.

```c
 
1
4d2
fffffb2e
```

### 2. 정밀도가 숫자의 길이보다 작거나 같은 경우

```c
printf("%.1x\n", 0);
printf("%.1x\n", 1);
printf("%.1x\n", 1234);
printf("%.1x\n", -1234);
```

정밀도와 상관없이 숫자를 그대로 출력한다.

```c
0
1
4d2
fffffb2e
```

### 3. 정밀도가 숫자의 길이보다 큰 경우

```c
printf("%.5x\n", 0);
printf("%.5x\n", 1);
printf("%.5x\n", 1234);
printf("%.5x\n", -1234);
```

왼쪽에서부터 (정밀도 - 16진수로 변환한 숫자의 길이)만큼 0을 채운다.

```c
00000
00001
004d2
fffffb2e
```

# width와 서식 지정자

width가 출력할 내용의 길이보다 큰 경우에는 (width - 출력할 내용의 길이)만큼 왼쪽부터 공백을 채운다.

한편, width가 출력할 내용의 길이보다 작거나 같은 경우에는 출력할 내용을 그대로 출력한다.

## %s (문자열)

```c
printf("%0s\n", "h");
printf("%0s\n", "hello");
printf("%0s\n", "hello world");

printf("%1s\n", "h");
printf("%1s\n", "hello");
printf("%1s\n", "hello world");

printf("%5s\n", "h");
printf("%5s\n", "hello");
printf("%5s\n", "hello world");
```

출력 결과는 다음과 같다.

```c
h
hello
hello world
h
hello
hello world
    h
hello
hello world
```

케이스를 나누면 다음과 같다.

### 1. width가 문자열의 길이보다 작거나 같은 경우

문자열을 그대로 출력한다.

```c
printf("%0s\n", "h");
printf("%0s\n", "hello");
printf("%0s\n", "hello world");

printf("%1s\n", "h");
printf("%1s\n", "hello");
printf("%1s\n", "hello world");
```

width가 0이어도 출력 결과에는 영향이 없다.

```c
h
hello
hello world
h
hello
hello world
```

### 2. width가 문자열의 길이보다 큰 경우

```c
printf("%5s\n", "h");
```

(width - 문자열의 길이)만큼 왼쪽부터 공백을 채우고 문자열을 출력한다.

즉, 출력한 문자열의 길이가 width만큼 되도록 만드는 것이다.

```c
    h
```

## %d (정수)

```c
printf("%0d\n", 0);
printf("%0d\n", 1);
printf("%0d\n", 1234);
printf("%0d\n", -1234);

printf("%1d\n", 0);
printf("%1d\n", 1);
printf("%1d\n", 1234);
printf("%1d\n", -1234);

printf("%5d\n", 0);
printf("%5d\n", 1);
printf("%5d\n", 1234);
printf("%5d\n", -1234);
```

출력 결과는 다음과 같다.

```c
0
1
1234
-1234
0
1
1234
-1234
    0
    1
 1234
-1234
```

케이스를 나누면 다음과 같다.

### 1. width가 출력할 숫자의 길이보다 같거나 작은 경우

```c
printf("%0d\n", 0);
printf("%0d\n", 1);
printf("%0d\n", 1234);
printf("%0d\n", -1234);

printf("%1d\n", 0);
printf("%1d\n", 1);
printf("%1d\n", 1234);
printf("%1d\n", -1234);
```

숫자를 그대로 출력한다.

```c
0
1
1234
-1234
0
1
1234
-1234
```

### 2. width가 출력할 숫자의 길이보다 큰 경우

```c
printf("%5d\n", 0);
printf("%5d\n", 1);
printf("%5d\n", 1234);
printf("%5d\n", -1234);
```

%s 와 마찬가지로 왼쪽부터 공백을 채워넣는다. 이때, 음수는 마이너스까지 문자열의 길이로 본다.

```c
    0
    1
 1234
-1234
```

## %x (16진수)

```c
printf("%0x\n", 0);
printf("%0x\n", 1);
printf("%0x\n", 1234);
printf("%0x\n", -1234);

printf("%1x\n", 0);
printf("%1x\n", 1);
printf("%1x\n", 1234);
printf("%1x\n", -1234);

printf("%5x\n", 0);
printf("%5x\n", 1);
printf("%5x\n", 1234);
printf("%5x\n", -1234);
```

출력 결과는 다음과 같다.

```c
0
1
4d2
fffffb2e
0
1
4d2
fffffb2e
    0
    1
  4d2
fffffb2e
```

케이스를 나누면 다음과 같다.

### 1. width가 출력할 길이보다 작거나 같은 경우

```c
printf("%0x\n", 0);
printf("%0x\n", 1);
printf("%0x\n", 1234);
printf("%0x\n", -1234);

printf("%1x\n", 0);
printf("%1x\n", 1);
printf("%1x\n", 1234);
printf("%1x\n", -1234);
```

16진수로 변환한 값을 그대로 출력한다.

```c
0
1
4d2
fffffb2e
0
1
4d2
fffffb2e
```

### 2. width가 출력할 길이보다 큰 경우

```c
printf("%5x\n", 0);
printf("%5x\n", 1);
printf("%5x\n", 1234);
printf("%5x\n", -1234);
```

(width - 출력할 길이)만큼 왼쪽부터 공백을 채워서 총 길이가 width가 되도록 출력한다.

```c
    0
    1
  4d2
fffffb2e
```

# 정밀도와 width 함께 사용하기

케이스가 정말 많지만, 공통적으로 정밀도가 width보다 우선순위가 높다.

## %s (문자열)

### 1. width가 정밀도를 적용한 문자열의 길이보다 큰 경우

width가 정밀도를 적용한 문자열의 길이보다 큰 경우에는 왼쪽에 공백을 채워서 전체 길이가 width가 되도록 출력한다.

```c
printf("%10.1s\n", "h");
printf("%10.1s\n", "hello");
printf("%10.1s\n", "hello world");

printf("%10.5s\n", "h");
printf("%10.5s\n", "hello");
printf("%10.5s\n", "hello world");
```

출력 결과는 다음과 같다.

```c
         h
         h
         h
         h
     hello
     hello
```

### 2. width가 정밀도를 적용한 문자열의 길이보다 작거나 같은 경우

width를 별도로 확보하지 않고, 정밀도를 적용한 문자열만 출력한다.

```c
printf("%1.1s\n", "hello");
printf("%1.1s\n", "hello world");

printf("%5.5s\n", "hello");
printf("%5.5s\n", "hello world");
```

출력 결과는 다음과 같다.

```c
h
h
hello
hello
```

## %d (정수), %x(16진수)

### 1. width가 정밀도보다 큰 경우

정밀도를 먼저 적용하고, (width - 정밀도가 적용된 숫자의 길이)만큼 왼쪽부터 공백으로 채운다.

```c
printf("%10.0d\n", 0);
printf("%10.0d\n", 1);
printf("%10.0d\n", 1234);
printf("%10.0d\n", -1234);

printf("%10.1d\n", 0);
printf("%10.1d\n", 1);
printf("%10.1d\n", 1234);
printf("%10.1d\n", -1234);

printf("%10.5d\n", 0);
printf("%10.5d\n", 1);
printf("%10.5d\n", 1234);
printf("%10.5d\n", -1234);
```

출력 결과는 다음과 같다.

```c
 
         1
      1234
     -1234
         0
         1
      1234
     -1234
     00000
     00001
     01234
    -01234
```

### 2. 정밀도가 0이거나 width가 정밀도보다 작거나 같은 경우

정밀도를 적용한 숫자만 출력한다.

```c
printf("%1.0d\n", 0);
printf("%1.0d\n", 1);
printf("%1.0d\n", 1234);
printf("%1.0d\n", -1234);

printf("%1.1d\n", 0);
printf("%1.1d\n", 1);
printf("%1.1d\n", 1234);
printf("%1.1d\n", -1234);

printf("%1.5d\n", 0);
printf("%1.5d\n", 1);
printf("%1.5d\n", 1234);
printf("%1.5d\n", -1234);
```

출력 결과는 다음과 같다.

```c
 
1
1234
-1234
0
1
1234
-1234
00000
00001
01234
-01234
```

%x는 %d와 결과가 동일하기 때문에 별도로 작성하지 않았다. 

# 테스트 전체 코드

```c
#include <stdio.h>

int main()
{
    // %d
    
    printf("%1.0d\n", 0);
    printf("%1.0d\n", 1);
    printf("%1.0d\n", 1234);
    printf("%1.0d\n", -1234);
    
    printf("%1.1d\n", 0);
    printf("%1.1d\n", 1);
    printf("%1.1d\n", 1234);
    printf("%1.1d\n", -1234);
    
    printf("%1.5d\n", 0);
    printf("%1.5d\n", 1);
    printf("%1.5d\n", 1234);
    printf("%1.5d\n", -1234);
    
    printf("%5.0d\n", 0);
    printf("%5.0d\n", 1);
    printf("%5.0d\n", 1234);
    printf("%5.0d\n", -1234);
    
    printf("%5.1d\n", 0);
    printf("%5.1d\n", 1);
    printf("%5.1d\n", 1234);
    printf("%5.1d\n", -1234);
    
    printf("%5.5d\n", 0);
    printf("%5.5d\n", 1);
    printf("%5.5d\n", 1234);
    printf("%5.5d\n", -1234);
    
    printf("%10.0d\n", 0);
    printf("%10.0d\n", 1);
    printf("%10.0d\n", 1234);
    printf("%10.0d\n", -1234);
    
    printf("%10.1d\n", 0);
    printf("%10.1d\n", 1);
    printf("%10.1d\n", 1234);
    printf("%10.1d\n", -1234);
    
    printf("%10.5d\n", 0);
    printf("%10.5d\n", 1);
    printf("%10.5d\n", 1234);
    printf("%10.5d\n", -1234);
    
    // %s
    
    printf("%1.0s\n", "h");
    printf("%1.0s\n", "hello");
    printf("%1.0s\n", "hello world");
    
    printf("%1.1s\n", "h");
    printf("%1.1s\n", "hello");
    printf("%1.1s\n", "hello world");
    
    printf("%1.5s\n", "h");
    printf("%1.5s\n", "hello");
    printf("%1.5s\n", "hello world");
    
    printf("%5.0s\n", "h");
    printf("%5.0s\n", "hello");
    printf("%5.0s\n", "hello world");
    
    printf("%5.1s\n", "h");
    printf("%5.1s\n", "hello");
    printf("%5.1s\n", "hello world");
    
    printf("%5.5s\n", "h");
    printf("%5.5s\n", "hello");
    printf("%5.5s\n", "hello world");
    
    printf("%10.0s\n", "h");
    printf("%10.0s\n", "hello");
    printf("%10.0s\n", "hello world");
    
    printf("%10.1s\n", "h");
    printf("%10.1s\n", "hello");
    printf("%10.1s\n", "hello world");
    
    printf("%10.5s\n", "h");
    printf("%10.5s\n", "hello");
    printf("%10.5s\n", "hello world");
    
    // %x
    printf("%1.0x\n", 0);
    printf("%1.0x\n", 1);
    printf("%1.0x\n", 1234);
    printf("%1.0x\n", -1234);
    
    printf("%1.1x\n", 0);
    printf("%1.1x\n", 1);
    printf("%1.1x\n", 1234);
    printf("%1.1x\n", -1234);
    
    printf("%1.5x\n", 0);
    printf("%1.5x\n", 1);
    printf("%1.5x\n", 1234);
    printf("%1.5x\n", -1234);
    
    printf("%5.0x\n", 0);
    printf("%5.0x\n", 1);
    printf("%5.0x\n", 1234);
    printf("%5.0x\n", -1234);
    
    printf("%5.1x\n", 0);
    printf("%5.1x\n", 1);
    printf("%5.1x\n", 1234);
    printf("%5.1x\n", -1234);
    
    printf("%5.5x\n", 0);
    printf("%5.5x\n", 1);
    printf("%5.5x\n", 1234);
    printf("%5.5x\n", -1234);
    
    printf("%10.0x\n", 0);
    printf("%10.0x\n", 1);
    printf("%10.0x\n", 1234);
    printf("%10.0x\n", -1234);
    
    printf("%10.1x\n", 0);
    printf("%10.1x\n", 1);
    printf("%10.1x\n", 1234);
    printf("%10.1x\n", -1234);
    
    printf("%10.5x\n", 0);
    printf("%10.5x\n", 1);
    printf("%10.5x\n", 1234);
    printf("%10.5x\n", -1234);
    
    return 0;
}
```