---
title: "[AWS] EC2 에 ALB 없이 CloudFront, ACM 이용해서 HTTPS 인증서 적용하기"
date: 2024-09-17 16:50:00 +0900
categories: [AWS]
tags: []
---

# 개요

AWS EC2 인스턴스에 ALB 대신 nginx 를 이용해서 HTTPS 통신이 가능하도록 ACM 으로 인증서를 발급하고 CloudFront 에 적용하는 방법을 정리했다.

# 아키텍처

AWS 아키텍처는 아래의 이미지와 같다.

![1.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/1.png)

큰 흐름은 아래와 같다.

1. 웹 브라우저에서 백엔드 서버에 API 요청(HTTPS).
2. 클라이언트가 보낸 요청을 CloudFront 가 대신 HTTPS 연결 수립.
3. HTTPS 연결 이후 CloudFront 가 EC2 인스턴스(nginx)로 HTTP 트래픽 전달.
4. 리버스 프록시 역할을 하는 nginx 가 백엔드 서버로 HTTP 트래픽 전달.

## ALB 를 사용하지 않는 이유

아래와 같이 크게 3가지로 정리할 수 있다.

### 1. 비용 절감

2024년 9월 17일 서울 리전(ap-northeast-2) 기준으로 ALB 와 EC2 인스턴스(t4g.micro) 시간당 사용 요금을 비교하면 아래의 표와 같다. (트래픽 관련 요금 제외)

| 유형           | 시간당 요금 | 1달(720시간) 사용 요금 |
| -------------- | ----------- | ---------------------- |
| ALB            | USD 0.0225  | USD 16.2               |
| EC2(t4g.micro) | USD 0.0084  | USD 6.048              |

즉, ALB 대신 EC2 인스턴스에서 nginx 를 사용하면 t4g.micro 기준으로 약 62.6% 저렴하다.

ALB 와 nginx 모두 L7 로드밸런서인데, nginx 설정을 직접 할 수 있다면 사이드 프로젝트에서 비용을 크게 절감할 수 있다.

### 2. ALB 없이도 HTTPS 통신 가능

보안을 위해 HTTPS 통신이 가능하게 하려면 Certificate Manager(ACM), CloudFront, Route 53 을 이용하면 된다.

CloudFront 를 이용할 때 트래픽 요금이 발생하긴 하지만, 매월 1TB 데이터를 인터넷으로 전송하고 HTTP/HTTPS 요청 월 1,000만 건에 대해 무료로 제공하기 때문에 사이드 프로젝트 수준에서는 거의 무료로 사용할 수 있다.

### 3. HTTPS 인증서 자동 갱신

ACM 에서 발급한 인증서는 자동으로 갱신해주는 기능이 있다.

만약 ACM 을 이용하지 않는다면, EC2 인스턴스에서 무료 인증서 발급이 가능한 letsencrypt 를 이용해서 주기적으로 갱신을 하면 된다.

하지만 자동으로 갱신해주기 위해서 EC2 에서 cron 을 설정하거나, GitHub Actions 등을 이용해서 스크립트를 추가로 작성해야 하는 번거로움이 있다.

# 설정 방법

EC2 인스턴스는 이미 생성했고, 도메인도 Route 53 에 이미 등록된 상태라고 가정한다.

## 1. ACM 인증서 발급

ACM(Certficate Manager)에서 인증서를 발급한다.

이때 중요한 것은 CloudFront 에 인증서를 적용하기 위해서는 인증서를 **버지니아 북부(us-east-1)**에 생성해야 한다는 것이다.

[AWS Certificate Manager] - [인증서] - [인증서 요청] 으로 접속한다.

아래의 이미지와 같이 [퍼블릭 인증서 요청]을 선택하고 [다음] 버튼 클릭.

![2.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/2.png)

[완전히 정규화된 도메인 이름] 항목에 등록하고자 하는 도메인을 입력한다.

![3.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/3.png)

참고로 프론트엔드는 `https://domain.link` 로 요청을 보내고, 백엔드는 `https://api.domain.link` 와 같이 서브 도메인으로 요청을 보내도록 했다.

서브 도메인은 Route 53 에 이미 등록한 상태이며, 이번 글에서는 서브 도메인 등록 방법에 대해 다루지 않는다.

나머지는 그대로 둔 채로 페이지 하단의 [요청] 버튼 클릭.

인증서 발급 이후 인증서 개인키를 보관하고 있는 주소를 찾기 위해 Route 53 에 CNAME 을 등록해주어야 한다.

CNAME 을 등록하지 않으면 [검증 대기 중]인 상태로 인증서 발급이 완료되지 않는다.

[인증서 나열] 페이지에서 요청한 [인증서 ID] 를 클릭한다.

![4.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/4.png)

[Route 53에서 레코드 생성] 버튼 클릭.

![5.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/5.png)

[레코드 생성] 버튼 클릭.

![6.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/6.png)

잠시만 기다리면 아래의 이미지와 같이 인증서 상태가 [발급됨]으로 표시된다.

![7.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/7.png)

## 2. CloudFront 생성

CloudFront 페이지에서 [배포 생성] 클릭.

![8.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/8.png)

[Origin Domain] 항목에 EC2 인스턴스의 [퍼블릭 IPv4 DNS] 값을 입력한다.

![9.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/9.png)

[퍼블릭 IPv4 DNS] 값은 EC2 페이지에서 인스턴스를 클릭하면 확인할 수 있다.

![10.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/10.png)

[프로토콜]은 [HTTP만 해당]을 선택한다.

![11.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/11.png)

이는 CloudFront 에서 EC2 인스턴스로 트래픽을 보낼 때 HTTP 통신을 한다는 것이다.

