---
title: "[Born2beroot] 8. WordPress 설치"
date: 2022-09-04 22:55:00 +0900
categories: [42seoul]
tags: [born2beroot]
use_math: true
---

# lighttpd

lighttpd는 적은 자원을 사용해서 높은 성능을 내는 오픈 소스 기반 웹 서버 애플리케이션이다. 공식 문서에 따르면 “라이티"라고 읽는다고 한다.

## lighttpd 설치

아래의 명령어를 입력해서 `lighttpd` 웹 서버를 설치한다.

```bash
sudo apt install lighttpd
```

웹 서버 설정 명령어는 다음과 같다.

```bash
sudo systemctl stop lighttpd.service		# 서버 중지
sudo systemctl start lighttpd.service		# 서버 시작
sudo systemctl enable lighttpd.service	# 부팅 시 서버 실행
sudo systemctl disable lighttpd.service	# 부팅 시 서버 실행 정지
```

## PHP 설치

워드 프레스는 DB와 정보를 주고 받기 위해 PHP를 사용한다.

PHP는 Personal HomePage tools 의 줄임말로 서버 사이드 프로그래밍 언어이다. 주로 HTML 코드를 동적으로 생성하기 위해 사용한다.

아래의 그림은 PHP의 동작 원리를 간략하게 표현한 것이다.

![php_works.png](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/php_works.png)

PHP를 설치하기 위해 아래의 명령어를 터미널에 입력한다.

```bash
sudo apt install php7.4-fpm
```

참고로 fpm은 FastCGI Process Manager 의 약자이다.

- CGI : Common Gateway Interface 의 약자로 웹 서버와 외부 프로그램을 연결하는 표준화 프로토콜이다. 정적 페이지가 아닌 동적 페이지를 처리해야 하는 경우에 사용한다. 클라이언트 요청마다 프로세스를 하나씩 생성하기 때문에 요청이 많아지면 서버 부담이 커진다.
- FastCGI : CGI의 단점을 보완하기 위해 하나의 프로세스로 여러 요청들을 처리하여 프로세스 생성 및 제거에 들어가는 부하를 줄인다. (멀티 스레딩) 클라이언트의 요청을 외부 PHP 프로그램에 전달하는 역할을 수행한다.

설치한 php fpm 과 lighttpd 를 연결하기 위해 `lighttpd` 의 fastcgi 설정 파일을 연다.

```bash
sudo vim /etc/lighttpd/conf-available/15-fastcgi-php.conf
```

아래의 내용을 주석처리한다.

```bash
"bin-path" => "/usr/bin/php-cgi",
"socket" => "/run/lighttpd/php.socket",
```

그 다음 아래의 내용을 추가하고 저장한다.

```bash
"socket" => "/var/run/php/php7.4-fpm.sock",
```

![1](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/1.png)

아래의 명령어를 입력하여 `lighttpd` 를 재시작 한다.

```bash
sudo lighttpd-enable-mod fastcgi
sudo lighttpd-enable-mod fastcgi-php
sudo service lighttpd force-reload
```

`lighttpd` 설정 파일에 의하면 기본 포트는 80번으로 되어 있다. 현재 과제에서는 `ufw` 방화벽을 사용하고 있기 때문에 해당 포트 번호를 열어주어야 한다.

```bash
sudo ufw allow 80
```

VirtualBox 의 포트 포워딩에서 다음과 같이 추가한다.

- Host IP / Host Port : 로컬 컴퓨터 IP 주소, 8080
- Guest IP / Guest Port : 가상 머신 IP 주소, 80

![2](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/2.png)

로컬 컴퓨터의 브라우저에서 `로컬 컴퓨터 IP주소:8080` 를 주소창에 입력하면 다음과 같은 페이지가 뜬다.

![3](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/3.png)

위의 페이지는 `ligthttpd.conf` 파일의 `server.document-root` 에 해당하는 디렉토리인 `/var/www/html/` 의 `index.lighttpd.html` 파일을 보여준 것이다.

해당 초기 페이지를 변경하고 PHP와 연동을 하기 위해 `/var/www/html/` 경로에 `info.php` 파일을 생성한다.

```php
<!-- info.php -->
<?php
	phpinfo();
?>
```

그 다음 로컬 컴퓨터의 브라우저에서 `로컬 컴퓨터 IP주소:8080/info.php` 로 접속하면 아래와 같이 FPM/FastCGI 가 정상적으로 적용된 것을 확인할 수 있다.

![4.png](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/4.png)

PHP 와 DB 를 연동하기 위한 패키지를 설치한다.

```php
sudo apt install php7.4-mysql
```

# MariaDB 설치

MariaDB는 MariaDB사에서 제작한 오픈소스 RDBMS 이다.

