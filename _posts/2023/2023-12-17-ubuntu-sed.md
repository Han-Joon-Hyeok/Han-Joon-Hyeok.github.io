---
title: "[Linux] sed 명령어로 파일 내용 한번에 변경하기"
date: 2023-12-17 21:20:00 +0900
categories: [linux]
tags: []
---

# sed

- EC2 인스턴스에 ssh 로 접속해서 작업하다보면 vim 을 사용할 일이 많다.
- vim 을 사용하지 않고도 터미널에서 빠르게 변경할 수 있는 방법은 sed 를 사용하면 된다.

```bash
sed -i 's/변경 전 내용/변경할 내용/g' [파일명]
```

## vim 에서 문자열 일괄 변경

- `:%s/변경 전 내용/변경할 내용/g` 입력 후 엔터

# 참고자료

- [[리눅스 명령어] sed : sed 명령어 사용하여 파일 내용 일괄 변경하기](https://honeyteacs.tistory.com/41) [티스토리]