---
title: "[Visual Studio Code, Mac] ssh remote connect 오류 해결 : Could not establish connection to ~ Permission denied(publickey)."
date: 2023-12-17 21:20:00 +0900
categories: [l개발환경]
tags: []
---

# 실행 환경

- OS : MacOS Sonoma 14.2 (Intel)
- Visual Studio Code : 1.85.1

# 문제 상황

- Visual Studio Code 의 Remote Explorer 기능을 이용해서 AWS EC2 인스턴스에 접속을 시도했다.
- 하지만, 아래의 사진과 같이 권한이 없다며 연결에 실패했다.
    
    ![1](/assets/images/2023/2023-12-17-visual-studio-code-ssh-remote-permission-denied/1.png)
    

# 문제 원인

- `/Users/[사용자]/.ssh/config` 파일에 키 페어 파일의 경로에 해당하는 `IdentityFile` 를 제대로 찾지 못해서 발생한 오류였다.
- 표준 에러 로그를 확인해보니 No such file or directory 라고 출력되어 있었다.
- `IdentityFile` 의 경로는 `file.pem` 으로 되어 있었다.

# 문제 해결

- `IdentityFile` 의 경로를 절대 경로로 수정했다.
- `/Users/[사용자]/.ssh` 폴더에 키 페어 파일을 저장해두었기 때문에 `~/.ssh/file.pem` 으로 수정하였다.

# 참고자료

- [[ERROR] Could not establish connection to ~~(feat. vs code)](https://kkkapuq.tistory.com/108) [티스토리]