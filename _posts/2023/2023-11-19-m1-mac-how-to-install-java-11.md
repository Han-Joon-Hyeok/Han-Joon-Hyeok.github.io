---
title: "[Java] Mac M1 에서 Java11 설치하기"
date: 2023-11-19 00:30:00 +0900
categories: [java]
tags: []
---

# 설치 방법

Mac 에는 Java 가 기본으로 설치되어 있지 않다.

그래서 직접 설치해주어야 한다.

## brew 를 이용해서 설치하기

Homebrew 를 이용하면 간단하게 설치할 수 있다.

1. 우선 아래의 명령어를 실행해서 설치할 수 있는 Java 가 있는 지 확인한다. `openjdk` 뒤에 버전을 명시해주면 된다.

    ```bash
    brew search openjdk11

    #==> Formulae
    #openjdk@11          openjdk             openjdk@17          openjdk@8

    #==> Casks
    #openttd
    ```

2. 해당하는 버전을 설치한다.

    ```bash
    brew install openjdk@11
    ```

3. JVM 이 brew 로 설치한 openjdk 를 이용할 수 있도록 심볼릭 링크를 걸어준다.

    ```bash
    sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
    ```

4. 아래의 명령어를 이용해서 자바가 정상적으로 설치되었는 지 확인한다.

    ```bash
    java -version

    #openjdk version "11.0.21" 2023-10-17
    #OpenJDK Runtime Environment Homebrew (build 11.0.21+0)
    #OpenJDK 64-Bit Server VM Homebrew (build 11.0.21+0, mixed mode)
    ```


# 참고자료

- [MacOS에 Homebrew로 Java 11 설치하기](https://willnfate.tistory.com/entry/MacOS%EC%97%90-Homebrew%EB%A1%9C-Java-11-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0) [티스토리]