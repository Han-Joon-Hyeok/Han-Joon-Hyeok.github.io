---
title: "[42Seoul] pipex (3) 구현 과정"
date: 2023-01-30 08:00:00 +0900
categories: [42seoul]
tags: [pipex]
use_math: true
---

# 회고

## 어서와, 멀티 프로세스는 처음이지?

그동안 수행했던 과제들은 모두 하나의 프로세스를 사용했다.

이번 과제는 처음으로 멀티 프로세스를 구현하고, 프로세스 간 통신(IPC)을 위해 파이프를 사용했다.

처음 보는 개념이 많다보니 이해하는데 시간이 꽤 걸렸다.

게다가 멀티 프로세스는 디버깅을 하는 것이 어려워서 디버깅에도 시간을 많이 썼다.

익숙하지 않은 개념을 이해하기 위해 그림을 그려서 이해하고자 노력했다.

그리고 다른 동료들에게 물어가며 내가 이해하고 있는 것이 맞는지 계속 확인했다.

그 결과로 효율적인 코드를 작성한 것은 아니지만, 멀티 프로세스가 어떻게 돌아가는지 이해할 수 있었다.

멀티 프로세스의 핵심은 병렬성이라 생각한다.

혼자서 많은 일을 해야 하는 것을 여럿이 나누어 효율적으로 처리하는 것이다.

그래서 부모 프로세스와 자식 프로세스가 수행해야 하는 작업은 정해져 있고, 자식 프로세스는 실행 결과를 부모 프로세스에게 전달해주어야 한다.

보너스에서는 히어독과 멀티 파이프를 다루는데, 이후 미니쉘 과제에서 어차피 구현할 거면 미리 구현하자는 생각으로 보너스를 했다.

사실 미니쉘에서 구현하는 것과는 조금 차이가 있지만, 미리 이 과제에서 공부한 덕분에 미니쉘에서는 해당 부분에 대해 큰 시간을 들이지 않을 수 있었다.

프로세스에 대한 이해가 있어야 미니쉘 뿐만 아니라 exam04 도 수월하게 통과할 수 있으니, 충분한 시간을 들여서 이 과제를 수행하는 것을 추천한다.

# Mandatory 구현

## 구조

![1.png](/assets/images/2023/2023-01-30-pipex-3-solution/1.png)

```bash
./pipex infile cmd1 cmd2 outfile
```

위의 명령어를 실행한다고 했을 때, `cmd1` 와 `cmd2` 모두 자식 프로세스를 생성해서 실행한다.

마지막으로 `cmd2` 를 실행하는 자식 프로세스는 종료 상태를 부모 프로세스로 반환한다.

## 학습 내용

`pipex` 과제를 통해 멀티 프로세스와 파이프 대해 배울 수 있다.

### 프로세스

![2.png](/assets/images/2023/2023-01-30-pipex-3-solution/2.png)

