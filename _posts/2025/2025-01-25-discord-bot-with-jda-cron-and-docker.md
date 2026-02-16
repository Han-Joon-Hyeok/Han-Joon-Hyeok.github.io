---
title: "[Java] JDA, cron, Docker를 활용한 Discord 메시지 전송 Bot 만들기"
date: 2025-01-25 22:50:00 +0900
categories: [java]
tags: []
---

# 개요

Discord 채널에 정해진 시간에 메시지를 자동으로 전송하는 방법을 정리했습니다. JDA(Java Discord API) 라이브러리를 이용해서 간단한 코드를 작성하고, Docker 이미지로 패키징한 실행 파일을 cron을 이용해서 컨테이너로 주기적으로 실행했습니다.

# 개발 배경

취업 스터디를 운영하며 아래와 같은 두 가지 규칙을 정했습니다.

1. 평일(월~금)에 오후 10시까지 각자의 루틴 내역을 게시한다.
2. 스터디 진행 요일(월, 수, 금)의 전날 오후 10시(화, 목, 일)까지 과제를 제출한다.

이를 요일별로 아래와 같습니다.

| 요일 | 루틴 인증 | 과제 제출 |
| ---- | --------- | --------- |
| 일   |           | O         |
| 월   | O         |           |
| 화   | O         | O         |
| 수   | O         |           |
| 목   | O         | O         |
| 금   | O         |           |
| 토   |           |           |

규칙을 지키지 못할 경우 벌금을 내기로 했기 때문에 깜빡하지 않는 것이 중요했습니다. 마침 의사소통을 위해 Discord를 사용하고 있었고, 스터디원이 모두 같은 알림을 받으면 편리하겠다고 생각해서 스터디원들의 의견을 조사해보았습니다.

![1.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/1.png)

스터디원 모두 알림 받길 원했고, 주기적으로 메시지를 전송하는 Bot을 만들었습니다.

# 개발 환경

- AWS EC2 (Amazon Linux 2023)
- Java17, Gradle
- Docker

# 개발 과정

## 1. Discord 설정

### 1) Discord Bot 생성

Discord API를 사용해서 메시지를 전송하려면 Bot을 생성해야 합니다.

