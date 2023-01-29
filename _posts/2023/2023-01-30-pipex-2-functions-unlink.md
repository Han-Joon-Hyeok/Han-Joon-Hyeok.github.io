---
title: "[42Seoul] pipex (2) 허용 함수 정리 : unlink"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---

# unlink

```c
#include <unistd.h>

int unlink(const char *file);
```

`unlink` 함수는 파일을 삭제하는 함수이다. 소프트 링크, 하드 링크 모두 적용된다.

링크를 지우면 링크 개수를 1개 감소시킨다.

만약, 소프트 링크의 원본 파일을 지우면 소프트 링크는 더 이상 사용할 수 없게 된다.

## 반환값

- 성공 : 0
- 오류 발생 : -1

## 예시 코드

`hello.txt` 파일을 삭제하는 예시이다.

```c
#include <unistd.h>

int	main(void)
{
	unlink("hello.txt");
	return (0);
}
```

# 참고 자료

- [C/C++ link(2) unlink(2)](https://bubble-dev.tistory.com/entry/CC-link2-unlink2) [티스토리]
- [[Linux] 하드링크, 심볼릭링크(ln)](https://m.blog.naver.com/kwonkise/222038118502) [네이버 블로그]
