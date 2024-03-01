---
title: "[Angular] Docker 컨테이너 이미지 빌드 시 발생하는 오류 해결"
date: 2024-03-01 09:43:00 +0900
categories: [infra]
tags: [angular]
---

# 실행 환경

- OS : MacOS Sonoma 14.2.1 (Intel 2020)
- Docker Engine : 25.0.3

# Dockerfile

Angular 프로젝트를 도커 컨테이너로 실행하기 위해서 Dockerfile 을 아래와 같이 작성했다.

```docker
# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:lts-alpine3.18 as build

# Set the working directory
WORKDIR /usr/app

# Install all the dependencies
COPY ./package.json /usr/app/package.json
RUN npm install

# Add the source code to app
COPY ./src /usr/app/src

# Generate the build of the application
RUN npm run build

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/app/dist/open-umbrella /usr/share/nginx/html
COPY ./open-umbrella.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80
```

이미지의 크기를 줄이기 위해 멀티 스테이지 빌드를 이용했다.

Angular 프로젝트를 빌드한 결과로 생성된 파일만 nginx 이미지만 포함했다.

Angular 프로젝트의 폴더 구조는 아래와 같다.

```bash
frontend
├── Dockerfile
├── README.md
├── angular.json
├── open-umbrella.conf
├── package-lock.json
├── package.json
├── src
├── tsconfig.app.json
├── tsconfig.json
└── tsconfig.spec.json
```

# 오류 해결

## 1. Error: This command is not available when running the Angular CLI outside a workspace.

`npm run build` 에서 아래와 같은 오류가 발생했다.

```bash
=> ERROR [frontend build 6/6] RUN npm run build                       1.7s
------
 > [frontend build 6/6] RUN npm run build:
0.812
0.812 > open-umbrella@0.0.0 build
0.812 > ng build
0.812
1.614 Error: This command is not available when running the Angular CLI outside a workspace.
------
failed to solve: process "/bin/sh -c npm run build" did not complete successfully: exit code: 1
```

검색을 해보니 `angular.json` 파일 안에 빌드에 필요한 설정들이 담겨있었다.

해당 파일에는 환경변수 설정을 위한 `enviroments` 폴더의 경로나 빌드 결과 파일을 어디에 저장할 지에 대한 정보가 담겨있다.

그래서 `angular.json` 파일을 복사해주었다.

```docker
# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:lts-alpine3.18 as build

# Set the working directory
WORKDIR /usr/app

# Copy angular.json
COPY ./angular.json /usr/app/angular.json

# Install all the dependencies
COPY ./package.json /usr/app/package.json
RUN npm install

# Add the source code to app
COPY ./src /usr/app/src

# Generate the build of the application
RUN npm run build

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/app/dist/open-umbrella /usr/share/nginx/html
COPY ./open-umbrella.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80
```

하지만 또 다른 오류가 발생했다.

## 2. Error: ENOENT: no such file or directory, lstat '/usr/app/tsconfig.app.json’

`angular.json` 파일 안에 빌드할 때 참고할 `tsconfig` 파일이 존재하지 않아서 발생한 오류다.

`angular.json` 파일을 확인해보니, 아래와 같이 architect.build.tsConfig 항목에 빌드할 때 `tsconfig.app.json` 파일을 참고하도록 설정되어 있었다.

```json
"architect": {
        "build": {
          "builder": "@angular-devkit/build-angular:browser",
          "options": {
            "outputPath": "dist/open-umbrella",
            "index": "src/index.html",
            "main": "src/main.ts",
            "polyfills": [
              "zone.js"
            ],
            "tsConfig": "tsconfig.app.json", # 빌드 시 필요한 부분
            "assets": [
              "src/favicon.ico",
              "src/assets"
            ],
            "styles": [
              "@angular/material/prebuilt-themes/indigo-pink.css",
              "src/styles.css"
            ],
            "scripts": []
          },
...
}
```

`tsconfig.app.json` 파일은 아래와 같았다.

```json
/* To learn more about this file see: https://angular.io/config/tsconfig. */
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "./out-tsc/app",
    "types": []
  },
  "files": ["src/main.ts"],
  "include": ["src/**/*.d.ts"]
}
```

이 파일은 `tsconfig.json` 파일에 추가하는 것이기 때문에 `tsconfig.json` 파일도 함께 존재해야 타입스크립트 파일을 자바스크립트 파일로 정상적으로 컴파일 할 수 있다.

따라서 `tsconfig.json` 파일과 `tsconfig.app.json` 파일을 모두 복사해주었다.

```docker
# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:lts-alpine3.18 as build

# Set the working directory
WORKDIR /usr/app

# Copy angular.json
COPY ./angular.json /usr/app/angular.json

# Copy tsconfig.json
COPY ./tsconfig.json /usr/app/tsconfig.json
COPY ./tsconfig.app.json /usr/app/tsconfig.app.json

# Install all the dependencies
COPY ./package.json /usr/app/package.json
RUN npm install

# Add the source code to app
COPY ./src /usr/app/src

# Generate the build of the application
RUN npm run build

# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:latest

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/app/dist/open-umbrella /usr/share/nginx/html
COPY ./open-umbrella.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80
```

# 정리

1. Angular 프로젝트에 `angular.json` 파일이 있다면 도커 이미지 빌드할 때 함께 복사해준다.
2. 코드를 TypeScript 로 작성했다면 `tsconfig.json` 파일도 함께 복사해준다.

# 참고자료

- [FIX: error: this command is not available when running the angular cli outside a workspace](https://thrivemyway.com/fix-error-this-command-is-not-available-when-running-the-angular-cli-outside-a-workspace/) [thrivemyway]
- [프로젝트 빌드/실행 설정](https://www.angular.kr/guide/build) [Angular]
