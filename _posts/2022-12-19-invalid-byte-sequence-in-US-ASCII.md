---
title: "[Jekyll] invalid byte sequence in US-ASCII 오류 해결"
date: 2022-12-19 10:00:00 +0900
categories: [jekyll]
tags: [jekyll]
use_math: true
---

# 🧐오류 발생 상황

github.io 블로그에 게시물을 올리기 전에 로컬 환경에서 테스트 하기 위해 아래와 같은 명령어를 실행시켰다.

```bash
bundle exec jekyll serve
```

하지만, 아래와 같은 오류를 출력했다.

```bash
[!] There was an error parsing `Gemfile`: 
[!] There was an error while loading `jekyll-theme-chirpy.gemspec`: invalid byte sequence in US-ASCII. Bundler cannot continue.

 #  from /Users/joonhyuk/workspace/Han-Joon-Hyeok.github.io/jekyll-theme-chirpy.gemspec:13
 #  -------------------------------------------
 #  
 >    spec.files         = `git ls-files -z`.split("\x0").select { |f|
 #      f.match(%r!^((assets\/(css|img|js\/[a-z])|_(includes|layouts|sass|config|data|tabs|plugins))|README|LICENSE|index|feed|app|sw|404|robots)!i)
 #  -------------------------------------------
. Bundler cannot continue.

 #  from /Users/joonhyuk/workspace/Han-Joon-Hyeok.github.io/Gemfile:5
 #  -------------------------------------------
 #  
 >  gemspec
 #  
 #  -------------------------------------------
```

# ❓오류 발생 원인

`bundle` 은 프로그램 실행 시 로케일(Locale)을 `en-US` 로 해석한다.

하지만 로컬 환경 변수에 로케일이 `en-US` 로 설정되어 있지 않았다.

# ✅오류 해결 방법

아래의 명령어를 터미널에 입력한다.
```bash
export LC_CTYPE=en_US.UTF-8
```

# 참고자료

- ["invalid byte sequence in US-ASCII (ArgumentError)"](https://github.com/fastlane/fastlane/issues/227#issuecomment-95871880)
- [로케일(Locale)에 관하여](http://coffeenix.net/doc/misc/locale.html)
