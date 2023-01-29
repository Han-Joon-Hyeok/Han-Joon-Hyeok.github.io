---
title: "[42Seoul] pipex (2) 허용 함수 정리 : dup2"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---

# dup2

```c
#include <unistd.h>

int dup2(int src_fildes, int dest_fildes);
```

`dup2` 함수는 첫 번째 매개변수로 복사하고자 하는 파일 디스크립터(`src_fildes`)를 두 번째 매개변수로 지정한 파일 디스크립터(`dest_fildes`)에 복사한다. `dup2` 함수는 특정 파일 디스크립터를 지정해서 복사할 수 있기 때문에 함수명을 풀어서 해석하면 `duplicate to` 라는 의미를 가지고 있는 것 같다.

## 반환값

- 성공 : 복사된 파일 디스크립터 번호
- 실패 : -1
    - 발생한 오류에 따라 `errno` 가 설정됨

## 예시

아래의 예시는 `printf` 로 출력한 내용이 터미널에 출력되는 것이 아닌 `hello.txt` 에 저장되는 예시이다.

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int	main(void)
{
	int		fd;
	char	*file;

	file = "hello.txt";
	fd = open(file, O_RDWR);
	dup2(fd, STDOUT_FILENO);
	printf("HELLO");
	close(fd);
	return (0);
}
```

`hello.txt` 파일에는 다음과 같은 내용이 저장되어 있다고 해보자.

```
hello world
```

위의 코드를 실행하면 터미널에는 아무 내용도 출력되지 않고, `hello.txt` 파일은 다음과 같이 변경된다.

```
HELLO world
```

`dup2` 를 실행하기 전에는 파일 디스크립터들이 다음과 같이 가리키고 있었다.

![1.png](/assets/images/2023-01-30-pipex-2-functions-dup2/1.png)

표준 출력(stdout)은 컴퓨터 화면에 출력할 수 있는 Inode 포인터를 가지고 있었지만, `dup2(fd, STDOUT_FILENO)` 를 실행하면 1번 파일 디스크립터는 컴퓨터 화면이 아닌 `hello.txt` 로 출력하게 된다.

![2.png](/assets/images/2023-01-30-pipex-2-functions-dup2/2.png)

`printf` 함수는 입력 받은 내용을 1번 파일 디스크립터로 출력하도록 동작하는데, `dup2` 함수를 통해 1번 디스크립터가 가리키는 포인터를 컴퓨터 화면이 아닌 `hello.txt` 파일로 변경했기 때문에 위와 같은 결과가 발생하는 것이다.

# 참고 자료

- [C언어 파일 디스크립터 복사본 만들기 함수 dup2()](https://badayak.com/entry/C%EC%96%B8%EC%96%B4-%ED%8C%8C%EC%9D%BC-%EB%94%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%84%B0-%EB%B3%B5%EC%82%AC%EB%B3%B8-%EB%A7%8C%EB%93%A4%EA%B8%B0-%ED%95%A8%EC%88%98-dup2) [바다야크]
