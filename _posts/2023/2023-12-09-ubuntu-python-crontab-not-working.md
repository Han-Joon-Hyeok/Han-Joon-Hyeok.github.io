---
title: "[Linux] python 을 crontab 으로 실행하도록 했는데 실행되지 않는 이유 (feat. 상대경로, 절대경로)"
date: 2023-12-12 19:40:00 +0900
categories: [inux]
tags: []
---

# 실행 환경

- OS : Ubuntu 22.04 (AWS EC2)
- Python : 3.10

# 문제 상황

- crontab 을 이용해서 python 파일을 매주 월요일마다 한국 시간 기준 오전 7시에 실행하도록 설정했다.

```bash
0 7 * * 1 /usr/bin/python3 /services/main.py
```

- 프로그램이 정상적으로 실행을 마쳤다면 `/services/log` 로그 파일에 기록을 하도록 설정해놨지만, 로그가 쌓이지 않았다.
- 그래서 아래와 같이 `cd` 명령어를 이용해서 current working directory 를 실행하고자 하는 python 파일의 경로로 이동하고, 해당 파일을 실행하도록 했더니 정상적으로 로그가 남는 것을 확인했다.

```bash
0 7 * * 1 cd /services; ./main.py
```

- 그렇다면 첫 번째 방법에서 실행 파일을 절대경로로 지정해주었는데도 실행이 안되었던 이유는 무엇일까?

# 문제 원인

- 원인은 python 코드 내에서 로그 파일을 저장하는 경로가 상대 경로였기 때문에 정확한 위치를 찾지 못했기 때문이다.

```python
import logging

logging.basicConfig(
	filename="./log", # 로그 파일을 저장하는 위치
	level=logging.INFO,
	format='%(asctime)s - %(levelname)s - %(message)s',
	datefmt='%Y-%m-%d %H:%M:%S'
)
```

- ubuntu 에서 cron 은 사용자마다 각각 원하는 작업을 실행시킬 수 있으며, cron 이 실행될 때는 각 사용자의 홈 디렉토리에서 별도의 shell 을 실행시킨다. (참고로 ubuntu 에서 cron 이 실행하는 shell 은 sh 이며, bash 로 변경하는 것도 가능하다.)
- 만약, `joonhan` 이란 계정의 사용자가 `crontab -e` 명령어를 이용해서 설정했다면 cron 은 `/home/joonhan` 위치에서 명령어를 실행한다.
- cron 이 실행하는 python 코드에서는 로그 파일의 위치를 상대 경로로 지정했기 때문에 `/home/joonhan/log` 라는 파일을 찾으려고 시도했지만, 이를 찾지 못했기 때문에 오류가 발생해서 정상적으로 로그가 남지 않은 것이다.

## (참고) cron 의 실행 위치 확인하기

- cron 이 실행하는 위치가 실제로 `/home/joonhan` 인지 확인하고 싶다면 `crontab` 에 아래와 같이 등록한다. 시간과 저장하고자 하는 파일 위치는 원하는 대로 수정하면 된다.

```bash
24 19 * * 2 pwd > /services/hello
```

- `joonhan` 계정에서 등록한 cron 이 실행되고 나서 `/services/hello` 파일에는 아래와 같이 저장되어 있었다.

```bash
/home/joonhan
```

# 문제 해결

- python 코드에서 파일의 위치를 상대 경로가 아닌 절대 경로로 수정해주면 된다.

```python
import logging

logging.basicConfig(
	filename="/services/log", # 로그 파일을 저장하는 위치
	level=logging.INFO,
	format='%(asctime)s - %(levelname)s - %(message)s',
	datefmt='%Y-%m-%d %H:%M:%S'
)
```

- 만약 cron 을 이용해서 주기적으로 실행해야 하는 파일이 있다면, 해당 파일의 코드 안에서 파일 경로는 절대 경로로 해주는 것이 좋을 것 같다.