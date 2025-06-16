---
title: "Redis 개념, 장점과 단점, Docker 사용 예시 정리"
date: 2023-10-03 23:56:00 +0900
categories: [redis]
tags: [redis]
---

# Redis

## 등장 배경

서버 프로그램이 데이터를 영구적으로 저장하기 위해서 데이터베이스를 사용한다. 데이터베이스는 주로 데이터 간의 관계를 정의한 RDBMS(Relational DataBase Management System)를 사용한다.

RDBMS는 데이터 간의 복잡한 관계를 보여줄 때 매우 효과적이다. 하지만 하드 디스크에 데이터를 저장하고 읽다보니 처리해야 하는 쿼리가 많아지면 연산이 느려질 수 밖에 없다.

이러한 RDBMS의 단점을 극복하기 위해 RDBMS 방식을 탈피한 NoSQL이 등장했다. NoSQL는 아래와 같이 여러 종류가 존재한다.

- 연관된 그래프 형식의 데이터를 저장하는 Graph Store
- Column 위주로 데이터를 저장하는 Column Store
- 비정형 대량 데이터를 저장하기 위한 Document Store
- 메모리 기반으로 빠르게 데이터를 읽고 저장하는 Key-Value Store

## Redis란 무엇인가?

Redis는 NoSQL 중에서 Key-Value Store에 해당한다.

**Re**mote **Di**ctionary **S**erver의 약자로 ‘원격 사전형 자료구조 서버’로 해석할 수 있다.

### 장점

1. RDBMS는 디스크를 기반으로 작동하지만, Redis는 메모리 기반 데이터베이스이기 때문에 속도가 훨씬 빠르다.
2. 길고 복잡한 쿼리의 결과를 캐싱해두고, 쿼리의 결과가 바뀔 수 있는 이벤트가 발생할 때마다 캐싱하면 서비스 속도를 향상시킬 수 있다.

### 단점

1. 메모리 기반 저장소이기 때문에 별도의 백업 처리 없이 서버가 종료되거나 재시작하면 데이터를 잃을 수 있다.
2. 싱글 스레드로 작동하기 때문에 다중 처리나 동시성이 요구되는 작업에는 적합하지 않다.

### 참고. 디스크 I/O 가 메모리(RAM)에 접근하는 것보다 느린 이유?

이를 이해하기 위해서는 하드웨어 관점에서 메모리를 살펴볼 필요가 있다. 메모리는 RAM 과 ROM 으로 구분할 수 있다.

**1. RAM(Random Access Memory)**

램은 내부적으로 저장하는 공간을 따로 마련하지 않아서 전류가 흐르지 않으면 데이터가 사라진다. 어떤 위치에 쓰여있는 데이터든 동일한 시간에 접근하며, 시간복잡도는 O(1)이다.

2**. ROM(Read Only Memory)**

롬은 소자(전자 부품) 사이에 0과 1을 저장할 수 있는 공간이 있어서 전류가 흐르지 않더라도 데이터가 보존된다. 기본적으로 읽기 작업만 가능하지만, 기술이 발전하면서 쓰기 작업도 가능해져서 이름 자체의 의미는 많이 희미해졌다. 읽고 쓰는 것이 가능한 플래시 메모리는 크게 아래와 같이 구분된다.

- NAND 게이트 기반
    - SSD, USB 에 사용
    - 데이터를 저장하는 공간(셀)이 직렬 형태로 이루어져있어서 데이터를 순차적으로 읽어내기 때문에 Read 는 느리다.
    - 메모리의 블록이 여러 페이지로 나누어져 있어서 Write 와 Erase 는 빠르다.
    - 삼성, SK 하이닉스에서 주로 제조하는 제품.
- NOR 게이트 기반
    - 컴퓨터 바이오스, 펌웨어 저장에 사용
    - 셀이 병렬 형태로 이루어져 있어서 Random Access 로 Read 속도가 빠르다.
    - 반대로 Write나 Erase는 모든 블록을 지워야 하기 때문에 속도가 느리다.

