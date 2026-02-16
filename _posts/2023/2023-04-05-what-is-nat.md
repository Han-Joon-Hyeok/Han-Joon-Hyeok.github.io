---
title: "NAT란?"
date: 2023-04-05 12:40:00 +0900
categories: [network]
tags: [network]
---
# NAT

## 개념

NAT 는 Network Address Translation 의 약자로, 네트워크 주소 변환을 의미한다.

IP 패킷에 있는 출발지 및 목적지의 IP 주소와 TCP/UDP 포트 숫자 등을 바꿔 재기록하면서 네트워크 트래픽을 주고 받도록 하는 기술이다.

## 동작 원리

![1.png](/assets/images/2023/2023-04-05-what-is-nat/1.png)

출처: [Network address translation [wikipedia]](https://en.wikipedia.org/wiki/Network_address_translation)

집에서 사용하는 인터넷 공유기를 통해 외부에 있는 웹 서버에 접근하는 경우, 요청 패킷은 반드시 공유기를 거친다.

이때, 출발지의 사설망 IP 주소가 그대로 외부 인터넷으로 나가면 수신 측(웹 서버)는 알 수 없는 사설망의 IP 주소이기 때문에 어디로 응답을 보내주어야 할 지 알 수 없다.

따라서 공유기(게이트웨이)는 패킷 출발지의 사설망 IP 주소를 자신의 공인 IP 주소로 변경하여, 수신 측에 응답을 보내주어야 할 곳을 명확하게 표시한다.

반대로 외부에서 들어오는 패킷은 목적지 IP 주소를 공인 IP 주소에서 사설망 IP 주소로 변경한다.

## 참고자료

- [[이해하기] NAT (Network Address Translation) – 네트워크 주소 변환](https://www.stevenjlee.net/2020/07/11/%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0-nat-network-address-translation-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC-%EC%A3%BC%EC%86%8C-%EB%B3%80%ED%99%98/) [stevenjlee]