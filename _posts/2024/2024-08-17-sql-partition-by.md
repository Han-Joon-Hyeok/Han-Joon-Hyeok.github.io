---
title: "[SQLD] PARTITION BY 이용해서 누적 합계 구하기"
date: 2024-08-17 14:20:00 +0900
categories: [sql, sqld]
tags: []
---

# PARTITION BY

PARTITION BY 절에 ORDER BY 를 사용하면 누적 합계를 표시한다.

## 예시

아래와 같은 테이블이 있다고 해보자.

| 사원번호 | 이름 | 부서코드 | 급여 |
| --- | --- | --- | --- |
| 101 | Alice | mkt | 3000 |
| 102 | Bob | mkt | 4000 |
| 103 | Charlie | hrd | 3500 |
| 104 | David | mkt | 5000 |
| 105 | Eve | hrd | 4500 |

```sql
SELECT 사원번호, 이름, 부서코드, 급여,
       SUM(급여) OVER (PARTITION BY 부서코드 ORDER BY 사원번호) AS 부서급여합
FROM 직원
WHERE 부서코드 IN ('mkt', 'hrd');
```

위의 쿼리 실행 결과는 아래와 같다.

| 사원번호 | 이름 | 부서코드 | 급여 | 부서급여합 |
| --- | --- | --- | --- | --- |
| 103 | Charlie | hrd | 3500 | 3500 |
| 105 | Eve | hrd | 4500 | 8000 |
| 101 | Alice | mkt | 3000 | 3000 |
| 102 | Bob | mkt | 4000 | 7000 |
| 104 | David | mkt | 5000 | 12000 |

ORDER BY 를 사용하지 않으면 그룹의 전체 합계를 표시한다.

```sql
SELECT 사원번호, 이름, 부서코드, 급여,
       SUM(급여) OVER (PARTITION BY 부서코드) AS 부서급여합
FROM 직원
WHERE 부서코드 IN ('mkt', 'hrd');
```

| 사원번호 | 이름 | 부서코드 | 급여 | 부서급여합 |
| --- | --- | --- | --- | --- |
| 103 | Charlie | hrd | 3500 | 8000 |
| 105 | Eve | hrd | 4500 | 8000 |
| 104 | David | mkt | 5000 | 12000 |
| 102 | Bob | mkt | 4000 | 12000 |
| 101 | Alice | mkt | 3000 | 12000 |

# 참고자료

- [[Oracle] 오라클 누적 합계 구하기 (SUM OVER)](https://gent.tistory.com/476) [티스토리]