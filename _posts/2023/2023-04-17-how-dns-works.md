---
title: "DNS 작동 방식"
date: 2023-04-17 09:49:00 +0900
categories: [Network]
tags: [Network]
---

# DNS란?

우리는 구글에 접속하기 위해 웹 브라우저 주소창에 `www.google.com` 라는 문자열을 입력한다.

어떤 사이트에 접속한다는 것은 IP 주소를 기반으로 클라이언트와 서버가 통신하는 것이다. 그래서 클라이언트는 사이트가 운영하는 서버의 IP 주소를 알아야 원하는 페이지를 볼 수 있는 것이다.

하지만 사람이 숫자로 된 IP 주소를 입력해서 사이트에 접속하는 것은 번거로운 일이다. 그래서 IP 주소를 사람이 기억하기 쉽고 알아보기 쉬운 문자열 형태로 바꾼 도메인 주소 체계가 만들어졌는데, 이를 DNS(Domain Name System) 라고 한다.

그래서 우리가 웹 브라우저 주소창에 `www.google.com` 문자열을 입력하면, 도메인 목록을 관리하고 있는 DNS 서버는 `www.google.com` 를  `8.8.8.8` 과 같은 IP 주소로 변환해준다.

## 도메인 체계

![1.png](/assets/images/2023/2023-04-17-how-dns-works/1.png)

