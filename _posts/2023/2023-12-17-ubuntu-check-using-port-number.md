---
title: "[Linux] ubuntu 사용 중인 포트 번호 확인"
date: 2023-12-17 21:20:00 +0900
categories: [inux]
tags: []
---

# netstat

- netstat 을 사용하면 열려있는 포트 번호와 해당 포트를 사용하는 프로세스의 PID, 프로그램의 이름을 확인할 수 있다.

```bash
$ netstat -tulpn

(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:46127           0.0.0.0:*               LISTEN      -
tcp        0      0 127.0.0.1:5432          0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:46493           0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:58719           0.0.0.0:*               LISTEN      -
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      -
...
```

# 참고자료

- [리눅스 포트 사용중인 프로세스 확인 방법](https://kugancity.tistory.com/entry/%EB%A6%AC%EB%88%85%EC%8A%A4-%ED%8F%AC%ED%8A%B8-%EC%82%AC%EC%9A%A9%EC%A4%91%EC%9D%B8-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-%ED%99%95%EC%9D%B8-%EB%B0%A9%EB%B2%95) [티스토리]