---
title: "[42Seoul] pipex (2) 허용 함수 정리 : access"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---

# access

```c
#include <unistd.h>

int access(const char *file, int mode);
```

`file` 에 대해 `mode` 에 대한 접근이 있는지 확인하는 함수이다.

`mode` 에 입력할 수 있는 값은 다음과 같다.

- `R_OK` : read 권한이 있는지 확인
- `W_OK` : write 권한이 있는지 확인
- `X_OK` : execute 또는 search 권한이 있는지 확인
- `F_OK` : 파일이 존재하는지 확인

`mode` 는 `OR` 연산이 가능하기 때문에 여러 개를 동시에 사용할 수 있다.

```c
access(file, R_OK | W_OK | X_OK);
```

## 반환값

- `0` : 성공
- `-1` : 실패. 발생한 오류에 대해 전역 변수인 `errno` 값이 설정된다.

## 예시

존재하지 않는 파일 `not_existed_file` 에 대해 파일이 존재하는지(`F_OK`), 존재하는 파일이지만 권한이 아무 것도 없는 파일 `not_accessible_file` (`R_OK | W_OK | X_OK)` 에 대해 access 함수를 실행하는 예시이다.

```c
#include <errno.h>	// errno 출력을 위한 header
#include <stdio.h>
#include <unistd.h>

int	main(void)
{
	char	*file;

	file = "not_existed_file";
	if (access(file, F_OK) == -1)
		perror(NULL);
	file = "not_accessible_file";
	if (access(file, R_OK | W_OK | X_OK) == -1)
		perror(NULL);
	return (0);
}
```

실행 결과는 다음과 같다.

```bash
No such file or directory
Permission denied
```

