---
title: "[Python] datetime 대신 arrow 로 한국 시간 간편하게 변환하기"
date: 2023-12-20 14:20:00 +0900
categories: [python]
tags: []
---

# datetime, pytz, locale 이용하기

한국 시간은 UTC 에서 9시간을 더해주어야 한다.

한국 시간으로 변환하기 위해서 주로 사용하는 방법은 파이썬 내장 모듈인 `datetime` 과 외부 라이브러리인 `pytz` 을 활용하는 것이다.

```python
from datetime import datetime
import pytz
import locale

# 한글 로케일 설정
locale.setlocale(locale.LC_TIME, 'ko_KR.UTF-8')

# UTC 를 KST 로 변경
def get_current_time_in_kst():
    kst = pytz.timezone('Asia/Seoul')  # 한국 시간대
    current_time_utc = datetime.utcnow()  # UTC 현재 시각
    current_time_kst = current_time_utc.replace(tzinfo=pytz.utc).astimezone(kst)  # UTC 시각을 한국 시간대로 변환
    return current_time_kst

# 월, 일, 요일 설정
current_time_kst = get_current_time_in_kst()
month = current_time_kst.month
day_of_month = current_time_kst.day
day_of_week = current_time_kst.strftime('%A')

# 출력
print(f"{month}월 {day_of_month}일 {day_of_week}")
```

출력 결과는 아래와 같다.

```
12월 20일 수요일
```

요일을 출력하기 위해서 `locale` 도 사용해야하고, 월, 일, 요일을 각각 추출하는 것은 꽤나 번거로운 일이다.

그래서 이를 간단하게 출력할 수 있는 라이브러리를 찾아보았고, `arrow` 라는 라이브러리가 문제를 해결해주었다.

# arrow 이용하기

`arrow` 라이브러리는 날짜와 시간을 간단하게 사용할 수 있도록 도와주는 라이브러리이다.

사용하기 위해서는 아래의 명령어를 입력해서 설치해주어야 한다.

```bash
pip3 install arrow
```

`arrow` 라이브러리를 이용하면 아래와 같이 코드가 간결해지는 장점이 있다.

```python
import arrow

current_time_kst = arrow.now('Asia/Seoul')
date_format = "YYYY년 MM월 DD일 dddd"
date_of_today = current_time_kst.format(date_format, locale="ko_kr")

print(date_of_today)
```

출력 결과는 아래와 같다. 

```
2023년 12월 20일 수요일
```

# 참고자료

- [arrow 공식문서](https://arrow.readthedocs.io/en/latest/guide.html#format)
- [[python] 날짜, 시간을 다루는 경우 datetime 모듈 대신 arrow 추천](https://bskyvision.com/entry/python-%EB%82%A0%EC%A7%9C-%EC%8B%9C%EA%B0%84%EC%9D%84-%EB%8B%A4%EB%A3%A8%EB%8A%94-datetime-%EB%AA%A8%EB%93%88-%EB%8C%80%EC%8B%A0-arrow-%EC%B6%94%EC%B2%9C) [bskyvision.com]