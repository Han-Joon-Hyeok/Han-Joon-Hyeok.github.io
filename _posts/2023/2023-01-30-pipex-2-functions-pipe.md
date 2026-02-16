---
title: "[42Seoul] pipex (2) 허용 함수 정리 : pipe"
date: 2023-01-30 08:00:00 +0900
categories: [l42seoul]
tags: [pipex]
use_math: true
---

# pipe

```c
#include <unistd.h>

int pipe(int fildes[2]);
```

크기가 2인 `int` 배열에 한 쪽에서는 데이터를 쓰고, 다른 한 쪽에서는 데이터를 읽을 수 있는 데이터 통신 파일 디스크립터를 만드는 함수이다.

첫 번째 원소인 `fildes[0]` 는 파이프의 `read end` 이고, 두 번째 원소인 `fildes[1]` 은 파이프의 `write end` 이다. 그래서 `fildes[1]` 에서 데이터를 입력하면 `fildes[0]` 에서 입력한 데이터를 읽을 수 있다.

## 반환값

- 성공 : 0
- 오류 : -1
  - 전역 변수 `errno` 에 발생한 에러 자동 설정

## 예시 코드

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		pipe_fd[2];
	char	buf[6];

	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	printf("pipe_fd[0]: %d, pipe_fd[1]: %d\n", pipe_fd[0], pipe_fd[1]);
	write(pipe_fd[1], "HELLO\n", 6);
	read(pipe_fd[0], buf, 6);
	printf("%s", buf);
	return (0);
}
```

파이프를 생성해서 `write end` 에서 `HELLO\n` 라는 데이터를 입력하면 `read end` 에서 이를 읽어와서 출력하는 예시이다.

실행 결과는 다음과 같다.

```bash
pipe_fd[0]: 3, pipe_fd[1]: 4
HELLO
```

파이프를 생성하면 사용할 수 있는 가장 낮은 파일 디스크립터부터 순서대로 배열에 할당된다.

파이프가 동작하는 모습을 그림으로 표현하면 다음과 같다.

![1.png](/assets/images/2023/2023-01-30-pipex-2-functions-pipe/1.png)

만약, `read end` 파이프를 먼저 닫고 데이터를 읽어오려고 하면 데이터를 읽어오지 못한다.

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		pipe_fd[2];
	char	buf[6];

	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	printf("pipe_fd[0]: %d, pipe_fd[1]: %d\n", pipe_fd[0], pipe_fd[1]);
	write(pipe_fd[1], "HELLO\n", 6);
	close(pipe_fd[0]); // 데이터를 읽기 전에 파이프를 닫음
	read(pipe_fd[0], buf, 6);
	printf("%s", buf);
	return (0);
}
```

실행 결과는 아래의 이미지와 같으며, 실행 환경에 따라 쓰레기값이 출력되거나 빈 문자열이 출력될 수 있다.

![2.png](/assets/images/2023/2023-01-30-pipex-2-functions-pipe/2.png)

그림으로 표현하면 다음과 같다.

![3.png](/assets/images/2023/2023-01-30-pipex-2-functions-pipe/3.png)

`close` 를 수행하면 파일 디스크립터가 가리키고 있던 대상은 해제되며 해당 파일이 가지고 있던 데이터는 더 이상 접근할 수 없게 된다.

파이프는 `read end` 또는 `write end` 중에 하나라도 닫히면 widowed(상대가 떠나버린) 상태가 된다.

구체적으로는 `read end` 가 먼저 닫히고 `write` 를 수행하면 프로세스는 `SIGPIPE` 시그널을 받게 된다.

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

void	print_hello(int signo)
{
	printf("SIGPIPE OCCURED %d\n", signo);
}

int	main(void)
{
	int		pipe_fd[2];
	char	*buf;

	signal(SIGPIPE, print_hello);	// SIGPIPE를 감지하기 위한 이벤트 핸들러
	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	printf("pipe_fd[0]: %d, pipe_fd[1]: %d\n", pipe_fd[0], pipe_fd[1]);
	close(pipe_fd[0]); // 데이터를 쓰기 전에 read end를 닫음
	write(pipe_fd[1], "HELLO\n", 6);
	read(pipe_fd[0], buf, 6);
	printf("%s", buf);
	return (0);
}
```

실행 결과는 다음과 같다.

```bash
pipe_fd[0]: 3, pipe_fd[1]: 4
SIGPIPE OCCURED 13
(null)
```

반대로 `write end` 를 먼저 닫고 `read end` 에 접근하면 프로세스는 `EOF` 를 받는다.

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		pipe_fd[2];
	char	*buf;

	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	printf("pipe_fd[0]: %d, pipe_fd[1]: %d\n", pipe_fd[0], pipe_fd[1]);
	close(pipe_fd[1]);
	read(pipe_fd[0], buf, 6);
	printf("%s", buf);
	return (0);
}
```

실행 결과는 다음과 같다.

```bash
pipe_fd[0]: 3, pipe_fd[1]: 4
(null)
```

만약, `write end` 를 닫지 않은 채 `read end` 에 접근하면 프로세스는 파이프에 데이터가 들어올 때까지 계속 대기한다.

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		pipe_fd[2];
	char	*buf;

	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	printf("pipe_fd[0]: %d, pipe_fd[1]: %d\n", pipe_fd[0], pipe_fd[1]);
	read(pipe_fd[0], buf, 6);	// 파이프의 write end 에서 데이터가 들어오는 것을 계속 기다림
	printf("%s", buf);
	return (0);
}
```

이는 `fork` 를 수행했을 때도 동일하다.

```c
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int	main(void)
{
	int		pipe_fd[2];
	char	*buf;
	pid_t	pid;

	if (pipe(pipe_fd) == -1)
	{
		printf("PIPE ERROR OCCURED\n");
		return (1);
	}
	pid = fork();
	if (pid == 0) // 자식 프로세스
	{
		printf("I'm waiting data written.\n");
		read(pipe_fd[0], buf, 6);	// 파이프의 write end 에서 데이터가 들어오는 것을 계속 기다림
	}
	else // 부모 프로세스
	{
		waitpid(pid, NULL, 0);
		write(pipe_fd[1], "HELLO\n", 6);
		close(pipe_fd[1]);
	}
	return (0);
}
```

부모 프로세스는 자식 프로세스가 끝나기를 기다리고 있는데, 자식 프로세스에서는 파이프의 `write end` 로부터 데이터가 들어오기를 계속 기다리고 있다. 그래서 위의 코드를 실행하면 끝나지 않고 계속 대기하는 현상이 발생한다.

![4.png](/assets/images/2023/2023-01-30-pipex-2-functions-pipe/4.png)

따라서 더 이상 사용하지 않는 파이프는 `close` 를 해주어야 무한 대기 현상 등을 방지할 수 있다.

# 참고 자료

- [c언어 pipe 란](https://nroses-taek.tistory.com/139) [티스토리]
- [C언어 파이프를 이용한 IPC 함수 pipe](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%ED%8C%8C%EC%9D%B4%ED%94%84%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-IPC-%ED%95%A8%EC%88%98-pipe) [바다야크]
