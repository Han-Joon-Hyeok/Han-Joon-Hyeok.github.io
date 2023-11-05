---
title: "[Homebrew] /opt/homebrew/bin is not in your PATH. 에러 해결"
date: 2023-11-05 16:00:00 +0900
categories: [homebrew]
tags: [trouble shooting]
---

# 문제 상황

M1 Mac Sonoma 14.0 에서 homebrew 를 아래의 명령어를 이용해서 설치하고자 했다.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

하지만 아래와 같은 에러가 발생했다.

```bash
Warning: /opt/homebrew/bin is not in your PATH.
   Instructions on how to configure your shell for Homebrew
   can be found in the 'Next steps' section below.

...
```

해석해보면 터미널에 표시된 ‘Next steps’ 을 잘 따라하면 해결될 것이라고 안내를 해주었다.

# 문제 원인

brew 를 사용하는데 필요한 환경변수가 shell 에 등록되어 있지 않았기 때문에 발생하는 오류이다.

Intel Mac 에서는 오류가 발생하지 않는데, M1 에서만 발생하는 이유는 잘 모르겠다.

# 문제 해결

아래의 명령어를 터미널에 입력한다.

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

# 참고자료

- [[m1 homebrew 설치 Warning 해결] /opt/homebrew/bin is not in your PATH](https://taenami.tistory.com/119) [티스토리]
