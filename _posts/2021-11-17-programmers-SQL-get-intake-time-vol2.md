---
title: 프로그래머스 Level 4 - 입양 시각 구하기(2) (MySQL)
date: 2021-11-17 14:50:00 +0900
categories: [programmers]
tags: [level4, programmers, MySQL]
---

> [프로그래머스 - Level4 입양 시각 구하기(2)](https://programmers.co.kr/learn/courses/30/lessons/59413)

# 문제 설명

`ANIMAL_OUTS` 테이블은 동물 보호소에서 입양 보낸 동물의 정보를 담은 테이블입니다. `ANIMAL_OUTS` 테이블 구조는 다음과 같으며, `ANIMAL_ID`, `ANIMAL_TYPE`, `DATETIME`, `NAME`, `SEX_UPON_OUTCOME`는 각각 동물의 아이디, 생물 종, 입양일, 이름, 성별 및 중성화 여부를 나타냅니다.

(테이블 생략)

보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 0시부터 23시까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.

## 🙋‍♂️나의 풀이

SQL 문법을 잘 몰라서 다른 분들의 풀이를 참고해서 풀었다.

### 작성 코드

```sql
SET @hour := -1;

SELECT (@hour := @hour + 1) as HOUR,
(SELECT COUNT(*) FROM ANIMAL_OUTS WHERE HOUR(DATETIME) = @hour) as COUNT
FROM ANIMAL_OUTS
WHERE @hour < 23
```

- `SET` 은 변수명과 초기값을 설정하는 명령어이다.
  - `@` 가 붙은 변수는 프로시저가 종료되어도 유지된다.
  - 따라서 값을 누적하여 0부터 23까지 표현이 가능하다.
- `:=` 은 PL/SQL 문법에서 비교 연산자 `=` 과 혼동을 피하기 위해 사용하는 **대입 연산자**이다.
- `SELECT (@hour := @hour +1)` 은 `@hour` 값에 1씩 증가시키면서 SELECT 문을 실행한다.
- 그리고 서브쿼리에서 `@hour` 값과 일치하는 데이터를 찾아서 COUNT 한다.

## 👀 참고한 풀이

`WITH RECURSIVE` 를 활용해서 재귀적으로 쿼리를 작성하였다.

- Recursive CTE(Common Table Expression)은 CTE 중 자기 자신을 반복적으로 호출하는 CTE이다. 흔히 조직도와 같은 계층적 데이터의 처리나 BOM(Bill of Materials) 등을 쿼리하는 데 많이 사용한다.
- 구문은 다음과 같다.

```sql
WITH RECURSIVE 생성할_뷰_이름 AS
(
	초기 SQL
	UNION ALL
	반복할_SQL(반복을_멈출_WHERE절_포함)
)
```

---

[MySQL 공식 사이트](https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive)에 나온 예제를 살펴보자.

```sql
WITH RECURSIVE cte (n) AS
(
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM cte WHERE n < 5
)
SELECT * FROM cte;
```

```sql
+------+
| n    |
+------+
|    1 |
|    2 |
|    3 |
|    4 |
|    5 |
+------+
```

- Recursive 구문을 통해 생성하는 뷰 이름은 `cte` 이고, `cte` 에는 `n` 이라는 컬럼이 존재한다.
- 그리고 `SELECT 1` 구문을 통해 1만 담긴 초기값 열을 하나 생성한다.
- `UNION ALL` 아래의 반복문을 수행하면서 나온 결과를 초기값과 모두 합친다.

---

```sql
WITH RECURSIVE cte (HOUR) AS
(
    SELECT 0
    UNION ALL
    SELECT HOUR + 1 FROM cte WHERE HOUR < 23
)
SELECT cte.HOUR, COUNT(ANIMAL_OUTS.ANIMAL_ID) AS 'COUNT'
FROM cte
LEFT JOIN ANIMAL_OUTS
ON cte.HOUR = HOUR(ANIMAL_OUTS.DATETIME)
GROUP BY cte.HOUR
```

- HOUR 컬럼에 0부터 23까지 값을 가진 cte 뷰를 생성한다.
- 이렇게 만들어진 cte와 ANIMAL_OUTS를 LEFT JOIN을 수행하는데, cte.HOUR와 ANINAL_OUTS의 HOUR(ANIMAL_OUTS.DATETIME)이 같은 값을 기준으로 조인한다.
- LEFT JOIN을 하는 이유는 오른쪽 테이블에 맞는 컬럼이 없어도, 왼쪽 테이블을 기준으로 무조건 JOIN 하기 때문이다. 만약, HOUR(ANIMAL_OUTS.DATETIME)에 18시가 없어도, cte에는 존재하므로 cte.HOUR 18에 해당하는 COUNT는 0으로 row가 생성된다.
- 그리고 GROUP BY로 합계를 처리할 때, `COUNT(*)`을 많이 사용하는데, 여기서는 다른 방식을 접근해야 한다.
- 위의 예시처럼 HOUR(ANIMAL_OUTS.DATETIME)에 18시가 없어도, cte.HOUR에는 18이 있기 때문에 LEFT JOIN한 테이블에는 ANIMAL_OUTS 값이 NULL로 채워진 cte.HOUR 18 row가 존재하게 된다.
- 따라서 `COUNT(*)`는 모든 row의 개수를 세는 것이기 때문에, 입양 데이터가 없어도 cte 뷰로 인해 생성된 row도 count 되어 `COUNT(*)`의 값은 무조건 1이상이 된다.

# 참고자료

- [프로그래머스 입양 시각 구하기(1), (2) (GROUP BY, HAVING, SET)](https://chanhuiseok.github.io/posts/db-6/)
- [[WITH RECURSIVE] 프로그래머스 - 입양 시각 구하기 (2)](https://huilife.tistory.com/entry/WITH-RECURSIVE-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%A8%B8%EC%8A%A4-%EC%9E%85%EC%96%91-%EC%8B%9C%EA%B0%81-%EA%B5%AC%ED%95%98%EA%B8%B02)
- [Recursive CTE 개념](http://www.sqlprogram.com/TIPS/tip-recursive-cte.aspx)
