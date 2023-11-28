---
title: "[MySQL] 데이터베이스 옮기는 방법(data migration)"
date: 2023-11-28 18:10:00 +0900
categories: [mysql]
tags: []
---

# 상황 설명

- 기존에 사용하던 AWS EC2 인스턴스에서 다른 계정의 EC2 인스턴스로 웹 서비스를 옮기는 작업을 해야 했다.
- 환경
    - OS : ubuntu 22.04
    - 데이터베이스 : MySQL

# mysqldump 로 데이터베이스 백업하기

- `mysqldump` 를 사용하면 데이터에베이스에 저장된 자료들을 데이터베이스 이름, 테이블 정의, 데이터 삽입 등 모든 것을 sql 문으로 변환한다.
    - `mysqldump` 는 `mysql` 을 설치하면 함께 설치되는 프로그램이다.
- 이를 sql 확장자 파일로 저장하고, `mysql` 명령어의 표준 입력으로 넣어주면 백업한 데이터를 그대로 옮길 수 있다.
- 아래의 명령어를 실행하면 현재 working directory 에 `backup.sql` 파일을 생성한다.
    
    ```bash
    sudo mysqldump [database_name] > backup.sql
    ```
    
    - `database_name` : 백업을 하고자 하는 database 이름을 입력한다.
- 만약, 기존 database 이름을 그대로 옮기고 싶다면 `--databases` 옵션을 추가하면 된다.
    
    ```bash
    sudo mysqldump --databases [database_name] > backup.sql
    ```
    

# mysql 로 데이터 옮기기

- 위에서 저장한 sql 파일을 새로 옮기고자 하는 EC2 인스턴스에 그대로 가져와서 저장한다.
- 그 다음 아래의 명령어를 입력한다.
    
    ```bash
    mysql -uroot -p < backup.sql
    ```
    
- root 계정의 비밀번호를 입력하고 엔터를 치면 자동으로 데이터베이스부터 테이블 정의, 기존 데이터까지 모두 생성된다.

# 참고자료

- [[Database] MySQL dump로 데이터 가져오기](https://velog.io/@goatyeonje/Database-MySQL-dump로-데이터-가져오기) [velog]
- [[mysql] DB 백업(dump)을 위한 mysqldump사용법](https://devpouch.tistory.com/114) [티스토리]