클라이언트와 HTTPS 통신은 CloudFront 에서 대신 해주기 때문에 CloudFront 와 EC2 인스턴스 사이에서는 HTTPS 통신을 추가로 하지 않아도 된다.

그리고 CloudFront 와 EC2 인스턴스에서 실행 중인 nginx 가 HTTPS 통신을 하려면 EC2 인스턴스에서도 인증서를 발급해야 하는데, 이미 ACM 에서 인증서를 발급했는데 다시 EC2 인스턴스에서 인증서를 발급할 이유는 없다.

따라서 EC2 인스턴스에서 인증서를 발급하지 않고 AWS 에서 제공하는 인증서를 이용하는 것이 목표이므로 [HTTP만 해당] 옵션을 선택했다.

[기본 캐시 동작] 의 [뷰어] - [뷰어 프로토콜 정책] 에서는 [HTTPS only] 를 선택했다.

![12.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/12.png)

이 옵션은 클라이언트가 `https://` 로 시작하는 요청을 보냈을 때만 통신을 허용한다는 것이다.

이 옵션을 적용한 상태로 `http://` 로 시작하는 요청을 보내면 아래의 이미지와 같이 CloudFront 에서 403 Bad Request 페이지를 반환한다.

![13.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/13.png)

[웹 애플리케이션 방화벽(WAF)] 는 비활성화 했다.

WAF 를 사용하면 보안이 견고해지겠지만, 비용이 추가로 발생하기 때문에 사용하지 않았다.

![14.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/14.png)

[설정] 의 [대체 도메인 이름(CNAME)] 에는 위에서 인증서로 발급한 도메인을 입력한다.

![15.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/15.png)

[Custom SSL certificate] 는 앞에서 발급한 인증서를 선택한다.

이 항목은 HTTPS 통신을 위해 어떤 인증서를 이용할 것인지 선택하는 것이다.

![16.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/16.png)

나머지 설정은 그대로 두고 페이지 하단의 [배포 생성] 버튼을 클릭.

## 3. Route 53 도메인 등록

CloudFront 에도 도메인이 자동으로 부여되는데, 이를 사용하고자 하는 도메인에 연결하는 작업이 필요하다.

Route 53 페이지로 이동해서 해당하는 도메인의 호스팅 영역을 클릭해서 들어온다.

[레코드 생성] 버튼을 클릭한다.

![17.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/17.png)

[단순 라우팅] 선택 후 페이지 하단의 [다음] 버튼 클릭.

![18.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/18.png)

[단순 레코드 정의] 버튼 클릭.

![19.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/19.png)

[값/트래픽 라우팅 대상] 항목에서 [엔드포인트 선택] 필드 클릭.

![20.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/20.png)

[CloudFront 배포에 대한 별칭] 선택.

![21.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/21.png)

CloudFront 에서 생성한 도메인 선택.

![22.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/22.png)

이후 [단순 레코드 정의] 버튼을 클릭한다.

## 4. nginx 설정 파일 수정

EC2 인스턴스에서는 docker compose 를 이용해서 컨테이너로 nginx 를 실행하고 있다.

디렉토리 구조는 아래와 같다.

```bash
.
├── conf
│   └── nginx.conf
└── docker-compose.yml
```

docker compose 파일은 아래와 같다.

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

nginx 설정 파일은 아래와 같이 80 포트에 대해서만 block 을 작성한다.

```diff
upstream blue {
    server backend.habitpay.internal:8080;
}

upstream green {
    server backend.habitpay.internal:8081;
}

+server {
+   listen 80;
+
+   server_name "api.habitpay.link";
+
+   location / {
+       proxy_pass http://blue;
+       proxy_http_version 1.1;
+       proxy_set_header Upgrade $http_upgrade;
+       proxy_set_header Connection 'upgrade';
+       proxy_set_header Host $host;
+       proxy_cache_bypass $http_upgrade;
+   }
+}
```

EC2 인스턴스에서 Docker 컨테이너로 nginx 를 실행 중이기 때문에 설정 파일 변경사항을 적용하기 위해 아래의 명령어를 실행했다.

```bash
docker exec [container-name] nginx -s reload
```

## 5. 접속 테스트

도메인으로 요청을 보내기 전에 CloudFront 의 상태가 [활성화됨] 으로 바뀌었는지 확인한다.

![23.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/23.png)

도메인으로 요청을 보내면 정상적으로 응답이 돌아오는 것을 확인할 수 있다.

![24.png](/assets/images/2024/2024-09-17-aws-https-certificate-on-ec2-cloudfront-without-alb/24.png)

# 글을 마치며

트래픽이 다수 발생하는 프로덕션 환경에서는 ALB 가 더 나은 선택으로 보인다.

생성한 EC2 인스턴스 사양으로 감당할 수 있는 트래픽을 초과하면 스케일 업 또는 스케일 아웃을 해야 하는데, ALB 는 이를 자동으로 처리해준다.

수작업으로 들어가는 시간을 아끼기 위해 비용을 지출하는 것이 비즈니스 이익에 도움이 된다면 ALB 를 선택할 것이다.

트래픽이 많이 발생하지 않는 사이드 프로젝트나 작은 서비스라면 ALB 대신 nginx 를 사용하면 비용을 많이 줄일 수 있다.

직접 로드 밸런서를 설정하는 작업을 해보니 ALB 도 비슷하게 작동하고 있겠다고 느꼈다.

# 참고자료

- [Configure Node.js on EC2 with CloudFront, Route 53, and AWS Certificate Manager](https://medium.com/@rahulvikhe25/configure-node-js-on-ec2-with-cloudfront-route-53-and-aws-certificate-manager-d9ae6d364a18) [medium]

끝.
