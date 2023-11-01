---
title: git reset, revert 비교 및 사용법 정리
date: 2021-01-25 22:53:00 +0900
categories: [git]
tags: [git]
---

> [생활코딩 - 지옥에서 온 Git](https://opentutorials.org/course/2708)을 공부하며 정리한 내용입니다.

# git reset, git revert : 과거로 돌아가기

`git reset`과 `git revert`는 특정 시점 commit으로 되돌리고 싶을 때 사용하는 명령어이다.

- `git reset` : 커밋 내역들을 삭제하고, 특정 시점의 커밋으로 되돌아감. 시계를 다시 맞추는 것.
- `git revert` : 이전 커밋 내역들은 그대로 두고, 되돌리고 싶은 커밋의 코드만 복원시킨다.

이 개념을 쉽게 Devpools의 이리온님께서 설명해주셨는데, 다음의 링크를 참고하면 도움이 될 것이다.

- [개발바보들 1화 - git "Back to the Future"](http://www.devpools.kr/2017/01/31/%EA%B0%9C%EB%B0%9C%EB%B0%94%EB%B3%B4%EB%93%A4-1%ED%99%94-git-back-to-the-future/)

# 1. git reset

![git reset(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset(1).png>)

위의 사진에서 `second commit`을 실행한 시점으로 돌아가고 싶고, 3~4번째 커밋을 삭제하고 싶다면 다음과 같은 명령어를 실행한다.

`$ git reset 되돌리고 싶은 커밋의 코드 --옵션`

![git reset(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset(2).png>)

그러면 3~4번째 커밋 내역은 삭제되고, 2번째 커밋 시점으로 되돌아가게 된다.

하지만 커밋 내역을 삭제했다는 것은 해당 파일들을 삭제했다는 것은 아니다. 당연히 reset을 잘못 수행했을 경우도 있기 때문에 이를 취소하는 방법도 존재한다. 우리 눈에 보이지 않을 뿐, 해당 버전에 대한 파일은 존재하고 있다.

![git reset(3)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset(3).png>)

주의할 점은, **reset은 가능하면 로컬 저장소에서만 실행**이 되어야 한다는 것이다. github와 같은 원격 저장소에 올라간 뒤에 reset을 실행하면 이전 커밋 내역들이 전부 삭제된다. 만약 다른 사람들과 함께 작업을 하고 있었고, 팀원들이 원격 저장소의 커밋을 되돌린 사실을 몰랐다면, 되돌렸던 커밋들이 다시 원격 저장소에 추가된다. 그래서 위의 그림과 같은 상황이 발생하지 않으려면 미리 공지를 하거나, 가급적이면 `git revert`를 사용하는 것이 안전하다.

## 옵션

옵션에는 여러 가지가 있는데, 그 중에서 자주 사용하는 것은 hard, mixed, soft가 있다.

우선 git 명령어들의 영향 범위를 그림으로 표현하면 다음과 같다.

<div class="img-container">
  <img class="post-img" src="/assets/images/2021/2021-01-25-git-reset-revert/git_movement.png">
  <p class="post-img-caption">출처 : 
    <a href="https://velog.io/@sonypark/git-reset-vs-git-revert-%EC%B0%A8%EC%9D%B4">
      https://velog.io/@sonypark/git-reset-vs-git-revert-차이
    </a>
  </p>
</div>

현재 항목에서는 다음과 같은 커밋을 진행하였다.

![git_commit_내역](/assets/images/2021/2021-01-25-git-reset-revert/git_commit_내역.png)

### 1. hard

돌아가려는 이력 이후의 모든 내용을 지우고 모든 상태를 초기화한다.

commit된 파일들 중 **tracked 파일들을 working directory**(로컬 저장소)에서 삭제한다.

![git reset --hard](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_hard(1).png>)

`git status`로 현재 스테이지 영역을 확인해보면, `Second commit` 이후의 어떠한 파일도 스테이지 영역에 올라와있지 않은 것을 확인할 수 있다.

![git reset --hard](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_hard(2).png>)

초록색으로 표시된 영역까지 현재 로컬 저장소에 남아있고, 이력 또한 `Second commit`이후의 내역은 삭제되었다.

### 2. soft

돌아가려 했던 이력으로 되돌아 갔지만, 이후의 내용이 지워지지 않으며, 해당 내용의 인덱스(또는 스테이지)도 그대로 존재한다.

![git reset --soft(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_soft(1).png>)

로컬 저장소의 파일은 삭제되지 않은 채로 스테이지 영역에 파일이 올라와있는 상태이다. 즉, `git add`가 실행된 직후의 되돌아가고, 바로 commit을 수행할 수 있는 상태가 되는 것이다.

![git reset --soft(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_soft(2).png>)

`Second commit`을 기준으로 했을 때,

- `test3.txt`는 새롭게 생성된 파일이기 때문에 `tracked`로 변경되었다.
- `test1.txt`는 기존 파일에서 내용이 추가되었기 때문에 `modified`로 변경되었다.

### 3. mixed (옵션을 적지 않으면 기본값으로 동작)

이력은 되돌려지지만, 스테이지는 초기화된다. 즉, `git add`가 실행되기 이전의 상태로 돌아가는 것이다.

![git reset --mixed(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_mixed(1).png>)

`soft`방식과 비슷하게 `test1.txt`파일과 `test3.txt`파일은 로컬 저장소에 되어있지만, `git add`를 실행하기 이전의 상태이다.

![git reset --mixed(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_mixed(2).png>)

## git reset 취소하기

`git reflog`를 입력하면 다음의 사진과 같이 변경 내역을 볼 수 있다.

![git reset cancel(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_cancel(1).png>)

되돌아가고 싶은 HEAD를 확인하고, 만약 `HEAD@{2} 'fourth commit'`로 이동하고 싶다면 다음과 같이 입력한다.

`git reset --hard HEAD@{2}`

![git reset cancel(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_cancel(2).png>)

그러면 reset을 정상적으로 취소하고, 원하는 상태로 되돌아올 수 있다.

![git reset cancel(3)](</assets/images/2021/2021-01-25-git-reset-revert/git_reset_cancel(3).png>)

# 2. git revert

1번에서 다룬 `reset`의 근본적인 문제점은 팀원들과 공유하는 원격 저장소의 커밋 내역을 강제로 조작한다는 것이었다.

그래서 `git revert`를 사용하면 커밋 내역을 전부 삭제하는 것이 아닌 `revert` 커밋 자체를 커밋 내역에 쌓는 방식으로 사용하면 앞선 문제점을 해결할 수 있다. 다시 말해서, **특정 커밋을 되돌리는 작업도 하나의 커밋으로 간주**하여 커밋 내역에 추가하므로, 내가 되돌린 작업을 다른 팀원들과 공유할 수 있게 된다.

![git revert(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert(1).png>)

## 방법

`$ git revert 되돌리고 싶은 commit의 hash`는 특정 커밋에서 변경 사항을 제거하고, 새로운 커밋을 생성하는 명령어이다.

*Commit A -> Commit B -> Commit C*의 순서로 커밋 내역이 쌓이는 것을 생각해보면, 이를 다시 원래대로 돌리기 위해서는 _Commit C -> Commit B -> Commit A_ 거꾸로 revert를 실행하면 된다.("실행취소"기능과 비슷하다)

![git revert(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert(2).png>)

위의 그림에서는 가장 최근의 커밋인 `fourth commit`으로 되돌렸고, 기존의 커밋들은 남은 채 새로운 커밋이 쌓인 것을 확인할 수 있다. 파일 상태는 다음과 같이 정리할 수 있다.

![git revert(3)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert(3).png>)

만약 `second commit`까지 되돌리고 싶은 경우에는 `..`으로 범위를 주어 `commit2..commit4`과 같이 입력하면 된다.

`$ git revert commit2_hash..commit4_hash`

즉, 아래와 같이 정리할 수 있다.

> git revert `되돌아갈 커밋`..`되돌리기 시작할 최근 커밋`

![git revert(4)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert(4).png>)

## `--no-commit` 옵션 사용하기

하지만 여러 커밋을 되돌리는 경우에는 각 revert마다 커밋 메세지를 작성해야 하는 번거로움이 생긴다. 이때, `--no-commit` 옵션을 이용하면 revert를 위한 커밋을 하나만 생성할 수 있다.

그리고 커밋의 hash가 아닌 `되돌리고 싶은 커밋의 범위`를 인수로 입력해주면 된다.

![git no-commit(1)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert_no_commit(1).png>)

`$ git revert --no-commit HEAD~2..`

`HEAD~2..`는 최근 2개 커밋을 의미한다. 현재 commit 4를 마친 상태에 있으므로, commit 4와 commit 3을 취소하게 되는 것이다.

`--no-commit`을 사용하면 복수의 revert에 대해서 각각 커밋 메세지를 남기는 대신, 하나의 커밋 메세지만 남기도록 한다. 따라서 `git add`를 완료한 상태로 되돌아가게 되며, 아래와 같이 별도의 커밋 메세지를 남겨야 한다.

![git no-commit(2)](</assets/images/2021/2021-01-25-git-reset-revert/git_revert_no_commit(2).png>)

위와 같이 정상적으로 여러 커밋에 대한 revert도 하나의 커밋 메세지로 처리할 수 있게 된다.

# 3. git reset과 git revert의 차이는?

![Difference between Reset and Revert](/assets/images/2021/2021-01-25-git-reset-revert/git_reset_revert_compare.png)

- `git reset`
  - 과거 커밋 내역을 삭제한다.
  - 과거 커밋으로 되돌아간다는 커밋 메세지를 남기지 않는다.
  - 주로 로컬 저장소에서 작업할 때 사용할 수 있다. (push를 하기 이전)
- `git revert`
  - 과거 커밋 내역을 유지한다.
  - 과거 커밋으로 되돌아간다는 커밋 메세지를 남길 수 있다.
  - 주로 원격 저장소에 이미 push를 했을 때 사용한다.

# 참고자료

- [https://medium.com/nonamedeveloper/[초보용]-Git-되돌리기-reset-revert](https://medium.com/nonamedeveloper/%EC%B4%88%EB%B3%B4%EC%9A%A9-git-%EB%90%98%EB%8F%8C%EB%A6%AC%EA%B8%B0-reset-revert-d572b4cb0bd5)
- [https://velog.io/@sonypark/git-reset-vs-git-revert-차이](https://velog.io/@sonypark/git-reset-vs-git-revert-%EC%B0%A8%EC%9D%B4)
- [[Git] reset 한거 취소하는 방법](https://88240.tistory.com/284)
- [https://jupiny.com/2019/03/19/revert-commits-in-remote-repository/](https://jupiny.com/2019/03/19/revert-commits-in-remote-repository/)
- [https://github.com/HomoEfficio/dev-tips/blob/master/Git%20reverting%20multiple-commits.md](https://github.com/HomoEfficio/dev-tips/blob/master/Git%20reverting%20multiple-commits.md)
