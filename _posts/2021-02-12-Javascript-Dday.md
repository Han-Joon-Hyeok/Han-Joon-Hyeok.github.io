---
title: Javascript - 시,분,초 D-Day 실시간 계산기 만들기
date: 2021-02-10 20:24:00 +0900
categories: [Javascript]
tags: [Javascript]
---

우선 `javascript`에서 시간을 계산하는 방법은 다음과 같다.

1. Javascript의 `getTime()` 메소드는 현재 시간을 `1970년 1월 1일` 이후로부터 경과한 시간을 `millisecond(ms)` 단위로 계산을 한다.
2. `1초 = 1000ms` 이라는 점을 활용하면 일, 시, 분, 초까지 구할 수 있다. 
   - 초 : `1ms * 1000`는 1초
   - 분 : `1ms * 1000`가 1초니까 여기서 `60`을 곱하면 1분
   - 시 : `1ms * 1000 * 60`은 1분이니까, `60`을 곱하면 1시간
   - 일 : `1ms * 1000 * 60 * 60`은 1시간이니까, `24`를 곱하면 1일
3. 하지만 `밀리세컨드`는 소수점 단위로 딱 맞게 떨어지지 않아서 남은 기간이 `1.3432...일` 소수로 떨어질 수 있다. 따라서 이런 경우에는 `Math.floor`메소드를 사용하여, 소숫점 단위를 강제로 내려준다.

정리한 내용을 바탕으로 코드로 작성하면 다음과 같다.

```Javascript
const text = document.querySelector("h1");

function getTime(){
    const Dday = new Date("2021-08-29:00:00:00+0900");
    const today = new Date();
    const diff = Dday.getTime() - today.getTime(),
        // Ms 단위로 변환
        secInMs = Math.floor(difference / 1000),
        minInMs = Math.floor(secInMs / 60),
        hourInMs = Math.floor(minInMs / 60),
        days = Math.floor(hourInMs / 24),
        // 남은 시간 계산
        seconds = secInMs % 60,
        minutes = minInMs % 60,
        hours = minutes % 24;

    text.innerHTML = `${days}일 ${hours}시간 ${minutes}분 ${seconds}초`
}

function init(){
    setInterval(getTime, 1000) // getTime이라는 함수를 1000ms(1초) 단위로 실행한다.
}

init()
```
