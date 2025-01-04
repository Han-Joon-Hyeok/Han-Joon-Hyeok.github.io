---
title: "[AWS] [AWS] Route 53 계정 간 도메인 이전 방법 및 ACM 발급"
date: 2025-01-05 00:10:00 +0900
categories: [aws]
tags: []
---

# 개요

AWS Route 53에서 구매한 도메인을 서로 다른 AWS 계정으로 이전하는 방법과 AWS Certificate Manager(ACM)을 이용해 HTTPS 통신을 위한 인증서를 발급하는 과정을 정리했습니다.

# 상황

AWS 계정 A와 B가 있다고 가정합니다.

1. 계정 A에서 Route 53을 통해 구매한 도메인의 소유권을 계정 B로 이전하려고 합니다.
2. 계정 B에서 이전받은 도메인을 CloudFront와 연결해 HTTPS 통신을 설정하려고 합니다.

# 과정

## 1. 도메인 소유권 이전

### Source Account (계정 A)

1. [Route 53] - [Domains] - [Registered domains] 메뉴로 이동합니다.
2. 이전하려는 도메인을 선택하여 상세 페이지로 진입합니다.
3. [Transfer out] - [Transfer to another AWS account]를 선택합니다.

   ![1.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/1.png)

4. 이전할 대상 AWS 계정의 Account ID(12자리)를 입력한 뒤, [Confirm]을 클릭합니다.

   ![2.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/2.png)

5. 생성된 암호를 복사합니다. 이 암호는 도메인 이전 요청을 인증하는 데 사용됩니다.

   ![3.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/3.png)

### Destination Account (계정 B)

1. [Route 53] - [Domains] - [Requests] 페이지에 진입합니다.
2. 이전 요청을 선택한 뒤, [Actions] - [Accept]를 클릭합니다.

   ![4.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/4.png)

3. 도메인을 입력하고 [Check] 버튼을 클릭합니다. 그리고 복사했던 비밀번호를 입력합니다.

   ![5.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/5.png)

4. 약관에 동의하고 [Transfer domain] 버튼을 클릭합니다.

   ![6.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/6.png)

5. 약 5분 후 도메인 이전이 완료됩니다.

   ![7.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/7.png)

## 2. 네임서버 수정

ACM 인증서를 발급받기 위해서는 네임서버를 수정해야 합니다.

1. [Route 53] - [Hosted zones] 페이지로 진입하여 [Create hosted zone] 버튼을 클릭합니다.

   ![8.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/8.png)

2. 이전 받은 도메인을 Public hosted zone으로 생성합니다.

   ![9.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/9.png)

3. NS 레코드에 생성된 주소 4개를 복사합니다.

   ![10.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/10.png)

4. [Route 53] - [Domains] - [Registered domains] 페이지 진입 후, 이전 받은 도메인을 클릭합니다. 이후 [Actions] - [Edit name servers]를 클릭합니다.

   ![11.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/11.png)

5. 복사한 NS 레코드의 주소 4개를 입력하고 [Save changes] 버튼을 클릭합니다.

   ![12.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/12.png)

## 3. ACM 인증서 발급

CloudFront에서 사용할 인증서는 반드시 us-east-1 리전에서 발급받아야 합니다.

1. us-east-1 리전으로 페이지를 전환하고, ACM 페이지로 이동합니다. [List certificates] 페이지에 진입하여 [Request] 버튼을 클릭합니다.

   ![13.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/13.png)

2. public certificate가 기본 선택된 상태에서 [Next] 버튼을 클릭합니다.

   ![14.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/14.png)

3. 도메인 이름을 입력하고 [Request] 버튼을 클릭합니다.

   ![15.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/15.png)

4. 표시된 페이지에서 [Create records in Route 53] 버튼을 클릭합니다.

   ![16.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/16.png)

5. [Create records] 버튼을 클릭하여 ACM 인증서에 대한 CNAME 레코드를 생성합니다.

   ![17.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/17.png)

6. 약 5분 정도 기다리면 인증서가 정상적으로 발급된 것을 확인할 수 있습니다.

   ![18.png](/assets/images/2025/2025-01-05-aws-transfer-domain-to-another-account/18.png)
