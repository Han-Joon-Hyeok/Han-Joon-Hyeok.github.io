---
title: 프로그래머스 Level 1 - 상위 n개 레코드 (MySQL)
date: 2021-11-17 14:50:00 +0900
categories: [programmers]
tags: [level1, programmers, mysql]
---

> [프로그래머스 - Level1 상위 n개 레코드](https://programmers.co.kr/learn/courses/30/lessons/59405)

# 문제 설명

---

`ANIMAL_INS` 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. `ANIMAL_INS` 테이블 구조는 다음과 같으며, `ANIMAL_ID`, `ANIMAL_TYPE`, `DATETIME`, `INTAKE_CONDITION`, `NAME`, `SEX_UPON_INTAKE`는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.

(테이블 생략)

동물 보호소에 가장 먼저 들어온 동물의 이름을 조회하는 SQL 문을 작성해주세요.

## 🙋‍♂️나의 풀이

### 작성 코드

```sql
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME LIMIT 1
```

# 배운 점

---

## MySQL - LIMIT 구문

```sql
LIMIT [시작지점,] 추출개수
```

`LIMIT` 구문은 시작점에서 몇 개의 행을 추출할 지 결정한다. 시작지점은 0부터 시작한다.

```sql
-- 맨 위에서부터 5개 행 조회
SELECT NAME
FROM ANIMALS_INS
LIMIT 5
```

```sql
-- 5번째부터 5개 조회
SELECT NAME
FROM ANIMAL_INS
LIMIT 5, 5
```

# 참고자료

- [[프로그래머스] 상위 n개 레코드](https://chanhuiseok.github.io/posts/db-3/)
