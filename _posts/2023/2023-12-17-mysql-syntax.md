---
title: "[MySQL] 데이터베이스 생성, 유저 생성 및 권한 부여, 유저 조회, 유저 삭제, 데이터 삭제"
date: 2023-12-17 21:20:00 +0900
categories: [mysql]
tags: []
---

# 실행 환경

- OS : Ubuntu 22.04 (AWS EC2)
- MySQL : 8.0.5

# 데이터베이스 생성

- 데이터베이스에 root 권한으로 접속한다.

```bash
mysql -uroot -p
```

- 아래의 쿼리문을 입력해서 데이터베이스를 생성한다.

```sql
create database [db_name];
```

# 유저 생성 및 권한 부여

- MySQL 8 버전부터는 아래와 같이 grant 키워드를 이용해서 유저 생성이 불가능하다.

```sql
GRANT ALL PRIVILEGES ON [db_name].* to [user_name]@'%' IDENTIFIED BY '[password]';
```

- 따라서 아래와 같이 생성해주어야 한다.

```sql
# 유저 생성
CREATE USER [user_name]@'%' IDENTIFIED BY '[password]';

# 유저에게 [db_name] 데이터베이스에 대한 모든 권한 부여
GRANT ALL PRIVILEGES ON [db_name].* TO [user_name]@'%' WITH GRANT OPTION;

# 권한 변경 사항을 디스크에 저장하여 반영
FLUSH PRIVILEGES;
```

# 유저 조회

- 기본 스키마인 `mysql` 데이터베이스의 `user` 테이블에서 확인할 수 있다.

```sql
# mysql 스키마 선택
use mysql;

# user 이름 확인
select user from user;
```

# 유저 삭제

```sql
DROP USER [user_name]@'%';
```

# 데이터 삭제

```sql
DELETE FROM [table] WHERE [column]=[value];
```

# 참고자료

- [mysql 사용자추가/DB생성/권한부여](https://nickjoit.tistory.com/144) [티스토리]
- [[부스트코스 SQL] SQL 설치 및 데이터베이스 생성](https://velog.io/@injoon2019/SQL-SQL-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%EC%83%9D%EC%84%B1) [velog]
- [[MySQL] 데이터 삭제하기 DELETE, TRUNCATE](https://lightblog.tistory.com/151) [티스토리]