출처: [[운영체제]멀티 프로세스 vs 멀티 스레드](https://wookkingkim.tistory.com/m/entry/%EB%A9%80%ED%8B%B0-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-vs-%EB%A9%80%ED%8B%B0-%EC%8A%A4%EB%A0%88%EB%93%9C) [티스토리]

프로세스를 살펴보기 전에 **프로그램**이란 무엇인지 살펴보자. 사전적 의미의 프로그램은 **업무를 어떻게 수행할 것인지 작성한 계획이나 순서**를 의미한다. 즉, 어떤 작업을 하기 위해 해야할 일들을 순서대로 나열한 것이다. 비슷한 맥락에서 컴퓨터가 사용하는 프로그램의 의미는 **어떤 작업을 하기 위한 명령어 목록과 이에 필요한 데이터를 묶어놓은 파일**이다. 컴퓨터의 프로그램은 보조 기억장치(HDD 또는 SSD)에 저장되어있다.

프로세스란 프로그램이 메모리에 적재되어 실행되고 있는 인스턴스를 의미한다. 즉, 운영체제로부터 시스템 자원을 할당 받는 작업의 단위이다. 운영체제에는 한정된 자원으로 여러 프로세스를 효율적으로 사용하기 위해 다음 실행 시간에 실행할 수 있는 프로세스 중 하나를 선택하는 스케줄러(Scheduler)가 있다. 이때, 프로세스는 스케줄러의 선택을 받으면 실행된다.

프로세스는 각각 독립된 메모리 영역(코드, 데이터, 스택, 힙)과 주소 공간을 운영체제로부터 할당 받는다.

- 코드(Code) : 프로세스가 실행할 코드와 매크로 상수가 기계어의 형태로 저장된 공간. 컴파일 타임에 결정되며, 중간에 코드를 바꿀 수 없도록 Read-Only 로 지정되어 있다.
- 데이터(Data) : 코드에서 선언한 전역 변수 또는 static 변수 등이 저장된 공간. 전역 변수나 static 변수의 값을 참조한 코드는 컴파일 이후 Data 영역의 주소값을 가리키도록 바뀐다. 실행을 거치며 값이 바뀔 수도 있기 때문에 Read-Write 로 지정되어 있다.
- 스택(Stack) : 프로세스의 메모리 공간을 관리하기 위한 영역. 함수 안에서 선언된 지역 변수, 매개변수, 리턴값, 돌아올 주소 등이 저장된다. 함수 호출 시 기록하고, 함수 호출이 끝나면 제거된다. 기록 및 제거는 후위선출(LIFO) 방식을 따른다.
- 힙(Heap) : 프로그래머가 필요할 때마다 사용하는 메모리 영역. 나머지 영역과는 달리 런타임(프로그램이 실제로 실행되는 시간)에 결정된다. `malloc` 이나 `calloc` 함수를 사용하면 할당 받는 공간이 힙 영역이다. 데이터 배열의 크기가 고정적이지 않을 때 힙 영역을 사용한다. 단, 사용하고 나서 반드시 할당받은 메모리는 해제 해야 한다. 그렇지 않으면 메모리 누수(Memory leak)가 발생한다.

프로세스는 각각 독립된 영역이므로 다른 프로세스의 변수나 자료구조에 접근할 수 없다. 그래서 다른 프로세스의 자원에 접근하고 싶다면 파이프, 시그널, 소켓, RPC(Remote Procedure Call)과 같은 프로세스 간 통신(IPC; Inter-Process Communication)을 사용해야 한다.

### 멀티 프로세스

멀티 프로세스는 하나의 응용 프로그램을 여러 개의 프로세스로 구성하여 각 프로세스가 하나의 작업을 처리하는 것을 의미한다.

멀티 프로세스는 다양하게 사용되고 있다.

1. 크롬 브라우저 페이지 탭 : 특정 페이지의 클라이언트 페이지 코드에서 오류가 발생했을 때, 다른 열려있는 페이지들이 종료되지 않도록 각 페이지는 별도의 프로세스에서 실행되고 있다.
2. 쉘 명령어 실행 : 쉘에서 명령어를 실행하고 나서 오류가 발생하더라도 전체 쉘에 영향이 가지 않도록 자식 프로세스를 생성해서 명령어, 리다이렉션, 히어독 등을 실행한다.

이처럼 멀티 프로세스의 가장 큰 장점은 안정성이 확보된다는 것이다. 여러 자식 프로세스 중 하나만 문제가 발생해도 다른 자식 프로세스에 영향이 확산되지 않는다.

자식 프로세스를 생성하면 부모 프로세스의 변수와

하지만 멀티 프로세스의 단점은 다음과 같다.

IPC 파이프

## 예외처리

### 1. 인자의 개수가 일치하지 않을 때

Mandatory 기준으로 pipex 프로그램은 아래와 같이 인자가 총 5개(실행 파일명 포함)가 전달되어야 작동한다.

```bash
./pipex infile cmd1 cmd2 outfile
```

만약, 인자의 개수가 5개가 아니라면 작동하지 않아야 한다.

예를 들어, 아래와 같이 인자의 개수가 4개인 경우에 해당한다.

```bash
./pipex infile "grep hell" "ls -l"
```

실행 결과는 다음과 같다.

```bash
❌Error: The number of arguments should be 5.
```

### 2. 환경변수 PATH가 unset 된 경우

쉘의 명령어를 실행하기 위해서는 환경변수 중에서 `PATH` 라는 변수가 있어야 한다.`PATH` 변수에는 프로그램이나 라이브러리를 설치하여 실행할 수 있는 경로가 저장되어 있기 때문이다.

만약, `PATH` 변수가 빈 값이거나 존재하지 않는다면 명령어를 정상적으로 실행할 수 없다.

```bash
# PATH 환경변수 해제
$ unset PATH

# ls 실행
$ ls
zsh: ls: No such file or directory

# exit status 확인
$ echo $?
127
```

`$?` 는 마지막으로 실행한 명령어의 exit code 를 저장하는데, `127` 은 `command not found` 에 해당한다.

쉘에서는 `unset PATH` 를 수행하고 아래와 같이 명령어를 수행했을 때,

```bash
< infile grep hello | wc -l > outfile
```

실행 결과는 다음과 같다.

```
zsh: command not found: grep
zsh: command not found: wc
```

그리고 `outfile` 은 빈 파일로 생성된다.

따라서 pipex 프로그램도 환경변수 `PATH` 를 `unset` 하고 아래와 같이 실행하면,

```bash
# PATH 환경변수 해제
$ unset PATH
# pipex 실행
$ ./pipex infile "grep hell" "ls -l" outfile
```

실행결과는 다음과 같도록 처리했다.

```
❌Error: command not found: grep
❌Error: command not found: ls
```

또한, exit code 도 127 를 반환하도록 처리했다.

### 3. 표준 입력으로 넘긴 infile 이 존재하지 않거나, 읽기 권한이 없을 때

리다이렉션 `<` 을 사용할 때 `infile` 이 존재하지 않을 때, 실행 결과는 다음과 같다.

```bash
$ < infile ls -l | wc -l > outfile
zsh: no such file or directory: infile
```

그리고 `infile` 에 대해 읽기 권한이 존재하지 않을 때 실행 결과는 다음과 같다.

```bash
$ < infile ls -l | wc -l > outfile
zsh: permission denied: infile
```

위의 2가지 경우에 대해서 동일하게 출력하고 프로세스를 종료하도록 했다.

```bash
# 파일이 존재하지 않을 때
$ ./pipex infile "grep hell" "ls -l" outfile
❌Error: No such file or directory: infile

# 읽기 권한이 존재하지 않을 때
$ ./pipex infile "grep hell" "ls -l" outfile
❌Error: permission denied: infile
```

`fork` 함수 다음에 실행하는 것과 pipe 를 닫은 후에 실행하는 것과 어떤 차이가 있는가?

### 4. 유효한 명령어가 아닐 때

`infile` 이 존재한다고 가정하고, 유효하지 않은 명령어에 대해서는 3가지로 나눌 수 있다.

1. 첫 번째 명령어가 존재하지 않을 때

   ```bash
   $ < infile NOT_VALID_CMD -l | wc -l > outfile
   zsh: command not found: NOT_VALID_CMD
   ```

   이 경우에는 exit code 가 0 이 반환된다.

2. 두 번째 명령어가 존재하지 않을 때

   ```bash
   $ < infile ls -l | NOT_VALID_CMD -l > outfile
   zsh: command not found: NOT_VALID_CMD
   ```

   파이프는 가장 마지막에 실행한 명령어의 실행 결과에 따라 exit code 가 바뀌는데, 이 경우에는 127(`command not found`)을 반환한다.

3. 첫 번째, 두 번째 명령어 모두 존재하지 않을때

   ```bash
   $ < infile NOT_VALID_CMD1 -l | NOT_VALID_CMD2 -l > outfile
   zsh: command not found: NOT_VALID_CMD1
   zsh: command not found: NOT_VALID_CMD2
   ```

   이 경우도 마찬가지로 파이프의 마지막 명령어가 정상적으로 실행되지 않았으므로 exit code는 127을 반환한다.

### 5. `infile` 이 멈추지 않고 계속 들어오는 경우(urandom)

`waitpid` 함수에서 `WNOHANG` 옵션을 사용하면 스트림을 끊을 수 있다.

# Bonus 구현

## 1. 멀티 파이프

1. `infile` 을 `open` 함수로 연다.

   ![3.png](/assets/images/2023/2023-01-30-pipex-3-solution/3.png)

2. `dup2(infile, STDIN_FILENO)` 를 실행하여 표준 입력 파일 디스크립터(0번)가 `infile` 을 가리키도록 한다.

   ![4.png](/assets/images/2023/2023-01-30-pipex-3-solution/4.png)

3. 자식 프로세스를 생성하기 전에 부모 프로세스에서 `pipe` 를 생성한다.

   ![5.png](/assets/images/2023/2023-01-30-pipex-3-solution/5.png)

4. `fork` 를 실행하면 자식 프로세스는 아래와 같이 `fork` 를 실행하는 당시 부모 프로세스의 파일 디스크립터 상태를 유지하며 생성된다.

   ![6.png](/assets/images/2023/2023-01-30-pipex-3-solution/6.png)

5. 부모 프로세스는 자식 프로세스가 실행한 결과를 파이프로 받기 위해 `dup2(pipe_fd[0], STDIN_FILENO)` 를 실행한다. 그리고 부모 프로세스는 write 를 수행하지 않기 때문에 `close(pipe_fd[1])` 을 하고, 0번 파일 디스크립터가 파이프의 `read end` 를 가리키고 있기 때문에 `close(pipe_fd[0])` 를 하여 사용하지 않는 파일 디스크립터를 닫아준다.

   ```c
   // 부모 프로세스
   close(pipe_fd[1]);
   dup2(pipe_fd[0], STDIN_FILENO);
   close(pipe_fd[0]);
   waitpid(pid, NULL, WNOHANG);
   ```

   그림으로 표현하면 다음과 같다.

   ![7.png](/assets/images/2023/2023-01-30-pipex-3-solution/7.png)

6. 자식 프로세스는 명령어를 실행시킨 결과를 파이프의 `write end` 에 입력해야 하기 때문에 read 작업은 수행하지 않는다. 따라서 `close(pipe_fd[0])` 을 하고, `dup2(pipe_fd[1], STDOUT_FILENO)` 을 하여 표준 출력을 파이프의 `write end` 로 연결한다. 그리고 사용하지 않는 `pipe_fd[0]` 은 마찬가지로 `close` 한다. 이 과정이 끝나면 명령어를 실행한다.

   ```c
   // 자식 프로세스
   close(pipe_fd[0]);
   dup2(pipe_fd[1], STDOUT_FILENO);
   close(pipe_fd[1]);
   execute_cmd(argv, envp, pipex);
   ```

   그림으로 표현하면 다음과 같다.

   ![8.png](/assets/images/2023/2023-01-30-pipex-3-solution/8.png)

7. 두 번째 명령어를 실행시킬 때는 첫 번째 명령어와 달리 표준 입력을 `infile` 이 아닌 첫 번째 명령어의 실행 결과가 담겨있는 `pipe_fd[0]` 에서 가져온다. 이때, 파이프는 자식 프로세스를 생성하기 전에 새롭게 생성한다. 이전에 부모 프로세스 실행했던 코드 그대로 작동시키면 아래와 같아진다.

   ![9.png](/assets/images/2023/2023-01-30-pipex-3-solution/9.png)

8. 자식 프로세스도 이전에 수행했던 과정을 그대로 수행하면 아래의 그림과 같아진다.

   ![10.png](/assets/images/2023/2023-01-30-pipex-3-solution/10.png)

   즉, 자식 프로세스는 표준 입력이 이전 파이프의 `read end` 와 연결된 상태로 두 번째 명령어를 실행하여 새롭게 만든 파이프의 `write end` 에 출력 결과를 입력한다. 명령어의 개수가 N개라면 이 과정을 N-1 번 수행한다. N-1 번 수행하는 이유는 마지막 명령어인 N번째 명령어는 `outfile` 에 기록해야 하기 때문이다.

   ```c
   while (i < argc - 2)
   		child_process(argv[i++], envp);
   ```

9. 마지막 명령어를 실행할 때는 `dup2(outfile, STDOUT_FILENO)` 를 실행하여 표준 출력을 `outfile` 로 바꾸어주고, 표준 입력은 N-1 번째 명령어를 실행한 결과를 파이프의 `read_end` 에서 읽어오면 된다.

   ![11.png](/assets/images/2023/2023-01-30-pipex-3-solution/11.png)

   ```c
   dup2(pipex.outfile, STDOUT_FILENO);
   execute_cmd(argv[argc - 2], envp);
   ```

## 2. here_doc

![12.png](/assets/images/2023/2023-01-30-pipex-3-solution/12.png)

`heredoc` 을 실행하면 사용자의 입력을 받는 자식 프로세스를 생성한다. 사용자의 입력을 파이프의 `write end` 로 보내고 종료한다.

그 다음 `cmd1` 을 실행하는 자식 프로세스를 생성한다. 파이프의 `read end` 에서 사용자의 입력을 읽어와서 `cmd1` 실행하고, 실행 결과는 다시 파이프의 `write end` 에 보낸다.

마지막으로 부모 프로세스에서 `cmd2` 를 실행하는데, 파이프의 `read end` 에서 `cmd1` 실행 결과를 받아와서 `cmd2` 실행 결과를 `outfile` 로 저장한다.

### 예외처리 1. 인자가 `here_doc` 이 아닌 경우

heredoc 을 실행할 때는 아래와 같이 2번째 인자를 `here_doc` 으로 받는다.

```bash
# 정상적인 상황
$ ./pipex here_doc "HELLO" cat "wc -l" outfile
```

하지만, `ft_strncmp` 만을 사용해서 `here_doc` 문자열 8글자만 검사한다면, 뒤에 다른 문자가 붙었을 때 오류가 발생할 수 있다.

```bash
# here_doc까지는 동일하지만 뒤에 tor이 붙은 상황
$ ./pipex here_doctor "HELLO" cat "wc -l" outfile
```

따라서 `ft_strncmp` 으로 `here_doc` 까지 검사를 먼저 하고, `ft_strlen` 으로 문자열의 길이가 8이 아니라면 프로그램을 종료하도록 했다.

```bash
$ ./pipex here_doctor "HELLO" cat "wc -l" outfile
❌ Usage: [./pipex here_doc LIMITER cmd cmd1 file]
```

반면, 아래처럼 `here_doc` 보다 길이가 작은 문자열이 들어오면 heredoc 이 아닌 `infile` 로 인식하기 때문에 `No such file or directory` 를 출력하도록 했다.

```bash
# here_do까지는 동일, 하지만 heredoc으로 실행되면 안됨.
$ ./pipex here_do "HELLO" cat "wc -l" outfile
```

```bash
$ ./pipex here_do "HELLO" cat "wc -l" outfile
❌Error: No such file or directory
```

### 예외처리 2. `cmd1` 이 유효한 명령어가 아닐 때

유효한 명령어가 아닌 경우는 명령어가 빈 문자열이거나, 실행할 수 없는 명령어인 경우이다.

우선 명령어가 빈 문자열인 경우이다.

```bash
# cmd1 이 빈 문자열인 경우
"" << "HELLO" | ls >> outfile
```

실행 결과 및 exit code 는 다음과 같다.

```bash
# 터미널 출력 결과
bash: : command not found
# exit code 확인
echo $?
0
```

다음으로 실행할 수 없는 명령어인 경우이다.

```bash
# cmd1 이 실행할 수 없는 명령어인 경우
# (command not found)
meow << "HELLO" | ls >> outfile
```

실행 결과 및 exit code 는 다음과 같다.

```bash
# 터미널 출력 결과
bash: meow: command not found
# exit code 확인
echo $?
0
```

두 경우 모두 터미널에는 `cmd1: command not found` 가 출력되고, `cmd2` 가 유효한 명령어(`ls`)이기 때문에 exit code 는 `0` 이 반환되었다.

따라서 위의 두 경우에 대해서 다음과 같이 처리하였고, exit code 는 두 번째 명령어의 실행 결과인 `0` 이 반환되도록 했다.

```bash
# cmd1 이 빈 명령어인 경우
./pipex here_doc "HELLO" "" "ls" outfile
heredoc> HELLO
❌Error: command not found:

# cmd1 이 실행할 수 없는 명령어인 경우
./pipex here_doc "HELLO" "meow" "ls" outfile
heredoc> HELLO
❌Error: command not found: meow
```

### 예외처리 3. `cmd2` 가 유효한 명령어가 아닐 때

`cmd2` 가 유효하지 않은 경우는 마찬가지로 빈 문자열이 들어오거나 실행할 수 없는 명령어인 경우이다.

우선 빈 명령어가 들어오는 경우이다.

```bash
# cmd2 가 명령어가 빈 문자열인 경우
ls << "HELLO" | "" >> outfile
```

실행 결과는 다음과 같다.

```bash
bash-3.2$ ls << "HELLO" | meow >> outfile
> HELLO
bash: : command not found
bash-3.2$ echo $?
127
```

이때, `outfile` 은 빈 파일로 생성된다.

다음은 실행할 수 없는 명령어인 경우이다.

```bash
# cmd2 가 실행할 수 없는 명령어인 경우
ls << "HELLO" | meow >> outfile
```

실행 결과는 다음과 같다.

```bash
bash-3.2$ ls << "HELLO" | meow >> outfile
> HELLO
bash: meow: command not found
bash-3.2$ echo $?
127
```

마찬가지로 `outfile` 은 빈 파일로 생성된다.

위의 두 경우에 대해 다음과 같이 처리했다.

```bash
# cmd2 가 빈 문자열인 경우
bash-3.2$ ./pipex here_doc "HELLO" "ls" "" outfile
heredoc> HELLO
❌Error: command not found:
bash-3.2$ echo $?
127

# cmd2 가 실행할 수 없는 명령어인 경우
bash-3.2$ ./pipex here_doc "HELLO" "ls" "meow" outfile
heredoc> HELLO
❌Error: command not found: meow
bash-3.2$ echo $?
127
```

### 예외처리 4. `outfile` 이 존재하지 않는 경로에 있을 때

`No such file or directory` 메세지를 출력하며, exit code 는 `1` 이 반환된다.

```bash
bash-3.2$ ls << "" | ls >> not_existed/outfile
>
bash: not_existed/outfile: No such file or directory
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "ls" "ls" not_existed/outfile
heredoc>
❌Error: No such file or directory: not_existed/outfile
bash-3.2$ echo $?
1
```

### 예외처리 5. `outfile` 이 이미 존재하지만 쓰기 권한이 없을 때

`permission denied` 메세지가 출력되며, exit code 는 `1` 이 반환된다.

```bash
bash-3.2$ ls << "" | ls >> outfile
>
bash: outfile: Permission denied
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "ls" "ls" outfile
heredoc>
❌Error: permission denied: outfile
bash-3.2$ echo $?
1
```

### 예외처리 6. `cmd1` 이 유효하지 않고, `outfile` 이 존재하지 않는 경로에 있는 경우

`cmd1` 이 유효하지 않고, `outfile` 이 존재하지 않는 경우에는 출력 결과는 다음과 같다.

```bash
# cmd1 이 유효하지 않고
# outfile 이 존재하지 않는 경로에 있는 경우
bash-3.2$ "" << "HELLO" | ls >> not_existed/outfile
> HELLO
bash: not_existed/outfile: No such file or directory
bash: : command not found
bash-3.2$ echo $?
1
```

bash 기준으로는 파이프의 마지막 부분에서 오류가 먼저 출력되고, 그 다음 heredoc 부분에 대한 오류가 발생한다.

exit code 는 `EXIT_FAILURE` 에 해당하는 `1` 이 반환된다.

존재하지 않는 경로에 있는 파일을 `open` 함수로 열면 `-1` 이 반환되는데, 마지막 명령어를 실행하기 전에 `outfile` 의 `fd` 가 `-1` 인지 먼저 검사를 했다.

만약 `outfile` 이 존재하지 않는 경로에 있다면 `exit` 을 하고, 존재하는 경로에 있으면 마지막 명령어를 실행하도록 했다.

실행하면 다음과 같다.

```bash
bash-3.2$ ./pipex here_doc "HELLO" "" "ls" not_existed/outfile
heredoc> HELLO
❌Error: No such file or directory: not_existed/outfile
❌Error: command not found:
bash-3.2$ echo $?
1
```

### 예외처리 7. `cmd1` 가 유효하지 않고, `outfile` 이 이미 존재하지만 쓰기 권한이 없을 때

파이프의 마지막 쪽에서 먼저 `outfile` 에 대해 `permission denied` 가 출력되며, 이어서 `cmd1` 에 대해 `command not found` 가 출력된다. exit code 는 `1` 이 반환된다.

```bash
bash-3.2$ "" << "" | ls >> outfile
>
bash: outfile: Permission denied
bash: : command not found
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "" "ls" outfile
heredoc>
❌Error: permission denied: outfile
❌Error: command not found:
bash-3.2$ echo $?
1
```

### 예외처리 8. `cmd2` 가 유효하지 않고, `outfile` 이 존재하지 않는 경로에 있는 경우

이 경우에는 `No such file or directory` 메세지가 출력되며, exit code 는 `1` 이 반환된다.

이를 통해 bash 에서는 파이프의 마지막 명령어보다 `outfile` 이 우선순위가 높다는 것을 알 수 있다.

```bash
bash-3.2$ ls << "" | "" >> not_existed/outfile
>
bash: not_existed/outfile: No such file or directory
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "ls" "" not_existed/outfile
heredoc>
❌Error: No such file or directory: not_existed/outfile
bash-3.2$ echo $?
1
```

### 예외처리 9. `cmd2` 가 유효하지 않고, `outfile` 이 이미 존재하지만 쓰기 권한이 없을 때

예외처리 6과 마찬가지로 명령어보다 `outfile` 이 우선순위가 높으며, `permission denied` 메세지가 출력된다. exit code 는 `1` 을 반환한다.

```bash
bash-3.2$ ls << "" | "" >> outfile
>
bash: outfile: Permission denied
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "ls" "" outfile
heredoc>
❌Error: permission denied: outfile
bash-3.2$ echo $?
1
```

### 예외처리 10. `cmd1` 과 `cmd2` 모두 유효하지 않고, `outfile` 이 존재하지 않을 때

앞서 살펴본 것처럼 두 번째 파이프에서는 `outfile` 이 우선순위가 높기 때문에 `outfile` 을 찾을 수 없다면 이에 해당하는 오류 메세지를 출력하고, 두 번째 명령어를 실행하지 않는다. `outfile` 에 권한이 없을 때도 마찬가지이다.

```bash
bash-3.2$ "" << "" | "" >> ""
>
bash: : No such file or directory
bash: : command not found
bash-3.2$ echo $?
1
```

이에 대해 동일하게 구현했다.

```bash
bash-3.2$ ./pipex here_doc "" "" "" ""
heredoc>
❌Error: No such file or directory:
❌Error: command not found:
bash-3.2$ echo $?
1
```

# 참고자료

- [[운영체제]멀티 프로세스 vs 멀티 스레드](https://wookkingkim.tistory.com/m/entry/%EB%A9%80%ED%8B%B0-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4-vs-%EB%A9%80%ED%8B%B0-%EC%8A%A4%EB%A0%88%EB%93%9C) [티스토리]
- [스택, 힙, 코드, 데이터영역](https://selfish-developer.com/m/entry/%EC%8A%A4%ED%83%9D-%ED%9E%99-%EC%BD%94%EB%93%9C-%EB%8D%B0%EC%9D%B4%ED%84%B0%EC%98%81%EC%97%AD) [티스토리]
- [What is the purpose of fork()?](https://stackoverflow.com/questions/985051/what-is-the-purpose-of-fork) [stackoverflow]
- [[OS] 프로세스(process)와 스레드(thread)](https://haedallog.tistory.com/m/138) [티스토리]
- [[운영체제] 스케줄러(Scheduler)](https://dheldh77.tistory.com/m/entry/%EC%9A%B4%EC%98%81%EC%B2%B4%EC%A0%9C-%EC%8A%A4%EC%BC%80%EC%A4%84%EB%9F%ACScheduler) [티스토리]
