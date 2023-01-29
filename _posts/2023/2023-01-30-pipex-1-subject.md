---
title: "[42Seoul] pipex (1) 프로젝트 개요"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---
# Mandatory part

## 과제 설명

쉘의 파이프(`|`) 명령어를 구현하는 과제

## 제출 파일

사용한 모든 파일 (libft 사용했을 경우 모두 포함해서 제출)

## 사용 가능한 함수

- open, close, read, write, malloc, free, perror, strerror, access, dup, dup2, execve, exit, fork, pipe, unlink, wait, waitpid
- ft_printf 또는 유사한 함수
- libft 에 포함된 함수

## 작동 예시

```bash
./pipex file1 cmd1 cmd2 file2
```

- file1, file2 : 파일명
- cmd1, cmd2 : 실행 명령어

```bash
./pipex infile "ls -l" "wc -l" outfile
```

실제 쉘에서는 다음과 같은 명령어와 같은 기능을 한다.

```bash
< infile ls -l | wc -l > outfile
```

1. `infile` 이라는 파일을 표준 입력(STDIN)으로 받아서 `ls -l` 명령어를 수행한다.
2. 파이프(`|`)는 1번에서 실행한 명령어의 결과를 표준 출력(STDOUT)으로 내보내지 않고, 두 번째 명령어인 `wc -l` 의 표준 입력(STDIN)으로 보낸다.
3. `wc -l` 의 처리 결과를 `outfile` 로 저장한다. 이때, `>` 는 `outfile` 이미 존재하더라도 내용을 덮어쓴다.

# Bonus part

## 과제 설명

1. 파이프를 여러 개 사용했을 때 작동하도록 구현
2. heredoc(`<<`) 기능 구현

## 작동 예시

### 1. 파이프 여러 개 사용하기

```bash
./pipex infile cmd cmd2 cmd3 ... outfile
```

실제 쉘에서는 다음과 같은 명령어와 같은 기능을 한다.

```bash
< infile cmd1 | cmd2 | cmd3 ... | cmdN > outfile
```

쉘 명령어 여러 개를 수행한 결과를 `outfile` 에 저장한다.

예를 들어, `infile` 에 다음과 같은 내용이 저장되어 있다 해보자.

```
hello
hello
hihihi
```

그리고 다음과 같은 명령어를 수행한다.

```bash
< infile grep hello | tr "h" "H" | grep Hello | wc -l > outfile
```

`infile` 에서 `hello` 라 적혀있는 문자열에 대해(`grep hello`) 소문자 `h` 를 대문자 `H` 로 변경하고(`tr “h” “H”`), 다시 `Hello` 문자열을 검색하여(`grep Hello`) 총 몇 줄이 있는지(`wc -l`)  `outfile` 에 저장하는 명령어이다.

`outfile` 에는 다음과 같이 저장된다.

```
			2
```

### 2. heredoc(`<<`) 기능 구현

```bash
./pipex here_doc LIMITER cmd1 cmd2 outfile
```

heredoc은 사용자의 입력을 표준 입력으로 받아서 명령어를 실행한다.

그리고 실행 결과를 `outfile` 이 존재한다면 파일의 마지막에 추가한다. (`>>`)

이때, `LIMITER` 는 사용자의 입력을 멈추기 위한 문자열을 의미한다. 즉, EOF의 역할을 하는 문자열을 의미한다.

실제 쉘에서는 다음과 같이 사용할 수 있다.

```bash
<< HELLO cat | wc -l >> outfile
heredoc> hello
heredoc> hello
heredoc> HELLO
```

사용자로부터 `HELLO` 라는 문자열이 들어오기 전까지 계속 표준 입력을 받고, 입력 받은 내용을 읽는다(`<< HELLO cat`). 그 다음 입력한 내용이 총 몇 줄인지 계산하고(`wc -l`), 출력 내용을 `outfile` 의 마지막에 추가한다.

`outfile` 이 없었다면 다음과 같이 저장된다.

```
			2
```

반대로 `outfile` 이 이미 존재했다면 해당 파일 내용의 마지막에 두 번째 명령어 실행 결과가 저장된다.

```
			2
```

`outfile` 이 위와 같이 저장되어 있고, 아래와 같이 실행한다고 해보자.

```bash
<< HELLO cat | wc -l >> outfile
heredoc> hello
heredoc> hello
heredoc> HELLO
```

`outfile` 에는 다음과 같이 저장된다.

```
			2
			2
```