참고로 HDD는 ROM이 아니다. 기술의 발전으로 SDD가 HDD처럼 사용 가능해졌기 때문에 이 글에서 디스크는 SDD 를 의미한다. 즉, 디스크 I/O 가 메모리에 접근하는 것이 느린 이유는 SDD가 NAND 게이트 기반 플래시 메모리이고 데이터를 순차적으로 읽기 때문에 Random Access가 불가능하기 때문이다.

## 자료구조

Redis는 Strings, Set, Sorted Set, Hash, List 등 다양한 자료구조를 제공한다.

![1.png](/assets/images/2023/2023-10-03-about-redis/1.png)

출처: [redisforum](https://forum.redis.com/t/about-redis-commands-data-structures/13)

모든 자료구조를 다루기에는 양이 많기 때문에 일부만 살펴보자.

### Strings

- 일반적인 문자열
- 최대 512MB 크기를 가지며, binary data, JPEG 이미지도 저장 가능
- 단순 증감 연산에 유리함

```bash
redis> SET num 42
"OK"
redis> GET num
"42"
redis> incr num
(integer) 43
redis> GET num
"43"
```

### Lists

- string 의 연결 리스트. 데이터를 순서대로 저장한다.
- 중간에 데이터를 추가하거나 삭제하는 연산이 느리다. 그래서 연결 리스트의 맨 앞이나 맨 끝에서 데이터를 추가하거나 삭제한다. (push, pop 연산)
- 메세지 큐로 사용하기 적절하다.
    - 메세지 큐는 다른 프로세스와 데이터를 통신을 하기 위한 방법이다.
    - 메세지를 전송하는 생산자(Producer)로 취급되는 컴포넌트가 메세지를 메세지 큐에 추가한다.
    - 해당 메세지는 소비자(Consumer)로 취급되는 다른 컴포넌트가 메세지를 검색하고 사용해서 어떤 작업을 수행할 때까지 메세지 큐에 저장된다.
    - 각 메세지는 하나의 소비자에 의해 한 번만 처리될 수 있기 때문에 메세지 큐를 이용하는 방식을 일대일 통신이라고 부른다.
    - 예를 들어, 사이트에서 회원가입용 메일 전송, 비밀번호 재설정 메일 전송 등 다양한 이메일 서비스가 있다고 해보자. 각 서비스는 이메일을 메세지 큐에 넣는다. 이메일 전송 전용 서비스(메세지 큐)는 어느 서비스가 생산자(Producer)인지 상관없이 소비자(Consumer)가 메세지 큐에 쌓인 메세지를 처리한다. 즉, 이메일이 보내져야 하는 곳으로 반드시 이메일이 전송된다는 것이다.

![2.png](/assets/images/2023/2023-10-03-about-redis/2.png)

        출처: [메시지 큐에 대해 알아보자!](https://tecoble.techcourse.co.kr/post/2021-09-19-message-queue/) [Tecoble]

    - Redis에 적용하면, 소셜 네트워크의 타임라인 기능을 구현할 때 새로운 글이 올라오면 `LPUSH` 로 추가하고, `LRANGE` 명령어를 사용해서 일정한 개수의 데이터를 고정적으로 반환할 수 있다.

## 사용법

Redis 는 key-value 데이터 구조로 간단하게 데이터를 다룰 수 있다.

데이터 입력, 수정, 삭제, 조회에 대해 아래와 같은 명령어를 제공한다.

| 종류 | 역할 |
| --- | --- |
| set | 데이터 저장 |
| get | 데이터 조회 |
| rename | 저장된 key 를 다른 이름을 가진 key 로 변경 |
| randomkey | 저장된 key 중에서 하나의 임의의 key 를 조회 |
| keys | 저장된 모든 key 를 검색 |
| exists | 검색 대상 key 의 존재 여부 확인 |
| mset | 여러 개의 데이터 저장 |
| mget | 여러 개의 데이터 조회 |

redis 의 명령어를 cli 환경에서 사용하는 예시는 아래와 같다.

```bash
redis> SET num 42
"OK"
redis> GET num
"42"
redis> RENAME num wow
"OK"
redis> GET wow
"42"
```

## Memcached 와 차이

Memcached도 key-value 모델을 기반으로 하는 NoSQL 이다. 다만 Redis가 Memcached보다 더 많은 기능을 지원하고 있다.

### Memcached 의 장점

1. 정적 데이터 캐싱에 효과적이다.
    - HTML 과 같은 정적 데이터를 캐싱할 때 효율적이다.
    - metadata 에 적은 자원을 사용하기 때문에 단순한 내부 메모리 관리에는 효율이 좋다.
2. 멀티 스레드 지원
    - 컴퓨팅 자원을 추가함으로써 스케일 업이 가능하다.

### Redis 를 사용하는 이유?

Memcached 대신 Redis 를 주로 사용하는 이유는 아래와 같이 정리할 수 있다.

1. 다양한 자료구조 및 용량 지원
    - Memcached 는 key 이름을 250byte 까지 제한하고, 자료구조는 string 만 사용한다.
    - Redis 는 key, value 의 이름을 512MB 까지 지원하고, hash, set, list 등 다양한 자료구조를 지원하기 때문에 데이터 조작이 편리하다.
2. 다양한 삭제(eviction) 정책 지원
    - 캐시는 메모리에 오래된 데이터를 삭제해서 새로운 데이터 공간을 확보하는 data eviction 방식을 사용한다.
    - Memcached 는 LRU(Least Recently Used) 알고리즘을 사용하기 때문에 새로운 데이터와 크기가 비슷한 데이터를 임의로 제거한다.
    - Redis 는 사용자가 6가지 다른 데이터 삭제 정책을 선택할 수 있으며, 메모리 관리와 데이터 삭제 선택을 더욱 정교하게 다룰 수 있다.
3. 디스크 영속화(persistence) 지원
    - Redis 는 디스크(HDD)에 데이터를 영구적으로 저장할 수 있다.
    - 그래서 Redis 의 데이터들은 서버 충돌이나 재부팅 시에도 복구될 수 있다는 장점이 있다.
4. 복제(replication) 지원
    - Redis 는 동일한 데이터를 같은 물리 서버의 다른 포트 번호를 사용하는 복제본을 만들거나, 물리적으로 다른 장치에 복제할 수 있다. (데이터 이중화)
    - 마스터 노드가 정상적으로 작동하지 않는 경우 레플리카(복제본)을 마스터 노드로 변경하여 서비스를 지속적으로 운영할 수 있다. 이를 Redis Sentinel 이 담당한다.
5. 트랜잭션(transaction) 지원
    - Memcached 도 처리가 모두 성공하거나 모두 실패하는 원자성을 보장하지만, Redis 는 트랜잭션을 지원한다. 즉, 트랜잭션의 4가지 특성 ACID 를 모두 보장한다는 것이다.

# WordPress와 연동하기

Redis를 WordPress에 연동함으로써 웹 페이지 로딩 속도를 향상시킬 수 있다.

![3.png](/assets/images/2023/2023-10-03-about-redis/3.png)

출처: [워드프레스 속도 개선을 위한 오브젝트 캐시 적용법](https://happist.com/574008/%EC%9B%8C%EB%93%9C%ED%94%84%EB%A0%88%EC%8A%A4-%EC%98%A4%EB%B8%8C%EC%A0%9D%ED%8A%B8-%EC%BA%90%EC%8B%9C-%EC%A0%81%EC%9A%A9%EB%B2%95) [꿈꾸는섬]

WordPress를 이용할 때 사용하는 캐시는 크게 브라우저 캐시, 페이지 캐시, 오브젝트 캐시가 존재한다.

- 브라우저 캐시 : 사용자의 브라우저에 저장하는 캐시이다. 브라우저는 방문했던 사이트의 데이터를 브라우저 캐시에 저장하기 때문에 다시 방문했을 때 빠른 속도로 페이지를 불러올 수 있다.
- 페이지 캐시 : 웹 서버(Nginx)는 사용자가 요청했던 페이지 정보를 저장하고, 다른 사용자가 해당 페이지를 요청하면 저장했던 정보를 바로 보여준다.
- 오브젝트 캐시 : 페이지를 동적으로 생성(마이 페이지 등)하기 위해 PHP에서 데이터베이스를 접속한다. 데이터베이스에 접속한다는 것은 하드디스크에 접근한다는 의미인데, Redis를 이용하면 하드디스크가 아닌 메모리에서 필요한 데이터를 빠르게 제공할 수 있다.

Redis는 사용자의 정보 뿐만 아니라 HTML 페이지도 캐싱하기 때문에 더욱 빠른 속도로 페이지를 제공할 수 있다는 장점이 있다.

Redis를 사용하는 웹 사이트는 평균 10%~30% 정도 빠르게 페이지를 불러온다는 결과가 있다. (출처: [GreenGeeks](https://www.greengeeks.com/tutorials/redis-wordpress/))

## Docker 이용해서 Redis 설치하기

이번 글에서는 Dockerhub 에서 이미 만들어진 이미지가 아닌 직접 만든 이미지로 설치하고자 한다.

### docker-compose.yml

아래는 docker-compose.yml 파일의 내용이다.

```yaml
version: "3"

services:
  nginx:
    container_name: nginx
    build: ./requirements/nginx
    image: nginx
    ports:
      - 443:443
    restart: on-failure:3
    volumes:
      - wordpress_data:/var/www/html/wordpress
    networks:
      - my_server

  mariadb:
    container_name: mariadb
    build: ./requirements/mariadb
    image: mariadb
    restart: on-failure:3
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - my_server
    env_file:
      - .env

  wordpress:
    container_name: wordpress
    image: wordpress
    depends_on:
      - mariadb
    build: ./requirements/wordpress
    restart: on-failure:3
    volumes:
      - wordpress_data:/var/www/html/wordpress
    networks:
      - my_server
    env_file:
      - .env

  redis:
    container_name: redis
    image: redis
    depends_on:
      - wordpress
    build: ./requirements/bonus/redis
    restart: on-failure:3
    networks:
      - my_server

volumes:
  wordpress_data:
    driver: local
    driver_opts:
      type: none
      device: /Users/joonhan/data/wordpress
      o: bind
  mariadb_data:
    driver: local # Save in host OS (Available for other volume plugin)
    driver_opts:
      type: none # File system type (like tmpfs, shm, ramfs)
      device: /Users/joonhan/data/mysql
      o: bind

networks:
  my_server:
    driver: bridge
```

### Redis Dockerfile

아래는 Redis의 Dockerfile 이다.

```docker
# Base image
FROM alpine:3.16

RUN apk update

RUN apk add --no-cache dumb-init redis

# Set memory usage limit and data eviction policy
RUN echo "maxmemory 100mb" >> /etc/redis.conf
RUN echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf

# Expose port 6379
EXPOSE 6379

# Start dumb-init for PID 1
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["redis-server", "--protected-mode", "no"]
```

**maxmemory 및 data eviction 정책 설정**

```bash
# Set memory usage limit and data eviction policy
RUN echo "maxmemory 100mb" >> /etc/redis.conf
RUN echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf
```

redis 는 데이터를 메모리(RAM)에 저장하기 때문에 하드디스크에 비해 적은 데이터를 저장할 수 있다.

그렇기 때문에 악의적인 의도를 가진 클라이언트가 메모리를 과도하게 많이 사용하는 것을 방지하기 위해 최대 메모리 사용량을 `maxmemory` directive 를 이용해서 설정할 수 있다.

또한, 데이터가 메모리가 아닌 swap 영역에 저장되지 않도록 방지하기 위해 사용할 수 있다.

`maxmemory` 의 최대 한도는 정해져 있지 않다.

그래서 물리적인 메모리 용량 이상을 사용하면 하드디스크에 존재하는 swap 영역으로 옮겨진다. 하드디스크에 접근하는 속도는 메모리에 접근하는 속도보다 느리기 때문에 swap 영역까지 사용하는 것은 redis 를 사용하는 목적에 부합하지 않다.

따라서 `maxmemory` 를 설정하여 빠른 데이터 제공을 보장해주는 것이 바람직하다.

그리고 메모리의 데이터를 지울 때 어떤 방식으로 지울 것(data eviction)인지 설정할 수 있다.

`maxmemory` 가 설정되고, 별도의 정책을 설정하지 않았다면 `maxmemory` 에 도달하는 순간 오류를 발생시킨다.

다양한 종류가 있지만 여기서는 최근에 가장 적게 쓰인 데이터를 삭제하는 LRU(Least Recently Used) 알고리즘을 설정했다.

자세한 내용은 [redis 공식 홈페이지](https://redis.io/docs/reference/eviction/)에서 확인 가능하다.

**redis protected mode**

CMD 명령어에 인자로 `--protected-mode no` 가 입력된 것을 확인할 수 있다.

redis 3.2.0 버전부터 protected mode 는 무분별한 공격을 막기 위해 도입되었다.

redis도 소켓을 이용한 통신을 하기 때문에 IP 주소와 redis 가 사용하는 포트 번호를 알면 누구든 접속해서 데이터를 확인할 수 있다.

이러한 문제를 막기 위해 Redis 는 기본 설정을 사용하는데 비밀번호를 설정하지 않은 경우 protected mode 를 사용하도록 설정했다.

이 모드는 외부의 접속 시도를 막고, 오직 루프백(자기 자신)만 접속을 허용한다.

현재 구성한 컨테이너 환경은 redis 가 WordPress 컨테이너와 다른 컨테이너를 사용하고 있다.

즉, redis 컨테이너와 WordPress 컨테이너는 다른 IP 주소를 가지고 있기 때문에 WordPress 에서 redis 로 접속을 시도하려고 해도 아래와 같은 오류 메세지를 표시한다.

> `SELECT` failed: DENIED Redis is running in protected mode because protected mode is enabled and no password is set for the default user. In this mode connections are only accepted from the loopback interface. If you want to connect from external computers to Redis you may adopt one of the following solutions: 1) Just disable protected mode sending the command 'CONFIG SET protected-mode no' from the loopback interface by connecting to Redis from the same host the server is running, however MAKE SURE Redis is not publicly accessible from internet if you do so. Use CONFIG REWRITE to make this change permanent. 2) Alternatively you can just disable the protected mode by editing the Redis configuration file, and setting the protected mode option to 'no', and then restarting the server. 3) If you started the server manually just for testing, restart it with the '--protected-mode no' option. 4) Setup a an authentication password for the default user. NOTE: You only need to do one of the above things in order for the server to start accepting connections from the outside.
>

따라서 현재 구성한 환경에서 redis 를 정상적으로 작동시키기 위해서는 protected mode 를 해제해주어야 한다.

### WordPress Dockerfile

WordPress 컨테이너를 위한 Dockerfile 은 아래와 같다.

```docker
# Base image
FROM alpine:3.16

# Install necessary packages

RUN apk update

RUN apk add --no-cache \
    dumb-init \
    curl \
    ca-certificates

RUN apk add --no-cache \
    php-fpm \
    php-opcache \
    php-mysqli \
    php-pdo_mysql \
    php-json \
    php-xml \
    php-gd \
    php-dom \
    php-zip \
    php-curl \
    php-openssl \
    php-mbstring \
    php-ctype \
    php-tokenizer \
    php-simplexml \
    php-fileinfo \
    php-exif \
    php-cli \
    php-gd \
    php-phar \
    mariadb-client

# Create directories for wordpress
RUN mkdir -p /var/www/html/wordpress

# Download wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy php-fpm configuration file
COPY ./conf/www.conf /etc/php8/php-fpm.d/

RUN chmod +x /usr/bin/dumb-init
COPY ./tools/entrypoint.sh /entrypoint.sh

# Expose port 9000 for php-fpm
EXPOSE 9000

WORKDIR /var/www/html/wordpress

# Start dumb-init for PID 1
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start php-fpm in the foreground
CMD ["/bin/sh", "/entrypoint.sh"]
```

여기서 WORKDIR 을 `/var/www/html/wordpress` 를 설정하는 이유는 이어지는 `entrypoint.sh` 파일에서 설명할 것이다.

```bash
#!/bin/sh

# Update WP-CLI to the latest stable release.
wp cli update

# Download and extracts WordPress core files to the specified path.
wp core download --allow-root --path="$WP_PATH"

# Generates a wp-config.php file.
wp config create --dbname="$MARIA_DB_DATABASE" --dbuser="$MARIA_DB_USER" \
				 --dbpass="$MARIA_DB_PASSWORD" --dbhost="$MARIA_DB_HOST" \
				 --path="$WP_PATH" \
				 --extra-php <<PHP
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', ${REDIS_PORT});
PHP

# Creates the WordPress tables in the database using the URL, title, and default admin user details provided
wp core install --allow-root --url="$WP_DOMAIN" --title="$WP_TITLE" \
				--admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PWD" \
				--admin_email="$WP_ADMIN_EMAIL" --skip-email --path="$WP_PATH"

# Creates a new user
wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PWD" \
				--path="$WP_PATH"

# Install redis-cache plugin
wp plugin install redis-cache --activate --path="$WP_PATH"

# Enable redis-cache plugin
wp redis enable

# Set ownership of WordPress files to www-data
adduser -D -S -G www-data www-data
chown -R www-data:www-data /var/www/html/wordpress

# Execute PHP FastCGI in foreground
php-fpm8 -F
```

**WORDIR 을 설정하는 이유**

`wp config create` 명령어를 사용할 때 발생하는 오류 때문에 설정했다.

2023년 5월에는 WORKDIR 을 별도로 설정하지 않아도 오류가 발생하지 않았다.

하지만, 2023년 10월에 다시 시도해보니 아래와 같은 오류 메시지가 표시됐다.

> PHP Warning:  file_get_contents(phar://wp-cli.phar/vendor/wp-cli/wp-cli/templates/phar://usr/bin/wp/vendor/wp-cli/config-command/templates/wp-config.mustache): Failed to open stream: phar error: "vendor/wp-cli/wp-cli/templates/phar:/usr/bin/wp/vendor/wp-cli/config-command/templates/wp-config.mustache" is not a file in phar "wp-cli.phar" in phar:///usr/bin/wp/vendor/wp-cli/wp-cli/php/utils.php on line 605
Error: Could not create new 'wp-config.php' file.
Error: Strange wp-config.php file: wp-settings.php is not loaded directly.
Error: Strange wp-config.php file: wp-settings.php is not loaded directly.
>

**`wp config create` 사용 시 redis 관련 설정 추가**

—extra-php 옵션을 이용해서 redis port 와 host 이름을 지정해주었다.

host 이름은 redis 컨테이너의 이름으로 지정하면 된다.

redis port 는 .env 파일로 전달하는 환경변수 값을 입력했다.

redis 기본 포트는 6379 이지만, 보안을 높이고자 한다면 다른 포트 번호를 사용하는 것이 권장된다.

```bash
wp config create --dbname="$MARIA_DB_DATABASE" --dbuser="$MARIA_DB_USER" \
				 --dbpass="$MARIA_DB_PASSWORD" --dbhost="$MARIA_DB_HOST" \
				 --path="$WP_PATH" \
				 --extra-php <<PHP
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', ${REDIS_PORT});
PHP
```

**wordpress ‘activate’와 ‘enable’의 차이**

```bash
# Install redis-cache plugin
wp plugin install redis-cache --activate --path="$WP_PATH"

# Enable redis-cache plugin
wp redis enable
```

`wp plugin install` 명령어의 옵션으로 activate 를 추가했는데, 그 다음 명령어에서 `wp redis enable` 을 추가로 입력했다.

찾아보니 activate 는 WordPress 가 플러그인의 메인 스크립트를 불러오고,  DB 테이블을 추가하는 등 기본 세팅을 실행하는 과정이라고 한다. (출처 : [wordpress developer](https://developer.wordpress.org/plugins/plugin-basics/activation-deactivation-hooks/))

enable 은 activate 된 플러그인을 사용 가능하게 만드는 명령어라고 한다.

비유로 설명하자면, 콘센트마다 전원 스위치가 있는 멀티탭이 있다고 해보자.

콘센트에 플러그를 꽂는 것 자체는 activate 에 해당하고, enable 은 꽂은 플러그를 실제로 사용할 수 있게 스위치를 키는 것에 해당한다.

# 참고자료

- [레디스Redis가 뭐에요? 레디스 설치하기, 레디스 튜토리얼](https://sihyung92.oopy.io/database/redis/1) [sihyung92.oopy.io]
- [[Redis] Redis란? & Redis 사용방법](https://seokhyun2.tistory.com/63) [티스토리]
- [[REDIS] 📚 자료구조 명령어 종류 & 활용 사례 💯 총정리](https://inpa.tistory.com/entry/REDIS-%F0%9F%93%9A-%EB%8D%B0%EC%9D%B4%ED%84%B0-%ED%83%80%EC%9E%85Collection-%EC%A2%85%EB%A5%98-%EC%A0%95%EB%A6%AC) [티스토리]
- [[NHN FORWARD 2021] Redis 야무지게 사용하기](https://www.youtube.com/watch?v=92NizoBL4uA) [유튜브]
- [[개념원리]Message Queue](https://velog.io/@power0080/Message-Queue-%EA%B0%9C%EB%85%90-%EC%A0%95%EB%A6%AC) [velog]
- [In-memory Redis vs Memcached 비교하기](https://escapefromcoding.tistory.com/704) [티스토리]
- [[Redis] 복제 Replication 이중화 방법, 위험성, 이중화정보 확인 방법](https://mozi.tistory.com/372) [티스토리]
- [Redis의 특징, 개념, 장점, 단점, 목적](https://upcurvewave.tistory.com/354) [티스토리]
- [[Redis] master-slave(replication) 구축하기](https://www.happykoo.net/@happykoo/posts/51) [티스토리]
- [Redis Eviction 정책을 적용하여 효율적인 캐시 띄우기](https://chagokx2.tistory.com/102) [티스토리]
- [[데이터베이스] 트랜잭션의 ACID 성질](https://hanamon.kr/%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4-%ED%8A%B8%EB%9E%9C%EC%9E%AD%EC%85%98%EC%9D%98-acid-%EC%84%B1%EC%A7%88/) [티스토리]
- [관계형 데이터베이스란 무엇인가요?](https://cloud.google.com/learn/what-is-a-relational-database?hl=ko) [google cloud]
- [[개발상식] 메모리란(DISK IO가 느린 이유, 램이 사용되는 곳)](https://frozenpond.tistory.com/156) [티스토리]
- [NAND, NOR flash Memory에 대해 알아보자](https://amanan1004.tistory.com/27) [티스토리]
- [소자](https://namu.wiki/w/%EC%86%8C%EC%9E%90) [나무위키]
- [ROM](https://namu.wiki/w/ROM) [나무위키]
- [하드 디스크 드라이브](https://namu.wiki/w/%ED%95%98%EB%93%9C%20%EB%94%94%EC%8A%A4%ED%81%AC%20%EB%93%9C%EB%9D%BC%EC%9D%B4%EB%B8%8C) [나무위키]