출처: [도메인이란?](https://xn--3e0bx5euxnjje69i70af08bea817g.xn--3e0b707e/jsp/resources/domainInfo/domainInfo.jsp) [KISA]

도메인 체계는 `.` 또는 루트라고 부르는 도메인 이하에 트리 구조로 되어 있다.

위의 그림을 보면 `.kr` 도메인에는 `.or` 영역을 표현하는 `or.kr` 도메인이 포함되어 있고, `or.kr` 도메인에는 `kisa.or.kr` 도메인이 포함되어 있다.

## DNS 서버 종류

![2.png](/assets/images/2023/2023-04-17-how-dns-works/2.png)

출처: [DNS란 뭐고, 네임서버란 뭔지 개념정리](https://gentlysallim.com/dns%EB%9E%80-%EB%AD%90%EA%B3%A0-%EB%84%A4%EC%9E%84%EC%84%9C%EB%B2%84%EB%9E%80-%EB%AD%94%EC%A7%80-%EA%B0%9C%EB%85%90%EC%A0%95%EB%A6%AC/) [gentlysallim]

도메인 서버는 크게 아래와 같이 구분한다.

### Recursive DNS 서버(로컬 DNS 서버)

사용자가 특정 사이트의 IP 주소를 물어볼 때 가장 먼저 물어보는 서버이다.

KT, LG, SK 와 같은 인터넷 제공 업체에서 운영하는 도메인 서버이다. 사이트를 접속할 때마다 매번 아래의 3개 서버를 거친다면 비효율적이기 때문에 일정기간(TTL; Time to Live) 동안 캐시에 저장해둔다.

직접 도메인과 IP 의 관계를 기록, 저장, 변경하지는 않으며, 반복해서 아래의 3개 서버들에게 질의를 요청하기 때문에 Recursive 라는 단어를 사용한다.

CloudFlare 와 같은 Public DNS 서버도 이에 속한다.

### Root DNS 서버

ICANN 이라는 비영리 단체가 운영하는 DNS 서버이다.

TLD DNS 서버 IP를 저장하고 안내하며, 전 세계의 IP 주소를 관리한다.

`a.root-server.net` 이라는 주소를 가진 컴퓨터가 존재하고, a 부터 m 까지 총 13개의 루트 네임 서버가 전 세계에 흩어져 있다. 각 컴퓨터들은 전 세계로 다시 흩어져서 여러 고성능 컴퓨터가 루트 네임 서버로서 동작하고 있다.

### Top Level Domain(TLD) 서버

루트 네임 서버가 관리하는 ICANN 밑에 Registry(등록소) 라는 기관 또는 기업이 있다.

Registry 는 `.com` / `.kr` / `.net` 과 같이 Top-level domain 들을 관리한다. `.com` 도 여러 네임 서버를 가지고 있다.

TLD 는 Authoritative DNS 서버 주소를 저장하고, 이를 안내하는 역할을 한다.

### Authoritative DNS 서버

실제 개인 도메인과 IP 주소의 관계가 기록, 저장, 변경되는 서버이다. 그래서 ‘권한’ 또는 ‘책임’이라는 의미의 Authoritative 단어를 사용한다. 일반적으로 도메인/호스팅 업체의 네임 서버를 의미하지만, 개인 DNS 서버도 여기에 속한다.

# DNS 작동 과정

그렇다면 우리가 웹 브라우저 주소창에 `www.google.com` 라는 문자열을 입력하면 실제로 어떤 과정을 거치는 걸까?

## DNS 서버 존재 이전

DNS 서버가 존재하기 이전에는 각 사용자들은 `/etc/hosts` 파일에 호스트 테이블(도메인 네임과 IP 주소를 대응한 표)를 직접 등록해서 사용했다.

```bash
$ cat /etc/hosts
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
```

호스트 컴퓨터의 수가 점점 늘어나면서 호스트 테이블을 중앙에 하나로 두고, 각 사용자들은 직접 업데이트를 받아서 사용했다.

하지만 이 방법도 얼마 가지 못해 한계에 이르렀고, DNS 가 등장했다.

## DNS 서버 존재 이후

![3.png](/assets/images/2023/2023-04-17-how-dns-works/3.png)

Linux/Mac 운영체제 기준으로는 위의 그림에 표시된 순서와 같으며 구체적으로는 아래와 같다.

1. `/etc/hosts` 파일에 ( `www.google.com` )에 해당하는 IP 주소가 있는지 확인한다.
2. 요청한 도메인이 없으면 DNS 캐시 테이블에서 해당 도메인에 대응하는 IP 주소를 검색한다.
    - DNS 캐시 테이블은 운영체제 내에서 도메인의 IP 주소 목록을 저장하고 있다.
3. DNS 캐시 테이블에 요청한 도메인의 IP 주소가 있는지 확인한다.
4. 요청한 도메인이 존재하지 않으면 로컬 DNS 서버로 요청한 도메인 네임에 대한 질의한다.
5. 로컬 DNS 서버에 요청한 도메인의 IP 주소가 있는지 질의한다.
6. 로컬 DNS 서버는 루트 DNS 서버에 `.com` 을 관리하는 DNS 서버의 IP 주소를 질의한다.
7. `.com` 도메인을 관리하는 DNS 서버의 IP 를 응답한다.
8. 로컬 DNS 서버는 다시 `.com` 을 관리하는 DNS 서버에 `google.com` 의 주소를 관리하는 DNS 서버 IP 를 질의한다.
9. `google.com` 을 관리하는 DNS 서버의 IP 주소를 응답한다.
10. 9번에서 받은 DNS 서버로 `google.com` 의 IP 주소를 질의한다.
11. `google.com` 의 IP 주소를 응답한다.
12. 로컬 DNS 서버는 클라이언트에게 `google.com` IP 주소를 응답한다.
13. 클라이언트는 `google.com` IP 주소로 요청을 보낸다.
14. `google.com` IP 주소에서 작동하는 서버가 클라이언트에게 응답한다.

# 참고자료

- [DNS란?](https://mer1.tistory.com/6) [티스토리]
- [DNS 캐시 테이블이란?](https://mer1.tistory.com/57) [티스토리]
- [DNS란 뭐고, 네임서버란 뭔지 개념정리](https://gentlysallim.com/dns%EB%9E%80-%EB%AD%90%EA%B3%A0-%EB%84%A4%EC%9E%84%EC%84%9C%EB%B2%84%EB%9E%80-%EB%AD%94%EC%A7%80-%EA%B0%9C%EB%85%90%EC%A0%95%EB%A6%AC/) [gentlysallim]
- [DNS](http://www.ktword.co.kr/test/view/view.php?m_temp1=264) [정보통신기술용어해설]
- [도메인 네임 시스템](https://ko.wikipedia.org/wiki/%EB%8F%84%EB%A9%94%EC%9D%B8_%EB%84%A4%EC%9E%84_%EC%8B%9C%EC%8A%A4%ED%85%9C) [위키백과]
- [Domain Name System(DNS)의 이해](https://zzsza.github.io/development/2018/04/16/domain-name-system/) [github.io]