---
title: CMD에서 특정 프로그램을 실행시킬 수 있는 환경 변수(Path) 설정법
date: 2021-05-28 18:00:00 +0900
categories: [windows]
tags: [windows]
---

보통 특정 파일을 실행시키려면 해당 파일이 위치한 폴더로 이동해서 실행 파일을 더블클릭하여 실행한다.
하지만 CMD창에서 특정 파일명을 입력하면 그 파일이 자동으로 실행되도록 하는 방법이 있다.

예를 들어 파이썬은 `python`을 입력하면 자동으로 `python.exe`가 cmd에서 실행이 된다.
이것은 파이썬이 설치할 때 자동으로 환경변수를 설정했기 때문에 가능한 것이다.

(사진)

환경변수는 


```
ocr_ms_server --port 10102 --msport 9102 --msname ocr-captcha --mszone http://localhost:8761/eureka --msgroupname OCR
```

그대로 실행을 하니 다음과 같은 오류가 발생했다.

```
'ocr_ms_server'은(는) 내부 또는 외부 명령, 실행할 수 있는 프로그램, 또는
배치 파일이 아닙니다.
```

여기서 `ocr_ms_server`는 403_ocr_server의 .exe 파일명을 의미하는데, 이를 정상적으로 작동 시키기 위해서는 환경 변수가 필요하다.

방법은 간단하다.

해당 파일이 위치한 경로를 환경 변수의 PATH에 추가해주면 된다.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9dda566a-be23-4485-a11d-6008037497aa/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9dda566a-be23-4485-a11d-6008037497aa/Untitled.png)

Path에 추가를 하면, Path에 있는 경로들 중에서 `ocr_ms_server`라는 파일이 있는 경로를 찾고, 해당 경로에서 해당 파일을 실행시키는 작동시키는 원리이다.