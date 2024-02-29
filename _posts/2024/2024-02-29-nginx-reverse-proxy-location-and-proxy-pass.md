---
title: "[nginx] 리버스 프록시 적용 시 location URL 와 proxy_pass URL 의 trailing slash 에 따른 차이 정리"
date: 2024-02-29 22:45:00 +0900
categories: [infra]
tags: [nginx]
---

# 실행 환경

- docker compose 를 이용해서 로컬 호스트에 총 3개의 컨테이너를 실행했다.
- 프론트 컨테이너에 nginx 를 실행시키고, nginx 가 백엔드 컨테이너로 api 요청을 전달해주도록 네트워크를 분리했다.
- 그림으로 표현하면 아래와 같다.
  ![1.png](/assets/images/2024/2024-02-29-nginx-reverse-proxy-location-and-proxy-pass/1.png)
- 즉, 네트워크를 (프론트-백엔드)를 묶고 (백엔드-DB)를 묶어서 총 2개의 네트워크를 만들었다.

## docker-compose.yaml

아래는 docker compose 파일의 내용이다.

```yaml
version: "3"

services:
  frontend:
    container_name: frontend
    build:
      context: ./frontend
      dockerfile: Dockerfile
    image: frontend
    ports:
      - 80:80
    restart: on-failure:3
    networks:
      - front-connection
    depends_on:
      - backend
      - mysql

  backend:
    container_name: backend
    build:
      context: ./backend
      dockerfile: Dockerfile
    image: backend
    expose:
      - 3000
    restart: on-failure:3
    networks:
      - front-connection
      - db-connection
    env_file:
      - ./backend/sql_app/.env
    depends_on:
      mysql:
        condition: service_healthy

  mysql:
    container_name: mysql
    image: mysql:8.0.36
    restart: on-failure:3
    expose:
      - 3306
    networks:
      - db-connection
    healthcheck:
      test: mysqladmin ping -h 127.0.0.1 -u $$MYSQL_USER --password=$$MYSQL_PASSWORD
      start_period: 5s
      interval: 5s
      timeout: 5s
      retries: 55
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      TZ: "Asia/Seoul"
    env_file:
      - .env.db

volumes:
  mysql-data:

networks:
  front-connection:
    driver: bridge
  db-connection:
    driver: bridge
```

## nginx 설정 파일

- 프론트는 Angular 빌드 후 nginx 를 이용해서 정적 파일을 전달하도록 했다.
  - 빌드 후 생성 파일은 컨테이너의 `/usr/share/nginx/html` 경로에 저장했다.
- 프론트에서 백엔드로 요청을 보낼 때는 `http://localhost/api` 경로로 요청하도록 했다.
  - 예를 들어, 프론트에서 `http://localhost/api/me` 요청을 보내면 백엔드에서는 `/me` 에 해당하는 컨트롤러가 응답해서 서비스 로직을 실행한다.
- 백엔드로 보내는 요청들은 nginx 가 리버스 프록시로 백엔드 컨테이너로 전달해준다.
- nginx 설정 파일은 아래와 같이 작성했고, 정상적으로 작동했다.

```
upstream backend {
    server backend:3000;
}

server {
    listen 80;

    server_name localhost;

    root      /usr/share/nginx/html;
    index     index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 웹 애플리케이션 서버로의 프록시 설정
    location /api/ {
        proxy_pass http://backend/; # backend 컨테이너의 3000 포트로 트래픽 전달
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

# 문제 상황

하지만 `location /api` 로 작성했을 때와, `location /api/` 로 작성했을 때 다르게 작동했다.

- `/api` 로 설정하면 nginx 에서 404 Not Found 오류를 표시했다.
- 반면, `/api/` 로 설정하면 정상적으로 요청이 처리된다.

`proxy_pass` 의 경로에 trailing slash 를 붙이고, `location /api/` 로 설정해야 백엔드에서 정상적으로 요청에 응답한다.

즉, 아래와 같이 작성해야 원하는 대로 리버스 프록시를 구현할 수 있었다.

```
location /api/ {
        proxy_pass http://backend/; # backend 컨테이너의 3000 포트로 트래픽 전달
}
```

다르게 작동하는 원인이 무엇인지 궁금해서 `proxy_pass` 의 URL 끝에 슬래시 여부와 `location` URL 끝에 슬래시 여부에 따른 실행 결과를 비교해서 아래의 표와 같이 정리했다.

## 설정 값에 따른 변화 비교

`proxy_pass` 에 trailing slash 의 여부와 `location` 의 경로에 trailing slash 의 여부에 따라 총 4가지 경우의 수가 생긴다.

이때, 프론트에서 nginx 로 보내는 요청은 `http://localhost/api/me` 로 동일하다고 가정한다.

