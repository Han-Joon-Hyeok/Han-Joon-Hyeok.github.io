---
title: "[Born2beroot] 2. sudo 설치"
date: 2022-09-03 23:20:00 +0900
categories: [42seoul]
tags: [born2beroot]
use_math: true
---

# sudo 설치

CentOS 는 sudo 가 기본적으로 내장되어 있지만, 데비안은 그렇지 않기 때문에 sudo 를 별도로 설치해야 한다.

## sudo 란?

![sudo](/assets/images/2022/2022-09-03-born2beroot-install-sudo/sudo.png)

출처: [xkcd](https://xkcd.com/149/)

리눅스 운영체제에서 최고 관리자 권한으로 실행하는 프로그램이다.

sudo 는 super user do(최고 권한 실행) 또는 substitute user do(다른 사용자의 권한으로 실행)의 줄임말로 쓰인다.

각종 명령어 맨 앞에 `sudo` 를 붙이면 그 명령어는 `root` 권한, 즉 최고 관리자 권한으로 실행된다.

`sudo` 명령어는 `/etc/sudoer` 설정 파일에 명시된 사용자만 사용 가능하다. 이를 수정하기 위해서는 `visudo` 명령어를 사용해야 한다.

- `visudo` : vim 과 비슷한 텍스트 편집기지만, `/etc/sudoer` 파일의 문법 오류를 미리 발견하는 기능이 있다. 이를 통해 프로그램이 오작동하지 않도록 방지한다.

## 설치 과정

1. `su -l` 명령어를 입력해서 root 계정으로 이동한다.

   ![1](/assets/images/2022/2022-09-03-born2beroot-install-sudo/1.png)

   ```bash
   # 문법
   su [options] [-] [user [argument...]]
   ```

   - `su` 는 `substitute user` 의 약자이다.
   - 현재 접속한 사용자를 로그아웃 하지 않고, 다른 사용자의 권한을 획득할 때 사용한다.
   - `-l` 옵션은 `--login` 옵션과 동일하다.
   - `user` 항목에 빈 칸으로 두면 `root` 계정의 권한을 획득한다.
   - 만약, 다른 유저의 권한을 획득하고 싶다면 `su -l userID` 를 입력하면 된다.

2. `dpkg -l sudo` 를 입력해서 `sudo` 가 설치되었는지 확인

   ![2](/assets/images/2022/2022-09-03-born2beroot-install-sudo/2.png)

   - `dpkg` 는 데비안 패키지 관리하는 프로그램이다. `.deb` 패키지의 설치, 삭제, 정보 제공을 위해 사용한다.

3. 설치되어 있지 않으면 `apt install sudo` 를 입력한다.

   ![3](/assets/images/2022/2022-09-03-born2beroot-install-sudo/3.png)

   - `apt` 는 advanced packaging tool 의 약자로 데비안 계열에서 소프트웨어를 설치하고 제거하는 작업을 관리한다.
   - `apt` 는 기능별로 `apt`, `apt-get`, `apt-cache`, `apt-key` 등으로 명령어가 나누어져 있다.
   - `apt` 와 `apt-get` 은 기능상으로 큰 차이는 없다.
   - 참고로 `aptitude` 는 `apt` 의 기능들을 포괄적으로 포함하는 상위 레벨 패키지 매니저이다. 주요 패키지 작업 과정을 자동화해서 쉽게 작업을 진행할 수 있다. 즉, 사용자 입장에서는 `apt` 보다 `aptitude` 를 조금 더 쉽게 사용할 수 있다. 기능적으로 큰 차이는 없지만, 편리함에 있어선 `aptitude` 가 우수하다.

## sudoer 설정

`sudo` 사용 시 비밀번호 정책이나 로그 기록 여부 등을 설정하는 방법은 다음과 같다.

1. `visudo` 를 입력하면 아래와 같이 sudoers 파일을 수정하는 텍스트 편집기로 진입한다.

   ![4](/assets/images/2022/2022-09-03-born2beroot-install-sudo/4.png)

2. `secure_path` 를 아래와 같이 수정한다.

   ![5](/assets/images/2022/2022-09-03-born2beroot-install-sudo/5.png)

   ```bash
   /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
   ```

   - sudo 는 권한이 강력하기 때문에 보안상의 이유로 `secure_path` 기능을 제공하고 있다.
   - `secure_path` 는 sudo 명령을 실행할 때 사용하는 가상 쉘의 경로를 설정하는 것이다.
   - sudo 명령을 실행할 때 현재 계정의 쉘이 아닌 새로운 쉘을 생성하고 그 안에서 명령을 실행하는데, 이때 명령을 찾을 경로를 나열한 환경변수인 PATH 값이 `secure_path` 가 된다.
   - 즉, sudo 명령을 통해 실행하는 명령은 제 3의 쉘 환경에서 샌드박스 형태로 실행된다.
   - 이 기능이 중요한 이유는 트로이목마 해킹 공격에 대한 1차적인 방어 기능을 제공하기 때문이다. 만약, 현재 계정의 PATH 에 악의적인 경로가 포함된 경우, `secure_path` 를 설정하면 이를 무시함으로써 sudo 를 통해 전체 시스템이 해킹되는 경우를 방지할 수 있다.

3. `Defaults` 항목들을 다음과 같이 추가한다.

   ![6](/assets/images/2022/2022-09-03-born2beroot-install-sudo/6.png)

   ```bash
   Defaults	authfail_message="%d incorrect password attempts"
   Defaults	badpass_message="Incorrect password"
   Defaults	log_input
   Defaults	log_output
   Defaults	requiretty
   Defaults	iolog_dir="/var/log/sudo/"
   Defaults	passwd_tries=3
   ```

   - `authfail_message` : 인증에 실패하면 표시하는 메세지. `%d` 를 입력하면 로그인 실패한 횟수도 같이 표시할 수 있다.
   - `badpass_message` : 잘못된 비밀번호를 입력할 경우 표시할 메세지.
   - `log_input` : sudo 를 이용해서 입력한 명령어를 로그 파일로 저장한다.
   - `log_output` : sudo 를 이용해서 실행한 명령어의 실행 결과를 로그 파일로 저장한다.
   - `requiretty` : 사용자가 실제 tty 로 로그인한 경우에만 sudo 를 실행하는 설정이다. 예컨대, batch 파일이나 cron 에 작성된 스크립트를 실행하는 경우에는 작동하지 않는 것이다. (참고자료 : [tty란?](https://www.notion.so/tty-04457e7bb65f46ce899be9d623310a34))
   - `iolog_dir` : log 가 기록될 위치를 설정한다.
   - `passwd_tries` : 비밀번호 입력 시도 최대 회수를 설정한다.

4. `control + x` → `Y` → `/etc/sudoers` 를 입력하여 파일을 저장한다.

   ![7](/assets/images/2022/2022-09-03-born2beroot-install-sudo/7.png)

5. `exit` 명령어를 입력해서 root 계정을 로그아웃한다. 정상적으로 설정되었는지 확인하기 위해 sudo 를 이용한 임의의 명령어를 입력하고 비밀번호를 틀리게 입력하면 다음과 같이 `/etc/sudoer` 파일에 설정한 대로 출력된다.

   ![8](/assets/images/2022/2022-09-03-born2beroot-install-sudo/8.png)

6. 사용자에게 sudo 사용 권한을 주기 위해 다시 root 계정으로 로그인해서 `visudo` 를 실행시켜서 다음의 항목을 추가한다.

   ```bash
   [사용자명]	ALL=(ALL:ALL) ALL
   ```

   ![9](/assets/images/2022/2022-09-03-born2beroot-install-sudo/9.png)

## sudo 그룹 설정

1. `groupadd` 명령어를 사용해서 그룹을 추가한다.

   ```bash
   groupadd user42
   ```

   ![10](/assets/images/2022/2022-09-03-born2beroot-install-sudo/10.png)

2. 사용자를 그룹에 추가하기 위해 `usermod` 명령어를 사용한다.

   ```bash
   # 유저를 그룹에 추가
   usermod -aG [그룹명[, ...]] [사용자명]
   ```

   - `usermod` 는 root 계정만 사용 가능하며, 존재하는 사용자에 대해서만 처리할 수 있다.
   - 그룹을 여러 개 추가하고자 할 때는 콤마(`,`)로 구분한다.
   - `-a` 옵션은 `-G` 옵션과 함께 사용한다.

   ```bash
   usermod -aG user42,sudo joonhan
   ```

   ![11](/assets/images/2022/2022-09-03-born2beroot-install-sudo/11.png)

   - `id 사용자명` 명령어를 입력하면 해당 사용자가 속한 그룹을 표시해준다. sudo 와 user42 그룹에 정상적으로 속한 것을 확인할 수 있다.

# 참고자료

- [sudo](https://namu.wiki/w/sudo) [나무위키]
- [[Ubuntu] dpkg 명령어 사용법](https://miiingo.tistory.com/183) [티스토리]
- [APT](https://ko.wikipedia.org/wiki/%EC%96%B4%EB%93%9C%EB%B0%B4%EC%8A%A4%ED%8A%B8_%ED%8C%A8%ED%82%A4%EC%A7%95_%ED%88%B4) [위키백과]
- [리눅스(우분투 위주) 시스템 강좌 2장. -패키지 및 패키지 툴](http://tpholic.com/xe/5102649) [tpholic]
- [[Linux] Sudo 명령의 Secure Path](https://www.tuwlab.com/ece/24044) [tuwlab]
- [Sudoer Manual](https://www.sudo.ws/docs/man/1.8.27/sudoers.man/) [sudo]
- [Why is "requiretty" not working?](https://unix.stackexchange.com/questions/651408/why-is-requiretty-not-working) [stack exchange]
- [[리눅스/유닉스] 사용자관리 usermod 명령어, 사용자 아이디 변경, 임시 계정 발급, usermod 옵션, 사용 예시](https://jhnyang.tistory.com/259) [티스토리]
- [우분투 리눅스 - sudo 명령어에서 root 권한이 없을 때 ( ... is not in the sudoers file. This incident will be reported.)](https://starseeker711.tistory.com/176) [티스토리]
