---
title: "HTTP와 HTTPS, 그리고 SSL/TLS"
date: 2023-04-05 13:05:00 +0900
categories: [docker]
tags: [docker]
---

# HTTP 와 HTTPS

## HTTP

HTTP 는 HyperText Transfer Protocol 의 약자로, 하이퍼텍스트를 전송하기 위해 사용되는 통신 규약(Protocol)이다.

즉, 인터넷에서 HTML 과 같은 문서를 클라이언트(사용자)의 웹 브라우저가 웹 서버(서비스 제공자)에 요청하거나 웹 서버가 클라이언트에서 응답을 보낼 때 지켜야 하는 규칙(프로토콜)을 의미한다.

여기서 프로토콜이란 간단하게 정해진 규칙 또는 양식이라 생각하면 된다. 택배를 주고 받을 때 정해진 송장 양식에 올바르게 작성해야 문제없이 잘 주고 받을 수 있는 것과 비슷하다.

![1.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/1.png)

HTTP 서버(웹 서버)는 80번 포트에서 서비스를 대기하고 있다가 클라이언트(웹 브라우저)가 TCP 80번 포트를 사용해 연결하면 서버는 요청에 응답하면서 자료를 전송한다.

### 요청 메세지(request message)

클라이언트가 서버에 요청(request)을 할 때는 아래와 같은 내용을 담아서 보낸다.

![2.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/2.png)

