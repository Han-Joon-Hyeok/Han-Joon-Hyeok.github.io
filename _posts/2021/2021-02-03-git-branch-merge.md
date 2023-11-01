---
title: Git branch 병합(merge)
date: 2021-02-03 09:54:00 +0900
categories: [git]
tags: [git]
---

> [생활코딩 - 지옥에서 온 Git](https://opentutorials.org/course/2708)을 공부하며 정리한 내용입니다.

# Git branch 병합하기(git merge)

<p align="center">
    <img class="post-img" src="/assets/images/2021/2021-02-03-git-branch-merge/git_branch_merge.png" alt="git branch merge">
    <span align="center" class="post-img-caption">출처 : <a href="https://light-tree.tistory.com/230">https://light-tree.tistory.com/230</a></span>
</p>

각각의 branch로 나누어 작업을 하다가 하나로 통합해야 하는 순간이 찾아오는데, 이때 사용하는 명령어가 `git merge`이다.

프론트엔드와 백엔드를 나누어 작업을 하고, 기능 테스트를 위해 통합하는 경우가 대표적인 사례이다. 조금 더 쉬운 사례로는 조별과제로 PPT를 분담해서 작성하다가 하나로 합치는 것으로 이해할 수 있다.

이때, **서로 작업한 내역이 겹치거나 중복되는 부분**이 하나라도 있다면 **충돌**을 일으키므로 **각자의 영역을 철저하게 분리해서 작업**하는 것이 중요하다.

![git merge(1)](</assets/images/2021/2021-02-03-git-branch-merge/git_merge(1).png>)

현재 포스팅에서는 이전 포스팅의 내용을 이어서 작성하고 있다. 위의 도표는 현재 각 브랜치에 가장 최근에 커밋된 파일과 파일 내용을 정리한 것이다. 이제 우리는 이 2개의 브랜치를 `main` 브랜치에 합치려고 한다.

# 기본적인 브랜치 병합

## git checkout : 병합을 실행할 브랜치로 전환

`main` 브랜치에 합치려면 다음의 명령어를 실행해서 `main` 브랜치로 전환한다.

```bash
$ git checkout main
```

## git merge "합치려는 브랜치 이름"

그 다음, `exp` 브랜치를 `main`으로 합치려고 하는 것이기 때문에 다음의 명령어를 실행한다.

```bash
$ git merge exp
```

간단한 커밋 메세지를 남기면 다음과 같이 성공적으로 명령어가 실행된다.

![git merge(2)](</assets/images/2021/2021-02-03-git-branch-merge/git_merge(2).png>)

## 병합 후 브랜치 상태 확인하기

```bash
$ git log --branches --graph --oneline
```

위의 명령어를 입력해서 현재 브랜치의 상태를 살펴보자.

![git merge(3)](</assets/images/2021/2021-02-03-git-branch-merge/git_merge(3).png>)

`exp` 브랜치의 커밋('4')과 `main` 브랜치의 커밋('5')이 `main` 브랜치로 합쳐졌다는 것을 확인할 수 있다.

## 브랜치 삭제하기

만약 특정 브랜치가 필요해지지 않으면 다음의 명령어를 통해 브랜치를 삭제할 수 있다.

```bash
$ git branch -d '삭제할 브랜치 이름'
```

# 심화 : Fast-Forward와 Recursive Strategy

상황에 따라 `merge`는 2가지 방식으로 작동 하는데, 위와 같이 간단한 상황이 아닌 복잡한 상황에서의 병합을 살펴보자. 여기서부터는 [git 공식 사이트](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EB%B8%8C%EB%9E%9C%EC%B9%98%EC%99%80-Merge-%EC%9D%98-%EA%B8%B0%EC%B4%88)에 기재된 사진을 활용해서 설명하려고 한다.

결론부터 말하자면 다음과 같다.

- `Fast-Forward` : 새로운 커밋을 생성하지 않음. 병합하려는 브랜치가 서로 같은 커밋을 가리킬 때 사용.
- `Recursive` : 새로운 커밋을 생성함. 병합하려는 브랜치가 서로 다른 커밋을 가리킬 때 사용.

위의 2가지 방식을 직접 실행해야 하는 건 아니고, 자동으로 알아서 선택이 된다. 아래의 설명을 보면서 차근차근 이해해보자.

## 예시 상황

![git pro merge(1)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(1).png>)

위의 사진에 대한 이해를 돕자면, 오른쪽으로 갈수록 최근 커밋을 의미한다.

커밋 포인터는 이전 커밋 내용을 가르키는 것이고, 브랜치 포인터는 해당 브랜치가 가르키는 최근 커밋(`tree`)을 의미한다.

![git pro merge(2)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(2).png>)

어떠한 이슈가 생겨서 이를 해결하기 위해 `iss53` 이라는 브랜치를 새롭게 생성하였다.

![git pro merge(3)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(3).png>)

`iss53` 브랜치에서 새롭게 작업을 하고 커밋을 생성한 상태가 됐다. 그래서 이제 `master` 브랜치와 `iss53` 브랜치는 각각 다른 브랜치 포인터를 갖는다.

![git pro merge(4)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(4).png>)

이때, 긴급하게 수정해야 하는 문제가 있어서 `hotfix`라는 브랜치를 새롭게 생성하여 작업을 한 뒤, 커밋을 새롭게 했다. 그래서 `hotfix` 브랜치도 `master` 브랜치와 다른 브랜치 포인터를 갖게 되었다.

## 1. Fast-Forward (빨리감기)

새롭게 생성된 브랜치와 `main` 브랜치가 별도의 커밋 작업 없이 병합되는 방식이다. 병합하려는 브랜치들의 커밋 포인터가 모두 같은 커밋을 가리키고 있을 때 사용된다.

`hotfix` 브랜치와 `master` 브랜치를 먼저 병합한다고 해보자. 현재 `hotfix` 브랜치가 가르키는 `C4` 커밋은 `C2`에 기반한 커밋이다. `C4`는 `C2` 입장에서 보았을 때, `C2` 상태에서 테이프를 빨리감기한 미래의 상태라고 볼 수 있다.

![git pro merge(5)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(5).png>)

그래서 `$ git merge hotfix`를 실행하면 위와 같은 화면이 나올 것이다.

```bash
$ git merge hotfix
Updating 115e50f..e83212d
Fast-forward
 f5.txt | 1 +
 1 file changed, 1 insertion(+)
```

![git pro merge(6)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(6).png>)

그러면 이제 `master`와 `hotfix` 브랜치는 `C4` 커밋을 가리키게 된다. 이제 `hotfix` 브랜치는 필요 없어졌으니 다음의 명령어를 실행해서 브랜치를 삭제한다.

```bash
$ git branch -d hotfix
```

다시 `iss53` 브랜치로 돌아가서 하던 작업을 마무리 하고 커밋을 하면 다음과 같이 변한다.

![git pro merge(7)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(7).png>)

`iss53` 브랜치는 이전에 `master` 브랜치가 병합을 했던 작업으로부터 아무런 영향을 받지 않은 채 `C5` 커밋을 가리키게 된다.

## 2. Recursive (재귀)

`Recursive` 방식은 새로운 커밋을 하나 생성하는 방식이다. 병합하려는 브랜치들의 커밋 포인터가 서로 다른 커밋을 가리키고 있을 때 사용된다.

![git pro merge(8)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(8).png>)

현재 `master` 브랜치의 `C4` 커밋 포인터는 `C2`를 가리키고 있는 반면, `iss53` 브랜치의 `C5` 커밋 포인터는 `C3`를 가리키고 있다. 두 브랜치 모두 같은 조상 `C2` 커밋으로부터 갈라져 나왔으므로 같은 커밋에서 갈라져 나왔다는 것을 명시해야 한다.

그래서 `master` 브랜치에서 병합을 수행하면, `3-way Merge`라는 내부 알고리즘을 이용해서 두 브랜치의 공통 조상을 찾아간다. 이때 `Recursive(재귀)` 방식으로 공통 조상을 찾고, 두 브랜치를 병합하고 나서 새로운 커밋을 생성하게 된다.

![git pro merge(9)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(9).png>)

병합을 수행한 뒤 모습은 최종적으로 위와 같다.

![git pro merge(10)](</assets/images/2021/2021-02-03-git-branch-merge/git_pro_merge(10).png>)

```bash
$ git merge iss001
hint: Waiting for your editor to close the file...
Merge made by the 'recursive' strategy.
 f6.txt | 2 ++
 1 file changed, 2 insertion(+)
 create mode 100644 f6.txt
```

그리고 `Merge made by the 'recursive' strategy`라는 문구와 함께 성공적으로 병합이 수행되는 것을 확인할 수 있다.

### 참고 사이트

- [https://light-tree.tistory.com/230](https://light-tree.tistory.com/230)
- [https://git-scm.com/book/ko/v2/Git-브랜치-브랜치와- Merge-의-기초](https://git-scm.com/book/ko/v2/Git-%EB%B8%8C%EB%9E%9C%EC%B9%98-%EB%B8%8C%EB%9E%9C%EC%B9%98%EC%99%80-Merge-%EC%9D%98-%EA%B8%B0%EC%B4%88)
