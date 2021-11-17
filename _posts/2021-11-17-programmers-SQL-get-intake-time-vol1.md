---
title: 프로그래머스 Level 2 - 입양 시각 구하기(1) (MySQL)
date: 2021-11-17 14:50:00 +0900
categories: [programmers]
tags: [level2, programmers, MySQL]
---

> [프로그래머스 - Level2 입양 시각 구하기(1)](https://programmers.co.kr/learn/courses/30/lessons/59412)

# 문제 설명

`ANIMAL_OUTS` 테이블은 동물 보호소에서 입양 보낸 동물의 정보를 담은 테이블입니다. `ANIMAL_OUTS` 테이블 구조는 다음과 같으며, `ANIMAL_ID`, `ANIMAL_TYPE`, `DATETIME`, `NAME`, `SEX_UPON_OUTCOME`는 각각 동물의 아이디, 생물 종, 입양일, 이름, 성별 및 중성화 여부를 나타냅니다.

(테이블 생략)

보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 09:00부터 19:59까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```sql
SELECT HOUR(DATETIME), COUNT(*)
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) >= 9 AND HOUR(DATETIME) < 20
GROUP BY HOUR(DATETIME)
ORDER BY HOUR(DATETIME)
```

- 날짜 데이터에서 일부만 추출하기 위해서 `HOUR` 함수를 사용했다. 이 외에도 `YEAR`, `MONTH`, `DAY`, `MINUTE` , `SECOND` 추출이 가능하다.
- SELECT 절 뿐만 아니라 WHERE 절에서도 사용이 가능하다.

# 참고자료

- [MySQL 날짜 데이터에서 일부만 추출하기](https://extbrain.tistory.com/60)