| proxy_pass URL    | location URL | 백엔드 요청 결과        | 상태 코드     |
| ----------------- | ------------ | ----------------------- | ------------- |
| `http://backend/` | /api         | `http://backend//me`    | 404 Not Found |
| `http://backend/` | /api/        | `http://backend/me`     | 200 OK        |
| `http://backend`  | /api         | `http://backend/api/me` | 404 Not Found |
| `http://backend`  | /api/        | `http://backend/api/me` | 404 Not Found |

### 1. proxy_pass 경로에 trailing slash 가 있는 경우

**1) `location /api` 로 설정**

```
location /api {
  proxy_pass http://backend/;
}

```

- 맨 앞에 슬래시가 하나 더 붙어서 `//me` 로 인식하고 404 Not Found 발생
  - 이는 백엔드 컨테이너에서 `/me` 라는 이름을 가진 파일을 찾으려고 한 것이다.
- `location /api` 는 `/api/me` 에서 `/api` 까지만 제거하고 `/me` 를 `proxy_pass` 로 전달해서 `http://backend//me` 로 요청한다.

**2) `location /api/` 로 설정**

```
location /api/ {
  proxy_pass http://backend/;
}

```

- `/me` 로 인식하고 200 OK 처리
  - 백엔드 컨트롤러인 `/me` 로 인식하고 서버가 응답해준 것이다.
- `location /api/` 는 `/api/me` 에서 `/api/` 까지 제거하고, `me` 를 `proxy_pass` 로 전달해서 `http://backend/me` 로 요청한다.

### 2. proxy_pass 경로에 trailing slash 가 없는 경우

**1) `location /api` 로 설정**

```
location /api {
  proxy_pass http://backend;
}

```

- `/api/me` 로 인식하고 404 not found 발생
  - 이는 백엔드 컨테이너에서 `/api/me` 라는 이름을 가진 파일을 찾으려고 한 것이다.
- `location /api` 는 `/api/me` 에서 `/api/me` 를 그대로 `proxy_pass` 로 전달하여 `http://backend/api/me` 로 요청한다.

**2) `location /api/` 로 설정 + `proxy_pass http://backend` 로 설정**

```
location /api/ {
  proxy_pass http://backend;
}

```

- `/api/me` 로 인식하고 404 not found 발생
  - 이는 백엔드 컨테이너에서 `/api/me` 라는 이름을 가진 파일을 찾으려고 한 것이다.
- `locatoin /api/` 는 위의 1번과 동일하게 요청함

# 정리

nginx 설정 파일의 `proxy_pass` 와 `location` URL 마지막에 붙는 trailing slash 여부에 따라 백엔드로 요청을 보낼 때 nginx 에서는 404 Not Found 오류를 발생시킬 수도, 200 OK 정상적으로 컨트롤러가 응답할 수도 있다.

나의 경우에는 아래와 같이 모두 trailing slash 를 붙여주어야 원하는 대로 작동했다.

```
location /api/ {
    proxy_pass http://backend/; # backend 컨테이너의 3000 포트로 트래픽 전달
}
```

# 참고자료

- [Nginx docker-compose forward traffic to my backend services](https://stackoverflow.com/questions/72784914/nginx-docker-compose-forward-traffic-to-my-backend-services) [stackoverflow]
- [How to use Nginx to proxy your front end and back end](https://blog.kronis.dev/tutorials/how-to-use-nginx-to-proxy-your-front-end-and-back-end) [kronis.dev]
