---
title: github 잔디심기를 위한 git commit 날짜 바꾸기
date: 2021-03-05 08:55:00 +0900
categories: [git]
tags: [git]
---

# 사용목적

github 잔디 심기를 위해 git commit 날짜를 임의로 조정하고 싶을 때 사용한다.
현재 포스팅에서 설명하는 방법은 가장 최근에 수행한 commit에 대해서만 날짜를 변경하는 것이다.
이전의 commit에 대해 변경하는 방법은 다시 보충할 예정이다.

# 방법

## 1. 마지막 Commit 날짜를 오늘로 설정

`git commit --amend --no-edit --date "${date}"`

## 2. 마지막 Commit 날짜를 임의의 날짜로 설정

`git commit --amend --no-edit --date "Thu 04 Mar 2021 18:25:00 KST"`

