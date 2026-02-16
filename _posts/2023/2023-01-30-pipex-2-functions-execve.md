---
title: "[42Seoul] pipex (2) 허용 함수 정리 : execve"
date: 2023-01-30 08:00:00 +0900
categories: [l42seoul]
tags: [pipex]
use_math: true
---

# execve

```c
#include <unistd.h>

int execve(const char *file, char *const argv[], char *const envp[]);
```

`execve` 함수는 실행하고자 하는 `file` 에 인자로 `argv` 와 환경변수인 `evnp` 를 전달해서 `file` 을 실행하여 새로운 프로세스를 생성하는 함수이다.

## 반환값

- 성공 : 아무 값도 반환하지 않음. 새로운 프로세스를 생성해서 실행하기 때문에 반환할 값이 없다.
- 실패 : -1
    - 전역 변수 `errno` 에 오류 발생 원인 설정

## 예시

```c
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int	main(void)
{
	char	*file;
	char	**argv;

	file = "/bin/ls";
	argv = malloc(sizeof(char *) * 3);
	argv[0] = "/bin/ls";
	argv[1] = "-l";
	argv[2] = NULL;
	execve(file, argv, NULL);
	return (0);
}
```

위의 예시는 `ls` 명령어를 `-l` 옵션을 주어 실행하는 예시이다.

실행 결과로 `ls -l` 을 실행한 결과가 터미널에 표시된다.

실행 프로그램에 필요한 인자들의 목록을 `argv` 라는 이중 포인터(또는 이중 배열)에 담는데, 이때 `argv` 의 첫 번째 원소는 실행 프로그램의 경로이며, 두 번째 원소부터는 명령어에 필요한 옵션이 들어가며, 마지막 원소에는 `NULL` 값이 들어간다. 마지막 원소에 `NULL` 값이 들어가는 이유는 문자열의 맨 마지막 글자가 `\0` 인 것과 동일하다.

그렇다면 `envp` 는 어떻게 사용할 수 있을까? 3가지 방법이 있다.

1. 환경 변수 값이 담긴 전역 변수인 `environ` 을 `extern` 하는 방법

    ```c
    extern char **environ;

    int	main(int argc, char **argv)
    {
    	...
    	return (0);
    }
    ```

2. main 함수의 세 번째 매개변수인 `envp` 를 사용하는 방법

    ```c
    int main(int argc, char **argv, char **envp)
    {
    	...
    	return (0);
    }
    ```

3. 직접 `envp` 를 정의해서 사용하는 방법

    2개의 파일을 이용해서 사용하는 방법을 소개하고자 한다.

    ```c
    // show_my_name.c

    #include <stdlib.h>
    #include <stdio.h>

    int	main(int argc, char **argv)
    {
    	printf("환경 변수 이름: %s\n", argv[1]);
    	printf("환경 변수 값: %s\n", getenv(argv[1]));
    }
    ```

    `show_my_name.c` 파일은 환경변수 키값을 매개변수로 받아서, 해당 환경변수가 가진 값을 출력하는 파일이다.

    `getenv` 함수는 프로그램이 실행되는 환경의 환경변수 중에서 매개변수로 넘긴 값과 일치하는 값을 가져오는 함수이다.

    이때, 컴파일은 다음과 같이 한다.

    ```bash
    gcc show_my_name.c -o show_my_name
    ```

    ```c
    // example.c

    #include <unistd.h>
    #include <stdio.h>
    #include <stdlib.h>

    int	main(void)
    {
    	char	*argv[3];
    	char	*envp[2];

    	argv[0] = "show_my_name";
    	argv[1] = "NAME";
    	argv[2] = NULL;
    	envp[0] = "NAME=joonhan";
    	envp[1] = NULL;
    	execve("show_my_name", argv, envp);
    	return (0);
    }
    ```

    `example.c` 파일은 `execve` 함수를 실행시키는 파일인데, 같은 디렉토리의 `show_my_name` 이라는 파일을 실행시킨다. 이때, 인자값으로 `NAME` 을 받고, 환경변수에는 `NAME` 이라는 키에 `joonhan` 이라는 값을 저장하여 실행한다.

    그 다음 `example.c` 파일을 컴파일한다.

    ```bash
    gcc example.c -o example
    ```

    그리고 다음과 같이 실행한다.

    ```bash
    ./example
    ```

    실행 결과는 다음과 같다.

    ```bash
    환경 변수 이름: NAME
    환경 변수 값: joonhan
    ```

    `execve` 함수를 사용하는 것은 쉘에서 다음과 같이 실행하는 것과 동일하다.

    ```bash
    # 환경변수 설정
    export NAME=joonhan
    # 파일 실행
    ./show_my_name NAME
    ```

    실행 결과는 다음과 같다.

    ```bash
    환경 변수 이름: NAME
    환경 변수 값: joonhan
    ```


# 참고 자료

- [C언어 다른 프로그램 실행 함수execve](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%EB%8B%A4%EB%A5%B8-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8-%EC%8B%A4%ED%96%89-%ED%95%A8%EC%88%98execve) [바다야크]
- [[Unix] execve](https://velog.io/@t1won/Unix-execve) [velog]
- [understanding requirements for execve and setting environment vars](https://stackoverflow.com/questions/7656549/understanding-requirements-for-execve-and-setting-environment-vars) [stackoverflow]
- [execve(2) - 프로그램 실행.](https://www.it-note.kr/157) [티스토리]