MariaDB는 MySQL의 커뮤니티 버전을 포크(fork)하는 RDBMS이며, MySQL과는 달리 상업용으로 사용해도 무료로 사용할 수 있다. 대부분의 리눅스에서는 MySQL 대신 MariaDB를 사용한다.

MySQL에서 사용하던 기능을 MariaDB에서도 사용할 수 있으며, 마이그레이션도 쉽게 진행할 수 있다.

아래의 명령어를 입력하여 MariaDB를 설치한다.

```bash
# -y 옵션은 설치 진행 시 yes 를 자동으로 입력하는 옵션이다.
sudo apt install mariadb-server mariadb-client -y
```

- `mariadb-server` : 실제로 서버에 데이터를 저장하는 프로그램
- `mariadb-client` : 클라이언트가 서버 데이터베이스에 접근할 때 사용하는 프로그램

아래는 DB 중지, 시작, 부팅 시 활성화 명령어이다.

```bash
sudo systemctl stop mysql.service			# 서버 중지
sudo systemctl start mysql.service		# 서버 시작
sudo systemctl enable mysql.service		# 부팅 시 서버 실행
sudo systemctl disable mysql.service	# 부팅 시 서버 실행 정지
```

아래의 명령어를 입력하여 보안 설정을 한다.

```bash
sudo mysql_secure_installation
```

DB의 root 계정 비밀번호 설정 등 여러 설정을 진행하는데, 전부 Y 를 입력하고 넘어가도 무방하다.

보안 설정이 끝나면 서비스를 재시작한다.

```bash
sudo systemctl restart mysql.service
```

## WordPress와 연동할 DB 생성

아래의 명령어를 입력하여 MariaDB로 진입할 수 있다. 패스워드는 MariaDB 보안설정 시 설정한 패스워드와 동일하다.

```bash
# -u : 접속할 유저 이름
sudo mysql -u root
```

SQL 문법을 사용해서 DB를 생성하고, 계정을 만들고 DB 접근 권한을 부여한다.

```bash
# DB 생성
CREATE DATABASE wpdb;
# 계정 생성 및 패스워드 설정
CREATE USER 'wp-user'@'localhost' IDENTIFIED BY 'wp-pw';
# 계정이 DB에 접근할 수 있는 모든 권한 부여
GRANT ALL ON wpdb.* TO 'wp-user'@'localhost' IDENTIFIED BY 'wp-pw' WITH GRANT OPTION;
# 설정을 마침
FLUSH PRIVILEGES;
# 종료
EXIT;
```

# WordPress 설치

## WordPress란?

워드프레스는 오픈소스 기반 설치형 블로그 또는 CMS이다.

- CMS : Contents Management System의 약자로 게시판, 레이아웃, 모듈 등을 쉽게 관리할 수 있는 프로그램이다.

언어는 PHP를 사용하고 있다. 설치형 블로그는 무료로 사용할 수 있고, CMS는 유료로 이용 가능하다.

특히, 해외에서 많이 사용되고 있으며, 국내 일부 기업에서도 워드프레스를 사용해서 블로그를 운영하고 있다.

### 장점

- 전 세계 많은 개발자들이 제작한 다양한 플러그인과 테마 사용 가능
- 웹 사이트를 완전히 커스텀 가능
- 일반적인 블로그와 달리 DB를 포함한 백엔드 영역까지 접근 가능

### 단점

- 사용법을 배우는 데 시간이 걸린다.
- 원하는 대로 커스텀 하기 위해서는 프로그래밍 언어에 능통해야 한다.
- 국내 자료가 부족하다.

## WordPress 다운

웹 상에 존재하는 워드 프레스 파일을 다운 받기 위해 `wget` 을 설치한다.

```bash
sudo apt install wget -y
```

워드 프레스 최신 파일을 다운 받는다.

```bash
# wget [option]... [URL]...
# -O : 다운 받을 경로 및 파일명 지정
sudo wget -O /tmp/wordpress.tar.gz "http://wordpress.org/latest.tar.gz"
```

다운받은 압축 파일을 해제한다.

```bash
sudo tar -xvzf /tmp/wordpress.tar.gz -C /var/www/html
```

`로컬 컴퓨터 IP주소:8080/wordpress` 에 접속하면 DB 설정 페이지가 표시된다.

![5](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/5.png)

웹에서도 DB를 설정할 수 있지만, CLI 환경에서 설정하는 방법은 다음과 같다.

## WordPress와 MariaDB 연동

아래의 명령어를 입력하여 WordPress 설정 파일을 편집한다.

```bash
sudo vim /var/www/html/wordpress/wp-config-sample.php
```

`DB_NAME`,`DB_USER`, `DB_PASSWORD` 항목을 SQL 문법을 사용해서 생성한 정보와 동일하게 입력한다.

![6](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/6.png)

