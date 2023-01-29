---
title: "[42Seoul] pipex (2) 허용 함수 정리 : wait"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---

# wait

```c
#include <sys/wait.h>

pid_t wait(int *status);
```

자식 프로세스가 끝나기를 기다리는 함수이다.

`status` 변수에는 자식 프로세스가 종료할 때 보내는 시그널 또는 exit code 를 저장한다.

## 반환값

- 자식 프로세스가 멈추거나 종료되면 종료된 자식 프로세스의 프로세스 아이디(pid)를 반환한다.
- 오류가 발생하면 -1 을 반환한다.

## 예시 코드

```c
#include <unistd.h>
#include <stdio.h>

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
		wait(&status);
	}
	if (WEXITSTATUS(status) == 127)
	{
		printf("COMMAND NOT FOUND!\n");
	}
	return (0);
}
```

실행 결과는 다음과 같다.

```
[PARENT] Hello, I'm parent.
[CHILD] Hello, I'm first child.
COMMAND NOT FOUND!
```

자식 프로세스가 종료될 때 `127` 을 리턴하고, 부모 프로세스에서 자식 프로세스가 리턴한 값이 `127` 인지 확인하는 예시이다.

참고로 `sys/wait.h` 에는 자식 프로세스의 종료 상태를 확인할 수 있는 매크로가 선언되어 있다.

| 매크로 | 설명 |
| --- | --- |
| WIFEXITED(status) | 자식 프로세스가 정상적으로 종료되었다면 TRUE |
| WIFSIGNALED(status) | 자식 프로세스가 시그널에 의해 종료되었다면 TRUE |
| WIFSTOPPED(status) | 자식 프로세스가 중단되었다면 TRUE |
| WEXITSTATUS(status) | 자식 프로세스가 종료되었을 때 반환한 값 |

# 참고 자료

- [C언어 자식 프로세스가 종료될 때까지 대기 함수 wait()](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%EC%9E%90%EC%8B%9D-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4%EA%B0%80-%EC%A2%85%EB%A3%8C%EB%90%A0-%EB%95%8C%EA%B9%8C%EC%A7%80-%EB%8C%80%EA%B8%B0-%ED%95%A8%EC%88%98-wait) [바다야크]