1. Discord Developer Portal([링크](https://discord.com/developers/applications))에 로그인합니다.
2. [Applications] 페이지로 이동해서 [New Application]버튼을 클릭합니다.

   ![2.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/2.png)

3. Bot 이름을 입력하고 약관에 동의한 후 [Create] 버튼을 클릭합니다.

   ![3.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/3.png)

### 2) Bot 토큰 생성

1. [Bot] 메뉴로 이동해 [Reset Token] 버튼을 클릭합니다.

   ![4.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/4.png)

2. [Yes, do it!] 버튼을 클릭해서 토큰을 생성합니다. 참고로 토큰은 계정의 패스워드와 비슷한 역할을 하며, Bot을 생성했다는 것을 인증하기 위해 사용합니다.

   ![5.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/5.png)

3. 비밀번호를 입력하고 [Submit] 버튼을 클릭합니다.

   ![6.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/6.png)

4. 토큰이 생성되면 복사해서 저장해둡니다.

   ![7.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/7.png)

### 3) Discord Bot 서버 초대

1. 생성한 Bot을 서버에 초대하기 위해 [OAuth2] 메뉴로 이동합니다.
2. [OAuth2 URL Generator] 항목에서 [bot]을 선택합니다.

   ![8.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/8.png)

3. [BOT PERMISSIONS] 항목에서는 [Send Messages]를 선택합니다.

   ![9.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/9.png)

4. 하단 [GENERATED URL]에 표시된 주소를 브라우저에 입력합니다.

   ![10.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/10.png)

5. 추가하고자 하는 서버를 선택하고 [계속하기] 버튼을 클릭합니다.

   ![11.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/11.png)

6. [승인] 버튼을 클릭합니다.

   ![12.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/12.png)

7. 정상적으로 초대되었다면 채널 메시지 창에 아래의 이미지와 같이 표시됩니다.

   ![13.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/13.png)

### 4) Discord 채널 ID 복사

1. 메시지를 전송하고자 하는 채널 ID를 알기 위해서는 설정을 변경해야 합니다. 환경설정(`command + ,`) 페이지로 이동합니다.

   ![14.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/14.png)

2. [고급] 메뉴에서 [개발자 모드]를 활성화합니다.

   ![15.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/15.png)

3. 메시지를 전송하고자 하는 채널을 우클릭하고 [채널 ID 복사하기] 버튼을 클릭합니다.

   ![16.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/16.png)

## 2. 코드 작성

### 1) Java 프로젝트 생성

IntelliJ를 이용해서 Gradle 기반 Java 프로젝트를 생성했습니다. 프로젝트 구조는 아래와 같습니다.

```bash
.
├── Dockerfile
├── build.gradle
├── gradle
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew
├── gradlew.bat
├── settings.gradle
└── src
    ├── main
    │   ├── java
    │   │   └── org
    │   │       └── example
    │   │           └── Main.java
    │   └── resources
    └── test
        ├── java
        └── resources
```

### 2) JDA 라이브러리 추가

Discord API를 이용하기 위해서 JDA([링크](https://github.com/discord-jda/JDA))를 사용했습니다. JDA는 Discord API를 간편하게 사용할 수 있도록 Discord API를 Wrapping한 라이브러리입니다.

> 참고로 Discord4j([링크](https://discord4j.com/))라는 라이브러리도 있지만, 개발 당시에는 인지하지 못했습니다. 둘 다 모두 사용 목적은 같기 때문에 편한 것을 선택해서 사용하면 됩니다.

`build.gradle` 파일에 아래와 같이 의존성을 추가합니다.

```groovy
dependencies {
    // 버전은 5.2.2 이 외 버전으로도 변경 가능합니다.
    implementation("net.dv8tion:JDA:5.2.2")
}
```

### 3) 메시지 전송 테스트

편의를 위해 코드는 Main 클래스에서 작성했으며, 토큰과 채널 ID는 환경변수와 같이 외부 파일에 저장해서 관리하는 것을 권장합니다.

```java
package org.example;

import java.io.IOException;
import net.dv8tion.jda.api.JDA;
import net.dv8tion.jda.api.JDABuilder;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;

public class Main  {
    public static void main(String[] args) throws InterruptedException {
        String BOT_TOKEN = "BOT_TOKEN";
        String channelId = "CHANNEL_ID";

        JDA api = JDABuilder.createDefault(BOT_TOKEN).build();

        api.awaitReady(); // Bot 연결 대기

        TextChannel textChannel = api.getTextChannelById(channelId);

        if (textChannel != null) {
	        textChannel.sendMessage("test").queue();
        }

        api.shutdown(); // Bot 연결 종료
    }
}
```

JDA 객체를 생성하면 기본적으로 채널에서 발생하는 이벤트를 감지하기 위해 종료되지 않습니다. 한 번만 실행하고 종료하고자 한다면 `shutdown()` 메서드를 호출해야 합니다.

코드를 실행하면 채널에 메시지가 전송된 것을 확인할 수 있습니다.

![17.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/17.png)

### 4) 코드 완성

요일에 맞는 메시지를 전송하기 위해 아래와 같이 코드를 작성했습니다.

```java
package org.example;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.stream.IntStream;
import net.dv8tion.jda.api.JDA;
import net.dv8tion.jda.api.JDABuilder;
import net.dv8tion.jda.api.entities.channel.concrete.TextChannel;

public class Main  {

    static final String DAILY_ROUTINE_MESSAGE = "기상 인증과 골밀도 인증까지 10분 남았습니다!";
    static final String STUDY_SUBMISSION_MESSAGE = "스터디 과제 제출까지 10분 남았습니다!";
    static final DayOfWeek[] DAILY_ROUTINE_DAYS_OF_WEEK = {
        DayOfWeek.MONDAY,
        DayOfWeek.TUESDAY,
        DayOfWeek.WEDNESDAY,
        DayOfWeek.THURSDAY,
        DayOfWeek.FRIDAY,
    };
    static final DayOfWeek[] STUDY_SUBMISSION_DAYS_OF_WEEK = {
        DayOfWeek.SUNDAY,
        DayOfWeek.TUESDAY,
        DayOfWeek.THURSDAY,
    };

    public static void main(String[] args) throws InterruptedException {
        String BOT_TOKEN = "BOT_TOKEN";
        String channelId = "CHANNEL_ID";

        JDA api = JDABuilder.createDefault(BOT_TOKEN).build();

        api.awaitReady();

        TextChannel textChannel = api.getTextChannelById(channelId);

        if (textChannel != null) {
            logger.info("서버에 연결되었습니다.");

            // KST 오후 9시 50분 (UTC 12시 50분)
            // 월 ~ 금 평일 루틴 인증
            if (Arrays.asList(DAILY_ROUTINE_DAYS_OF_WEEK).contains(LocalDate.now().getDayOfWeek())) {
                sendMessage(textChannel, DAILY_ROUTINE_MESSAGE);
            }

            // 일, 화, 목 스터디 제출 안내
            if (Arrays.asList(STUDY_SUBMISSION_DAYS_OF_WEEK).contains(LocalDate.now().getDayOfWeek())) {
                sendMessage(textChannel, STUDY_SUBMISSION_MESSAGE);
            }
        }

        api.shutdown();
    }

    private static void sendMessage(TextChannel textChannel, String message) {
        textChannel.sendMessage(message).queue();
    }
}
```

## 3. Docker 이미지 생성 (선택)

cron을 이용해서 정해진 일정에 맞춰 실행한다면 Docker 없이 빌드된 파일을 실행해도 무방합니다.

OS에 JDK를 직접 설치하는 것보다 격리된 환경에서 필요한 것만 다운 받아서 코드를 실행하는 것이 예기치 못한 문제를 사전에 방지하기 좋아서 Docker 컨테이너로 실행하는 것을 좋아합니다.

### 1) shadowJar 추가하기

gradle로 빌드하면 작성한 코드만 컴파일 되어 `build/libs` 경로에 jar 파일로 패키징 됩니다. IntelliJ와 같은 IDE에서 실행하는 것이 아닌 Docker 컨테이너로 실행하기 위해서는 빌드할 때 JDA 라이브러리도 함께 컴파일 해서 jar 파일 안에 넣어야 합니다. 이를 편리하게 도와주는 shadowJar 라이브러리([링크](https://github.com/GradleUp/shadow))를 이용했습니다.

`build.gradle` 에 아래와 같이 추가합니다.

```groovy
plugins {
    id 'java'
    id("com.gradleup.shadow") version "9.0.0-beta4" // 추가
}
```

### 2) Dockerfile 파일 작성

Dockerfile은 아래와 같이 작성했습니다.

```docker
# 1. Build stage

FROM amazoncorretto:17-alpine3.19-jdk AS builder

WORKDIR /usr/app

COPY . .

# shadowJar 인자 추가
RUN ./gradlew shadowJar

# 2. Run stage

FROM amazoncorretto:17-alpine3.19-jdk

RUN apk update && apk add dumb-init

WORKDIR /usr/app

COPY --from=builder /usr/app/build/libs/*-all.jar app.jar
COPY ./entrypoint.sh ./

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/bin/sh", "./entrypoint.sh" ]
```

dumb-init이 컨테이너의 PID 1가 되도록 했으며, `entrypoint.sh` 는 아래와 같이 간단하게 작성했습니다.

```bash
#!/bin/sh

java -jar app.jar
```

### 3) Docker 이미지 빌드

AWS EC2에 접속해서 소스 코드를 다운 받고 이미지를 빌드합니다.

```bash
docker build -t discord-notifier:latest .
```

## 4. cron 설정

AWS EC2(Amazon Linux 2023)에서 cron을 이용해서 컨테이너를 주기적으로 실행하기 위해 아래의 명령어를 터미널에 입력합니다.

```bash
crontab -e
```

참고로 cron은 Amazon Linux 2023에 기본으로 포함되지 않기 때문에 수동으로 설치해야 합니다.

```bash
# crontab 설치
sudo yum install cronie -y

# 동작 확인
sudo systemctl status crond

# 실행
sudo systemctl start crond
sudo systemctl enable crond
```

cron 표현식은 아래와 같이 작성했습니다. EC2의 시간은 UTC이기 때문에 한국에서 실행할 시간에서 9시간을 빼서 설정합니다.

```bash
# 일~금 21시 50분 (한국 기준)
50 12 * * 0-5 docker run --rm discord-notifier:latest
```

# 실행 결과

오후 9시 50분에 루틴 인증, 과제 제출 알림이 전송되어 스터디원들이 까먹지 않고 규칙을 지킬 수 있도록 했습니다.

![18.png](/assets/images/2025/2025-01-25-discord-bot-with-jda-cron-and-docker/18.png)

# 개선 방향

이후에는 AWS EventBridge + Lambda로 개발하고자 합니다. 현재는 EC2에서 작동하고 있는데, 다른 서비스들을 컨테이너로 실행하고 있다보니 예상치 못하게 간섭 받는 경우가 있었습니다.

다른 서비스는 무중단 배포를 위해 shell script를 실행하는데, 이 안에는 사용하지 않는 Docker 컨테이너, 이미지, 네트워크를 삭제하는 명령어가 있었습니다.

```bash
docker system prune
```

하지만, Discord 메시지 전송을 위한 Docker 컨테이너는 한번 실행하고 나서 종료되다보니 해당 Docker 이미지는 사용하지 않는 상태(unused)가 됩니다. 그래서 다른 서비스가 새롭게 배포되는 이벤트가 발생하면 `docker system prune` 명령어가 실행되어 Discord 메시지 전송 Docker 이미지도 함께 삭제됐습니다. 결국, cron으로 Docker 컨테이너 실행할 때 이미지를 찾지 못해서 정상적으로 작동하지 않는 문제가 있었습니다.

EventBridge를 이용하면 cron처럼 스케줄링이 가능하고, Lambda를 이용하면 EC2 없이 무료로 실행할 수 있다는 장점이 있습니다. 또한, Terraform을 이용해서 작성하면 인프라를 코드로 관리하기 때문에 AWS 계정이 바뀌어도 동일한 환경으로 실행할 수 있는 장점이 있습니다. 해당 서비스들을 적용하고 나서 포스팅을 추가로 작성해보겠습니다.

# 참고자료

- [[DiscordBot] Java로 디스코드봇 만들기 1. 환경설정](https://constmine.tistory.com/3?category=1163498) [티스토리]
- [[Gradle] shadowJar로 dependency가 포함된 뚱뚱한 fat jar 만들기](https://blog.leocat.kr/notes/2017/10/11/gradle-shadowjar-make-fat-jar) [티스토리]
- [[aws] amazon linux 2023 crontab 설치](https://mjlabs.tistory.com/46) [티스토리]