그 다음 고유한 인증키를 설정하기 위해 아래 주소에 접속하여 표시되는 내용을 그대로 복사하여 붙여넣고 저장한다. 참고로 해당 페이지는 새로고침을 할 때마다 인증키가 바뀐다.

[https://api.wordpress.org/secret-key/1.1/salt/](https://api.wordpress.org/secret-key/1.1/salt/)

여기서 사용하는 salt 는 외부에서 사용자의 암호를 쉽게 파악하기 어렵도록 원본 데이터에 임의로 추가하는 데이터이다.

![7](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/7.png)

`wp-config-sample.php` 파일을 `wp-config.php` 로 파일명을 변경한다.

```bash
sudo mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
```

로컬 컴퓨터의 브라우저에서 `로컬 컴퓨터 IP주소:8080/wordpress` 에 접속하면 다음과 같은 페이지가 표시된다.

![8](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/8.png)

정보를 입력하고 Install WordPress 를 클릭한다.

입력한 정보로 로그인하면 다음과 같이 Dashboard 페이지가 표시된다.

![9.png](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/9.png)

# phpMyAdmin

phpMyAdmin 은 MySQL을 웹 브라우저에서 관리할 수 있는 도구이다.

## phpMyAdmin 설치

phpMyAdmin 파일을 wget 명령어를 이용해서 다운 받는다.

```bash
sudo wget -O /tmp/phpmyadmin.tar.gz "https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.tar.gz"
```

압축 해제할 폴더를 생성한다.

```bash
sudo mkdir /var/www/html/phpmyadmin
```

압축을 해제한다.

```bash
sudo tar -xvzf /tmp/phpmyadmin.tar.gz -C /var/www/html/phpmyadmin
```

php 관련 프로그램을 다운 받는다.

```bash
sudo apt install -y php*
```

phpmyadmin 패키지 설치시 다음과 같은 화면이 보인다. `No` 를 선택한다.

![10](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/10.png)

방향키로 lighttpd 를 선택하고 스페이스바로 선택한다. 그 다음 엔터를 입력한다.

![11](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/11.png)

lighttpd 서비스를 재시작한다.

```bash
sudo service lighttpd force-reload
```

로컬 PC 브라우저에서 다음의 주소로 접속한다.

```bash
[로컬 PC IP주소]:8080/phpmyadmin
```

다음과 화면이 뜬다.

![12.png](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/12.png)

사용자명에는 MariaDB 설정 시 사용했던 `DB_USER` , 암호에는 `DB_PASSWORD` 를 입력해서 로그인한다.

![13.png](/assets/images/2022/2022-09-04-born2beroot-install-wordpress/13.png)

위와 같은 화면이 뜨면 정상적으로 설치된 것이다.

# 참고자료

- [워드프레스](https://namu.wiki/w/%EC%9B%8C%EB%93%9C%ED%94%84%EB%A0%88%EC%8A%A4) [나무위키]
- [워드프레스란?](https://news.wp-kr.com/wordpress-start-guide/) [워드프레스웹코리아]
- [워드프레스란 뭐임? 장점과 단점에 대해 알아봄](https://gentlysallim.com/%EC%9B%8C%EB%93%9C%ED%94%84%EB%A0%88%EC%8A%A4%EB%9E%80-%EB%AD%90%EC%9E%84-%EC%9E%A5%EC%A0%90%EA%B3%BC-%EB%8B%A8%EC%A0%90%EC%97%90-%EB%8C%80%ED%95%B4-%EC%95%8C%EC%95%84%EB%B4%84/) [gentlysallim]
- [lighttpd](https://www.lighttpd.net/) [lighttpd.net]
- [Description of core php.ini directives](https://www.php.net/manual/en/ini.core.php#ini.cgi.fix-pathinfo) [php.net]
- [Why WordPress Uses PHP?](https://code.tutsplus.com/tutorials/why-wordpress-uses-php--cms-31077) [envatotuts]
- [PHP #1\_ 웹 서버와 PHP란?](https://doorbw.tistory.com/29) [티스토리]
- [PHP 동작 원리](http://www.tcpschool.com/php/php_intro_works) [TCP School]
- [[MariaDB] MariaDB란 무엇일까? MariaDB 소개 (MariaDB Overview)](https://engkimbs.tistory.com/931) [티스토리]
- [[database] mysql과 mariaDB 중 어떤 DB가 나에게 맞을까?](https://sabarada.tistory.com/164) [티스토리]
- [phpMyAdmin](https://ko.wikipedia.org/wiki/PhpMyAdmin) [위키백과]
- [Ubuntu에서 PHP, MariaDB 및 PhpMyAdmin을 사용하여 Lighttpd를 설치하는 방법](https://ko.linux-console.net/?p=1185) [Linux-Console.net]
