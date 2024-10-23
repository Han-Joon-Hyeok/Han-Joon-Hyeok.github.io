---
title: "[AWS] AWS 3-Tier 아키텍처에서 nginx 리버스 프록시를 이용한 pgadmin 배포 방법"
date: 2024-10-23 16:30:00 +0900
categories: [aws]
tags: []
---

# 개요

이 글에서는 AWS 에 3-Tier 아키텍처로 배포한 웹 애플리케이션의 DB 데이터를 쉽게 조회하고 수정할 수 있는 pgadmin 을 배포하는 방법을 정리했다.

특히 로컬 환경과 운영 환경에서 pgadmin 설정이 어떻게 달라지는지 기록하기 위해 작성했다.

# 환경

- AWS EC2: amazon linux 2023
- Docker: 25.0.6(Server), 25.0.5(Client)
- Docker Compose: 2.29.2
- nginx: stable-alpine-perl (docker image)
- postgreSQL: postgres:16.2-alpine3.18 (docker image)
- pgadmin: dpage/pgadmin4 (docker image)

# 아키텍처

![1.png](/assets/images/2024/2024-10-23-how-to-setup-pgadmin-on-aws/1.png)

위 그림은 AWS 에 구축한 아키텍처를 표현한 것이다.

여기서 pgadmin 은 녹색 선으로 표시된 대로 nginx EC2 에서 DB EC2 로 리버스 프록시를 통해 연결된다.

# pgadmin 설정

## docker-compose.yaml

```yaml
services:
  postgres:
    container_name: postgres
    image: postgres:16.2-alpine3.18
    restart: on-failure:3
    ports:
      - $POSTGRES_PORT:$POSTGRES_PORT
    networks:
      - db-connection
    healthcheck:
      test: pg_isready -h 127.0.0.1 -d $$POSTGRES_DB -U $$POSTGRES_USER
      start_period: 5s
      interval: 5s
      timeout: 5s
      retries: 55
    volumes:
      - postgres-data:/var/lib/postgresql/data
    environment:
      TZ: "Asia/Seoul"
    env_file:
      - ../env/.env.db.prod

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4
    restart: on-failure:3
    ports:
      - $PGADMIN_PORT:80
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    env_file:
      - ../env/.env.pgadmin
    networks:
      - db-connection
    depends_on:
      postgres:
        condition: service_healthy

volumes:
  postgres-data:
  pgadmin-data:

networks:
  db-connection:
    driver: bridge
```

pgadmin 은 postgreSQL 과 같은 인스턴스에서 컨테이너로 실행된다.

외부에 개방하는 포트는 `5050` 으로 설정했지만, `5050` 이 아닌 다른 포트로 해도 상관 없다.

참고로 `$PGADMIN_PORT` 는 `docker-compose.yaml` 파일과 동일한 디렉토리에 위치한 `.env` 파일의 값을 가져온다.

## 환경 변수 설정

`.env.pgadmin` 파일은 다음과 같이 작성했다.

```
PGADMIN_CONFIG_WTF_CSRF_ENABLED=False
```

이 옵션은 pgadmin 의 CSRF 보호 기능의 활성 여부를 설정하는 것이다.

활성화 상태에서는 pgadmin 을 로그아웃 후 다시 로그인할 때 `CSRF tokens do not match` 라는 오류가 발생했다. 이를 해결하기 위해 nginx 의 설정을 다양하게 바꿔보기도 했지만, 모두 실패했다.

사용 편의를 위해 설정을 비활성화했지만, 보안적으로 취약할 수 있으니 주의해야 한다.

- 참고자료: [CSRF token is missing error in docker pgadmin](https://stackoverflow.com/questions/64394628/csrf-token-is-missing-error-in-docker-pgadmin) [stackoverflow]

# nginx 설정

## docker-compose.yaml

```yaml
services:
  nginx:
    container_name: nginx
    image: nginx:stable-alpine-perl
    restart: on-failure:3
    ports:
      - 80:80
    networks:
      - nginx-connection
    volumes:
      - ./conf/:/etc/nginx/conf.d/

networks:
  nginx-connection:
    driver: bridge
```

pgadmin 을 배포하기 위해 `docker-compose.yaml` 파일에 추가적인 수정은 필요하지 않았다.

## nginx 설정 파일

```
upstream blue {
    server backend.habitpay.internal:8080;
}

upstream green {
    server backend.habitpay.internal:8081;
}

upstream pgadmin {
    server db.habitpay.internal:5050;
}

limit_req_zone $binary_remote_addr zone=ddos_limit:10m rate=10r/s;

server {
    listen 80;

    server_name "service.domain";

    location / {
        limit_req zone=ddos_limit burst=10 nodelay;
        real_ip_header    X-Forwarded-For;
        set_real_ip_from 0.0.0.0/0;

        proxy_pass http://blue;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /pgadmin/ {
        limit_req zone=ddos_limit burst=10 nodelay;
        real_ip_header    X-Forwarded-For;
        set_real_ip_from 0.0.0.0/0;

        proxy_pass http://pgadmin;
        proxy_redirect off;
        proxy_set_header X-Script-Name /pgadmin;
        proxy_set_header X-Forwarded-Host $host;
    }
}
```

pgadmin 은 이미 구매한 도메인을 그대로 활용하기 위해 subdirectory 를 이용해서 배포했다. 서브 도메인을 이용할 수도 있지만, 서브 도메인은 비용이 추가되기 때문에 비용을 줄이기 위해 subdirectory 를 이용했다.

nginx 는 `https://service.domain` 으로 백엔드 API 를 처리하고, pgadmin 트래픽은 `https://service.domain/pgadmin` 으로 처리하도록 설정했다.

nginx 설정은 pgadmin 공식 문서([링크](https://www.pgadmin.org/docs/pgadmin4/6.21/container_deployment.html#http-via-nginx))를 참고했다.

# AWS 보안 그룹 설정

## DB 인스턴스

DB EC2 의 보안 그룹에서 인바운드 규칙만 추가했다. nginx 가 DB EC2 의 5050 포트에 접속할 수 있도록 했다. 그리고 트래픽은 nginx EC2 에서만 오기 때문에 소스는 nginx 의 보안 그룹으로 설정했다.

![0.png](/assets/images/2024/2024-10-23-how-to-setup-pgadmin-on-aws/2.png)

## nginx

nginx 의 보안 그룹 설정은 다음과 같다.

![0.png](/assets/images/2024/2024-10-23-how-to-setup-pgadmin-on-aws/3.png)

# 결과물

![0.png](/assets/images/2024/2024-10-23-how-to-setup-pgadmin-on-aws/4.png)

위의 사진과 같이 로컬 환경에서 접속한 것처럼 운영 환경에서도 정상적으로 pgadmin 을 이용할 수 있었다.

# 참고자료

- [CSRF token is missing error in docker pgadmin](https://stackoverflow.com/questions/64394628/csrf-token-is-missing-error-in-docker-pgadmin) [stackoverflow]
- [Container Deployment](https://www.pgadmin.org/docs/pgadmin4/6.21/container_deployment.html#container-deployment) [pgadmin]