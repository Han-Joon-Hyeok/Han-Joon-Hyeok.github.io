---
title: "[Born2beroot] 6. 비밀번호 정책 설정"
date: 2022-09-04 22:45:00 +0900
categories: [l42seoul]
tags: [born2beroot]
use_math: true
---

# 비밀번호 정책 설정

사용자 관리는 리눅스 시스템 관리에서 중요한 일이다. 특히, 비밀번호 정책은 중요한 비중을 차지하고 있다. 비밀번호를 강력하게 유지해야 허용되지 않은 사용자의 시스템 접근을 막을 수 있기 때문이다.

예를 들어, 어느 웹 사이트를 가입하는데 반드시 대소문자 포함, 숫자 포함, 특수문자 포함해서 비밀번호를 설정해야 하는 사이트와 그렇지 않은 사이트 중 어느 사이트가 해킹에 안전하다고 볼 수 있을까? 당연히 많은 조건을 충족시켜야 하는 전자가 안전하다고 할 수 있다.

## 비밀번호 정책 설정 방법

1. `/etc/login.defs` 파일은 비밀번호 정책을 저장하는 파일이다. 아래의 명령어를 입력해서 해당 파일을 연다.

   ```bash
   sudo vim /etc/login.defs
   ```

2. 다음의 항목들을 변경하고 저장한다.

   ![1](/assets/images/2022/2022-09-04-born2beroot-setting-password-policy/1.png)

   - `PASS_MAX_DAYS` : 패스워드 최대 유지 기간. 30일로 변경하여 비밀번호가 30일마다 만료되도록 함.
   - `PASS_MIN_DAYS` : 패스워드 최소 유지 기간. 비밀번호를 최소 2일 사용해야 변경할 수 있도록 함.
   - `PASS_WARN_AGE` : 비밀번호 만료일 며칠 전에 경고 메세지를 받을 것인지 설정. 만료 7일 전에 메세지를 받도록 함.

3. 나머지 정책들을 설치하기 위해 PAM(Plaggable Authentication Module)을 설치한다.

   ```bash
   sudo apt install libpam-cracklib
   ```

   ![2](/assets/images/2022/2022-09-04-born2beroot-setting-password-policy/2.png)

   - PAM 이란 사용자를 인증하고 응용 프로그램에 대한 사용 권한을 제어하는 프로그램이다.
   - PAM 을 사용하기 이전에는 리눅스 시스템에서 사용자를 인증하기 위해 사용자 정보가 담긴 주요 시스템 파일인 `/etc/passwd` 에 대한 접근 권한을 가지고 있어야 했다. 이는 보안상 위험했기 때문에 PAM 이 등장하게 되었다.
   - PAM 의 동작원리는 다음과 같다.
     1. 인증이 필요한 응용 프로그램은 더 이상 passwd 파일을 열지 않고, PAM 모듈에 사용자 인증을 요청한다.
     2. PAM 은 인증을 요청한 사용자의 정보를 통해 결과를 도출하여 응용 프로그램에 전달한다.
   - 사용자가 설정한 정책 이외에도 PAM 자체적으로 설정한 정책(연속된 숫자나 알파벳 등)이 존재한다.

4. 다음의 명령어를 입력해서 비밀번호 설정 파일을 연다.

   ```bash
   sudo vim /etc/pam.d/common-password
   ```

5. 기본적인 비밀번호 정책은 다음과 같다.

   ```bash
   retry=3  # 암호 입력 최대 횟수를 3번까지 허용
   minlen=8 # 암호 최소 길이를 8로 설정
   difok=3  # 기존 암호와 달라야 하는 문자의 개수를 3개로 설정
   ```

   ![3](/assets/images/2022/2022-09-04-born2beroot-setting-password-policy/3.png)

6. 과제에서 요구한대로 수정하고 저장한다.

   ```bash
   retry=3          # 그대로 유지
   minlen=10        # 최소 길이 10
   difok=7          # 기존 암호와 달라야 하는 문자의 개수를 7개로 설정
   ucredit=-1       # 대문자 1개 이상 포함
   lcredit=-1       # 소문자 1개 이상 포함
   dcredit=-1       # 숫자 1개 이상 포함
   ocredit=0        # 특수문자 0개 포함
   reject_username  # 비밀번호에 유저명이 포함되지 않아야 함
   enforce_for_root # 루트 계정에도 해당 규칙을 적용
   maxrepeat=3      # 같은 문자가 3번 이상 연속하면 안됨
   ```

   - 참고로 `ucredit` 과 `dcredit` 의 설정값이 양수면 최대 N개를 포함하는 것이고, 음수면 최소 N개를 포함하는 것이다.
   - `ucredit=3` 은 최대 3개 포함, `ucredit=-3` 은 최소 3개 포함인 것이다.

## 기존 계정에 변경된 정책 반영하기

비밀번호 정책을 변경한 다음에는 기존에 존재하는 사용자들의 비밀번호 정책에 다시 적용해주어야 한다.

1. 아래의 명령어를 사용하면 현재 계정의 비밀번호 정책을 확인할 수 있다.

   ```bash
   chage -l [사용자명]
   ```

   ![4](/assets/images/2022/2022-09-04-born2beroot-setting-password-policy/4.png)

2. 다음의 명령어를 입력해서 root 계정과 사용자 계정에 변경한 비밀번호 정책을 적용한다.

   ```bash
   chage -M 30 -m 2 -W 7 [사용자명]
   chage -M 30 -m 2 -W 7 root
   ```

   - `chage` 명령어의 매개변수는 `/etc/login.defs` 파일의 각각 다음의 항목과 대응한다.

   ```bash
   -M : PASS_MAX_DAYS
   -m : PASS_MIN_DAYS
   -W : PASS_WARN_AGE
   ```

3. 정상적으로 변경된 것을 확인할 수 있다.

   ![5](/assets/images/2022/2022-09-04-born2beroot-setting-password-policy/5.png)

## 계정 비밀번호 변경하기

위와 같이 비밀번호 정책을 설정해도, 정책을 설정하기 이전에 생성된 계정 중에서 비밀번호 정책에 부합하지 않는다는 안내나 경고가 별도로 발생하지 않는다.

그래서 아래의 명령어를 입력해서 직접 root 계정과 처음 생성한 계정의 비밀번호를 변경해준다.

```bash
sudo passwd [사용자명]
```

# 참고자료

- [[리눅스(Linux)] 비밀번호(패스워드) 정책 설정](https://jmoon417.tistory.com/36) [티스토리]
- [[Linux] PAM 파일 상세 설명 및 설정 방법](https://sysops.tistory.com/125) [티스토리]
- [리눅스 PAM 모듈의 이해](http://www.igloosec.co.kr/BLOG_%EB%A6%AC%EB%88%85%EC%8A%A4%20PAM%20%EB%AA%A8%EB%93%88%EC%9D%98%20%EC%9D%B4%ED%95%B4?searchItem=&searchWord=&bbsCateId=49&gotoPage=1) [IGLOO]
- [Why is this random password flagged saying it is too simplistic/systematic?](https://unix.stackexchange.com/questions/121087/why-is-this-random-password-flagged-saying-it-is-too-simplistic-systematic) [stackexchange]
