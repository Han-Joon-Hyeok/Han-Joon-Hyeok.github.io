---
title: 리눅스 터미널 명령어 정리
date: 2021-12-30 01:20:00 +0900
categories: [inux]
tags: [inux]
---

> [필수 리눅스 명령어 정리 - 드림코딩](https://www.youtube.com/watch?v=EL6AQl-e3AQ) 영상을 정리한 글입니다.

# 쉘 (shell)

쉘은 명령어 해석기, 명령행 인터페이스이자 스크립트 언어이다.

유닉스 계열의 운영체제는 보통 텍스트 모드의 터미널 화면에서 명령행에 명령어를 입력하여 사용한다. 이 명령어를 해석하는 프로그램이 쉘(shell)이다. 쉘 명령은 GUI 도구로는 수행하기 어려운 다양한 고급 기능을 제공한다. 쉘 명령어로 구성된 쉘 스크립트 프로그램을 작성하면 쉘이 스크립트 파일을 읽어 일련의 명령을 수행할 수 있다.

# 쉘 명령어

## 메뉴얼 관련

### man

`man` 은 특정 명령어에 대한 사용법과 설명을 보여준다. 해당 명령어가 필요한 매개변수와 같은 자세한 정보를 표시한다.

```bash
man [명령어 이름]
```

### clear

`clear` 는 현재 화면을 깔끔하게 지워주는 역할을 한다. 사실 지워진 것은 아니고, 화면을 아래로 내려서 이전에 수행한 명령어들이 안 보이게 해주는 것이다.

```bash
clear
```

## 파일 탐색기 및 터미널 관련

### pwd

`pwd` 는 `print working directory` 의 약자로, 현재 터미널이 작동하고 있는 디렉토리를 출력한다.

```bash
pwd
# /Users/joonhyuk
```

### open [path]

`open` 은 매개변수로 입력한 경로를 파일 탐색기로 띄워주는 역할을 한다.

```bash
# 현재 디렉토리의 폴더를 파일 탐색기로 띄움
open .
```

### ls

`ls` 는 `list` 의 약자로, 현재 디렉토리에 존재하는 파일과 폴더명을 보여준다. 추가 매개변수에 따라 다른 옵션을 설정할 수 있다.

- `-l` : `long` 의 약자로 파일형태, 사용권한, 하드링크번호, 소유자, 그룹, 파일크기, 시간, 연도, 파일명 순으로 자세한 정보를 표시한다.
- `-a` : `all` 의 약자로 현재 디렉토리의 숨겨진 파일을 포함한 모든 파일을 보여준다.

### cd [path]

`cd` 는 `change directory` 의 약자로, 매개변수로 주어진 경로로 디렉토리를 이동한다.

```bash
# 현재 디렉토리에 있는 workspace 폴더로 이동
cd workspace

# 상위 폴더로 이동
cd ..

# root 폴더로 이동
cd ~

# 이전 폴더로 다시 이동
cd -
```

### find

`find` 는 대상 경로에서 찾고자 하는 이름의 파일 또는 폴더를 찾는 명령어다

```bash
find [경로] [...탐색조건]

# 현재 디렉토리에서 txt 파일을 모두 검색
find . -type file -name '*.txt'

# 현재 디렉토리에서 맨 끝에 2가 포함된 폴더를 검색
find . -type directory -name '*2'
```

### which

`which` 는 환경변수로 지정된 명령어의 경로를 표시한다.

```bash
which node
# /usr/local/bin/node

which code
# /usr/local/bin/code
```

## 파일 생성 및 관리

### touch

`touch` 는 디렉토리 내에서 존재하지 않는 파일명을 지정하면 새로운 파일이 생성되며, 이미 존재하는 파일명을 지정하면 파일의 수정시간이 업데이트 된다.

```bash
# new_file1.txt 파일을 생성 (디렉토리 내 없다고 가정)
touch new_file1.txt
```

### cat

`cat` 은 텍스트 파일의 내용을 표시하는 명령어다.

```bash
# file1.txt 내용 출력
cat file1.txt

# file1, file2, file3 내용 연속해서 출력
cat file1 file2 file3

# 행 번호를 표시해서 출력
cat -n file1
```

### echo

`echo` 는 터미널에 입력하고자 하는 내용을 그대로 출력하거나 파일에 저장하는 기능을 수행한다.

```bash
# 터미널에 hello wolrd 출력
echo "hello world"

# 새로운 파일인 new_file1 을 만들면서 맨 첫줄에 hello world 입력
echo "hello world" > new_file1.txt

# 만약 이미 존재하는 파일이라면 그대로 덮어씌운다.
echo "Hello World Again" > new_file1.txt

# 기존 내용에서 추가하고자 한다면 화살표를 2개 사용한다.
echo "this is second line" >> new_file1.txt
```

### mkdir

`mkdir` 은 `make directory` 의 약자로, 현재 디렉토리에서 지정한 이름의 디렉토리를 새롭게 만든다.

```bash
# 현재 디렉토리에 new_dir 폴더를 생성
mkdir new_dir

# 디렉토리를 중첩해서 만들기 위해선 -p 옵션 사용
mkdir -p nested_dir/subdir1/subdir2
```

### cp

`cp` 는 `copy` 의 약자로, 현재 디렉토리에 존재하는 파일을 대상 경로에 복사한다.

```bash
# file1.txt 를 dir1 에 복사
cp file1.txt dir1/

# file1.txt 를 현재 디렉토리에 file2.txt 로 복사
cp file1.txt file2.txt
```

### mv

`mv` 는 `move` 의 약자로, 현재 디렉토리에 존재하는 파일을 대상 경로에 이동한다.

```bash
# file1.txt 를 dir1 에 이동
mv file1.txt dir1/

# file1.txt 를 file2.txt 로 변경
mv file1.txt file2.txt
```

### rm

`rm` 은 `remove` 의 약자로, 대상 파일 또는 디렉토리를 삭제한다.

```bash
# 현재 디렉토리에 있는 file1.txt 를 삭제
rm file1.txt

# 디렉토리를 삭제할 때는 -r (recursive) 옵션을 사용하며, 내부 디렉토리를 모두 삭제한다.
rm -r dir2
```

### grep

`grep` 은 `global regular expression print` 의 약자로, 특정 파일 내부에 존재하는 텍스트를 검색한다.

```bash
# 현재 디렉토리에서 "world" 텍스트를 포함하고 있는 모든 txt 파일을 검색한다.
grep "wolrd" *.txt

# -n 옵션은 텍스트가 몇 번째 라인에 있는지 함께 표시해준다.
grep -n "world" *.txt

# -i 옵션(insensitive)은 대소문자 구분없이 검색한다.
grep -i "world" *.txt

# -r 옵션(recursive)는 하위 디렉토리를 모두 포함해서 검색한다.
grep -r "world" *.txt
```

## 환경 변수 설정 및 관리

## export

`export` 는 환경 변수를 등록하는 명령어다. 경로나 필요한 값을 편리하게 사용할 수 있도록 한다.

```bash
# MY_DIR 이라는 변수에 dir1 을 저장
export MY_DIR = 'dir1'

# 환경 변수를 출력할 때는 $ 표시를 사용한다.
# MY_DIR 에 저장된 경로로 디렉토리를 변경
cd $MY_DIR
```

## Vim

`vim` 은 리눅스의 텍스트 에디터이다.

### 파일 생성

```bash
# file1.txt 이름의 파일을 연다.
vim file1.txt
```

### 명령어

`vim` 에 진입하고 나서 사용하는 명령어는 다음과 같다.

- `i` : `insert` 의 약자로, 파일에 내용을 입력할 때 사용한다.
- `esc` : 내용 입력을 마칠 때 사용한다.
- `:w` : `write` 의 약자로, 현재 작성한 내용을 저장한다.
- `:q` : `quit` 의 약자로, 현재 파일을 저장하지 않았다면 오류가 발생한다. 저장하지 않은 채로 파일을 닫으려면 `:q!` 를 입력한다.
