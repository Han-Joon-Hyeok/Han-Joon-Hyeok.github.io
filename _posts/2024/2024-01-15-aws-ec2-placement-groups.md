---
title: "[AWS] EC2 인스턴스 구매 옵션 비교 정리"
date: 2024-01-15 15:47:00 +0900
categories: [aws]
tags: []
---

# 배치 그룹(Placement Groups)

## 개요

EC2 인스턴스는 서버 랙(Rack)에 설치된 여러 서버 컴퓨터에서 가상머신을 할당 받아서 사용하는 것이다.

하지만 특정 서버 랙이 고장 난다면 가상머신이 제대로 작동하지 않을 것이고, 우리가 EC2 에서 배포하거나 작동시키고 있는 애플리케이션도 오류가 발생할 수 있다.

그렇기 때문에 EC2 인스턴스의 물리적인 위치를 분리하여 가용성을 높이는 전략이 필요했고, 배치 그룹(Placement Groups)가 이를 도와준다.

배치 그룹은 EC2 인스턴스의 물리적 위치를 어디에 배치할 것인지 정하는 설정 항목이다.

배치 그룹 종류에는 3가지가 존재한다.

## 클러스터(Cluster)

![출처: [AWS Docs](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/placement-groups.html)](/assets/images/2024/2024-01-15-aws-ec2-placement-groups/1.png)

출처: [AWS Docs](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/placement-groups.html)

클러스터는 같은 가용 영역(AZ) 안에서 같은 랙(Rack)에서 EC2 인스턴스를 실행하는 전략이다.

같은 하드웨어 안에 있기 때문에 애플리케이션 간의 네트워크 통신 속도가 빠른 장점이 있다.

즉, 지연 시간이 짧은 서비스를 운영하기에는 클러스터가 유리한 선택이다.

하지만, 같은 하드웨어에 있기 때문에 하나라도 실패하거나 고장나면 다른 인스턴스들도 사용하지 못하는 단점이 있다.

## 분산(Spread)

![출처: [in28minutes](https://cloud.in28minutes.com/aws-certification-ec2-placement-groups)](/assets/images/2024/2024-01-15-aws-ec2-placement-groups/2.png)

출처: [in28minutes](https://cloud.in28minutes.com/aws-certification-ec2-placement-groups)

분산은 데이터 손실 및 서비스 실패 위험을 감소시키기 위해 같은 리전 안에서 다수의 가용 영역을 사용하고, 서로 다른 하드웨어 랙에 인스턴스를 분산 배치한다.

어떤 EC2 가 작동하고 있는 하드웨어 랙이 고장나거나 실패하더라도, 다른 랙이 작동할 것이기 때문에 가용성이 높아지는 장점이 있다.

인스턴스 오류를 서로 격리해야 하는 크리티컬 애플리케이션 환경에 적합하다.

하지만 하나의 가용 영역 안에 인스턴스 7개만 사용할 수 있다는 제한이 있다.

그래서 너무 크거나 너무 작지 않은 중간 사이즈의 애플리케이션에 적절하다.

## 분할(Partition)

![출처: [Medium](https://enlear.academy/lets-talk-about-ec2-placement-groups-and-hibernate-a6e4bed854c)](/assets/images/2024/2024-01-15-aws-ec2-placement-groups/3.png)

출처: [Medium](https://enlear.academy/lets-talk-about-ec2-placement-groups-and-hibernate-a6e4bed854c)

여러 가용 영역의 파티션에 인스턴스를 분산하는 전략이다.

파티션은 하드웨어 랙을 의미하는데, 가용 영역당 최대 7개의 파티션을 사용할 수 있다.

파티션 간에는 동일한 하드웨어를 공유하지 않지만, 파티션 내에서 특정 인스턴스의 오류는 파티션 내 전체 인스턴스에 영향을 줄 수 있다.

100개 이상의 EC2 인스턴스를 실행할 수 있기 때문에 대규모 애플리케이션에 적합한 전략이다.

HDFS, HBase, Cassandra, Kafka 와 같은 빅 데이터 애플리케이션에 적합하다.

# 참고자료

- [배치 그룹](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/placement-groups.html) [AWS Docs]