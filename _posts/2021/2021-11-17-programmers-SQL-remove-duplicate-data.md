---
title: 프로그래머스 Level 2 - 중복 제거하기 (MySQL)
date: 2021-11-17 14:50:00 +0900
categories: [programmers]
tags: [level2, programmers, mysql]
---

> [프로그래머스 - Level2 중복 제거하기](https://programmers.co.kr/learn/courses/30/lessons/59408)

# 문제 설명

`ANIMAL_INS` 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. `ANIMAL_INS` 테이블 구조는 다음과 같으며, `ANIMAL_ID`, `ANIMAL_TYPE`, `DATETIME`, `INTAKE_CONDITION`, `NAME`, `SEX_UPON_INTAKE`는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

(테이블 생략)

동물 보호소에 들어온 동물의 이름은 몇 개인지 조회하는 SQL 문을 작성해주세요. 이때 이름이 NULL인 경우는 집계하지 않으며 중복되는 이름은 하나로 칩니다.

## 🙋‍♂️나의 풀이

### 작성 코드

```sql
SELECT COUNT(DISTINCT NAME)
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
```

- SELECT 절에서 중복을 제거하여 조회를 하고 싶다면 `DISTINCT` 를 컬럼명 앞에 붙이면 된다.
- `COUNT` 함수와 함께 쓸 경우에는 괄호 안에 `DISTINCT 컬럼명` 으로 작성하면 된다.
