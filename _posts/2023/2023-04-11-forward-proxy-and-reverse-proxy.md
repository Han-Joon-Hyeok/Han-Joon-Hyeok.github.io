---
title: "Forward Proxy와 Reverse Proxy"
date: 2023-04-11 10:00:00 +0900
categories: [nginx]
tags: [nginx]
---

# 프록시(Proxy)란?

프록시는 사전적인 의미로 ‘대리인’, ‘중개자’ 라는 의미를 가지고 있다.

컴퓨터 공학에서 프록시는 보안상의 문제로 직접 통신을 주고 받을 수 없는 두 PC 사이에서 통신을 중계하는 것을 의미한다.

이처럼 중계 기능을 수행하는 서버를 ‘프록시 서버’라고 한다.

![1.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/1.png)

출처: [What is a Proxy Server? How does it work?](https://www.fortinet.com/resources/cyberglossary/proxy-server) [fortinet]

보통 웹 서비스는 클라이언트와 서버가 데이터를 주고 받는다.

이때 중복되는 데이터를 반복해서 전달하는 상황이 발생할 수 있는데, 동일한 요청을 매번 처리하는 것은 리소스 낭비와 서버의 부하로 이어진다.

그래서 본 서버에 도달하기 전에 새로운 서버(proxy server)를 미리 배치해서 중복 요청에 대해, 특히 연산이 필요없는 요청에는 동일한 응답을 하도록 한다. 그러면 클라이언트 입장에서는 빠르게 요청을 받아볼 수 있고, 서버 입장에선느 불필요한 부하를 줄이는 효과를 누릴 수 있다.

프록시 서버는 서버가 어디에 위치해있는지에 따라 포워드 프록시와 리버스 프록시로 나뉜다. 프록시의 종류에 따라 사용하는 목적과 수행하는 역할도 함께 달라진다.

# 포워드 프록시 (Forward Proxy)

클라이언트가 서버로 자원을 요청할 때, 직접 요청하지 않고 프록시 서버를 거쳐 요청하는 서버를 포워드 프록시라고 한다. 포워드 프록시는 클라이언트 앞에 위치하고 있다.

![2.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/2.png)

출처: [포워드 프록시(forward proxy) 리버스 프록시(reverse proxy) 의 차이](https://www.lesstif.com/system-admin/forward-proxy-reverse-proxy-21430345.html) [lesstif]

예를 들어, 클라이언트가 `google.com` 에 접속하고자 하는 경우, 클라이언트가 직접 `google.com` 에 요청하는 것이 아니라 포워드 프록시 서버가 클라이언트의 요청을 받아서 대신 `google.com` 에 요청하는 것이다. 그리고 서버의 응답을 다시 포워드 프록시 서버가 받아서 클라이언트에게 전달(forward)하는 역할을 수행한다.

## 왜 사용하는가?

클라이언트가 직접 서버에 요청을 수행하면 되는데, 굳이 중간에서 포워드 프록시 서버가 대신 전달해주는 이유는 무엇일까?

### 접속 제한

보안상의 이유로 일부 정부, 학교, 기업에서는 방화벽을 이용해서 사내망이 아닌 외부의 특정 사이트에 접속하는 것을 막고 있다.

즉, 포워드 프록시 서버는 방화벽과 같은 개념으로 네트워크 접속 제한을 위해 사용한다.

### 캐싱 (Caching)

어떤 웹 페이지에 접근하면 프록시 서버는 해당 페이지 서버의 정보를 임시로 보관(캐싱)한다.

그래서 프록시 서버는 동일한 페이지에 대한 요청이 들어오면 캐싱한 데이터(페이지)를 그대로 반환하는데, 덕분에 서버의 부하를 줄이는 효과가 생긴다.

### 암호화 (Encryption)

클라이언트의 요청은 포워드 프록시 서버를 통과할 때 클라이언트의 IP 를 숨길 수 있다.

프록시 서버를 통해 요청하는 패킷의 헤더에는 `Via` 헤더 또는 `X-Forwarded-For` 헤더가 붙는다.

- `Via` 헤더 : 프록시 서버의 종류를 표시한다.
- `X-Forwarded-For` 헤더 : 처음 요청을 보낸 클라이언트의 IP 를 표시한다.

그리고 프록시의 종류에 따라 헤더가 다르게 붙는다.

- Transparent : 요청 헤더에 `Via`, `X-Forwarded-For` 헤더를 붙여서 클라이언트의 IP 를 추적할 수 있다.
- Anonymous : `Via` 헤더만 포함해서 보내기 때문에 클라이언트의 IP 를 추적할 수 없다.
- High anonymous : 위의 두 헤더를 모두 포함하지 않기 때문에 클라이언트의 IP 뿐만 아니라 프록시 사용 여부를 알 수 없다. 일반 패킷과 구별할 수 없으며, 현재 기술력으로는 서버가 High anonymous 프록시 사용 여부를 구별할 수 없다.

그래서 Transparent 프록시가 아니라면 서버에서 IP 주소를 역추적해도 실제 요청을 보낸 클라이언트의 정체를 확인하기 어렵다.

# 리버스 프록시 (Reverse Proxy)

![3.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/3.png)

출처: [[network] 프록시(proxy)란, forward proxy와 reverse proxy](https://sujinhope.github.io/2021/06/13/Network-%ED%94%84%EB%A1%9D%EC%8B%9C(Proxy)%EB%9E%80,-Forward-Proxy%EC%99%80-Reverse-Proxy.html) [gitub.io]

리버스 프록시는 포워드 프록시의 반대되는 개념이다.

리버스 프록시는 애플리케이션 서버의 앞에 위치하며, 클라이언트가 서버에 요청을 보내면 리버스 프록시가 서버 대신 요청을 받는다. 그리고 리버스 프록시가 서버로 요청을 대신 보내고, 응답을 받아서 클라이언트에게 전달해준다.

이처럼 클라이언트는 프록시 서버를 호출하기 때문에 실제 애플리케이션 서버를 감추는 역할을 한다.

## 왜 사용하는가?

### 로드 밸런싱(Load Balancing)

많은 트래픽으로 인해 부하가 걸린 서버를 정상적으로 작동시키기 위해서는 크게 2가지 방법이 있다.

![4.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/4.png)

출처: [컴퓨터의 성능을 높이는 방법 - 스케일업(scale up)과 스케일 아웃(scale out)](https://butter-shower.tistory.com/109) [티스토리]

첫 번째 방법은 서버 컴퓨터의 성능을 높여주는 스케일 업(Scale-up)이다.

CPU나 RAM을 현재 사용하는 것보다 더 좋은 성능의 부품으로 교체하거나, RAM이나 저장 장치(SSD, HDD)를 추가로 장착하는 방법이다.

하지만 서버 컴퓨터 1대의 성능을 최대치는 정해져 있기 때문에 한계가 존재한다.

그래서 두 번째 방법으로 서버 컴퓨터를 여러 대 연결해서 트래픽을 각 컴퓨터에 나누어 전달해주는 스케일 아웃(Scale-out)이 있다.

스케일 아웃을 통해 하나의 서버가 감당해야 했던 부담을 여러 대의 서버로 나누어주는 로드 밸런싱을 구현할 수 있다.

![5.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/5.png)

출처: [What Is Load Balancing?](https://www.nginx.com/resources/glossary/load-balancing/) [nginx]

로드 밸런싱의 알고리즘에는 종류가 여러 가지가 있다.

1. 라운드 로빈 (Round robin)
    - 클라이언트의 요청을 여러 대의 서버에 순차적으로 분배하는 방식이다. 총 3대의 서버가 있으면, 1-2-3-1-2-3… 과 같은 방식으로 분배한다.
    - 추가적인 계산을 하지 않고 들어온 요청을 빠르게 서버에 분산해주는 단순한 방식이기 때문에 가장 많이 사용된다. 모든 서버의 성능이 동일하거나 비슷한 경우에 사용한다.
2. 가중 라운드 로빈 (Weighted round robin)
    - 각 서버에 처리량(가중치)를 지정하고, 가중치가 높은 서버에 클라이언트 요청을 우선 전달하는 방식이다.
    - 특정 서버의 사양의 좋을 때 사용하는 방식이다.
    - 예를 들어, 1번 서버(가중치 3), 2번 서버(가중치 1)이고, 클라이언트로부터 총 8개의 요청을 받았다면, 1번 서버에는 6개의 요청이, 2번 서버에는 2개의 요청이 전달된다.
3. IP 해시 (IP Hash)
    - 클라이언트의 IP 주소를 해싱하여 동일한 IP 에 대해서는 항상 동일한 서버로 연결되는 것을 보장하는 방식이다.
    - 세션을 유지해야 하는 사이트에서 주로 사용하는 방식이다.
4. 최소 연결 (Least connection)
    - 요청이 들어온 시점에 가장 적게 연결되어 있는 서버에 요청을 전송하는 방식이다.
5. 최소 응답 시간 (Least response time)
    - 서버의 연결 상태와 응답 시간을 모두 고려해서 가장 적은 연결 수와 가장 짧은 응답 시간을 가지는 서버에 우선 요청을 보내는 방식이다.

또한 로드 밸런서의 종류에는 여러 종류가 존재한다. OSI 7계층을 기준으로 L2, L3, L4, L7이 존재한다.

간단하게 L2 는 Mac 주소를 바탕으로, L3 는 IP 주소를 바탕으로 작동한다.

여기서는 L4 와 L7 을 위주로 다루어보고자 한다.

1. L4
    - Transport layer (IP & Port) 계층에서 클라이언트로부터 들어온 요청을 여러 대의 서버로 나누어주는 것을 의미한다.
    - 서버의 IP 주소와 포트 번호를 기준으로 작동하기 때문에 하나의 물리 서버 컴퓨터에서 각기 다른 포트 번호를 부여한 여러 서버 프로그램을 운영한다면 최소 L4 로드 밸런서 이상을 사용해야 한다.
2. L7
    - IP 와 포트 번호 이외에도 URI, Payload, Http header, Cookie 의 내용을 기준으로 트래픽을 분산한다.
    - 예를 들어, `https://naver.com` 에 접속한다면, `/blog` 에 대한 요청을 `/blog` 를 담당하는 서버로, `/news` 에 대한 요청을 `/news` 를 담당하는 서버로 보내는 것이다.
    - L4 로드 밸런서와 달리, 패킷을 분석해서 처리가 가능하기 때문에 악의적이거나 비정상적인 콘텐츠를 감지해서 보안 지점을 구축할 수 있다는 장점이 있다. 하지만, 그만큼 자원 소모가 크다는 단점도 존재한다.


정리하면, 리버스 프록시를 사용하면 로드 밸런싱을 통해 여러 WAS(웹 애플리케이션 서버)를 두어 사용자의 요청을 분산할 수 있다. 이로 인해 트래픽이 과도하게 몰리는 것을 방지할 수 있다.

### 보안

클라이언트는 실제 서버의 IP를 모르게 함으로써 서버를 감출 수 있다.

기업의 네트워크 환경에는 DMZ(DeMilitarized Zone)가 존재한다.

DMZ는 외부 네트워크와 내부 네트워크 사이에서 외부 네트워크 서비스를 제공하는 동시에 내부 네트워크를 보호하는 서브넷을 의미한다. 즉, 외부에 오픈된 서버 영역이다.

![6.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/6.png)

출처: [[네트워크] DMZ(DeMilitarized Zone)](https://ee-22-joo.tistory.com/40) [티스토리]

DMZ 의 앞뒤로 방화벽이 설치된다. 하나는 내부 네트워크와 연결되며, 다른 하나는 외부 네트워크와 연결된다.

내부 및 외부 네트워크 모두 DMZ 에 접속할 수 있지만, DMZ 내의 컴퓨터는 오직 외부 네트워크에만 연결할 수 있다.

보안 목적으로 내부 네트워크를 사용하는 단체가 존재하는데, 이 경우에는 외부 네트워크와 단절되어 메일 서버, 웹 서버, DNS 서버와 같은 기본적인 인터넷 서비스를 사용할 수 없다.

그렇기 때문에 DMZ 는 외부에서 접근되어야 할 필요가 있는 서버들을 위해 사용한다.

외부와 통신해야 하는 서버를 위해 내부 네트워크의 포트를 열어 사용한다면 내부 네트워크가 노출되어 해킹될 위험이 존재한다.

외부 네트워크에서 DMZ 로 가는 연결은 포트 주소 변환(PAT; Port Address Translation)을 통해 이루어진다. PAT는 NAT(Network Address Translation)과 비슷하지만, 포트 번호까지 함께 변환해준다.

![7.png](/assets/images/2023/2023-04-11-forward-proxy-and-reverse-proxy/7.png)

출처: [NAT / PAT 동작방식](https://zigispace.net/1107) [티스토리]

PAT 는 NAT 와 동일하게 IP 주소 변환을 해주지만, 포트 번호까지 함께 변경하여 NAT 테이블을 관리한다.

덕분에 하나의 IP 만으로도 다양한 포트 번호를 사용해서 사용자를 구분할 수 있다는 장점이 있다. 다만, 포트가 동시에 사용 중이거나 재사용할 수 없을 때는 PAT 가 정상적으로 작동하지 않는다.

### 캐싱 (Caching)

포워드 프록시와 마찬가지로 프록시 서버에 캐싱되어 있는 데이터를 제공함으로써 클라이언트에게 빠르게 서비스를 제공할 수 있다.

만약, 미국에 웹 서버가 있고, 한국에 리버스 프록시 서버를 두었다고 해보자. 어떤 한국 유저가 한국에 있는 리버스 프록시 서버와 통신해서 캐싱되어 있는 데이터를 사용할 경우 더욱 빠르게 서비스를 이용할 수 있다.

# 참고자료

- [포워드 프록시(forward proxy) 리버스 프록시(reverse proxy) 의 차이](https://www.lesstif.com/system-admin/forward-proxy-reverse-proxy-21430345.html) [lesstif]
- [🌐 Reverse Proxy / Forward Proxy 정의 & 차이 정리](https://inpa.tistory.com/entry/NETWORK-%F0%9F%93%A1-Reverse-Proxy-Forward-Proxy-%EC%A0%95%EC%9D%98-%EC%B0%A8%EC%9D%B4-%EC%A0%95%EB%A6%AC) [티스토리]
- [Proxy의 세가지 종류](https://spr2ad.tistory.com/243) [티스토리]
- [[해치지 않는 웹] 3. 프록시 서버](https://brunch.co.kr/@swimjiy/7) [브런치]
- [[network] 프록시(proxy)란, forward proxy와 reverse proxy](https://sujinhope.github.io/2021/06/13/Network-%ED%94%84%EB%A1%9D%EC%8B%9C(Proxy)%EB%9E%80,-Forward-Proxy%EC%99%80-Reverse-Proxy.html) [gitub.io]
- [[네트워크] DMZ(DeMilitarized Zone)](https://ee-22-joo.tistory.com/40) [티스토리]
- [NAT / PAT 동작방식](https://zigispace.net/1107) [티스토리]
- [Scale-up, Scale-out 이란 무엇인가](https://chunsubyeong.tistory.com/63) [티스토리]
- [[10분 테코톡] 🐿 제이미의 Forward Proxy, Reverse Proxy, Load Balancer](https://youtu.be/YxwYhenZ3BE) [유튜브]