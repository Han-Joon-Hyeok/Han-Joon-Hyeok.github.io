---
title: 프로그래머스 Level 1 - 최댓값 구하기 (MySQL)
date: 2021-11-17 14:50:00 +0900
categories: [programmers]
tags: [level1, programmers, MySQL]
---

> [프로그래머스 - Level1 최댓값 구하기](https://programmers.co.kr/learn/courses/30/lessons/59415)

# 문제 설명

`ANIMAL_INS` 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. `ANIMAL_INS` 테이블 구조는 다음과 같으며, `ANIMAL_ID`, `ANIMAL_TYPE`, `DATETIME`, `INTAKE_CONDITION`, `NAME`, `SEX_UPON_INTAKE`는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

(테이블 생략)

가장 최근에 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.

## 🙋‍♂️나의 풀이

### 작성 코드

```sql
SELECT MAX(DATETIME)
FROM ANIMAL_INS
```

- 시간은 내부적으로 밀리 세컨드 단위로 계산되는데, 1970년 1월 1일 09:00:00은 정수로 0을 의미한다. 정수 1000은 날짜값으로 1초가 지난 1970년 1월 1일 09:00:01을 의미한다.
- 따라서 TIMESTAMP 형식의 데이터에서 `MAX` 함수를 적용하면 가장 최근의 시간이 반환된다.
- 반대로 `MIN` 함수를 적용하면 가장 오래된 시간이 반환된다.

```sql
SELECT DATETIME
FROM ANIMAL_INS
ORDER BY DATETIME DESC
LIMIT 1
```

- 또는 `ORDER BY` 내림차순 정렬 후, `LIMIT` 로 1행만 추출하는 방법도 있다.
