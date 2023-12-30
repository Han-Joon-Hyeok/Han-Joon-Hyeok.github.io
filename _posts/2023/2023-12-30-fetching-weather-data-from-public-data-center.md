---
title: "[Python] 공공데이터포털 기상청 API 이용해서 날씨 예보 가져오기"
date: 2023-12-30 19:20:00 +0900
categories: [python]
tags: []
---

# 실행 환경

- OS : Mac OS Sonoma 14.2.1
- Python : 3.9.6

# 결과물

Github Actions 의 cron 기능을 이용해서 매일 슬랙 채널에 특정 지역의 당일 최저 기온, 최고 기온, 하늘 상태를 알려주는 슬랙 봇을 개발했다.

![1.png](/assets/images/2023/2023-12-30-fetching-weather-data-from-public-data-center/1.png)

```
[2023년 12월 27일 수요일 인증 스레드]
🌏 현재 날씨: 맑음 ☀️ (강수: 없음)
🔼 최고 기온: 7.0°C
⬇️ 최저 기온: -2.0°C
🔎 관측 지점: 서울 강남구 개포2동
```

공공데이터포털에서 제공하는 기상청 단기예보 API 를 이용하면 구, 동 단위의 세부적인 지역을 선택해서 기상 예보 정보를 받을 수 있다.

다만, 기상청 API 는 2년에 1번씩 API 키를 갱신해주어야 하기 때문에 만료 기간을 꼭 확인하자. 

단기예보 API 는 실시간 기상 정보를 제공해주지 않는다. 기상청에서 3시간마다 발표하는 시간별 기상 예측 정보를 제공한다.

그 중에서도 당일 새벽 2시에 발표한 자료에는 당일 최저 기온과 최고 기온 정보가 포함되어 있다. 

# 기상청 단기예보 API 사용법

## API 사용 신청

