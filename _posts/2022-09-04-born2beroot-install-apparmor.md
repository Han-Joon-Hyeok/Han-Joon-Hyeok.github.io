---
title: "[Born2beroot] 3. AppArmor 설치"
date: 2022-09-04 22:20:00 +0900
categories: [42seoul]
tags: [born2beroot]
use_math: true
---

# AppArmor 설치

AppArmor 는 데비안 운영체제 설치와 함께 설치된다.

해당 패키지가 설치되었는지 확인하기 위해서는 다음의 명령어를 사용한다.

```bash
sudo dpkg -l apparmor
sudo dpkg -l apparmor-utils
```

만약 설치되지 않았다면 다음과 같이 `Version` 와 `Architecture` 항목이 `<none>` 으로 표시되고, `Description` 항목이 `(no description available)` 로 표시된다.

![1](/assets/images/2022-09-04-born2beroot-install-apparmor/1.png)

설치되지 않았다면 다음의 명령어를 사용해서 설치할 수 있다.

```bash
sudo apt install apparmor
sudo apt install apparmor-utils
```

## AppArmor 프로필

설치된 프로그램마다 보안정책을 설정하기 위해서는 AppArmor 프로필을 수정해야 한다.

프로필은 `/etc/apparmor.d` 디렉토리에 저장되어 있다.

현재 과제에서는 별도의 프로그램마다 보안정책을 설정하지 않기 때문에 넘어가도 된다.

# 참고자료

- [AppArmor Profiles on Ubuntu](https://linuxhint.com/apparmor-profiles-ubuntu/) [linuxhint]