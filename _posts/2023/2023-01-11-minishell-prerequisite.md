---
title: "[42Seoul] minishell (1) 개념 정리"
date: 2023-01-12 00:30:00 +0900
categories: [42seoul]
tags: [minishell]
use_math: true
---

[gnu bash reference](https://www.gnu.org/software/bash/manual/bash.html) 에 있는 자료를 토대로 bash 가 작동하는 원리를 정리한 내용이다.

# bash 작동 원리

## 1. 파일 읽기

```bash
filename arguments
```

### 파일 실행

- `filename` 을 읽어서 실행한다.
- 그리고 `exit` 한다.
- 이를 `non-interactive shell` 이라 한다. 사용자가 명령을 입력할 수 있는 경우를 `interactive` 하다고 말한다.

```
When Bash finds such a file while searching the $PATH
for a command, it creates a new instance of itself to execute it.
```

- `bash` 는 명령어를 실행할 때 무조건 `fork()` 함수를 사용해서 자식 프로세스를 만든다.

### 파일 검색 순서

1. 현재 디렉토리
2. `$PATH` 환경 변수에 저장된 경로

### 메모

- `filename` 을 현재 디렉토리에서 찾아본다.
- 만약, 실행 가능하다면 `execve` 함수로 실행시킨다.
- 현재 디렉토리에 없으면 `$PATH` 환경변수에 저장된 경로를 찾아가서 파일이 존재하는지 확인하고, 실행 권한이 있으면 `execve` 함수로 실행시킨다.

## 2. 토큰화

입력 받은 내용을 word 와 operator 로 구분하며, 이 과정에서 Quoting 규칙은 무시한다.

metacharacter 로 word 와 operator 가 구분되는데, 이를 token 또는 unit 이라 한다.

bash 에서는 토큰화 과정에서 Alias expansion 도 이루어진다.

>💡 **Alias expansion**
>
>따옴표로 묶이지 않은 명령어가 입력되면 먼저 alias 가 존재하는지 확인한다.
>
>`/`, `$`, ```, `=` 와 메타 문자, 따옴표는 alias 의 이름으로 사용될 수 없다.
>
>alias 와 함께 arguments 를 넘길 수는 없다.
>
>명령어가 실행되기 전에 alias 를 먼저 확장한다. 
>
>Alias expansion 이 토큰화에서 이루어지는데, Mandatory 에서는 명시된 사항이 아니라서 구현하지 않았다.

### word

문자열을 의미한다.

쉘에서는 문자열을 unit 으로 판단하며, word 에는 `metacharacter` 가 포함되지 않는다.

### metacharacter

word 를 구분하는 문자이다. 단, 따옴표로 묶이지 않은 문자열에 대해서만 구분한다.

종류는 다음과 같다.

- 공백, 탭, newline
- `|`, `&`, `;`, `(`, `)`, `<`, `>`


> 💡 파이프나 redirection 은 공백을 사용하지 않아도 실행된다.

```bash
ls|cat # OK
ls | cat # OK

ls|cat>outfile # OK
ls | cat > outfile # OK
```

### operator

`operator` 는 2가지 종류가 있다.

1. `control operator` 
    
    특정 기능을 수행하는 토큰이다.
    
    - newline
    - `||`, `&&`, `&`, `;`, `;;`, `;&`, `;;&`, `|`, `|&`, `(`, `)`
        - `||` ("[or](http://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Control_Operators_.28.26.26_and_.7C.7C.29)") and `&&` ("[and](http://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Control_Operators_.28.26.26_and_.7C.7C.29)") separate two commands, resulting in the second command being executed if the first fail (i.e., returns with non-zero exit code) or succeeds (returns with zero exit code), respectively.
        - `;`, newline and `&` ("[background](http://mywiki.wooledge.org/ProcessManagement#How_do_I_run_a_job_in_the_background.3F)") separate two commands. The first is useful if you want to put "unrelated" commands on the same line. The last also sends a command to the background, continuing execution without waiting for the command to finish.
        - `;;` separates two `[case](http://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Choices_.28case_and_select.29)` statements.
        - `(` and `)` enclose a set of commands which are run in a [subshell](http://mywiki.wooledge.org/SubShell).
        - `|` ("[pipe](http://mywiki.wooledge.org/BashGuide/InputAndOutput#Pipes)") separates two commands, pointing standard output of the first command to standard input of the second command.
        - `|&` ("[error pipe](https://www.gnu.org/software/bash/manual/bashref.html#Pipelines)") separates two commands, pointing standard output *and* standard error of the first command to standard input of the second command. Try `(echo out; echo err >&2) 2>/dev/null |& cat`
        
        → [참고자료](https://stackoverflow.com/questions/20997060/what-is-a-control-function-in-bash) [stackoverflow]
        
2. `redirection operator` 
    - 명령어가 실행되기 전에 input 과 output 에 대한 redirect 가 먼저 이루어진다.

### token

word 또는 operator에 해당한다.

token 을 unit 이라고 부르기도 한다.

token 은 metacharacter 에 의해 나누어진다. 

### 예시

```bash
ls | grep joonhan > outfile
```

- word
    - `ls`
    - `grep`
    - `joonhan`
    - `outfile`
- metacharacter
    - `` : 모든 공백
    - `|`
    - `>`
- operator
    - `|`
    - `>`
- token
    - `ls`
    - `|`
    - `grep joonhan`
    - `>`
    - `outfile`

### Quoting

특정 문자나 특별한 기능에 대한 처리를 비활성화 하고, 매개 변수의 확장을 막는다.

- Escape character
    - `\` 문자 다음에 오는 문자를 리터럴로 처리한다.
    - **Mandatory 에서 구현 사항은 아니다.**

```bash
$ echo "$USER"
# joonhan

$ echo "\$USER"
# $USER
```

- Single Quotes
    - 작은 따옴표 안에 있는 것들은 모두 문자열로 처리한다.
    - `\` 도 무시하고, 환경 변수도 모두 문자열로 처리한다.

```bash
$ echo '$USER'
# $USER

$ echo '$USER \$USER'
# $USER \$USER
```

- Double Quotes
    - Single Quotes 와 달리 특수한 기능을 하는 문자들을 모두 작동하게 만든다.
    - Mandatory 에서는 환경 변수를 확장하는 `$` 만 구현하면 된다.

```bash
echo He said,"Hello world"
# He said,Hello world

echo "'He said, Hello world'"
# 'He said, Hello world'

echo "$USER"
# joonhan
```

### 토큰화 예시 1

```bash
echo 'hello "world"' | cat > a
# hello "world"
```

Token 1

- `echo` : word

Token 2

- `'hello "world"'` : word

Token 3

- `|` : operator (pipe)

Token 4

- `cat` : word

Token 5

- `>` : operator (redirection)

Token 6

- `a` : word

### 토큰화 예시 2

```bash
echo aaa"kk"kk haha > ee
```

Token 1

- `echo`

Token 2

- `aaa"kk"kk`

Token 3

- `haha`

Token 4

- `>`

Token 5

- `ee`

> 테스트 케이스
> 

```bash
echo "hello 'world' > outfile"
# echo
# "hello 'world' > outfile"

echo 'hello "world"' | cat > a
# echo
# 'hello "world"'
# |
# cat
# >
# a

echo aaa"kk"kk haha > ee
# echo
# aaa"kk"kk
# haha
# >
# ee

  echo 'hello "world"' |>
# echo
# 'hello "world"'
# |
# >

ls | cat > outfile
# ls
# |
# cat
# >
# outfile

ba'sh'
# ba'sh'

'ba'"sh"
# 'ba'"sh"

b'as'h
# b'as'h

b'a'"s"h 
# b'a'"s"h

"hello$USER".hi
# "hello$USER".hi
```

## 3. 파싱

### shell command

- command 와 argument 는 space 로 구분된다.

```bash
# [command] [...arguments]
echo a b c
# a b c
```

- 명령어 실행하고 나면 `waitpid` 함수를 통해서  exit status 를 반환한다.
- 시그널에 의해 멈추는 경우에는 `128 + n` 을 반환한다. `n` 은 시그널 번호이다.

### arguments

파이프를 만나기 전에 command 뒤에 나오는 word 는 argument 이다.

```bash
ls << eof libft
# libft는 ls 의 argument 이다.

ls libft << eof
# 위와 동일하다.
```

### redirection

redirection 바로 뒤에는 파일 이름이 온다.

```bash
ls > outfile

> outfile ls

ls >> outfile

>> outfile ls

< infile cat

cat < infile
```

### heredoc

heredoc 바로 뒤는 `LIMITER` 이다.

```bash
<< eof ls libft/
```

### 테스트 케이스

```bash
echo 'hello "world"' | cat > a
# echo            : COMMAND
# 'hello "world"' : ARGUMENT
# |               : PIPE
# cat             : COMMAND
# >               : REDIR_RIGHT
# a               : FILE_NAME
```

```bash
###############################
#### REDIRECTION INPUT (<) ####
####          OK           ####
###############################
< Makefile cat
# <               : REDIR_LEFT
# Makefile        : FILE_NAME
# cat             : COMMAND

# Makefile 대신 infile 을 cat 한 결과가 출력됨
< Makefile cat infile
# <               : REDIR_LEFT
# Makefile        : FILE_NAME
# cat             : COMMAND
# infile          : ARGUMENT

< Makefile ls -la
# <               : REDIR_LEFT
# Makefile        : FILE_NAME
# ls              : COMMAND
# -al             : ARGUMENT

cat < Makefile
# cat             : COMMAND
# <               : REDIR_LEFT
# Makefile        : FILE_NAME

wc -l < Makefile
# wc              : COMMAND
# -l              : ARGUMENT
# <               : REDIR_LEFT
# Makefile        : FILE_NAME
```

```bash
##################################
#### REDIRECTION HEREDOC (<<) ####
####           OK             ####
##################################
<< eof ls
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND

<< eof ls -al
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND
# -al             : ARGUMENT

<< eof ls libft/
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND
# libft/          : ARGUMENT

<< eof ls -la libft/
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND
# -la             : ARGUMENT
# libft/          : ARGUMENT

<< eof ls > outfile
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND
# >               : REDIR_RIGHT
# outfile         : FILE_NAME

<< eof ls | << foe cat
# <<              : REDIR_HEREDOC
# eof             : LIMITER
# ls              : COMMAND
# <<              : REDIR_HEREDOC
# foe             : LIMITER
# cat             : COMMAND
```

```bash
####################################
#### REDIRECTION OUTPUT (>, >>) ####
####             OK             ####
####################################
ls > outfile
# ls              : COMMAND
# >               : REDIR_RIGHT
# outfile         : FILE_NAME

> outfile cat infile
# >               : REDIR_RIGHT
# outfile         : FILE_NAME
# cat             : COMMAND
# infile          : ARGUMENT

ls -la >> outfile
# ls              : COMMAND
# -la             : ARGUMENT
# >>              : REDIR_APPEND
# outfile         : FILE_NAME

>> outfile cat infile
# >>              : REDIR_RIGHT
# outfile         : FILE_NAME
# cat             : COMMAND
# infile          : ARGUMENT
```

```bash
##############################
#### REDIRECTION PIPE (|) ####
####            OK        ####
##############################
ls | > outfile
# ls              : COMMAND
# |               : PIPE
# >               : REDIR_RIGHT
# outfile         : FILE_NAME

ls | >> outfile
# ls              : COMMAND
# |               : PIPE
# >               : REDIR_APPEND
# outfile         : FILE_NAME
```

### 문법 검사

1. 따옴표가 제대로 닫혀있는지? (2. 토큰화에서 처리함)
    
    ```bash
    echo "'hello"'
    ```
    
2. operator 뒤에 아무 것도 없는가?
    
    ```bash
    cat infile >
    ```
    
3. 파이프 바로 뒤에 파이프가 왔는가?
    
    ```bash
    ls | | cat
    ```
    
4. redirection 뒤에 operator 가 왔는가?
    
    ```bash
    cat > | ls
    
    cat > > ls
    ```
    

## 4. Shell expansion

### Shell expansion


>💡 **Tilde Expansion**
>`cd` 명령어를 수행하기 전에는 `OLDPWD` 환경변수가 없지만, 한번 수행하고 나면 `OLDPWD` 가 생기면서 변수 `PWD` 와 함께 지속적으로 갱신된다.
>
>서브젝트에서 요구하는 사항은 아님.

- 소괄호, 패턴 등과 같은 치환을 모두 수행한다.
- 환경 변수 치환 → word spliting → quote removal
- 그 다음 Quote Removal 을 하는데, expansion 의 결과를 제외한 `\`, `'`, `"` 문자들은 모두 지워진다.
    - `"` 큰 따옴표 안에 있는 환경변수는 치환된다.
    - `'` 작은 따옴표 안에 있는 환경변수는 리터럴로 해석된다.

> 예시
> 

```bash
export cute=hi

echo $cute
# hi

echo '$cute'
# $cute

echo "$cute"
# hi
```

### 환경변수 치환

환경변수 목록에 없으면 빈 문자열을 출력한다.

```bash
echo "hello$not_existed_variable world"
# hello world
```

> 테스트 케이스
> 
1. 환경변수를 확장하는 경우

```bash
##################################
# 1. 쌍따옴표 안에 있는 환경변수는 확장한다.
echo "hello $USER"
# echo "hello joonhan"
# hello joonhan

echo "'hello "$USER"'"
# echo "'hello "joonhan"'"
# 'hello joonhan'

echo "'hello '$USER''"
# echo "'hello 'joonhan''"
# 'hello 'joonhan''

echo ""$USER" '$USER'"
# echo ""joonhan" 'joonhan'"
# joonhan 'joonhan'

echo hello,"$USER".welcome
# echo hello,"joonhan".welcome
# hello,joonhan.welcome

echo hello,"$USER"
# echo hello,"joonhan"
# hello,joonhan

echo "hello $NAME$"
# echo "hello joonhan$"
# hello $

echo "hello $USER >> $USER"
# echo "hello joonhan >> joonhan"
# hello joonhan >> joonhan

echo "hello $USER "
# echo "hello joonhan "
# hello joonhan

echo "hello'$USER'world"
# echo "hello'$USER'world"
# hello'joonhan'world

echo "hello, $USER.hi".hi
# echo "hello, joonhan.hi".hi
# hello, joonhan.hi.hi
##################################

##################################
# 2. 따옴표에 감싸지지 않은 환경변수도 확장한다.
echo $USER
# echo joonhan

export a=ho
ec$a $USER
# echo joonhan
##################################
```

1. 환경변수를 확장하지 않는 경우

```bash
##################################
# 1. 닫히지 않은 따옴표이기 때문에 오류가 발생한다.
"'$USER"'
##################################

##################################
# 2. 홑따옴표 안에 있는 환경 변수는 확장하지 않는다.
echo 'hello "$USER"'
# echo 'hello "$USER"'
# hello "$USER"

echo ""'$USER'""
# echo ""'$USER'""
# $USER

echo hello'world"$USER"'
# echo hello'world"$USER"'
# helloworld"$USER"
##################################

##################################
# 3. 환경변수가 없는 경우
echo "hello joon joonhan"

##################################
```

### word spliting

따옴표에 묶인 상태에서 공백은 그대로 인식된다.

```bash
$ echo 'a  "a"'
# a  "a"

$ echo "a  'a'"
# a  'a'
```

하지만 환경변수의 확장이 일어나면 공백은 하나만 남기고 사라진다.

```bash
# 환경변수 설정
$ export a="a        'a'   b"
$ echo $a
# a 'a' b
```

### quote removal

따옴표로 묶인 문자열은 따옴표가 제거된다.

```bash
$ echo "a         a"
# a         a
```

다만, 따옴표 안에 포함된 따옴표는 제거되지 않는다.

```bash
$ echo "'hello'"
# 'hello'
```

그리고 확장(expansion)이 이루어진 문자열 내부에 포함된 따옴표도 제거되지 않는다.


>💡 After the preceding expansions, all unquoted occurrences of the characters ‘\’, ‘'’, and ‘"’ that did not result from one of the above expansions are removed.

참고 : [Bash Reference - Quote Removal](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)

```bash
$ export a="a    'a'"
$ echo $a
# a 'a'
```

> 테스트 케이스
> 

```bash
export a="a     'a'"
echo $a
# a 'a'

echo "hello $a"world'joon  park''$a'
# hello a    'a'worldjoon  parka    'a'

# 빈 문자열 출력
echo $not_existed_variable 
# 

echo 
```

## 5. redirection

- 명령어가 실행되기 전에 input 과 output 이 설정되어야 한다.
- Redirection 은 왼쪽에서 오른쪽으로 순서대로 처리한다.
- Redirection 에 관련한 모든 작업이 끝나면, Redirection 연산자와 피연산자를 인자 목록에서 제거한다.
    - 트리에서 제거하는 걸로 이해하면 될듯.

### Heredoc

- Heredoc 실행 시, 임시 파일을 만들어서 저장한다. (참고자료 : [How here document works in shell](https://stackoverflow.com/questions/70672456/how-here-document-works-in-shell) [stackoverflow])

## 6. Executing Commands

- 변수로 할당된 word 와 redirection 은 나중에 처리한다.
    - 실행하기 전에 expansion 하고 redirection 을 한다.

## 7. Exit Status

- Exit Status 는 마지막에 실행된 명령어를 waitpid 해서 받은 값으로 반환한다. (전역 변수로 관리)
- 모든 자식 프로세스는 waitpid 로 회수하기.