출처: [HTTP Request Message Format](http://www.tcpipguide.com/free/t_HTTPRequestMessageFormat.htm) [tcpipguide]

포함되는 내용을 추려서 정리하면 아래와 같다.

- 요청하는 리소스(위의 사진에서는 `/index.html`)
- 어떤 메서드를 사용할지(GET, POST, DELETE, PUT 등)
- HTTP 버전 정보
- 요청을 보내는 도메인 이름(현재 클라이언트가 접속한 사이트의 주소)

### 응답 메세지(response message)

서버는 클라이언트가 요청한 것에 대해 응답(response)할 때는 아래와 같은 내용을 담아서 보낸다.

![3.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/3.png)

출처: [HTTP Request Message Format](http://www.tcpipguide.com/free/t_HTTPRequestMessageFormat.htm) [tcpipguide]

- HTTP Status code : 응답 처리에 대한 결과 (200 OK = 정상)
- Message Body: 요청한 파일의 내용

## HTTPS

HTTP 는 정보를 텍스트로 주고 받기 때문에 네트워크에서 전송 신호를 가로챌 가능성이 존재하며, 데이터 유출이 발생할 수 있는 보안 취약점이 있다.

데이터 유출이 발생할 수 있는 이유는 패킷이 요청한 서버에 도달하기 위해 거쳐가야 하는 수 많은 공유기, 네트워크 장비가 존재하기 때문이다.

![4.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/4.png)

출처: [Traceroute in Network Layer](https://www.geeksforgeeks.org/traceroute-in-network-layer/) [geeksforgeeks]

누군가 패킷 내부를 확인해서 민감한 개인 정보를 가로챌 수도 있고, 클라이언트 입장에서는 누군가 패킷 내부를 확인했는지 여부를 알 수 없다는 문제점이 있다.

또는, 중간에 누군가 서버인척 위장하여 클라이언트의 패킷을 가로채서 응답을 보내줄 수도 있다. ([ARP 스푸핑](https://namu.wiki/w/ARP%20%EC%8A%A4%ED%91%B8%ED%95%91))

실제로 macOS 환경에서 구글 서버 IP 주소인 8.8.8.8 에 요청을 보내보면 수 많은 경로를 거쳐가는 것을 확인할 수 있다.

```bash
$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 64 hops max, 52 byte packets
1  10.31.254.254 (10.31.254.254)  1.076 ms  0.595 ms  0.510 ms
2  nat (10.60.1.1)  0.168 ms  0.169 ms  0.231 ms
3  * * *
4  112.189.14.85 (112.189.14.85)  0.766 ms  0.623 ms
  112.189.13.85 (112.189.13.85)  0.857 ms
5  * * *
6  112.174.90.10 (112.174.90.10)  8.583 ms
  112.174.90.62 (112.174.90.62)  5.806 ms
  112.174.90.38 (112.174.90.38)  7.515 ms
7  112.174.84.18 (112.174.84.18)  7.874 ms
  112.174.84.14 (112.174.84.14)  6.282 ms
  112.174.84.30 (112.174.84.30)  6.419 ms
8  142.250.165.78 (142.250.165.78)  28.176 ms
  72.14.243.228 (72.14.243.228)  32.753 ms
  142.250.165.78 (142.250.165.78)  28.055 ms
9  * * *
10  dns.google (8.8.8.8)  29.805 ms  31.165 ms  30.371 ms
```

이처럼 HTTP 가 가진 문제점을 해결하기 위해 HTTP 에 SSL(Secure Socket Layer)을 추가한 것이 HTTPS 이다.

HTTPS 를 사용하면 서버와 클라이언트 사이의 모든 통신 내용이 암호화된다.

# SSL(Secure Socket Layer)

SSL 은 넷스케이프에서 개발한 인터넷 보안 프로토콜이다.

SSL 1.0 은 공개되지 않았지만, SSL 2.0 은 1995년에, SSL 3.0 은 1996년에 발표되었다.

SSL 은 기업이 만든 프로토콜이기 때문에 독점의 우려가 있었고, 인터넷 관련 기술을 표준화하는 IETF 에서 SSL 3.0 을 TLS 1.0 로 발표하였다. (TLS : Transport Layer Security 의 줄임말)

SSL 및 TLS 의 버전 발표 연도는 아래와 같다.

| 버전 | 연도 |
| --- | --- |
| SSL 1.0 | ? |
| SSL 2.0 | 1995 |
| SSL 3.0 | 1996 |
| TLS 1.0 | 1999 |
| TLS 1.1 | 2006 |
| TLS 1.2 | 2008 |
| TLS 1.3 | 2018 |

엄밀히 말하면 SSL 은 TLS 와 다르지만, 큰 흐름에서 보았을 때 TLS 가 SSL 을 계승했다는 점에서 TLS 와 SSL 은 동일한 의미에서 사용하고 있다.

![5.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/5.png)

출처: [SSL/TLS 와 HTTPS](https://www.lesstif.com/ws/ssl-tls-https-43843962.html) [lessif]

TLS 는 전송 계층(Transport layer)의 암호화 방식이기 때문에 HTTP 뿐만 아니라 FTP, XMPP 등 응용 계층 프로토콜의 종류에 상관없이 사용할 수 있다는 장점이 있다. 또한 인증, 암호화, 무결성을 보장한다.

- 암호화 : 데이터를 제 3자가 볼 수 없도록 숨긴다.
- 인증 : 정보를 교환하는 당사자가 정보를 요청한 당사자임을 보장한다.
- 무결성 : 데이터가 바뀌지 않고 원본 그대로 전달

## TLS Handshake

서버와 클라이언트는 데이터를 주고 받기 전에 서로 연결할 수 있는 상태인지 확인해야 한다.

이를 Handshake(악수) 라 하며, TLS 는 아래와 같은 과정을 거쳐 연결이 이루어진다.

클라이언트는 서버의 인증서를 받아 서버의 무결성을 확인한다. 만약, 신뢰할 수 있는 서버라는 것을 확인하면 클라이언트는 암호화 통신에 사용할 대칭키를 서버의 공개키로 암호화 하여 전달한다. 이 과정을 TLS Handshake 이다.

![6.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/6.png)

출처: [TLS(SSL) - 3. Handshake](https://babbab2.tistory.com/7) [티스토리]

TLS 를 이용한 통신은 위의 그림과 같은 과정을 거쳐서 이루어진다.

### 1. ClientHello

클라이언트는 서버에 ClientHello 메세지를 전송한다. 패킷에는 아래와 같은 정보들이 담긴다.

- 클라이언트에서 사용하는 TLS 버전
- Cipher Suites(클라이언트가 지원하는 암호화 방식) : 서버와 클라이언트가 지원하는 암호화 방식이 다를 수 있기 때문에 handshake 를 통해 어떤 암호화 방식을 사용할 지 정한다. 구체적으로는 아래와 같은 항목들이 포함된다.

    ```bash
    SSL/TLS_(A)_(B)_WITH_(C)_(D)_(E)
    - (A) : 키 교환 암호 알고리즘
    - (B) : 인증 알고리즘
    - (C) : 대칭 암호 알고리즘
    - (D) : 블록 암호 운용 방식
    - (E) : 해시 알고리즘
    ```

    - 키 교환 알고리즘 : 서버와 클라이언트가 키를 교환하는 알고리즘
    - 인증 알고리즘 : 서버와 클라이언트가 교환한 인증서를 확인하는 알고리즘
    - 대칭 암호 알고리즘 : 실제 데이터를 암호화 하는 알고리즘
    - 블록 암호 운용 방식 : 데이터를 암호화할 때 한번에 암호화 하지 않고 블록 단위로 하는데, 블록된 암호화 패킷을 조합하여 데이터를 추측하는 것을 방지하기 위한 방식
    - 해시 알고리즘 : 서로 상대방이 암호화한 것이 맞는지 확인하는 알고리즘
- Client Random Data(클라이언트에서 생성한 난수. 대칭키 생성 시 사용)
- 세션 ID : 동일한 클라이언트와 서버가 매번 Handshake 를 한다면 많은 시간이 소요될 것이다. 그래서 최초의 Handshake 만 Full handshake(서버 인증서 확인, 암호화 방식 선정, 대칭키 교환 등)를 수행하고, 이후에는 세션 ID 만 확인해서 통신을 한다.

![7.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/7.png)

    출처: [TLS(SSL) - 3. Handshake](https://babbab2.tistory.com/7) [티스토리]

    - 최초 Handshake 에서 클라이언트의 세션 ID 는 0 이다.
    - 이후 ServerHello 메세지를 통해 서버는 세션 ID 를 보낸다.
    - 클라이언트는 서버가 보낸 세션 ID 를 로컬에 저장한다.
    - 이후 같은 서버와 Handshake 를 하면, 이전에 로컬에 저장한 세션 ID 를 전송한다.
    - 서버는 세션 ID 를 확인해서 다시 사용해도 괜찮으면 ServerHello 에 같은 세션 ID 를 보낸다.
- SNI(Server Name Indication, 서버 이름) : 서버의 이름(ex. www.naver.com)을 표시하는 부분이다.
    - 기존에는 IP 주소와 도메인이 1:1 대응되었기 때문에 문제가 없었다.
    - 하지만, 최근에는 IP 주소 하나에 여러 도메인을 연결할 수 있기 때문에 문제가 발생한다. 서버에서 발행한 인증서 하나에 모든 도메인을 명시하는 것은 불가능하며, 도메인마다 인증서를 발급하는 것도 비효율적이다.
    - 따라서 IP 주소에 접속할 때, 어떤 도메인에 접속하는 지 명시하는 부분이 SNI 이다.
    - 이를 이용하면 물리적으로 동일한 서버에 존재하는 각기 다른 도메인들이 서로 다른 TLS 인증서를 적용할 수 있다.

### 2. ServerHello

클라이언트가 보낸 ClientHello 에 대해 서버에서 응답하는 메세지이다.

포함되는 정보는 ClientHello 와 유사하며, 구체적으로는 아래와 같다.

- 서버에서 사용하는 TLS 버전
- Selected Suite : 클라이언트가 보낸 암호화 방식 중에서 서버가 사용 가능한 암호화 방식이다.
- Server Random Data : 서버에서 생성한 난수이다. 클라이언트와 동일하게 대칭키를 만들기 위해 사용한다.
- 세션 ID : ClientHello 에 세션 ID 가 0 으로 왔다면 새로 세션 ID 를 생성해서 보내고, 0 이 아니라면 해당 세션 ID 가 유효한지 확인하고 새로 발급해주거나 클라이언트가 보낸 세션 ID 를 그대로 보내준다.
- SNI : 서버에서는 비워서 보낸다.

### 3. Server Certificate

서버의 인증서를 클라이언트에게 보내는 과정이다.

인증서의 역할은 클라이언트가 접속한 서버가 클라이언트가 요청한 서버가 맞는지 보장하는 것이다.

이러한 인증서를 발급하는 기업들을 CA(Certificate Authority) 또는 Root Certificate 라고 한다. CA 는 신뢰성이 엄격하게 공인된 기업들만 참여할 수 있다.

TLS 를 통해 암호화 통신을 제공하려는 서비스는 CA 를 통해 인증서를 구입해야 한다.

만약 개발 또는 사적인 목적을 위해 TLS 를 이용하고자 한다면, 자신이 직접 CA 역할을 할 수도 있다. 하지만 공인된 인증서가 아니기 때문에 브라우저에서는 아래와 같은 경고를 띄울 수 있다.

![8.png](/assets/images/2023/2023-04-05-http-https-ssl-tls/8.png)

출처: [HTTPS와 SSL 인증서](https://www.opentutorials.org/course/228/4894) [생활코딩]

인증서에는 아래와 같은 정보가 포함되어 있다.

1. 서비스의 정보 : 인증서를 발급한 CA, 서비스의 도메인 등
2. 서버 측 공개키 : 공개키의 내용, 공개키의 암호화 방법

1번은 클라이언트가 접속한 서버가 클라이언트가 의도한 서버가 맞는지에 대한 내용이 담겨있다.

2번은 서버와 통신할 때 사용할 공개키와 그 공개키의 암호화 방법들의 정보를 담고 있다.

위의 정보들은 서비스가 CA 로부터 인증서를 구입할 때 제출해야 하며, CA 에 의해 암호화 된다.

이때 사용하는 암호화 기법은 공개키 방식이다. CA 는 자신의 CA 비공개키를 이용해서 서버가 제출한 인증서를 암호화 한다.

브라우저는 내부적으로 CA 의 리스트를 미리 파악하고 있다.

즉, 브라우저 소스 코드 안에는 CA 의 리스트가 들어있다는 것이다. 브라우저가 미리 파악하고 있는 CA 의 리스트에 포함되어야만 공인된 CA 가 될 수 있다.

그래서 브라우저는 CA 의 리스트와 함께 CA 의 공개키를 이미 알고 있다.

클라이언트의 브라우저는 서버로부터 받은 인증서가 공인된 CA 목록에 있는지 확인하고, 브라우저가 가지고 있는 공개키로 인증서를 복호화 한다. 복호화 된 인증서에는 서버의 공개키가 담겨있다.

그러면 이전에 서버로부터 받은 난수와 클라이언트가 생성한 난수를 조합하고 pre master secret 라는 키를 생성한다. 이는 앞으로 클라이언트와 서버가 암호화 통신에 사용할 대칭키의 재료가 되는 키이다.

### 4. Server Hello Done

서버가 클라이언트에게 보낼 메세지를 모두 보냈다는 의미이다.

### 5. Client Key Exchange

클라이언트는 3번에서 만든 pre master secret 키를 서버의 공개키로 암호화하여 서버에 전송한다.

### 6. Key Generation

서버는 클라이언트가 전송한 pre master secret 키를 서버의 개인키로 복호화한다. 그리고 클라이언트와 서버는 일련의 과정을 거쳐서 pre master secret 키를 master secret 키를 생성한다.

master secret 는 session key 를 생성하는데, session key 를 이용해 서버와 클라이언트는 통신을 암호화 하는데 사용한다.

### 7. Cipher Spec Exchange

이제 서버와 클라이언트가 주고 받는 모든 메세지는 정해진 알고리즘과 session key 를 이용해서 암호화 하겠다고 서로 알려준다.

### 8. Finished

그 다음 Finished 메세지를 보내서 각자 handshake 과정이 끝났음을 알린다.

# 참고자료

- [HTTP 개념 및 주요 내용 정리](https://seunghyun90.tistory.com/41) [티스토리]
- [HTTPS란? (동작방식, 장단점)](https://rachel-kwak.github.io/2021/03/08/HTTPS.html) [github.io]
- [[10분 테코톡] 👶에단의 TLS](https://youtu.be/EPcQqkqqouk) [youtube]
- [IP/ARP 스푸핑 (Spoofing)공격은 무엇이며 공격은 어떻게 실행되는지를 학습합니다.](https://m.blog.naver.com/brickbot/220441375126) [네이버 블로그]
- [SSL (secure sockets layer)](https://www.techtarget.com/searchsecurity/definition/Secure-Sockets-Layer-SSL) [TechTarget]
- [TLS Handshake는 어떻게 진행되는가? | Session Key](https://sunrise-min.tistory.com/entry/TLS-Handshake%EB%8A%94-%EC%96%B4%EB%96%BB%EA%B2%8C-%EC%A7%84%ED%96%89%EB%90%98%EB%8A%94%EA%B0%80) [티스토리]
- [SSL/TLS, Cipher suite란?](https://run-it.tistory.com/30) [티스토리]
- [HTTPS와 SSL 인증서](https://www.opentutorials.org/course/228/4894) [생활코딩]
- [TLS(SSL) - 3. Handshake](https://babbab2.tistory.com/7) [티스토리]