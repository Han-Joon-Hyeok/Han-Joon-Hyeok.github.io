---
title: "[Born2beroot] 1. 가상 머신 및 데비안 설치"
date: 2022-08-17 17:20:00 +0900
categories: [l42seoul]
tags: [born2beroot]
use_math: true
---

# 과제 소개

Born2beroot 과제는 가상 머신에 운영체제를 설치하고, 여러 사용자가 운영체제를 이용할 수 있도록 기본 환경 설정을 하는 것이 목표이다. 파티션 설정, 비밀번호 정책, 방화벽 설정, SSH 연결, 운영체제 등을 배우게 된다. 추가로 보너스 과제를 수행한다면 워드 프레스를 설치하기 위해 웹 서버, WAS, DB 까지 가볍게 짚어볼 수 있다.

코드를 작성하는 과제는 아니다보니 공부해야 하는 개념이 많지만, 본인의 목표에 맞춰서 원하는 깊이까지 공부하는 것을 권장한다.

본 포스팅에서는 보너스까지 수행하는 방법을 소개하고 있다.

# 가상 머신 설치 방법

## 0. 클러스터에서 VirtualBox 설치하기

1. `Command + Space` 입력하여 `Spotlight` 실행
2. `Managed Software Center` 입력
3. `VirtualBox` 검색 후 다운

## 1. VirtualBox 설치

개인 맥북에서 가상 머신을 설치하는 방법은 다음과 같다.

(OS : macOS Monterey Version 12.4)

