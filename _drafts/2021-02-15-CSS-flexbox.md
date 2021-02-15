---
title: CSS - Flexbox 속성 및 사용법 정리
date: 2021-02-15 09:00:00 +0900
categories: [css]
tags: [css]
---

> [드림코딩 - CSS Flexbox 완전 정리](https://youtu.be/7neASrWEFEM) 영상을 공부하며 정리한 내용입니다.

# Flexbox?

`Flexbox`는 행과 열로 HTML 요소들을 유연하고 빠르게 정렬하는 것을 도와주는 CSS의 속성이다. 

기존에는 원하는 위치에 요소를 배치하기 위해서 `table`, `position`, `float`를 사용했었다. 하지만, 새로운 요소가 추가되면 전체적인 CSS를 변경해야 하거나, 요소들을 같은 간격으로 동일한 너비와 높이로 정렬하는 것은 어려운 문제였다.

이러한 문제를 해결하기 위해 등장한 것이 `Flexbox`이다.

이제 `Flexbox`는 핵심적인 2가지를 살펴보도록 하자.

## 1. Flexbox의 속성

`Flexbox`는 요소를 담는 `container`에 적용하는 속성과 내부 `item`에 적용할 수 있는 속성, 2가지로 나뉜다.

1. `container` 속성
   - display
   - flex-direction
   - flex-wrap
   - flex-flow
   - justify-content
   - align-items
   - align-content
2. `item` 속성
   - order
   - flex-grow
   - flex-shrink
   - flex
   - align-self

### container 속성

#### `display: flex`

`box` 형태의 아이템들을 `인라인` 형태로 좌측에서 우측으로 정렬한다.

#### `flex-direction`

- row : 기본값. 좌측에서 우측으로 정렬
- row-reverse : 우측에서 좌측으로 정렬
- column : 수직으로 정렬. 위에서 아래로 정렬
- column-reverse : 반대 순서로 정렬. 아래에서 위로 정렬

## 2. Axis(축)

flexbox는 메인축(`main axis`)과 반대축(`cross axis`)으로 구성이 되어있다. 만약 수평을 메인축으로 하면, 반대축은 수직이 되는 것이다. 기본값은 `수평`이 메인축이다.

<p class="img-container">
    <img class="post-img" src="/assets/images/2021-02-15-CSS-flexbox/flexbox-axis(1).png" alt="Jekyll">
    <p class="post-img-caption">출처 : <a href="https://d2.naver.com/helloworld/8540176">https://d2.naver.com/helloworld/8540176</a></p>
</p>




참고자료 : https://developer.mozilla.org/ko/docs/Learn/CSS/CSS_layout/F