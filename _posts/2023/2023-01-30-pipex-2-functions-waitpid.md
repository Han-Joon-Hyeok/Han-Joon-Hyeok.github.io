---
title: "[42Seoul] pipex (2) 허용 함수 정리 : waitpid"
date: 2023-01-30 08:00:00 +0900
categories: [l42seoul]
tags: [pipex]
use_math: true
---

# waitpid

```c
#include <sys/wait.h>

pid_t waitpid(pid_t pid, int *status, int options);
```

인자로 넘기는 `pid` 자식 프로세스가 끝나기를 기다리는 함수이다.

`status` 변수에는 자식 프로세스가 종료할 때 보내는 시그널 또는 exit code 를 저장한다.

`options` 는 자식 프로세스를 기다릴 때 부모 프로세스가 어떻게 동작할 지 설정할 수 있다.

- `WNOHANG` : 자식 프로세스가 실행 중인지, 종료되었는지 확인하고 다시 부모 프로세스로 복귀한다. 즉, 부모 프로세스를 block 하지 않는다.
- 0 : 자식 프로세스가 종료할 때까지 부모 프로세스를 block 하며, `wait` 함수와 동일하다.

## 반환값

- 자식 프로세스가 멈추거나 종료되면 종료된 자식 프로세스의 프로세스 아이디(pid)를 반환한다.
- 오류가 발생하면 -1 을 반환한다.

## 예시 코드

```c
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

int	main(void)
{
	pid_t	pid;
	int		status;

	pid = fork();
	if (pid == 0)
	{
		printf("[CHILD] Hello, I'm first child.\n");
		return (127);
	}
	else
	{
		printf("[PARENT] Hello, I'm parent.\n");
		waitpid(pid, &status, WNOHANG);
	}
	printf("[PARENT] WNOHANG options proceed without waiting child process finished.\n");
	return (0);
}
```

실행 결과는 다음과 같다.

```
[PARENT] Hello, I'm parent.
[PARENT] WNOHANG options goes without waiting child process finished.
[CHILD] Hello, I'm first child.
```

# 참고 자료

- [C언어 자식 프로세스 종료 확인 함수 waitpid ()](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%EC%9E%90%EC%8B%9D-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-%EC%A2%85%EB%A3%8C-%ED%99%95%EC%9D%B8-%ED%95%A8%EC%88%98-waitpid) [바다야크]
