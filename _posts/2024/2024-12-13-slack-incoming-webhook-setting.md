---
title: "[Slack] Incoming Webhook 설정 방법"
date: 2024-12-13 17:50:00 +0900
categories: [argocd, slack]
tags: []
---

# 개요

ArgoCD에서 Webhook을 이용한 알림 전송을 위해 Slack의 Incoming Webhook URL을 생성하는 방법을 정리했습니다. (2024.06.21 기준)

# Incoming Webhook

Incoming Webhook URL로 정해진 형식에 맞춰 데이터를 전송하면 Slack의 특정 채널에 아래의 이미지와 같이 메세지를 보내줍니다.

![1.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/1.png)

Incoming Webhook을 사용하면 Slack Bot처럼 메세지를 보내는 유저의 이름, 프로필 이미지, 메세지 형식을 자유롭게 구성할 수 있습니다.

# App 생성

Incoming Webhook을 생성하기 위해서는 우선 Slack App을 생성해야 합니다. [api.slack.com](http://api.slack.com) 에 접속해서 상단의 [Your apps] 를 클릭합니다.

![2.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/2.png)

[Create New App]을 클릭합니다.

![3.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/3.png)

[From scratch]를 선택합니다.

![4.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/4.png)

[App Name] 입력 후 Webhook을 사용할 슬랙 워크스페이스를 선택합니다.

![5.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/5.png)

# Incoming Webhook 추가

슬랙 워크스페이스에서 좌측 메뉴 바의 [더 보기] - [자동화]를 클릭합니다.

![6.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/6.png)

[Incoming Webhooks]를 클릭합니다.

![7.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/7.png)

[구성]을 클릭합니다.

![8.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/8.png)

[Slack에 추가]를 클릭합니다.

![9.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/9.png)

Webhook을 추가할 채널을 선택하고 [통합 앱 추가]를 클릭합니다.

![10.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/10.png)

채널에 추가하고 나면 해당 채널에는 아래와 같이 `incoming-webhook`이 추가되었다는 메세지가 표시됩니다.

![11.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/11.png)

[웹후크 URL]을 복사해서 Webhook 을 이용하고자 하는 서비스에서 이용하면 됩니다.

![12.png](/assets/images/2024/2024-12-13-slack-incoming-webhook-setting/12.png)

# 참고자료

- [[Slack] Incoming Webhook 연동해서 메세지 보내기](https://velog.io/@yujinaa/Slack-Incoming-Webhook-%EC%97%B0%EB%8F%99%ED%95%B4%EC%84%9C-%EC%95%8C%EB%A6%BC%EB%B3%B4%EB%82%B4%EA%B8%B0) [velog]
