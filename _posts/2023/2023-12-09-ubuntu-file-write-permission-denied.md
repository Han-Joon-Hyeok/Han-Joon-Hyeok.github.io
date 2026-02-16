---
title: "[Linux] 파일 write 작업 시 PermissionError: [Errno 13] Permission denied 오류 해결"
date: 2023-12-09 21:00:00 +0900
categories: [inux]
tags: []
---

# 작업 환경

- OS : Ubuntu 22.04 (AWS EC2)
- Python : 3.10

# 문제 상황

- Python 으로 파일에 접근하여 내용을 변경하는 코드를 작성했다.

```python
with open("[some_file]", "w+") as f:
	f.write(...) # 파일에 작성하는 내용
```

- 하지만 아래와 같이 파일에 접근할 수 없다는 오류 메세지가 표시되었다.

```bash
PermissionError: [Errno 13] Permission denied: '[some_file]'
```

# 문제 원인

- 접근하려는 파일에 쓰기 권한이 없었기 때문에 위와 같은 오류가 발생했던 것이다.
- 현재 작업하는 AWS EC2 에서는 ubuntu 계정을 사용하지 않고, 별도의 계정을 새로 만들어서 로그인했다.
- 그리고 계정마다 작업할 수 있는 그룹(`servciegroup`)을 부여하여 유저마다 제한된 작업을 하도록 했다.
- 접근하려는 파일의 권한은 아래와 같이 644 로 되어 있었다.

```bash
-rw-r--r--   1 root    servicegroup    422 Dec  6 17:10 [some_file]
```

# 문제 해결

- 접근하려는 파일의 접근 권한을 그룹에 포함된 유저가 모두 쓰기 작업을 할 수 있도록 `chmod` 명령어를 이용해서 권한을 부여했다.

```bash
sudo chmod 664 [some_file]
```

- 위의 명령어 실행 후 파일 권한은 아래와 같이 변경되었다.

```bash
-rw-rw-r--   1 root    servicegroup    188 Dec  9 20:43 [some_file]
```