- [오라클 VirtualBox 사이트](https://www.virtualbox.org/wiki/Downloads)에 접속한다.
- `OS X hosts` 를 클릭하여 `.dmg` 파일을 다운 받는다
- 안내에 따라 설치를 진행한다.
- 설치가 끝나면 재부팅 한다.

## 2. 데비안 다운로드

- [데비안 사이트](https://www.debian.org/download)에 접속한다.
  ![1.png](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/1.png)
- 본인의 운영체제와 PC에 맞는 `.iso` 설치 파일 링크를 띄워주는데, 이를 클릭하여 다운 받는다.
- 참고로 크롬 브라우저에서 다운로드 받을 경로를 수동으로 지정해주려면 `Settings` 에 들어가서 `download` 를 검색한다.
  ![2](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/2.png)
- 그 다음, `Ask where to save each file before downloading` 항목을 활성화 한다.

## 3. VirtualBox 실행

![3.png](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/3.png)

- `New` 클릭

![4](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/4.png)

- `Name` 에 사용할 가상 머신의 운영체제 이름을 적으면 자동으로 `Version` 항목이 변경된다.

![5](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/5.png)

- 가상 머신의 RAM 크기를 설정하는 부분인데, 추후에 필요하면 추가로 설정 가능하다. 별도의 설정없이 `Continue` 를 클릭한다.

![6](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/6.png)

- 가상 머신이 사용할 수 있는 가상 하드 디스크를 생성 여부를 묻는 화면이다. `Create a virtual hard disk now` 를 선택한다.

![7](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/7.png)

- 하드 디스크 파일 종류를 선택하는 화면이다. 가상 머신이 실제 하드 디스크처럼 파일을 저장하고 관리하기 위해 이미지 파일을 사용한다. `VDI` 는 Oracle VirtualBox 에서 기본적으로 제공하는 이미지 파일의 종류이다. `VDI` 를 선택한다.
- 파일 종류에 대한 자세한 정보는 [오라클 공식 사이트](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vdidetails.html)에서 확인할 수 있다.

![8](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/8.png)

- 가상 머신이 사용할 하드 디스크의 크기를 필요에 따라 동적으로 변경해서 사용할 것인지, 고정된 크기로 사용할 것인지 선택하는 화면이다.
- 얼마나 용량이 필요할 지 모르기 때문에 `Dynamically allocated` 를 선택한다.

![9](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/9.png)

- 하드 디스크 이미지 파일이 저장될 경로를 지정하고, 하드 디스크의 초기 용량을 설정하는 화면이다.
- 개인 PC 라면 경로를 수정하지 않아도 괜찮지만, 클러스터에서 설치할 경우에는 경로를 ‘그 곳'으로 설정한 뒤 `Create` 를 선택한다.

![10](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/10.png)

- 정상적으로 가상 머신을 위한 하드 디스크가 생성되면 위와 같이 초기에 설정한 가상 머신 이름이 표시된다.
- 그 다음 `Start` 를 선택한다.

![11](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/11.png)

- 가상 머신에 설치할 운영체제 설치 파일을 선택하는 화면이다.
- 우측의 폴더 버튼을 클릭한다.

![12](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/12.png)

- `Add` 선택

![13](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/13.png)

- 다운 받은 데비안 설치 파일 (`.iso`)을 선택한다.

![14](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/14.png)

- `Choose` 선택

![15](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/15.png)

- `Start` 선택

![16](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/16.png)

- 위와 같은 작고 귀여운 화면이 뜬다면 성공.
- 화면을 조금 더 크게 보기 위해 `command + c` 를 입력한다.

## 4. 데비안 설치

![17](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/17.png)

- 과제에서는 GUI 를 사용하지 않아야 하므로 `Install` 선택.
- 가상 머신 화면에서 키보드 또는 마우스를 입력하면 화면 안에 갇히게 된다. 이때, `command` 를 누르면 밖으로 마우스가 빠져나온다.

![18](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/18.png)

- 언어를 설정하는 화면이다. 한국어도 있긴 하지만, 원활한 과제 수행을 위해 `English` 를 선택한다.

![19](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/19.png)

- 시간대를 설정하기 위해 현재 위치한 국가를 선택하는 화면이다. 무엇을 선택하든 상관없다.
- 참고로 `Other` - `Asia` 로 들어가면 남한으로 선택할 수 있다. (북한도 선택 가능하다.)

![20](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/20.png)

- `locale` 을 설정하는 화면이다. `United States` 를 선택한다.
- 참고로 `locale` 은 국가마다 통용되는 통화, 인코딩, 종이 사이즈 등을 설정한 값들이다. 선택한 국가에 따라 환경 변수에 다르게 저장된다.
- `locale` 에 대한 자세한 정보는 [이 곳](https://linuxhint.com/locales_debian/)에서 확인할 수 있다.

![21](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/21.png)

- 사용하는 키보드의 언어를 선택하는 화면이다.
- 영어만 사용할 예정이기 때문에`American English` 를 선택한다.

![22](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/22.png)

- 호스트 이름(hostname)을 설정하는 화면이다.
- 과제에서는 `인트라 아이디 + 42` 를 설정하라고 나와있으므로 이에 맞추어 입력한다.
- 호스트 이름이란 네트워크에 연결된 장치들에게 부여되는 각각의 고유한 이름이다. 데이터 통신을 하기 위해서는 상대방의 IP주소를 알아야 하는데, 이를 인간이 모두 기억하기는 어렵다. 그래서 숫자로 구성된 IP주소가 아닌 문자를 사용해서 사람이 읽기 쉽도록 만든 것이 호스트 이름이다. 그래서 네트워크 상에서도 호스트 이름만 알면 데이터 통신이 가능한 것이다.
- 예를 들어, ‘네이버 메일’에 접속하기 위해서는 `https://mail.naver.com` 를 주소창에 입력하면 된다. 주소는 다음과 같이 이루어져있다.
  - `https` : 프로토콜
  - `mail` : 호스트 네임
  - `naver` : 세컨드 레벨 도메인 (SLD; Second Level Domain)
  - `com` : 탑레벨 도메인(TLD; Top Level Domain)
- 여기서 프로토콜을 제외한 나머지를 FQDN(Fully Qualified Domain Name)이라고 하는데, 이 주소는 DNS(Domain Name System) 서버에서 단 하나만 존재하는 고유한 주소이다.
  - DNS 는 사람이 읽을 수 있는 주소 (ex: `mail.naver.com`)를 기계가 읽을 수 있는 IP주소 (ex: 192.0.2.44)로 변환하는 기능을 수행한다.
- 도메인 네임(Domain name)은 네트워크 상에서 식별할 수 있는 고유한 컴퓨터의 이름을 의미한다. 위의 예시에서 도메인 네임은 `naver.com` 이다.
- 브라우저에서 `https://mail.naver.com` 를 입력하면 다음과 같은 과정이 이루어진다.
  - `.com` 사용하는 DNS 서버를 찾아가서 `naver` 라는 도메인을 사용하는 DNS 서버를 찾아간다.
  - `.naver` 에서는 `mail` 이라는 호스트 네임을 가진 IP주소를 반환해준다.

> 참고자료
>
> - [hostname(호스트명), domain name(도메인), same origin VS same site](https://velog.io/@minjae-mj/%ED%98%B8%EC%8A%A4%ED%8A%B8-%EB%84%A4%EC%9E%84%EA%B3%BC-%EB%8F%84%EB%A9%94%EC%9D%B8-%EB%84%A4%EC%9E%84) [velog]
> - [All you need to know: what is a hostname?](https://www.ionos.com/digitalguide/hosting/technical-matters/hostname/) [ionos]
> - [what is dns?](https://aws.amazon.com/ko/route53/what-is-dns/) [AWS]
> - [DNS Explained](https://www.youtube.com/watch?v=72snZctFFtA&ab_channel=DNSMadeEasyVideos) [Youtube]
> - [도메인 네임](https://ko.wikipedia.org/wiki/%EB%8F%84%EB%A9%94%EC%9D%B8_%EB%84%A4%EC%9E%84) [위키백과]

![23](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/23.png)

- 도메인 이름을 설정하는 항목이다.
- 도메인을 설정하면 외부에서 접속할 수 있게 되는데, 도메인을 사용하려면 별도의 비용을 지불해야 한다. 과제에서는 외부 네트워크와 통신을 하지 않기 때문에 별도로 설정하지 않고 넘어간다.

![24](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/24.png)

- `root` 계정의 비밀번호를 설정하는 화면이다.
- `root` 계정은 시스템의 전반적인 권한을 가진 계정이다.
- 기억하기 쉬운 비밀번호로 설정한다.

![25](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/25.png)

- 다시 한번 비밀번호를 입력한다.

![26](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/26.png)

- `root` 권한이 없는 새로운 계정의 실제 이름(real name)을 설정하는 화면이다. 이메일을 보낼 때나 프로그램에서 실제 유저의 이름을 띄워줄 때 사용할 이름을 의미한다.
- 본인의 인트라 아이디를 입력한다.

![27](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/27.png)

- 새로운 계정이 사용할 username 을 설정하는 화면이다.
- 이전 화면에서 입력한 정보가 입력되기 때문에 그대로 사용해도 된다.

![28](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/28.png)

- 새로운 계정이 사용할 비밀번호를 설정하는 화면이다.
- 기억하기 쉬운 비밀번호를 입력한다.

![29](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/29.png)

- 다시 한번 비밀번호를 입력한다.

![30](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/30.png)

- Bonus 에서 요구한 대로 파티션을 나누기 위해 Manual 선택

![31](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/31.png)

- SCSI(소형 컴퓨터 인터페이스)의 하드 디스크(sda) 선택
  - SCSI(Small Computer System Interface) 는 하드 디스크와 메인 보드를 연결하는 단자 종류의 하나이다. 비싸지만 좋은 성능을 보장하기 때문에 서버용으로 주로 사용되고 있다.
  - SDA(SCSI Hard disk A) : SCSI 방식의 첫 번째 하드 디스크

> 참고자료
>
> - [하드웨어의 선택 - IDE, SCSI, SATA, SAS](https://m.blog.naver.com/bestheroz/66675774) [네이버 블로그]
> - [IDE 하드와 SATA 하드의 다른점](https://webzigi.tistory.com/164) [티스토리]

![32](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/32.png)

- 선택한 하드 디스크에 빈 파티션을 생성할 것인지 확인하는 화면.
- `Yes` 선택
- 파티션(Partition)이란 하나의 물리적인 하드 디스크를 여러 개의 논리적 디스크로 나누는 작업을 의미한다. 처음 운영체제를 설치할 때 파티션 나누는 것은 운영체제를 저장할 공간과 데이터를 저장할 공간을 나누기 위함이다.
- 또한, 파티션을 통해 시스템을 안정적으로 운영하기 위함이다.
- 예컨대, DB서버를 mysql 을 운영한다면, `/var/lib/mysql` 에 데이터 파일을 저장한다. 만약, 루트(`/`) 파티션을 통째로 사용하다가 시스템에 치명적인 문제가 생기면 DB 데이터 파일에 치명적인 영향이 가지만, 파티션을 별도로 생성했다면 데이터를 안전하게 보존할 수 있다.
- 참고로 Linux 에서는 디스크가 추가될 때마다 알파벳 순으로 디렉토리가 형성된다.
  - `/dev/sda`, `/dev/sdb`, …
- 그리고 파티션은 숫자 순으로 증가한다.
  - `/dev/sda1`, `/dev/sda2`, …

> 참고자료
>
> - [파티션(Partition)의 개념](https://dakuo.tistory.com/60) [티스토리]
> - [Partition Structure](https://k-dfc.tistory.com/64) [티스토리]
> - [Partition](https://k-dfc.tistory.com/63?category=630187) [티스토리]
> - [부트 섹터](https://ko.wikipedia.org/wiki/%EB%B6%80%ED%8A%B8_%EC%84%B9%ED%84%B0) [위키백과]
> - [윈도우10 활성 파티션 비활성화 방법](https://extrememanual.net/27585) [익스트림 매뉴얼]
> - [디스크(Disk) /파티션(Partition) / 볼륨(Volum) / 파일시스템 용어정리](https://pearlluck.tistory.com/179) [티스토리]
> - [데비안 10(buster) 설치](<https://wiki.debianusers.or.kr/index.php?title=%EB%8D%B0%EB%B9%84%EC%95%88_10(buster)_%EC%84%A4%EC%B9%98>) [debianusers]

![34](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/34.png)

- 새롭게 생성된 빈 파티션 선택

![35](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/35.png)

- Create a new partition 선택

![36](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/36.png)

- 부팅용으로 사용할 파티션의 용량을 설정하는 화면.
- 보너스에 나온 용량은 30.8G 기준이지만, 8.00GB 를 기준으로는 500M 을 입력한다.

![37](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/37.png)

- 부팅용으로 운영체제를 설치하기 위한 주 파티션(Primary)으로 설정

![38](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/38.png)

- 주 파티션의 위치를 선택하는 화면이다.
- 시작 위치(sda1)로 지정해야 하므로 `Beginning` 선택

![39](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/39.png)

- Mount point 를 선택
  - Mount point : 리눅스 운영체제에서 사용하고자 하는 장치들을 인식시키기 위한 디렉토리 이름이다. 파티션 또한 장치와 동일하게 디렉토리로 지정하여 사용할 수 있다.
  - Mount : 파티션의 자원을 사용자가 사용할 수 있도록 디렉토리에 연결하는 과정이다. 물리적 장치 또한 디렉토리에 연결해서 사용할 수 있다. 쉽게 생각하면, Mount 는 외부 장치를 컴퓨터에서 사용할 수 있도록 잠시 자리를 빌려주는 것이다.

> 참고자료
>
> - [inode 그리고 마운트 포인트란?](https://www.crocus.co.kr/1700) [티스토리]
> - [리눅스 마운트에 대해 알아보자 (리눅스 mount 개념 및 실습)](https://m.blog.naver.com/haejoon90/220750372195) [네이버 블로그]

![40](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/40.png)

- `/boot` 선택
  - boot 는 부팅에 필요한 파일이 설치되는 디렉토리다.

> 참고자료
>
> - [[Linux / Unix] 리눅스 파티션 나누기 (포멧)](https://firedev.tistory.com/entry/LinuxUnix-%EB%A6%AC%EB%88%85%EC%8A%A4-%ED%8C%8C%ED%8B%B0%EC%85%98-%EB%82%98%EB%88%84%EA%B8%B0-%ED%8F%AC%EB%A9%A7) [티스토리]

![41](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/41.png)

- Done setting up the partition 선택

![42](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/42.png)

- 빈 파티션 선택

![43](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/43.png)

- Create a new partition 선택

![44](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/44.png)

- 나머지 모든 공간에 LVM(논리 볼륨 관리자)를 설정해야 하기 때문에 `max` 입력

![45](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/45.png)

- 데이터 저장 공간으로 사용해야 하기 때문에 Logical 선택

![46](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/46.png)

- Mount point 선택

![47](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/47.png)

Do not mount it 선택

해당 파티션은 논리 파티션이지만 확장 파티션에 속해야 하기 때문에 위와 같이 설정한다.

- 확장 파티션(Extended Partition) : MBR 구조에서는 총 4개의 파티션 테이블이 존재하는데, 4개 이상의 파티션을 정의하기 위해 사용하는 파티션이 확장 파티션이다. 기존의 4개 파티션 엔트리에서 마지막 엔트리가 확장 파티션 엔트리가 된다.
- 아래는 MBR의 주 파티션 테이블을 나타낸 그림이다.
  ![mbr_partition_table.png](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/mbr_partition_table.png)
- 파티션이 4개를 초과하면 주 파티션 테이블의 마지막 파티션에는 첫 번째 확장 파티션의 위치를 가리킨다.
  ![extended_partition.png](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/extended_partition.png)
  > 참고자료
  >
  > - [MBR 확장 파티션(Extended Partition)](https://lemonpoo22.tistory.com/m/80) [티스토리]

![48](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/48.png)

Done setting up the partition 선택

![49](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/49.png)

파티션 암호화를 위해 Configure encrypted volumes 선택

![50](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/50.png)

Yes 선택

![51](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/51.png)

Create encrypted volumes 선택

![52](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/52.png)

논리 파티션은 `/dev/sda5` 부터 시작하므로 해당 칸으로 내려가서 Space 입력 후 엔터

![53](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/53.png)

Done setting up the partition 선택

![54](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/54.png)

Finish 선택

![55](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/55.png)

파티션 진행 전에 해당 파티션이 위치할 공간의 데이터를 지워도 괜찮은지 확인하는 화면

Yes 선택

![56](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/56.png)

논리 파티션 암호 설정 화면

부팅 시 입력할 비밀번호 입력

![57](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/57.png)

다시 한번 입력

![58](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/58.png)

확장 파티션을 논리 파티션으로 세분화 하기 위해 Configure the Logical Volume Manager 선택

![59](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/59.png)

Yes 선택

![60](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/60.png)

확장 파티션을 논리 파티션으로 세분화하기 위해서는 논리 파티션들을 묶을 그룹이 필요함.

Create volume group 선택

![61](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/61.png)

그룹 이름을 LVMGroup 으로 지정

![62](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/62.png)

그룹으로 지정할 파티션은 논리 파티션이므로 스페이스바를 눌러 `/dev/mapper/sda5_crypt` 선택

![63](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/63.png)

Create logical volume 선택

![64](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/64.png)

LVMGroup 선택

![65](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/65.png)

root 입력

- `/root` : 슈퍼 유저의 홈 디렉토리

![66](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/66.png)

2G 입력

![67](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/67.png)

root와 동일하게 새로운 볼륨 생성하고, swap 입력

- `/swap` : RAM 의 공간이 부족할 때 사용되는 예비 파티션
- 보통 용량은 RAM 의 2배 정도 권장
- 반드시 필요한 파티션은 아님

> 참고자료
>
> - [리눅스 스왑(SWAP) 파티션이란 무엇? 어떤 일을 하나요?](https://sergeswin.com/1034/) [티스토리]

![68](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/68.png)

1G 입력

![69](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/69.png)

home 입력

![70](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/70.png)

1G 입력

- `/home` : 사용자의 홈 디렉토리. `useradd` 명령어로 새로운 사용자를 생성하면 대부분 사용자의 ID와 동일한 이름의 디렉토리가 자동으로 생성된다.

> 참고자료
>
> - [리눅스 디렉토리 구조](https://webdir.tistory.com/101) [티스토리]

![71](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/71.png)

var 입력

- `/var` : 시스템 운용 중에 생성되었다가 삭제되는 데이터를 일시적으로 저장하는 디렉토리이다. 로그 파일이나 프린트를 하기 위한 스풀 파일 등이 저장된다.

![72](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/72.png)

1G 입력

![73](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/73.png)

srv 입력

- `/srv` : 서버를 위한 디렉토리. 주로 FTP, SFTP, RSync와 같은 프로토콜을 이용하여 외부 사용자와의 공유를 위해 사용되며 다른 디렉토리에 비해 비교적 외부 사용자들이 쉽게 접근가능.

> 참고자료
>
> - [[리눅스 기초] 루트디렉토리 구조](https://medium.com/harrythegreat/%EB%A6%AC%EB%88%85%EC%8A%A4-%EA%B8%B0%EC%B4%88-%EB%A3%A8%ED%8A%B8%EB%94%94%EB%A0%89%ED%86%A0%EB%A6%AC-%EA%B5%AC%EC%A1%B0-b3e4871af4b3) [Medium]

![74](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/74.png)

1G 입력

![75](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/75.png)

tmp 입력

- `/tmp` : 세션 정보나 현재까지 작업한 파일이 임시로 저장되는 디렉토리

![76](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/76.png)

1G 입력

![77](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/77.png)

var-log 입력

- `/var/log` : 시스템 로그 파일이 저장되는 디렉토리

![78](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/78.png)

남은 용량 입력

![79](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/79.png)

Display configuration details 를 통해 현재까지 작업한 파티션 확인

![80](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/80.png)

파티션 확인 후 Continue 선택

![81](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/81.png)

Finish 선택

![82](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/82.png)

실제로 저장될 디렉토리를 지정하기 위한 마운트를 위해 LVMGroup - LV home 선택

![83](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/83.png)

Use as : do not use 선택

![84](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/84.png)

Ext4 journaling file system 선택

- Ext4 : 리눅스에서 사용하는 파일 시스템. ext3 를 개선시킨 버전

> 참고자료
>
> - [ext4 파일 시스템\_1 (기본 구조)](https://ddongwon.tistory.com/66) [티스토리]

![85](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/85.png)

Mount point 선택

![86](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/86.png)

home 선택

![87](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/87.png)

Done setting up the partition 선택

![88](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/88.png)

root 선택

![89](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/89.png)

use as 는 Ext4로 동일하게 설정

마운트 포인트는 `/`

![90](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/90.png)

srv 선택

![91](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/91.png)

Use as : Ext4

Mount point : `/srv`

![92](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/92.png)

swap 선택

![93](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/93.png)

Use as : swap area 선택

![94](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/94.png)

tmp 선택

![95](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/95.png)

Use as : Ext4

Mount point : `/tmp`

![96](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/96.png)

var 선택

![97](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/97.png)

Use as : Ext4

Mount point : `/var`

![98](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/98.png)

var-log 선택

![99](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/99.png)

Use as : Ext4

Mount point 는 Enter manually 선택

![100](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/100.png)

`/var/log` 입력

![101](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/101.png)

Finish partitioning and write changes to disk 선택

![102](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/102.png)

Yes 선택

![103](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/103.png)

디스크를 추가로 읽을 것인지 선택하는 화면이다.

`No` 선택

![104](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/104.png)

- 프로그램을 설치하기 위한 네트워크 미러 사이트를 설정하기 위해 현재 접속한 위치를 설정하는 화면이다.
- `Korea, Republic of` 를 선택한다.

![105](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/105.png)

- 미러 사이트로 이용할 주소를 설정하는 화면이다. `deb.debian.org` 을 선택한다.

![106](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/106.png)

- 외부 네트워크에 접속하기 위한 프록시를 설정하는 화면이다.
- 별다른 설정 없이 엔터를 입력한다.

![107](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/107.png)

- debian 에 통계 자료를 보낼 것인지 선택하는 화면이다.
- `No` 를 선택한다.

![108](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/108.png)

- `.iso` 파일에는 debian 의 핵심만 설치되었기에 추가로 설치할 항목들을 선택하는 항목이다. 현재 설치하지 않아도 추후에 다시 설치할 수 있다.
- SSH server 와 standard system utilities 는 선택되어 있으므로 엔터를 입력해서 넘어간다.

![109](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/109.png)

- 부트로더인 GRUB(Grand Unified Bootloader) 설치 여부를 묻는 화면이다.
- 부트로더는 PC를 부팅할 때, 가장 먼저 실행되며, Linux 운영체제의 커널을 로드하고, 파라미터를 커널에 넘겨주는 부팅 전반에 걸친 작업을 진행한다.
- `Yes` 를 선택한다.

> 참고자료
>
> - [[Linux]GRUB 이란?](https://youngswooyoung.tistory.com/67) [티스토리]

![110](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/110.png)

- 부팅용으로 사용할 파티션을 선택하는 화면이다.
- `/dev/sda` 를 선택한다.

![111](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/111.png)

- 설치가 정상적으로 끝나면 위와 같은 화면이 나타난다.
- `Continue` 를 선택하고 엔터를 입력한다.

![112](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/112.png)

재부팅이 되면서 위와 같은 화면이 표시되면 성공한 것이다.

![113](/assets/images/2022/2022-08-12-born2beroot-install-virtual-machine/113.png)

로그인하여 `lsblk` 명령어를 입력하면 위의 그림과 같이 표시된다.
