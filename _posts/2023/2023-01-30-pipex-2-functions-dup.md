---
title: "[42Seoul] pipex (2) 허용 함수 정리 : dup"
date: 2023-01-30 08:00:00 +0900
categories: [l42seoul]
tags: [pipex]
use_math: true
---

# dup

```c
#include <unistd.h>

int dup(int fildes);
```

함수의 매개변수(`fileds`)로 전달하는 파일 디스크립터를 현재 할당할 수 있는 가장 작은 파일 디스크립터에 복사하여 반환한다.

## 반환값

- 성공 : 복사된 파일 디스크립터 번호
- 실패 : -1
  - 발생한 오류에 따라 `errno` 가 설정됨

## 예시

`hello.txt` 파일에 다음과 같이 저장되어있다고 해보자.

```
hello wolrd
```

`hello.txt` 의 파일 디스크립터를 복사하여 `hello.txt` 파일의 내용에서 소문자 `hello` 를 대문자 `HELLO` 로 변경하는 예시이다.

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int	main(void)
{
	int		fd;
	int		dup_fd;
	char	*file;

	file = "hello.txt";
	fd = open(file, O_RDWR);
	dup_fd = dup(fd);
	printf("fd: %d, dup_fd: %d\n", fd, dup_fd);
	write(dup_fd, "HELLO", 5);
	close(fd);
	close(dup_fd);
	return (0);
}
```

실행 후 출력 결과는 다음과 같다.

```bash
fd: 3, dup_fd: 4
```

`dup` 함수는 현재 사용할 수 있는 파일 디스크립터 중에서 가장 낮은 번호에 원본 파일 디스크립터를 복사한다.

실행 후 `hello.txt` 파일에는 다음과 같이 변경된다.

```
HELLO world
```

`dup_fd` 에 `write` 함수를 실행했는데, `fd` 에 해당하는 파일 내용이 변경되는 이유는 두 파일 디스크립터가 같은 파일을 가리키고 있기 때문이다.

이를 이해하기 위해서는 파일 디스크립터에 대한 이해가 필요하다.

# 파일 디스크립터 이해하기

![1.png](/assets/images/2023/2023-01-30-pipex-2-functions-dup/1.png)

출처: [wikipedia](https://en.wikipedia.org/wiki/File_descriptor)

위의 그림은 파일 디스크립터가 작동하는 방식을 표현한 그림이다.

파일 디스크립터는 인덱스로만 존재하며, 파일 테이블에 존재하는 파일을 포인터로 가리킨다. 파일 테이블이란 모든 프로세스에서 열린 파일들에 대해 시스템 전체가 사용할 수 있는 테이블이다. 파일 테이블에는 특정 파일을 어떤 모드로 열었는지 기록한다. 즉, 읽기 전용, 쓰기 전용, 읽기 및 쓰기 등과 같은 정보를 기록하는 것이다. 그리고 파일 테이블은 실제 데이터가 저장되어 있는 Inode 테이블을 포인터로 가리킨다.

위의 그림에서 알 수 있듯이 다른 파일 디스크립터가 같은 파일 테이블을 가리킬 수도 있다. 파일 디스크립터 0번과 2번이 파일 테이블의 read를 지칭하는 경우인데, 이 경우는 같은 파일을 각각 다른 파일 디스크립터로 open 한 경우이다. 예시 코드는 다음과 같다.

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int	main(void)
{
	int		fd;
	int		fd2;
	char	*file;

	file = "hello.txt";
	fd = open(file, O_RDONLY);
	fd2 = open(file, O_RDONLY);
	printf("fd: %d, fd2: %d\n", fd, fd2);
	close(fd);
	close(fd2);
	return (0);
}
```

실행 결과는 다음과 같다.

```bash
fd: 3, fd2: 4
```

또는 다른 파일 테이블이 같은 Inode 테이블을 가리킬 수도 있다. 파일 디스크립터 1번과 4번이 각각 다른 파일 테이블을 가리키고 있지만 같은 Inode 테이블을 지칭하는 경우인데, 이 경우는 같은 파일을 각각 다른 모드로 open한 경우에 해당한다. 예시 코드는 다음과 같다.

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int	main(void)
{
	int		fd;
	int		fd2;
	char	*file;

	file = "hello.txt";
	fd = open(file, O_RDONLY);
	fd2 = open(file, O_RDWR);
	printf("fd: %d, fd2: %d\n", fd, fd2);
	close(fd);
	close(fd2);
	return (0);
}
```

## dup 함수에 적용하기

![2.png](/assets/images/2023/2023-01-30-pipex-2-functions-dup/2.png)

`dup` 함수를 사용하기 전에는 `fd` 변수에 `hello.txt` 파일을 가리키는 포인터의 파일 디스크립터 3번이 저장되어 있었다.

이때, `dup_fd` 변수에 `dup(fd)` 를 실행하면 사용 가능한 가장 낮은 디스크립터 번호인 4번에 `hello.txt` 를 가리키는 포인터를 저장하는 것이다. `fd` 변수는 `open` 할 때 읽기 및 쓰기 모드를 사용했는데, `dup` 함수는 파일 테이블 포인터도 동일하게 복사하기 때문에 동일한 파일을 가리킬 수 있게 되는 것이다.

![3.png](/assets/images/2023/2023-01-30-pipex-2-functions-dup/3.png)

# 참고 자료

- [https://badayak.com/entry/C언어-파일-디스크립터-복사본-만들기-함수-dup](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%ED%8C%8C%EC%9D%BC-%EB%94%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%84%B0-%EB%B3%B5%EC%82%AC%EB%B3%B8-%EB%A7%8C%EB%93%A4%EA%B8%B0-%ED%95%A8%EC%88%98-dup)
- [https://reakwon.tistory.com/104](https://reakwon.tistory.com/104)
- [File descriptor](https://en.wikipedia.org/wiki/File_descriptor) [wikipedia]
