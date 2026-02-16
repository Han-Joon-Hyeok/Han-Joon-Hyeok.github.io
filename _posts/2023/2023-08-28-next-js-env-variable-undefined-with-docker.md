---
title: next.js 빌드 시 환경 변수가 undefined 인 문제 해결 (feat. docker-compose)
date: 2023-08-28 01:25:00 +0900
categories: [frontend]
tags: [nextjs, docker, docker-compose]
---

# 문제 상황

Next.js 로 작성한 프론트엔드 프로젝트를 docker 와 docker-compose 를 이용해서 컨테이너로 올리고 싶었다.

개발할 때는 `.env` 파일을 docker-compose 를 통해서 넣어줬고, 환경 변수를 잘 인식했다.

하지만 배포를 위해 `npm run build` 명령어로 빌드하고 `npm run start` 로 실행해보니 환경변수가 `undefined` 로 찍히는 상황을 마주했다.

## 프로젝트 구조

프로젝트 폴더 구조는 아래와 같다.

```bash
.
├── .env
├── Makefile
├── README.md
├── **backend/**
├── docker-compose.dev.yml
├── docker-compose.yml
├── **frontend/**
└── **types/**
```

`.env` 파일은 프론트엔드, 백엔드 모두 공유하도록 구성했다.

사실 프론트엔드와 백엔드가 서로 공유하는 환경 변수는 없어서 굳이 같은 파일을 공유할 필요는 없다.

별도의 `.env` 파일로 관리하는 것이 맞는 것 같다.

## 개발용 Docker 환경

### docker-compose.dev.yml

개발용 docker compose 파일은 `docker-compose.dev.yml` 라는 이름으로 저장했다.

파일 내용은 아래와 같다.

```yaml
# docker-compose.yml

version: "3"

services:
  frontend:
    container_name: frontend
    build:
      context: ./frontend
      dockerfile: ./Dockerfile.dev
    image: frontend
    ports:
      - 3000:3000
    restart: on-failure:3
    volumes:
      - ./frontend:/app
      - ./types:/app/types
    env_file:
      - .env
    networks:
      - naengmyeon_pong_network

   ...

networks:
  naengmyeon_pong_network:
    driver: bridge
```

### Dockerfile.dev

`frontend` 폴더에 있는 docker 파일의 내용은 아래와 같다.

```docker
# Dockerfile.dev

FROM node:18-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app

EXPOSE 3000

# Start dumb-init for PID 1
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

# Start react in the foreground
CMD [ "npm", "run", "dev" ]
```

docker-compose 에서 `env_file` 항목에 `.env` 파일을 전달했을 때는 정상적으로 환경 변수가 출력되었다.

하지만, Dockerfile 에서 `npm run dev` 대신 `npm run build` 실행 이후 `npm run start` 로 바꾸니 환경 변수가 제대로 출력되지 않았던 것이다.

# 문제 원인

문제는 `npm run dev` 는 런타임 환경이고, `npm run start` 는 컴파일 후 생성된 정적 파일을 실행하는 환경이라는 차이점에서 발생했다.

런타임 환경에서는 컨테이너 내부에서 설정된 환경 변수를 사용해서 가져오는 것이었다.

즉, 컨테이너 내부에서 `env` 명령어를 실행하면 확인할 수 있는 환경 변수를 그대로 가져와서 사용하기 때문에 문제가 없었던 것이다.

하지만, `npm run build` 로 컴파일 할 때는 컨테이너 내부에서 선언된 환경 변수를 가져오는 것이 아니라 `package.json` 파일과 동일한 위치에 있는 `.env` 파일을 가져와서 환경 변수를 컴파일 한다.

# 해결 방법

개발용 Docker 환경과 배포용 Docker 환경을 다르게 설정해야 한다.

## 배포용 Docker 환경

### docker-compose.yml

```yaml
version: "3"

services:
  frontend:
    container_name: frontend
    build:
      context: . # context 를 frontend 가 아닌 docker-compose.yml 파일 기준으로 설정
      dockerfile: ./frontend/Dockerfile
    image: frontend
    ports:
      - 3000:3000
    restart: on-failure:3
    networks:
      - naengmyeon_pong_network

networks:
  naengmyeon_pong_network:
    driver: bridge
```

이번 프로젝트에서는 백엔드와 프론트엔드 .env 파일을 동시에 공유하고 있다.

그래서 docker-compose 파일에 이미지 빌드 시 context 를 docker-compose.yml 파일이 위치한 디렉토리로 설정해서 `.env` 파일을 가져올 수 있도록 설정한다.

### Dockerfile

```docker
FROM node:18-alpine

RUN apk add --no-cache dumb-init

WORKDIR /app

COPY ./frontend /app
COPY ./types /app/types

# docker-compose.yml 파일이 위치한 경로에서 .env 파일을 컨테이너 내부로 복사한다.
COPY ./.env .

RUN npm run build

EXPOSE 3000

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD ["npm", "run", "start"]

```

Dockerfile 에서는 `.env` 파일을 컨테이너 내부에 복사한다.

그러면 터미널에 정상적으로 `.env` 파일을 반영해서 컴파일 했다는 안내 문구가 표시된다.

```bash
$ npm run build

> client@0.1.0 build
> next build

- info Loaded env from /Users/workspace/frontend/.env # 환경 변수를 불러왔다는 표시가 뜬다.
- info Skipping linting
- info Checking validity of types
Warning: For production Image Optimization with Next.js, the optional 'sharp' package is strongly recommended. Run 'yarn add sharp', and Next.js will use it automatically for Image Optimization.
Read more: https://nextjs.org/docs/messages/sharp-missing-in-production
- info Creating an optimized production build ..
```
