---
title: "[Next.js] Vercel 대신 AWS 에 배포하기(feat.SST)"
date: 2024-10-02 17:20:00 +0900
categories: [aws, nextjs]
tags: []
---

# 개요

Next.js 프로젝트를 SSR 방식으로 AWS 에 간편하게 배포하기 위해 SST 라이브러리를 이용했다.

SST 라이브러리를 이용하면 아래의 표와 같은 AWS 서비스를 사용한다.

| 서비스 | 설명 |
| --- | --- |
| Lambda | Next.js 의 SSR 을 가능하도록 하는 서버리스 컴퓨팅. |
| CloudFront | 프론트엔드 정적 파일들을 전달해주는 CDN. |
| Route53 | 도메인으로 접속 했을 때 CloudFront 와 연결해주는 DNS. |
| Certificate Manager | 도메인 HTTPS 접속 연결을 위한 인증서 발급. |
| S3 | 프론트엔드 정적 파일 및 캐시 파일을 저장하는 Storage. |
| CloudWatch | 프론트엔드 접속 요청 로그 수집. |
| CodeDeploy | GitHub Repository 에서 소스 코드를 가져와서 자동 빌드 후 배포. |

SST 를 이용해서 배포한 AWS 서비스 구조를 그림으로 표현하면 아래의 이미지와 같다.

![1.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/1.png)

본 게시물은 사이드 프로젝트를 AWS 에 배포하기 위한 SST 라이브러리 사용 방법 및 CI/CD 구축 방법에 대해 정리하였다.

# Vercel 을 사용하지 않은 이유

GitHub Organization Repository 를 사용하는 사이드 프로젝트에서는 Vercel 을 사용하는 것보다 AWS 에 배포하는 것이 약 75% 저렴하다. (1달 기준 Vercel = 20 USD, AWS = 5 USD)

## Vercel 요금 체계

Vercel 은 배포하고자 하는 GitHub Organization Repository 에 대해 1개월에 팀원 1명당 20달러(약 26,000원)를 지불해야 한다.

여기서 의미하는 팀원은 GitHub Organization 에 소속된 팀원이 아닌 Vercel 사이트에서 생성한 계정으로 해당 GitHub Organization Repository 의 대시보드에 접근할 수 있는 팀원을 의미한다.

Vercel 을 이용하면 클릭 몇 번으로 빠르고 간편하게 서비스를 배포할 수 있고, 다양한 모니터링 기능도 이용할 수 있다.

즉, Vercel 이 제공하는 간편하고 편리한 기능들을 팀원들과 함께 사용하기 위해서는 20 + (20 * N명) 만큼 결제해야 한다.

물론 무료로 배포할 수 있는 방법이 있긴 하다.

GitHub Organization 에 소속된 Repository 를 개인 계정의 Repository 로 fork 해서 배포하면 된다.

하지만 이렇게 하면 배포한 서비스를 모니터링 할 수 있는 Vercel 계정이 오직 1개로 제한된다.

다시 말해서, 다른 팀원들이 Vercel 대시보드에 접속해서 모니터링을 하려면 배포한 Vercel 계정의 로그인 정보를 알아야 한다는 것이다.

개인 정보를 공유하는 것은 보안 상 바람직하지 않기 때문에 이 방법을 사용하지 않았다.

## AWS 요금 체계

AWS 는 사용한 만큼만 지불하는 On-Demand 방식이다.

AWS 에서 제공하는 프리 티어 혜택을 잘 이용하면 프론트엔드는 1달에 약 5달러 정도만 지불하면 된다.

또한, AWS 크레딧을 이용해서 지불할 수 있기 때문에 무료로 받은 크레딧으로 결제가 가능하다는 장점이 있다.

이번 사이드 프로젝트를 위해 사용할 수 있는 크레딧이 약 $150 있었기 때문에 비용 부담을 덜 수 있었다.

## SST 라이브러리 적극 활용하기

SST 에서도 Vercel 만큼 많은 기능을 지원하는 건 아니지만 웹 대시보드를 제공하고 있다.

GitHub Repository 의 main 브랜치에 push 가 발생하면 CI/CD 를 알아서 구축해주는 편리한 기능도 지원하기 때문에 Vercel 의 대안으로 적합했다.

# SST

## 소개

