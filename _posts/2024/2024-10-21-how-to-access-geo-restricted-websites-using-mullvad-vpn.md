---
title: "국가 제한이 걸린 사이트에 접속하는 방법 (feat. Mullvad VPN)"
date: 2024-10-21 11:30:00 +0900
categories: [network]
tags: []
---

# 해외 사이트 접속이 왜 안될까?

해외에서 접속이 잘 되는 사이트는 대체로 다른 국가에서도 문제 없이 접속된다. 하지만 일부 사이트는 특정 국가 외에서의 접속을 제한하는 경우가 있다.

예를 들면, 호주의 대형마트인 [Coles](https://www.coles.com.au/) 는 호주 외 국가에서 접속하는 것을 막고 있다. (2023년 07월 24일 접속 기준)

![1.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/1.png)

대부분의 사이트는 이런 제약이 없는데, **왜 특정 사이트는 국가별 접속 제한을 걸까?**

## 왜 사이트는 접속을 제한할까?

이유는 여러 가지가 있겠지만, **보안상의 이유**가 가장 크다.

가장 쉬운 예로, 한국 기업에 대한 해킹 시도는 **북한이나 중국 같은 해외**에서 이루어지는 경우가 많다. 사이버 공격은 법적으로 처벌이 가능하지만, **해외 공격자를 추적하거나 처벌하는 일은 복잡**하다.

따라서 기업이나 국가 입장에서는 **해외 접속을 허용하는 것이 잠재적인 위협**이 될 수 있기 때문에 일부 사이트는 **해외 접속을 차단**하고 있다.

그렇다면, 해외 사이트를 접속하려면 **물리적으로 해당 국가를 방문**해야 할까?

그렇지 않다. 여러 방법 중 **VPN** 을 이용하면 **현지에 있지 않아도 접속이 가능**하다.

# VPN 이란?

VPN 은 Virtual Private Network 의 약자로, ‘가상 사설망’을 뜻한다.

개념을 이해하기 위해서 **해외 직구와 배송대행지**를 예로 들어보자.

## 해외 직구와 배송대행지

해외 쇼핑몰 중에는 국제 배송을 지원하지 않는 곳이 있다. 이런 경우에는 **해당 국가에 있는 배송대행지**를 통해 물건을 받아야 한다.

![2.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/2.png)

소비자는 **쇼핑몰에서 주문할 때 배송대행지 주소**를 입력하고, 배송대행지에 **주문 정보와 실제 배송받을 주소**를 전달한다. 이를 통해 판매자는 **소비자의 실제 주소를 알지 못해도** 물건을 안전하게 배송할 수 있다.

## VPN 의 개념 적용

VPN 도 배송대행지와 비슷한 역할을 한다.

인터넷에서 데이터를 주고받을 때는 택배처럼 **출발지와 목적지**가 명확하게 표시되는데, **VPN 은 사용자의 접속 요청을 대신 보내주는 중간 매개체**다.

![3.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/3.png)

즉, VPN 을 통해 사이트에 접속하면 사이트는 **사용자가 실제로 어디에서 접속하는지**를 파악하기 어렵다.

VPN 이 **사용자의 위치를 감추고** 대신 **다른 위치에서 접속**하는 것처럼 보이게 해주기 때문이다.

여러 소프트웨어 회사에서 다양한 VPN 을 제공하고 있으며, 이를 통해 다양한 국가에 위치한 서버로 접속할 수 있다.

## 개인 정보 노출 위험은 없을까?

VPN 을 사용할 때, **100% 안전을 보장할 수 없다**. 인터넷에서 이동하는 모든 데이터는 **가로채기**가 가능하기 때문이다. 그러나 **암호화 기술** 덕분에 이러한 데이터를 해독하는 것은 매우 어렵다.

택배가 중간에 열릴 수 있듯이, VPN 도 데이터를 중간에서 열어보거나 기록할 가능성이 있다. 특히 **무료 VPN 은 민감한 개인 정보를 수집**할 가능성이 높기 때문에 유료 VPN 사용을 권장한다.

유료 VPN 이 데이터를 가로채지 않는다고 보장할 수 없지만, **더 높은 수준의 암호화**와 **안정적인 서비스**를 제공한다.

# Mullvad VPN 소개

인터넷에 유료 VPN 을 검색하면 **Nord VPN**, **Express VPN** 과 같은 서비스가 먼저 보인다. 이들은 마케팅에 많은 비용을 들여 **대대적인 할인**을 진행하기도 한다.

하지만 개인적으로 이런 마케팅 전략을 사용하는 서비스는 제품 개발보다 마케팅에 더 신경을 쓰는 것 같아 선호하지 않는다. 그러다 발견한 것이 **Mullvad VPN** 이다.

**Mullvad VPN** 은 스웨덴에서 운영하는 서비스이며, **소스 코드가 공개**되어 있어서 **보안상 취약점이 없는지** 누구나 확인할 수 있다.

가격도 5유로(약 6,600원)로 고정되어 있어, 할인이나 마케팅에 치중하지 않는 투명한 가격 정책이 돋보인다.

참고로, **Mullvad** 는 스웨덴어로 ‘두더지’를 뜻한다.

## 사용법 (MacOS 기준)

1. Mullvad VPN 홈페이지에 접속한다. ([링크](https://mullvad.net/))
2. 우측 상단에 ‘계정’(Account)을 클릭한다.

   ![4.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/4.png)

3. ‘새 계정 생성’ 클릭

   ![5.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/5.png)

4. ‘계정 번호 생성’ 클릭

   ![6.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/6.png)

   이 부분도 정말 마음에 드는 부분 중 하나이다. 회원가입을 하기 위해서 어떠한 정보도 요구하지 않는다!

5. 생성된 계정 번호를 다른 곳에 메모해두고, ‘계정에 시간 추가’를 클릭한다.

   ![7.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/7.png)

6. 원하는 결제 방식을 선택해서 결제한다. 페이팔도 지원하고 있다.

   ![8.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/8.png)

7. 결제를 완료했으면 상단 메뉴바의 ‘다운로드’를 클릭한다.

   ![9.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/9.png)

8. 본인의 운영체제에 맞게 선택해서 다운로드한다.

   ![10.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/10.png)

9. 다운로드가 끝나면 받은 파일을 실행한다. (Mac OS는 .pkg 파일)
10. Continue 클릭

    ![11.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/11.png)

11. Install 클릭

    ![12.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/12.png)

12. 비밀번호 또는 지문으로 인증

    ![13.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/13.png)

13. OK 클릭

    ![14.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/14.png)

14. 설치 끝

    ![15.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/15.png)

15. 런치 패드 또는 Spotlight(cmd + space)를 통해서 Mullvad VPN 실행

    ![16.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/16.png)

16. 상단 바에 빨간색 자물쇠 클릭

    ![17.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/17.png)

17. 5번에서 메모해둔 16자리 번호 입력

    ![18.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/18.png)

18. 국가 선택을 위한 버튼 클릭

    ![19.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/19.png)

19. 원하는 국가와 도시를 클릭

    ![20.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/20.png)

20. 아래 화면과 같이 나온다면 정상적으로 연결된 것이다.

    ![21.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/21.png)

21. 해외 사이트를 마음대로 접속할 수 있게 되었다. 만약 속도가 느리다면 같은 국가의 다른 도시를 선택해서 접속하면 된다.

    ![22.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/22.png)

## 유의사항

### 필요할 때만 VPN 사용하기

VPN 을 사용하면 중개자를 거치기 때문에 인터넷 사용 속도가 VPN 을 사용하지 않을 때보다 느려질 수 있다.

그래서 불필요할 때는 VPN 을 끄는 것이 좋다.

VPN 을 끄려면 아래의 화면과 같이 Disconnect 버튼을 클릭하면 된다.

![23.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/23.png)

### 30일 환불 정책

Mullvad VPN 은 결제 후 30일 이내 환불이 가능하다.

자세한 내용은 아래의 링크를 참고하면 된다.

- https://mullvad.net/ko/help/refunds/

### 프로그램 삭제 방법

1. 프로그램을 삭제하기 전에는 프로그램을 종료해야 한다. 상단 바에 있는 아이콘을 선택하고, 톱니바퀴 버튼을 클릭한다.

   ![24.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/24.png)

2. Quit 버튼을 클릭한다.

   ![25.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/25.png)

3. Finder - 좌측 메뉴바에서 Application 클릭 - Mullvad VPN 을 찾아서 삭제(cmd + backspace)한다.

   ![26.png](/assets/images/2024/2024-10-21-how-to-access-geo-restricted-websites-using-mullvad-vpn/26.png)

# 참고자료

- [가상 사설망](https://namu.wiki/w/%EA%B0%80%EC%83%81%20%EC%82%AC%EC%84%A4%EB%A7%9D) [나무위키]
- [개발자는 알아야 할 VPN 작동원리](https://www.youtube.com/watch?v=Q0EgiHhw-E4) [youtube]
- [Mullvad VPN](https://namu.wiki/w/Mullvad%20VPN) [나무위키]
