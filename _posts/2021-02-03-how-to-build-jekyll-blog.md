---
title: github.io에 Jekyll Theme(Chirpy)를 적용해보자
date: 2021-02-03 08:45:00 +0900
categories: [github]
tags: [github, jekyll]
image:
    src: /assets/images/2021-02-03-how-to-build-jekyll-blog/preview_image.png
    alt: how to apply 'chirpy' theme of jekyll in github.io
---

# 0. 들어가며

개발 공부를 하면서 공부한 것들을 정리하지 않으면 금세 날아가 버린다는 것을 느끼고 있었다. 강의를 듣고 배우기는 했어도, 남들에게 설명해보라고 하면 쉽게 할 수 없는 그런 상태였다. 다시 말해, 수동적으로 강의를 듣고 마치 내가 모든 것을 다 안다는 착각에 빠져있었던 것이다. 

<p align="center">
    <img class="post-img" src="/assets/images/2021-02-03-how-to-build-jekyll-blog/cheese_duck.png" alt="공부를 했어도 시험지에는 답을 쓸 수가 없다">
    <span align="center" class="post-img-caption">교수님께 애정을 담은 편지를 써볼까 진지하게 고민도 해봤었다.</span>
</p>

학습의 효과는 강의를 듣기만 하는 것보다 소리를 내어 말하는 것이 좋고, **가장 좋은 방법은 누군가를 가르칠 때 가장 큰 효과**를 보인다고 한다. 그래서 이 블로그에는 개발을 공부하며 배운 것들을 차근차근 하나씩 정리해나갈 예정이다. 지식의 정확도나 깊이가 좋지 않을 수 있지만, 이 글을 읽고 있는 여러분들의 피드백이나 질문은 언제나 환영이다.

<p align="center">
    <img class="post-img" src="/assets/images/2021-02-03-how-to-build-jekyll-blog/learning_pyramid.png" alt="학습효과 피라미드">
    <span align="center" class="post-img-caption">출처 : <a href="https://m.blog.naver.com/u2math/221346925531">https://m.blog.naver.com/u2math/221346925531</a></span>
</p>

# 1. github.io란?

<p align="center">
    <img class="post-img" src="/assets/images/2021-02-03-how-to-build-jekyll-blog/github_pages.jpg" alt="github pages">
    <span align="center" class="post-img-caption">출처 : <a href="https://pages.github.com/">https://pages.github.com/</a></span>
</p>


`github.io`는 github에서 제공하는 무료 호스팅 도메인이다. github에 가입되어 있다면 누구나 `https://(github 아이디).github.io` 주소를 가진 페이지를 가질 수 있다.

이번 포스팅에서는 `Jekyll`을 활용하여 개인 블로그 제작하는 방법에 대해 담아보았다. Github Pages를 구축하는 방법은 다른 분들께서 상세하게 설명한 글들이 많기도 하고, 그렇게 어려운 작업은 아니기 때문에 다른 글들을 참고해서 구축하는 것을 추천한다. 

> **참고 사이트**
> - [생활코딩 github pages](https://opentutorials.org/course/3084/18891)

Github Pages는 HTML, CSS, JS만으로도 구축할 수 있지만, `Markdown`을 사용한 웹 사이트를 생성하기 위해서 `Jekyll`을 지원한다. 

# 2. Jekyll이란?

<p align="center">
    <img class="post-img" src="/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll.png" alt="Jekyll">
    <span align="center" class="post-img-caption">출처 : <a href="https://poiemaweb.com/jekyll-basics">https://poiemaweb.com/jekyll-basics</a></span>
</p>

`Jekyll`은 `Ruby`로 만들어졌으며, `Markdown`으로 작성된 문서를 HTML로 변환해서 웹사이트를 구축할 수 있도록 도와주는 `Static Website Generator(정적 사이트 생성기)`이다. Jekyll은 전 세계 각지에서 다양한 사람들이 만든 블로그 테마들이 존재한다. 그래서 이 테마들을 이용하면 Jekyll에 대해서 잘 모르더라도 누구나 쉽고 빠르게 개인 블로그를 만들 수 있는 것이다. 

# 3. Jekyll 테마를 골라보자

이미 다양한 사이트에서 수 많은 테마를 제공하고 있어서 무엇을 고를 지 고민스러울 정도다. 다음은 Jekyll 테마를 제공하는 사이트 목록이다. 

## Jekyll 테마 사이트 목록

Jekyll은 오픈소스 테마가 굉장히 많이 공유되고 있다. 너무 많아서 고르기가 힘들 정도인데, 다음의 사이트들을 하나씩 살펴보면서 마음에 드는 테마를 찾아보면 좋을 것 같다.

1. [https://github.com/topics/jekyll-theme](https://github.com/topics/jekyll-theme)
    ![jekyll theme page(1)](/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll_theme_page(1).png)
    - `Github`에 사용자들이 공유한 Jekyll Theme를 볼 수 있는 페이지이다. 
    - 필터링 기능을 제공하기 때문에 사용이 편리하다는 장점이 있다.
2. [https://jekyllthemes.io/free](https://jekyllthemes.io/free)
    ![jekyll theme page(2)](/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll_theme_page(2).png)
    ![jekyll theme page(2-1)](/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll_theme_page(2-1).png)
    - 무료/유료 테마를 다운받을 수 있는 사이트이다. 
    - 원하는 목적에 맞는 테마 목록들을 제공하고 있다는 장점이 있다.
3. [http://jekyllthemes.org/](http://jekyllthemes.org/)
    ![jekyll theme page(3)](/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll_theme_page(3).png)
    - 심플한 구성이 특징인 사이트이다. 
    - 필터링이나 카테고리 기능을 제공하지 않기 때문에 창고형 매장처럼 원하는 테마를 하나씩 찾아보아야 한다.
4. [hhttp://themes.jekyllrc.org/](hhttp://themes.jekyllrc.org/)
    ![jekyll theme page(4)](/assets/images/2021-02-03-how-to-build-jekyll-blog/jekyll_theme_page(4).png)
    - `셔플` 기능이 특징인 사이트이다. 랜덤으로 돌리다가 원하는 테마를 찾는 재미가 쏠쏠하다.
    - 페이지를 따로 넘기지 않고 한 페이지 안에 모두 테마를 볼 수 있어서 편하다는 장점이 있다.




참고 사이트

https://theorydb.github.io/envops/2019/05/02/envops-blog-theme/
http://labs.brandi.co.kr/2018/05/14/chunbs.html
https://poiemaweb.com/jekyll-basics
https://dreamgonfly.github.io/blog/jekyll-remote-theme/
https://opentutorials.org/course/3084/18891