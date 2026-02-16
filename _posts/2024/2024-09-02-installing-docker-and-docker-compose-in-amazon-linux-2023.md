---
title: "Amazon Linux 2023 docker compose 설치"
date: 2024-09-02 11:00:00 +0900
categories: [aws, docker]
tags: []
---

# 개요

AWS EC2 에서 사용하는 Amazon Linux 2023 에서 Docker 와 Docker Compose 를 설치하는 방법을 정리했다.

# Docker 설치

1. 패키지를 업데이트 한다.

    ```bash
    sudo yum update -y
    ```


2. docker 를 설치한다.

    ```bash
    sudo yum install -y docker
    ```

3. `ec2-user` 로 로그인한 경우 해당 유저를 `docker` 그룹에 추가한다.

    ```bash
    sudo usermod -a -G docker ec2-user
    ```

4. docker 서비스를 시작한다.

    ```bash
    sudo service docker start
    ```

5. 정상적으로 실행되는지 확인한다.

    ```bash
    docker ps
    ```

    만약, 아래와 같은 오류가 발생한다면 ssh 접속을 끊었다가 다시 연결한다.


# Docker Compose 설치

Amazon Linux 2023 에서는 docker 를 설치해도 docker compose plugin 을 별도로 포함되어있지 않다.

그래서 직접 다운받아서 설치하면 된다.

```bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins/
sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker compose version
```

# 참고자료

- [Installing Docker to use with the AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-docker.html) [AWS]
- [Amazon Linux 2023 Docker Compose 플러그인 설치](https://kdev.ing/install-docker-compose-in-amazon-linux-2023/) [github.io]