SST 는 프론트엔드 프레임워크(Next.js, Remix, Svelte 등)를 AWS 나 CloudFlare 에 배포할 수 있도록 돕는 라이브러리이다.

2024년 8월 27일 기준 최신 버전은 v3 이며, SST ION([GitHub 링크](https://github.com/sst/ion))이라는 이름의 프로젝트로 개발 중이다.

v3 에서는 ION 은 Pulumi 와 Terraform 을 이용해서 코드로 인프라를 관리하는 IaC(Infrastructure as Code)를 구현했다.

참고로 v2 에서는 CloudFormation 을 이용해서 AWS 자원을 생성했다. 하지만, AWS 자원이 정상적으로 삭제 되지 않거나, CDK(Cloud Development Kit)에서 오류 메세지에 명확한 원인을 표시하지 않는 문제가 있었다고 한다. 자세한 내용은 아래의 링크에서 확인할 수 있다.

- 참고자료: [Moving away from CDK](https://sst.dev/blog/moving-away-from-cdk) [SST]

## 주요 기능

SST 는 자체적으로 운영하고 있는 Console 페이지([링크](https://console.sst.dev/habitpay/frontend/autodeploy))를 통해 여러 편리한 기능을 제공하고 있다.

### CI/CD 지원

SST 는 배포하고자 하는 프로젝트의 GitHub Repository 에 연결하면 자동으로 배포해주는 CI/CD 기능을 지원한다.

내부적으로 AWS CodeDeploy 를 이용해서 배포를 자동화하고 있다.

Console 페이지를 통해 배포가 정상적으로 이루어졌는지 확인할 수 있다.

![2.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/2.png)

### AWS 사용 중인 자원 목록 표시

AWS 에서 사용 중인 자원들의 목록을 표시해준다.

배포를 위해 많은 AWS 자원을 생성하는데, 어떤 자원이 생성되었는지 쉽게 확인할 수 있도록 도와준다.

![3.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/3.png)

### 로그 수집

Lambda 에서 실행한 코드의 로그를 수집해서 표시해준다.

내부적으로 AWS CloudWatch 를 이용한다.

![4.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/4.png)

## 사용 이유

Next.js 를 SST 로 배포한 이유는 크게 3가지로 정리할 수 있다.

### 1. 비용 부담 낮추기

위에서 언급하긴 했지만, AWS 서비스를 사용하는 만큼만 비용을 지불하고, 크레딧으로 결제가 가능해서 비용 부담을 낮출 수 있었다.

### 2. 서버리스를 이용한 SSR 방식 배포

처음에는 Next.js 를 SSG 방식으로 빌드해서 AWS S3 에 업로드 하고자 했다.

이전에 Next.js 를 배포한 경험은 없었고, React 를 정적 파일로 빌드해서 배포한 경험만 있었기 때문에 Next.js 도 SSG 방식을 이용하면 될거라 생각했다.

하지만, 이번 프로젝트에서는 Dynamic Routes(동적 라우팅) 기능([참고 자료](https://nextjs.org/docs/pages/building-your-application/routing/dynamic-routes))을 이용하고 있어서 SSG 로 빌드하는 것이 불가능했다.

SSG 방식으로 Dynamic Routes 를 이용할 수 있는 방법은 아무리 찾아봐도 존재하지 않아서 SSR 방식으로 배포하기로 했다.

SSR 방식으로 배포하기 위해 2가지 선택지가 있었다.

1. EC2 에서 `npm run start` 명령어를 실행하여 배포
2. AWS 서버리스(Lambda) 서비스를 이용한 배포

결론부터 말하면 비용 절감 및 간편한 배포를 위해 2번을 선택했다.

1번 방식을 이용하면 EC2 실행 시간 비용 + EBS 비용이 매월 꼬박꼬박 발생한다.

t4g.small 기준으로 1개월 실행 비용만 $12 이고, EBS 15G 는 약 $1.4 이다.

이 외에도 다른 비용을 합산하면 최소 월 $14 이상 지불해야 한다.

이에 비해 AWS Lambda 는 매월 아래와 같은 사용량에 대해 프리티어를 제공한다.

- 월별 무료 요청 **1,000,000**건
- 월별 **최대 320만 초**의 컴퓨팅 시간

프리티어를 초과한 사용량에 대한 계산을 위해 아래와 같은 상황을 가정해보자.

- 월 요청 건수: 5,000,000건
- 평균 실행 시간: 0.5초
- 메모리: 512MB(0.5GB)

1. 요청 건수에 대한 비용
    - 5,000,000 - 1,000,000(프리티어) = 4,000,000건
    - 1,000,000 건당 $0.20
    - 0.2 * 4 = **$0.8**
2. 컴퓨팅 시간에 대한 비용
    - 5,000,000 * 0.5 = 2,500,000 초
    - 2,500,000 초 * 0.5GB = 1,250,000 GB/초
    - (1,250,000 GB/초 - 320,000 GB/초) * 0.0000166667 = **$15.51**
3. 총 비용
    - $0.8 + $15.51 = **$16.31**

단순 비용만 놓고 보면 EC2 와 유사한 수준이다.

하지만, 포트폴리오 목적의 사이드 프로젝트에서 5백만 건 이상의 요청이 들어오기는 어렵기에 실제로는 $16 이하의 요금이 청구될 것이다.

실제로 비용이 얼마나 발생할 지는 서비스를 운영해봐야 알겠지만, 계산만으로는 EC2 보다 Lambda 를 이용하는 것이 훨씬 경제적이라는 것을 알 수 있다.

### 3. 간편한 CI/CD 구축 및 HTTPS 인증서 적용

앞선 2번과 이어지는 맥락이다.

EC2 에 배포한다면 CI/CD 구축을 위해 GitHub Actions 를 이용할 수 있다.

하지만, SST 는 클릭 몇 번으로 GitHub Repository 와 연동해서 GitHub Actions 를 위한 코드를 작성하지 않아도 CI/CD 를 간편하게 구축할 수 있다.

그리고 HTTPS 통신을 위한 인증서 적용을 위해 certbot 을 이용해서 주기적으로 인증서를 발급 및 갱신하거나, CloudFront 를 EC2 와 연결해서 AWS 에서 발급하는 인증서를 적용할 수도 있다.

또한, SST 를 이용해서 배포하면 CloudFront 를 통한 요청에 대해서도 ACM(AWS Certificate Manager)에서  HTTPS 인증서도 알아서 발급하고 적용해주기 때문에 간편하다.

# SST 사용 방법

아래의 내용은 SST 라이브러리 공식 문서([링크](https://sst.dev/docs/start/aws/nextjs))를 참고해서 작성했다.

## 개발 환경

- OS: macOS 14.6.1

## 1. SST 라이브러리 설치

Next.js 디렉토리에서 터미널에 아래의 명령어를 실행한다.

```bash
npx sst init
npm install
```

`sst.config.ts` 파일이 생성되며, 초기 내용은 아래와 같다.

```tsx
// sst.config.ts

/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "ion",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
    };
  },
  async run() {
    new sst.aws.Nextjs("MyWeb");
  },
});
```

## 2. `sst.config.ts` 파일 설정

### region 설정

Autodeploy 기능을 이용하기 위해 배포할 region 을 설정한다.

`app()` 함수에 `providers` 속성을 아래와 같이 추가한다.

```tsx
  app(input) {
    return {
      name: "frontend",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
      providers: {
        aws: {
          region: "ap-northeast-2",
        },
      },
    };
  },
```

참고로 region 을 명시하지 않으면 기본으로 `us-east-1` 에 배포가 이루어진다.

region 값은 민감한 정보일 수 있기 때문에 하드 코드 값을 넣는 대신 아래와 같이 환경 변수로 대체할 수 있다.

```tsx
  app(input) {
    return {
      name: "frontend",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
      providers: {
        aws: {
          region: process.env.AWS_REGION,
        },
      },
    };
  },
```

환경 변수는 SST Console 페이지에서 설정 가능한데, 이 부분은 아래에서 자세히 설명할 것이다.

### 자동 배포 설정

main 브랜치에 push 되었을 때만 배포할 수 있도록 아래와 같이 `console` 속성을 추가한다.

이 부분은 CI/CD 구축할 때 필요하다.

자세한 내용은 아래에서 확인할 수 있다.

```tsx
  app(input) {
    // ... 생략
  },

  // <-- 이하 추가한 부분
  console: {
    autodeploy: {
      target(event) {
        if (
          event.type === "branch" &&
          event.branch === "main" &&
          event.action === "pushed"
        ) {
          return {
            stage: "production",
          };
        }
      },
    },
  },
  // 이상 추가한 부분 -->

  async run() {
    // 생략...
  },
```

### 도메인 연결

CloudFront 과 연결할 도메인을 `run()` 함수에 명시할 수 있다.

도메인은 이미 구매한 상태여야 하며, AWS Route53 에서 구매하는 것이 가장 간편하다.

```tsx
async run() {
  new sst.aws.Nextjs("Habitpayfrontend", {
    domain: "habitpay.link", // 사용할 도메인 입력.
  });
},
```

### 전체 설정 파일

```tsx
/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "frontend",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
      providers: {
        aws: {
          region: "ap-northeast-2",
        },
      },
    };
  },
  console: {
    autodeploy: {
      target(event) {
        if (
          event.type === "branch" &&
          event.action === "pushed" &&
          event.branch === "main"
        ) {
          return {
            stage: "production",
          };
        }
      },
    },
  },
  async run() {
    new sst.aws.Nextjs("Habitpayfrontend", {
      domain: "habitpay.link",
    });
  },
});
```

## 3. AWS IAM 권한 설정

SST 가 나의 AWS 계정에 AWS 자원을 생성하기 위해 필요한 권한을 부여해주어야 한다.

`AdministratorAccess` 를 주는 것이 가장 간단하지만, 최소 권한만 부여하는 것이 보안상 안전하며 AWS 에서 권장하는 방법이기 때문에 최소 권한만 부여한다.

### 사용자 생성

SST 가 사용할 사용자 계정을 먼저 생성한다.

[IAM] - [사용자] 페이지에서 [사용자 생성] 버튼을 클릭한다.

![5.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/5.png)

사용자 이름은 자유롭게 입력 후 [다음] 클릭.

![6.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/6.png)

[직접 정책 연결] 선택 후 [정책 생성] 버튼 클릭.

![7.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/7.png)

[JSON] 선택.

![8.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/8.png)

기본으로 작성되어 있는 JSON 대신 아래의 내용 입력.

`Resource` 속성에 있는 `REGION` 과 `ACCOUNT` 는 각자 사용하는 정보에 맞춰서 변경한다.

```json
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Sid": "ManageBootstrapStateBucket",
          "Effect": "Allow",
          "Action": [
              "s3:CreateBucket",
              "s3:PutBucketVersioning",
              "s3:PutBucketNotification",
              "s3:DeleteObject",
              "s3:GetObject",
              "s3:ListBucket",
              "s3:PutObject"
          ],
          "Resource": [
              "arn:aws:s3:::sst-state-*"
          ]
      },
      {
          "Sid": "ManageBootstrapAssetBucket",
          "Effect": "Allow",
          "Action": [
              "s3:CreateBucket",
              "s3:PutBucketVersioning",
              "s3:DeleteObject",
              "s3:GetObject",
              "s3:ListBucket",
              "s3:PutObject"
          ],
          "Resource": [
              "arn:aws:s3:::sst-asset-*"
          ]
      },
      {
          "Sid": "ManageBootstrapECRRepo",
          "Effect": "Allow",
          "Action": [
              "ecr:CreateRepository",
              "ecr:DescribeRepositories"
          ],
          "Resource": [
              "arn:aws:ecr:REGION:ACCOUNT:repository/sst-asset"
          ]
      },
      {
          "Sid": "ManageBootstrapSSMParameter",
          "Effect": "Allow",
          "Action": [
              "ssm:GetParameters",
              "ssm:PutParameter"
          ],
          "Resource": [
              "arn:aws:ssm:REGION:ACCOUNT:parameter/sst/passphrase/*",
              "arn:aws:ssm:REGION:ACCOUNT:parameter/sst/bootstrap"
          ]
      },
      {
          "Sid": "Deployments",
          "Effect": "Allow",
          "Action": [
              "*"
          ],
          "Resource": [
              "*"
          ]
      },
      {
          "Sid": "ManageSecrets",
          "Effect": "Allow",
          "Action": [
              "ssm:DeleteParameter",
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:GetParametersByPath",
              "ssm:PutParameter"
          ],
          "Resource": [
              "arn:aws:ssm:REGION:ACCOUNT:parameter/sst/*"
          ]
      },
      {
          "Sid": "LiveLambdaSocketConnection",
          "Effect": "Allow",
          "Action": [
              "iot:DescribeEndpoint",
              "iot:Connect",
              "iot:Subscribe",
              "iot:Publish",
              "iot:Receive"
          ],
          "Resource": [
              "*"
          ]
      }
    ]
}
```

[정책 이름] 작성 후 하단에 [정책 생성] 버튼 클릭

![9.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/9.png)

[사용자 생성] 페이지에서 [새로고침] 버튼 클릭 후 방금 생성한 정책 검색 후 선택.

![10.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/10.png)

[사용자 생성] 버튼 클릭.

![11.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/11.png)

### 액세스 키 생성

로컬 환경에서 배포하기 위해서는 액세스 키가 필요하다.

[IAM] - [사용자 관리] - [사용자]에서 방금 생성한 사용자를 선택한다.

![12.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/12.png)

[보안 자격 증명] 탭을 선택해서 [액세스 키 만들기] 버튼을 클릭한다.

![13.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/13.png)

[Command Line Interface(CLI)] 선택 - [확인] 체크박스 선택 - [다음] 버튼 클릭한다.

![14.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/14.png)

액세스 키를 생성하면 아래와 같이 [액세스 키]와 [비밀 액세스 키]가 표시된다.

[비밀 액세스 키]는 이 화면에서 보여주는게 전부이기 때문에 반드시 저장해두어야 한다.

![15.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/15.png)

발급한 액세스 키를 로컬 환경에 등록하기 위해 터미널에서 아래의 명령어를 실행한다.

```bash
aws configure
```

만약 aws cli 가 설치되지 않았다면 `brew install awscli` 를 실행해서 설치한다. (macOS 기준)

액세스 키, 비밀 액세스 키, 리전, 출력 형식을 입력한다.

출력 형식은 json 으로 입력했다.

```bash
AWS Access Key ID [None]: [access key]
AWS Secret Access Key [None]: [secret key]
Default region name [None]: [region name] # ap-northeast-2
Default output format [None]: json
```

아래의 명령어를 실행해서 설정이 잘 되었는지 확인한다.

```bash
aws sts get-caller-identity
#{
#    "UserId": "[access-key]",
#    "Account": "[AWS-ID]",
#    "Arn": "arn:aws:iam::[AWS-ID]:user/[user-name]"
#}
```

## 4. console 페이지에 AWS 계정 연동하기

배포가 잘 되었는지 확인하기 위해 SST 라이브러리에서 제공하는 console 페이지를 이용할 것이다.

https://console.sst.dev/ 로 접속하면 아래와 같이 이메일로 로그인 하는 화면이 표시된다.

### 로그인

![16.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/16.png)

이메일로 로그인을 위한 숫자 6자리가 발송되는데, 받을 이메일을 작성하고 [Continue] 버튼을 클릭한다.

이메일을 확인하면 아래와 같이 숫자 6자리가 도착했을 것이다.

![17.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/17.png)

아래와 같은 화면에 숫자를 입력한다.

![18.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/18.png)

### Workspace 생성

로그인을 마치면 Workspace 생성 화면이 표시된다.

![19.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/19.png)

사용하고자 하는 이름을 입력하고 [Create Workspace] 버튼을 클릭한다.

### AWS 계정 연동

Workspace 를 생성하면 아래와 같이 AWS 계정과 연동하라는 화면이 표시된다.

![20.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/20.png)

[Connect an AWS Account] 버튼을 클릭해서 AWS 계정으로 로그인한다.

로그인을 마치면 CloudFormation 스택 생성 화면이 아래와 같이 표시된다.

![21.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/21.png)

입력된 항목들은 수정하지 않은 채로 페이지 하단으로 내려서 [**AWS CloudFormation에서 사용자 지정 이름으로 IAM 리소스를 생성할 수 있음을 승인합니다.]** 버튼에 체크표시를 한다.

![22.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/22.png)

CloudFormation 스택 생성이 끝나면 SST console 페이지는 아래와 같이 표시된다.

![23.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/23.png)

## 5. 로컬 환경

### 배포

Next.js 프로젝트가 있는 루트 디렉토리에서 아래의 명령어를 실행한다.

```bash
npx sst deploy --stage production
```

배포까지 약 5분 ~ 10분 정도 걸린다.

배포가 정상적으로 끝나면 아래와 같이 표시된다.

![24.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/24.png)

### 삭제

마찬가지로 Next.js 프로젝트가 있는 루트 디렉토리에서 아래의 명령어를 실행한다.

```bash
npx sst remove --stage production
```

삭제도 약 5분 ~ 10분 정도 걸린다.

삭제가 완료되면 아래와 같이 표시된다.

![25.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/25.png)

## 6. CI/CD 구축

SST 라이브러리에서 제공하는 console 페이지의 autodeploy 기능을 이용하면 GitHub Repository 와 연결할 수 있다.

autodeploy 를 이용하면 Repository 의 특정 브랜치에 push 이벤트가 발생하면 자동으로 빌드 및 배포까지 할 수 있다.

CI/CD 구축을 위해서는 로컬에서 먼저 배포를 해주어야 한다.

### SST 설정 파일 확인

autodeploy 설정이 잘 되어있는지 `sst.config.ts` 파일을 확인한다.

```tsx
/// <reference path="./.sst/platform/config.d.ts" />

export default $config({
  app(input) {
    return {
      name: "my-app",
      removal: input?.stage === "production" ? "retain" : "remove",
      home: "aws",
      providers: {
        aws: {
          region: "ap-northeast-2",
        },
      },
    };
  },
  console: {
    autodeploy: {
      target(event) {
        if (
          event.type === "branch" &&
          event.action === "pushed" &&
          event.branch === "main"
        ) {
          return {
            stage: "production",
          };
        }
      },
    },
  },
  async run() {
    new sst.aws.Nextjs("my-app", {
      domain: "joonhan.link",
    });
  },
});
```

여기서는 main 브랜치에 push 가 되었을 때만 autodeploy 하도록 했다.

autodeploy 가 되려면 위의 설정 파일이 GitHub Repository 에 올라가있어야 한다.

### console 과 GitHub Repository 연결

console 첫 페이지에서 [Manage workspace] 클릭.

![26.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/26.png)

페이지 하단의 [GitHub] 슬라이드 버튼을 클릭한다.

![27.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/27.png)

연결하고자 하는 Repository 를 선택하는 페이지가 표시된다.

![28.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/28.png)

연결하고자 하는 계정 또는 조직을 선택한다.

[Only select repositories] 선택 후 연결하고자 하는 Repository 이름을 검색해서 선택한다.

선택이 끝나면 하단의 [Install] 버튼을 클릭한다.

![29.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/29.png)

연결이 되면 아래와 같이 표시된다.

![30.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/30.png)

메인 페이지로 돌아가보면 아래의 이미지와 같이 배포한 애플리케이션이 보인다.

![31.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/31.png)

만약 보이지 않고 ‘Searching for apps…’ 문구만 표시된다면 [Manage workspace] 클릭 후 [Accounts] 에서 AWS 계정의 [Rescan] 버튼을 클릭한다.

![32.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/32.png)

정상적으로 애플리케이션이 표시되면 생성한 애플리케이션 (위의 이미지에서는 my-app)을 클릭 후 [SETTINGS] 페이지로 진입한다.

[Autodeploy] 항목에서 연결하고자 하는 Repository 를 선택한다.

![33.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/33.png)

[Select] 버튼을 클릭한다.

![34.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/34.png)

[Branch environment] 클릭.

![35.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/35.png)

[STAGE] 에는 production 입력하고, [AWS ACCOUNT] 를 선택한 뒤 [Add Environment] 버튼 클릭.

![36.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/36.png)

아래와 같이 표시되면 정상적으로 연결된 것이다.

![37.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/37.png)

이제 main 브랜치에 push 하면 [AUTODEPLOY] 탭에서 배포가 진행 중인 것을 확인할 수 있다.

![38.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/38.png)

[In Progress] 를 클릭하면 아래와 같이 로그를 표시해주는 페이지로 이동한다.

![39.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/39.png)

### AUTODEPLOY 해제

[SETTINGS] 탭에서 [Disconnect] 버튼을 클릭한다.

![40.png](/assets/images/2024/2024-10-02-deploy-nextjs-using-sst/40.png)

# 참고자료

- [Next.js on AWS with SST](https://sst.dev/docs/start/aws/nextjs) [SST]
- [NoSuchBucket error with 'sst deploy' #281](https://github.com/sst/ion/issues/281) [GitHub]