---
title: "WordPress 접속 느려지는 현상 해결방법"
date: 2022-09-04 23:00:00 +0900
categories: [42seoul]
tags: [born2beroot]
use_math: true
---

# 문제 상황

![1](/assets/images/2022/2022-09-04-born2beroot-improving-access-speed-to-wordpress/1.png)

가상 머신에 워드프레스를 정상적으로 설치하고 나중에 다시 로컬 컴퓨터에서 접속하려고 하니 접속하는데 1~2분 정도 걸렸다. 그리고 이미지도 깨져서 나타나는 현상이 발생했다.

# 원인 분석

초기에 워드프레스를 설정한 로컬 PC의 IP 주소와 현재 접속한 로컬 PC의 IP 주소가 달라서 발생하는 현상이다. IP 주소가 고정된 가상 머신과 달리 로컬 PC는 네트워크 접속 위치에 따라 IP 주소가 바뀌기 때문이다.

워드프레스 초기 설정 시, 로컬 PC 에서 설정하기 때문에 웹 서버 주소가 로컬 PC 의 IP 주소로 설정된다. 이는 MariaDB 의 wp_options 테이블에 접근하면 확인할 수 있다.

가상 머신에서 아래의 명령어를 입력한다.

```bash
# -u : 접속할 유저 이름
mysql -u root -p
```

root 계정으로 접속하여 비밀번호를 입력한 뒤, 워드프레스가 사용하는 데이터베이스에 접근한다.

```bash
use [워드프레스 DB명]
```

그 다음 아래의 SQL문을 입력하여 현재 워드프레스에 저장된 웹 서버 주소를 확인한다.

```sql
select * from wp_options where option_id < 3;
```

실행 결과는 다음과 같다.

```bash
+-----------+-------------+-------------------------------------+----------+
| option_id | option_name | option_value                        | autoload |
+-----------+-------------+-------------------------------------+----------+
|         1 | siteurl     | http://[초기설정 IP주소]:8080/wordpress | yes      |
|         2 | home        | http://[초기설정 IP주소]:8080/wordpress | yes      |
+-----------+-------------+-------------------------------------+----------+
```

현재 로컬 PC의 주소를 확인하기 위해서는 로컬 PC의 터미널에서 아래의 명령어를 입력한다.

```bash
ipconfig getifaddr en0
```

만약, 데이터베이스에 저장된 IP 주소와 현재 로컬 PC의 IP 주소가 다르다면 현재 로컬 IP 주소로 변경하면 문제가 해결된다.

# 문제 해결

MariaDB에서 아래의 SQL문을 입력하여 현재 로컬 PC의 IP 주소로 변경한다.

```sql
update wp_options
set option_value="http://[현재 로컬 IP주소]:8080/wordpress"
where option_id < 3;
```

다시 로컬 PC에서 워드프레스를 접속하면 빠르게 접속되면서 이미지도 정상적으로 출력되는 것을 확인할 수 있다.

![2](/assets/images/2022/2022-09-04-born2beroot-improving-access-speed-to-wordpress/2.png)

# 참고자료

- [WordPress(워드프레스) IP 변경하기](https://pyj92.tistory.com/23) [티스토리]
