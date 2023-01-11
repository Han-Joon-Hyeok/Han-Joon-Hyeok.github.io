---
title: git 기초 명령어 사용법에 대해 알아보자(git init, git add, git commit)
date: 2021-01-24 09:00:00 +0900
categories: [git]
tags: [git]
---

> [생활코딩 - 지옥에서 온 Git](https://opentutorials.org/course/2708)을 공부하며 정리한 내용입니다.

`git`을 이용해서 버전관리를 시작해보자. `git`에서 주로 사용되는 명령어들 중에서 이번 포스팅에서는 다음의 내용들을 다루어보고자 한다.

- [1. git init : 저장소 만들기](#1-git-init--저장소-만들기)
- [2. git add : git이 관리할 대상으로 파일 등록](#2-git-add--git이-관리할-대상으로-파일-등록)
  - [사용법](#사용법)
  - [작동원리](#작동원리)
  - [git status : 파일의 상태를 조회](#git-status--파일의-상태를-조회)
    - [git status의 원리](#git-status의-원리)
  - [Staging Area](#staging-area)
- [3. git commit : 버전 만들기](#3-git-commit--버전-만들기)
  - [사용법](#사용법-1)
  - [git commit의 원리](#git-commit의-원리)
  - [git log : 커밋 내역 확인](#git-log--커밋-내역-확인)
    - [사용법](#사용법-2)
- [그렇다면 git add와 git commit은 왜 같이 쓰는 걸까?](#그렇다면-git-add와-git-commit은-왜-같이-쓰는-걸까)

또한 `git add`, `git commit`, `git status`의 작동원리에 대해서 함께 소개하고자 한다.
작동원리는 다소 초심자가 이해하기에는 다소 어려운 내용일 수 있으므로, 해당 내용은 건너뛰고 나중에 필요할 때 다시 읽어보는 것을 추천한다.

# 1. git init : 저장소 만들기

`Git`을 로컬 저장소에서 생성하기 위해서 `Git Bash` 프롬프트에서 `git init`을 입력하면 `.git`이라는 파일이 생성된다. 이 파일은 버전에 대한 정보를 담고 있는 파일이며, 평소에는 숨김 파일로 설정되어 눈에 보이지 않는다. 그리고 파일이 추가/삭제 되거나, 파일의 내용이 변경되는 것을 자동으로 감지할 수 있다. 해당 파일을 삭제하면 이전 버전에 대한 정보가 날아가므로 주의해야 한다.

`git init`은 `initialize(초기화)`를 의미한다. 이 명령어를 실행하기 전까지 폴더는 내 컴퓨터에만 존재하는 세상 평범한 폴더였지만, 이제는 버전 관리가 가능한 특별한 폴더가 된다.

참고로 Github의 저장소 구조를 나타내면 아래의 사진과 같다.

<div class="img-container">
    <img class="post-img" src="https://user-images.githubusercontent.com/54902347/105453593-bcbfda00-5cc3-11eb-8cd7-09468d742372.png" alt="Github 저장소 구조">
    <p class="post-img-caption">출처 : <a href="https://velog.io/@devmin/깃허브github-명령어-알아보기">https://velog.io/@devmin/깃허브github-명령어-알아보기</a></p>
</div>

크게는 `로컬 저장소`와 `원격 저장소` 2가지로 나뉘는데, 쉽게 말해서 `로컬 저장소`은 내 컴퓨터에 저장된 폴더를 의미하고, `원격 저장소`는 `Github` 서버에 올라간 폴더를 의미한다. 

**주의할 점**은 실시간으로 폴더 내의 변화를 감지해서 원격 저장소와 연동 하는 것이 아니다. 지속적으로 변화하는 파일의 상태를 실시간으로 서버와 지속적으로 연결해서 비교하는 것은 네트워크 자원을 소모하는 낭비일 뿐이며, 파일 버전 관리의 의미가 없어지게 된다. 

~~누가 이렇게 생각을 하겠냐마는, 부끄럽게도 처음에 내가 이렇게 생각했었다.~~

앞으로 자세히 설명하겠지만, `git add` - `git commit` - `git push` 순으로 명령어를 입력하면 Github에 내 파일들이 올라가는 것을 볼 수 있다.


# 2. git add : git이 관리할 대상으로 파일 등록

`git add`는 작업 디렉토리 상의 변경 내용을 스테이징 영역에 추가하기 위해 사용하는 명령어이다. 

예를 들어, `hello.txt`를 해당 폴더에 처음 생성하고 prompt에서 `git status`를 입력하면 파일의 상태를 다음과 같이 확인할 수 있다.

![git_status](https://user-images.githubusercontent.com/54902347/105452248-58038000-5cc1-11eb-8c88-769fb81f63c2.png)

빨간색으로 표시된 파일이 현재 `Untracked` 상태라는 것인데, `git`이 해당 파일에 대한 어떠한 정보도 가지고 있지 못하다는 것을 의미한다. 

![git_add](https://user-images.githubusercontent.com/54902347/105452426-a6b11a00-5cc1-11eb-88b9-5dd9386acb6d.png)

명령어가 실행되면 스테이징 영역으로 넘어가서 `Tracked`로 상태가 바뀌고, 초록색으로 표시되는 파일은 현재 커밋을 기다리는 단계임을 알려준다.

## 사용법

1. `git add .` : 현재 디렉토리의 모든 변경 내용을 스테이징 영역으로 넘길 때 `.`을 인자로 넘긴다. 개인적으로 1번을 제일 많이 사용한다.
    
2. `git add -A` : 작업 디렉토리 내의 모든 변경 내용을 모두 스테이징 영역으로 넘긴다. `git add .`와는 달리 현재 디렉토리를 기준으로 상위 폴더의 변경 내용까지 포함한다. 
    ``` TEXT 
    \---one 
      | one.txt
      |
      +---two
      |   two.txt
      |

    ```
    만약, 위와 같이 `one`폴더 아래 `two` 폴더가 있다고 했을때, `one`폴더에서 `three.txt`를 생성하고 `two` 폴더에서 `git add -A`를 실행하면 상위 폴더에서 생성된 `three.txt` 파일도 스테이징 영역으로 넘긴다.

3. `git add 파일/디렉토리 경로` : 작업 디렉토리의 변경 내용의 일부만 스테이징 영역에 넘기고 싶을 때는 수정한 파일이나 디렉토리의 경로를 인자로 넘긴다.

## 작동원리

`git add`는 현재 디렉토리에서 생성된 파일을 `스테이지 영역(커밋 대기상태)`에 추가하는 역할을 한다.

```Text
[t1.txt]
a
```

`t1.txt`에 위와 같은 내용으로 저장을 하고, .`git` 폴더 내부를 살펴보자.

![git add(1)](/assets/images/2021-01-24-git-basic-commands/git_add(1).png)

`git add`를 실행하면 `.git`폴더 내부에는 위와 같이 `index`파일과 `objects`폴더 아래에 파일이 하나 생긴다. 하나씩 살펴보자면 다음과 같다.

- `index` : 현재 스테이징 영역에 존재하는 파일을 의미한다. 즉, 커밋을 대기하는 상태인 파일들의 목록이다.
- `objects` : 스테이징 영역에 올라온 파일에 대한 내용이 생성되거나 커밋 내용이 생성되는 객체 폴더이고, 하위 폴더에는 각각의 고유한 문자열로 저장이 된다.
  - `길이가 2인 하위 디렉토리`가 생성되며, 이 디렉토리 안에 파일의 내용을 `SHA1` 알고리즘으로 해석한 해시값이 파일명으로 생성된다. (SHA1으로 해시값을 만들어보고 싶다면 [SHA1-Online](http://www.sha1-online.com/)에 접속하여 확인해보자.)
  
  ![git add(2)](/assets/images/2021-01-24-git-basic-commands/git_add(2).png)

  - 본문에 `a`라고 입력하고 저장하면, git 내부적으로 내용을 압축하고 해시값을 계산을 한다. 이 글을 보시는 분들도 똑같이 내용을 입력하고 `git add`를 수행하면 사진과 똑같은 해시값을 얻게 될 것이다.

  - git에서는 해당 파일에 대한 고유한 해시값을 `폴더명(2글자)` + `내용 해시값`을 합쳐서 인식을 한다. 

  ![git add(3)](/assets/images/2021-01-24-git-basic-commands/git_add(3).png)

  - 그래서 `index`파일에서 링크가 된 해시값을 클릭하면 `f1.txt`에 대한 내용이 담긴 `objects`폴더 내부의 파일을 볼 수 있다.

  - 즉, `index`는 스테이징 영역에 올라온 파일들을 해시코드를 통해 추적을 할 수 있다. C언어에서 사용하는 `포인터`와 비슷한 원리라고 생각할 수 있다.

다음으로 `f2.txt`를 아래와 같이 생성하고 `git add`를 실행해보자.

``` Text
[f2.txt]
z
```

![git add(4)](/assets/images/2021-01-24-git-basic-commands/git_add(4).png)

내용에 따라 해시값이 달라지므로 당연히 `f1.txt`와 해시값이 고유하게 구분이 된다.

그러면 똑같은 내용의 파일을 복사한다면 git은 어떻게 인식을 할까?
`f1.txt`를 복사해서 `f3.txt`로 만들고, `git add`를 실행하면 다음과 같은 결과가 나온다.

![git_add(5)](/assets/images/2021-01-24-git-basic-commands/git_add(5).png)

`f1.txt`와 `f3.txt`는 파일이름이 다르지만, 내용이 똑같아서 같은 해시값으로 오브젝트 파일이 생성된다.

**즉, 이름이 다른 파일이 5억개가 있어도 내용이 동일하다면 같은 오브젝트 파일**이라는 것이다. 그래서 `index`에서는 다른 파일명들은 인식하지만, 모두 같은 오브젝트 파일이기 때문에 **파일 내용에 대한 중복**을 제거할 수 있다.

![git add(6)](/assets/images/2021-01-24-git-basic-commands/git_add(6).png)

## git status : 파일의 상태를 조회

이 명령어는 `git add`와 주로 함께 사용된다.
실행 결과는 크게 `Untracked`, `Tracked`, `Modified`, `Unmodified` 4가지이고, 현재 파일의 상태를 나타낸다.

<div class="img-container">
    <img class="post-img" src="https://user-images.githubusercontent.com/54902347/105460364-05c95b80-5ccf-11eb-9072-04d3d50e5743.png" alt="file lifecycle">
    <p class="post-img-caption">출처 : <a href="https://git-scm.com/">https://git-scm.com/</a></p>
</div>

1. 처음 생성하면 `Untracked` 상태인데, 파일을 `git add`로 스테이징 영역으로 옮기면 `Tracked` 상태가 된다.
2. `commit`을 통해 현재 버전에 대한 이력을 저장했다면, 자동으로 `Unmodified` 상태로 변경이 된다.
3. `commit`이 완료된 파일이 수정된다면 `Modified`로 변경된다.
4. `Modified` 상태의 파일을 다시 `git add`로 스테이징 영역에 올린다. 즉, 한번 커밋된 파일이 수정되면 무조건 다시 `git add`부터 입력해주어야 한다는 것이다.
5. 만약 `commit`이 완료된 파일을 삭제하게 되면 해당 파일은 `Untracked` 상태가 되어 git의 관리 대상에서 제외된다.

### git status의 원리

`index` 파일에 담긴 파일 정보와 현재 `Wokring Directory`에 있는 파일을 비교하여 새로운 파일이 추가되었는지, 기존의 파일이 수정 또는 삭제되었는지 판단한다.

![git status](/assets/images/2021-01-24-git-basic-commands/git_status.png)

이전 커밋의 `tree`에서는 `f2.txt`에 대한 해시값을 발견할 수 없으므로 `git status`는 새로운 파일이 생성되었음을 발견한다.

만약 `f1.txt`파일이 수정되었다면 해당 파일에 대한 해시값이 변경되므로, `git status`를 실행했을 때 해시값을 비교하여 수정되었다는 것을 감지할 수 있다.

## Staging Area

`스테이징 영역`은 커밋을 대기하는 장소로써, 작업 디렉토리와 Git 저장소 변경 이력 사이의 징검다리 역할을 한다. `작업 디렉토리`는 아직 commit할 준비가 안된 변경 내용을 자유롭게 수정할 수 있지만, `스테이징 영역`은 commit할 준비가 된 변경 내용이 Git 저장소에 기록되기 전에 대기하는 장소이다. 그래서 `git add` 명령어를 사용하면 현재 `작업 디렉토리`에 있는 모든 파일 또는 일부 파일의 변경 내용을 `스테이징 영역`으로 옮길 수 있다. 

# 3. git commit : 버전 만들기

`git commit`은 파일 및 폴더의 추가/변경 사항을 저장소에 기록하는 것이다. 즉, 파일(폴더)의 버전이 의미 있는 변화가 발생했다는 것이고, 특정 작업이 완결된 상태로 바뀌었다는 것을 의미한다. 커밋을 할 때는 보통 변경 내역에 대한 상세한 설명을 함께 포함하는데, 이것이 우리가 Github의 레포지토리에서 발견하는 문구이다. 커밋한 내용을 통해 어떤 파일이 언제, 어떻게 변경되었는지 한 눈에 타임라인으로 파악할 수 있다.

![git_commit_message](https://user-images.githubusercontent.com/54902347/105458557-2b089a80-5ccc-11eb-8219-618007cd80c0.png)

## 사용법

1. `git commit -m "메세지 내용"`  : 변경 내역에 대한 메모와 함께 커밋한다.
2. `git commit -am "메세지 내용"` : `git add`와 `git commit`을 동시에 수행한다. 단, 이 기능을 사용하기 위해서는 commit이 한 번은 수행되어 있어야 한다.
3. `git commit --amend` : 방금 커밋한 메세지를 수정한다. 

## git commit의 원리

`git commit`을 수행하면 커밋 메세지에 대한 새로운 객체 파일을 생성하고, 해당 커밋 메세지에는 `tree`와 `parent`가 포함된다.

- `tree` : 해당 커밋을 수행한 당시에 스테이지 영역에 있던 파일들의 목록이 담겨있다.
- `parent` : 첫 커밋에는 존재하지 않지만, 두 번째 커밋부터는 이전에 실행된 커밋에 대한 정보가 존재한다. 
- `blob` : 파일의 내용을 담고 있다.

![git commit(1)](/assets/images/2021-01-24-git-basic-commands/git_commit(1).png)

첫 커밋에서는 `parent`가 존재하지 않고, `tree`만 존재한다.

![git commit(2)](/assets/images/2021-01-24-git-basic-commands/git_commit(2).png)

두 번째 커밋부터는 이전 커밋에 대한 내역이 담긴 `parent`가 생성된다.

![git commit(3)](/assets/images/2021-01-24-git-basic-commands/git_commit(3).png)

위의 그림과 같이 각각의 커밋들은 서로 연결이 되있고, 각 커밋들마다 파일 내용에 대한 정보를 담고 있기 때문에 Git을 통한 **파일 백업**이 가능해진다.

즉, `tree`라고 하는 정보 구조에 각각의 커밋에 대한 모습을 사진으로 남겨놓는 것이다.

## git log : 커밋 내역 확인

`git log`를 입력하면 아래와 같이 커밋이 완료된 내역들에 대해 조회할 수 있다. 

![git_log](https://user-images.githubusercontent.com/54902347/105459353-75d6e200-5ccd-11eb-8fdd-231461064fe6.png)

### 사용법 

1. `git log -p` : commit 내역을 한 줄씩 내리면서 확인할 수 있다.
2. `git log diff 커밋코드1..커밋코드2` : 다른 2개의 커밋에 대해서 어떤 파일이 변경되었고, 어떤 코드가 변경되었는지 차이점을 보여준다.

![git_diff](https://user-images.githubusercontent.com/54902347/105466221-45944100-5cd7-11eb-9ffe-83dbdc9cfa8f.png)

위의 사진에서는 `git log diff 가장 마지막 커밋..가장 최근 커밋`을 입력을 했다.
빨간색이 과거 커밋 내용이고, 파란색이 최근 커밋 내용이다.
로그 메세지를 읽는 방법은 다음과 같다.

``` text
1. --- /dev/null : subfolder/test2.txt 라는 파일이 과거에는 없었다는 의미이다. 
2. +++ b/subfolder/test2.txt : 해당 파일이 최근 커밋에 추가 되었다는 의미이다.
3. @@ -0,0 +1 @@ : -0,0은 과거 파일을 기준으로 아무 것도 변경된 것이 없다는 것이고, +1은 최근 파일 1개에 1줄이 추가되었다는 것을 의미한다. 
   만약 2줄이 추가 되었으면 @@ -0,0 +1,2 @@로 표시될 것이다.
4. +hello this is second folder : "hello this is second folder"라는 내용이 파일에 추가되었다는 것이다.

```
# 그렇다면 git add와 git commit은 왜 같이 쓰는 걸까?

여기서 의문이 들 수 있는 점이 `git commit`만 하면 될 것이지, 왜 굳이 `git add`를 사용해야 하냐는 것이다.

결론부터 말하자면, **원하는 파일에 대해서만 커밋을 하기 위해서**이다. 

혼자서 작업을 한다면 큰 문제가 되지 않지만, 큰 프로젝트를 진행하다보면 코드를 많이 수정하는 경우가 생긴다. 커밋을 할 때는 1가지 기능만 수정하는 것이 이상적인데, 개발을 하다보면 어떤 파일은 아직 완료가 안 되어 있기도 하고, 어떤 파일은 올리면 안되는 경우가 생긴다. 또는 커밋 시기를 놓쳐서 각 파일마다 커밋 메세지를 못 남기는 경우가 있을 수 있다. 

그래서 `git add`를 사용하면 원하는 파일만 스테이징 영역에 올려서 **선택적인 커밋**을 할 수 있게 된다. 그리고 각 파일마다 커밋 메세지를 다르게 남기고 싶은 경우에도 동일하게 적용할 수 있다. (물론 귀찮기 때문에 이렇게는 안하고, 연관된 파일들끼리 묶어서 커밋을 한다.)