1. [[공공데이터포털]](https://www.data.go.kr/) 에서 회원가입한다.
2. [[기상청 단기예보 조회서비스]](https://www.data.go.kr/data/15084084/openapi.do) 페이지에서 [활용신청]을 클릭한다.
3. [[마이페이지]](https://www.data.go.kr/iim/main/mypageMain.do) 에 접속하면 개인 API 인증키가 자동으로 발급되어 있는 것을 확인할 수 있다.

기상청 API 는 활용신청을 한다고 해서 바로 사용할 수 있는 것은 아니다. 사용 승인까지 최소 1일 정도 걸린다.

## API 요청하기

단기예보 API 요청은 GET 메서드를 이용해서 보내면 된다.

사용하는 파라미터는 아래와 같다.

| Key | 설명 | 필수 여부 |
| --- | --- | --- |
| serviceKey | 개인 API 인증키 | 필수 |
| pageNo | numOfRows 만큼 요청 했을 때 받고자 하는 페이지 번호 | 필수 |
| numOfRows | API 요청 시 반환하는 자료의 개수 | 선택 |
| dataType | API 응답 시 반환하는 자료 형식 (JSON 또는 XML) | 선택 |
| base_date | 예보 발표 기준 날짜 | 필수 |
| base_time | 예보 발표 기준 시간 | 필수 |
| nx | 예보 구역 위도 | 필수 |
| ny | 예보 구역 위도 | 필수 |

Python 으로 JSON 형식으로 응답을 받고자 하는 코드는 아래와 같이 작성할 수 있다.

```python
# weather.py

import os

from dotenv import load_dotenv

load_dotenv()

SERVICE_KEY = os.environ.get("SERVICE_KEY")

api_url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"

# 관측 위치 : 서울특별시 강남구 개포2동
# 당일 새벽 2시에 발표된 예보를 기준으로 최저기온, 최고기온 정보를 가져옵니다.
params = {
    'serviceKey': SERVICE_KEY,
    'numOfRows': '10',
    'dataType': 'JSON',
    'base_time': '0200',
    'nx': '62',
    'ny': '125',
}

'''
category: 예보 항목
- TMN : 최저 기온 - 오전 6시 
- TMX : 최고 기온 - 오후 3시 
- SKY : 하늘 상태
- PTY : 강수 형태
'''
def fetch_data_from_kma(current_time_kst, page_no, category, fcst_time):
    try:
        date_format = "YYYYMMDD"
        base_date = current_time_kst.format(date_format)
        params['base_date'] = base_date
        params['pageNo'] = page_no

        response = requests.get(api_url, params=params)
        response.raise_for_status()
        data = response.json()

        items = data['response']['body']['items']['item']
        found = next(filter(lambda x: x['category'] == category and x['fcstTime'] == fcst_time, items), None)

        if (found):
            return found['fcstValue']
        else:
            return None

    except requests.exceptions.HTTPError as errh:
        print(f"HTTP Error: {errh}")
    except requests.exceptions.ConnectionError as errc:
        print(f"Error Connecting: {errc}")
    except requests.exceptions.Timeout as errt:
        print(f"Timeout Error: {errt}")
    except requests.exceptions.RequestException as err:
        print(f"Something went wrong: {err}")

    return None
```

```python
# main.py

import arrow

def main():
    # 현재 날짜 (KST 기준)
    current_time_kst = arrow.now('Asia/Seoul')
    date_format = "YYYY년 MM월 DD일 dddd"
    date_of_today = current_time_kst.format(date_format, locale="ko_kr")

    # 날씨 정보
    weather_msg = ""
    sky = weather.fetch_data_from_kma(current_time_kst, '3', 'SKY', '0500')
    precipitation = weather.fetch_data_from_kma(current_time_kst, '4', 'PTY', '0500')
    lowest_temp_of_today = weather.fetch_data_from_kma(current_time_kst, '5', 'TMN', '0600')
    highest_temp_of_today = weather.fetch_data_from_kma(current_time_kst, '16', 'TMX', '1500')

    if (sky == None or precipitation == None or 
        lowest_temp_of_today == None or highest_temp_of_today == None):
        weather_msg = "날씨 정보를 가져오지 못했습니다. 😢"
    else:
        weather_of_today = f"{STATUS_OF_SKY[sky]} (강수: {STATUS_OF_PRECIPITATION[precipitation]})"
        weather_msg = (
            f"🌏 현재 날씨: {weather_of_today}\n"
            f"🔼 최고 기온: {highest_temp_of_today}°C\n"
            f"🔽 최저 기온: {lowest_temp_of_today}°C\n"
            f"🔎 관측 지점: 서울 강남구 개포2동"
        )
```

`numOfRows` 가 10 일 때, 최저 기온과 최고 기온은 아래의 조건으로 찾을 수 있다.

- 최저 기온 : 페이지 번호 - 5, 예측 시간(fcst_time) - 0600
- 최고 기온 : 페이지 번호 - 16, 예측 시간(fcst_time) - 1500

다른 블로그에서는 하루의 모든 자료를 요청해서 가져오셨다. 이 방식은 약 200개가 넘는 데이터를 가져오는데, 불필요한 데이터까지 모두 요청하기 때문에 비효율적이다.

그래서 `pageNo` 와 `numOfRows` 를 적절하게 설정하면 필요한 최소한의 데이터만 요청해서 가져올 수 있다. 필요한 데이터가 포함된 20개의 데이터만 요청함으로써 실행 속도도 높이고, 네트워크 사용량도 줄일 수 있다. 

# 참고자료

API 요청과 관련된 자세한 자료는 단기예보 API 페이지에서 `참고문서` 항목에 첨부된 파일을 확인하면 된다.

위의 예제에서 사용한 코드는 [github 링크](https://github.com/Han-Joon-Hyeok/42seoul-slack-bot-weather-notification)에서 확인할 수 있다.