---
title: "[42Seoul] pipex (2) 허용 함수 정리 : fork"
date: 2023-01-30 08:00:00 +0900
categories: [l42seoul]
tags: [pipex]
use_math: true
---

# fork

```c
#include <unistd.h>

pid_t fork(void);
```

`fork` 함수는 자식 프로세스를 생성하는 함수이다.

## 반환값

- 부모 프로세스에서는 자식 프로세스의 프로세스 아이디(pid)를 받는다.
- 자식 프로세스에서는 0을 받는다.
- 오류 발생 시 -1 을 받는다.

## 예시 코드

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		num;
	pid_t	pid;

	num = 0;
	pid = fork();
	if (pid == -1)
	{
		printf("FORK ERROR OCCURED\n");
	}
	else if (pid == 0)
	{
		printf("[CHILD]I'm child process (%d).\n", pid);
		printf("[CHILD]num: %d\n", num);
	}
	else
	{
		num += 1;
		printf("[PARENT]I'm parent process. My child process is (%d).\n", pid);
		printf("[PARENT]num: %d\n", num);
		waitpid(pid, NULL, 0);
	}
	printf("Everything is done.\n");
	return (0);
}
```

실행 결과는 다음과 같다.

```
[PARENT]I'm parent process. My child process is (3211).
[PARENT]num: 1
[CHILD]I'm child process (0).
[CHILD]num: 0
Everything is done.
Everything is done.
```

실행 과정을 자세하게 설명하면 다음과 같다.

1. `fork` 함수가 실행되는 순간 자식 프로세스가 생성된다. 이때, `fork` 함수를 실행하기 이전까지 부모 프로세스에서 선언한 변수와 변수에 저장된 값이 모두 복사가 된다. 다만, 부모 프로세스와 자식 프로세스는 각자 다른 메모리 영역을 할당받아서 사용하기 때문에 `fork` 이후에는 부모 프로세스와 자식 프로세스는 변수에 값이 변경되어도 변경된 내용을 공유하지 않는다.

![1.png](/assets/images/2023/2023-01-30-pipex-2-functions-fork/1.png)

1. 부모 프로세스는 `num` 변수에 저장된 값에서 1을 더하고, `waitpid` 함수를 사용하면 자식 프로세스가 실행을 끝낼 때까지 기다렸다가 부모 프로세스의 남은 코드를 실행한다.

   ```c
   else
   {
   	num += 1;
   	printf("I'm parent process. My child process is (%d).\n", pid);
   	printf("[PARENT]num: %d\n", num);
   	waitpid(pid, NULL, 0); // 자식 프로세스가 끝날 때까지 기다림
   }
   ```

2. 자식 프로세스는 `num` 변수에 저장된 값을 출력하고, `Everything is done.` 이라는 문장을 출력하고 끝난다. 이때, 자식 프로세스의 `num` 변수의 값은 0으로 출력되는데, `fork` 함수를 실행한 이후에는 부모 프로세스에서 값을 변경해도 자식 프로세스에 반영이 되지 않기 때문이다.

   ```c
   else if (pid == 0) // 자식 프로세스
   {
   	printf("I'm child process(%d).\n", pid);
   	printf("[CHILD]num: %d\n", num);
   }
   else // 부모 프로세스
   {
   	...
   }
   printf("Everything is done.\n");
   return (0);
   ```

3. 자식 프로세스가 실행을 끝냈기 때문에 부모 프로세스는 `Everything is done.` 이라는 문장을 출력하고 프로그램을 종료한다.

   ```c
   else
   {
   	...
   	waitpid(pid, NULL, 0); // 자식 프로세스 실행이 끝나면 다음 코드를 실행
   }
   printf("Everything is done.\n");
   return (0);
   ```

# 참고 자료

- [C언어 프로세스 생성 함수 fork](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-%EC%83%9D%EC%84%B1-%ED%95%A8%EC%88%98-fork) [바다야크]
- [fork 함수 사용하여 프로세스 생성](https://codetravel.tistory.com/23) [티스토리]
