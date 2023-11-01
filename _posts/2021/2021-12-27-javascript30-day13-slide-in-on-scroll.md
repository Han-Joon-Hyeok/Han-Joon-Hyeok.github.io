---
title: Javascript30 - Day 13 Slide in on Scroll
date: 2021-12-27 00:20:00 +0900
categories: [javascript]
tags: [javascript30, javascript]
---

> [Javascript30](https://javascript30.com/)

# 구현 내용

스크롤을 했을 때, 이미지의 절반 이상 지나가면 자연스럽게 날아오는 효과를 구현한다. 브라우저에서 스크롤한 위치와 이미지의 높이 및 offset 값을 계산해서 절반을 지나갔는지 확인한다.

## debouncing

템플릿 파일에서 제공하는 함수이다. 디바운싱은 연속해서 호출되는 함수들 중 마지막 함수 또는 제일 처음 함수만 호출하도록 하는 것이다. 사용자가 스크롤을 멈추기 전까지는 스크롤 이벤트를 계속 호출하는데, 이로 인해 성능이 저하되는 문제를 해결하기 위해 사용한다. 일정 시간이 지나고 나서 이벤트가 다시 발생하지 않으면 이벤트 발생이 끝난 것으로 파악하고, 내부 로직을 수행한다.

```javascript
function debounce(func, wait = 20, immediate = true) {
  var timeout;
  return function () {
    var context = this,
      args = arguments;
    var later = function () {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
}
```

## slide 효과 구현

### 1. 브라우저 높이 구하기

![image001.jpg](/assets/images/2021/2021-12-27-javascript30-day13-slide-in-on-scroll/image001.jpg)

스크롤이 끝나는 시점에서 현재 위치를 구하기 위해서 우선 브라우저의 높이를 구한다. 아래의 두 가지는 다른 것이며, 여기서는 `innerHeight` 를 이용해서 구한다.

- `[window.innerHeight](https://developer.mozilla.org/en-US/docs/Web/API/Window/innerHeight)` : 눈에 보이는 브라우저의 현재 높이, 즉 viewport 의 높이를 의미한다.
- `[Element.clientHeight](https://developer.mozilla.org/en-US/docs/Web/API/Element/clientHeight)` : padding 을 포함한 요소 내부의 높이를 의미한다. margin 과 border 는 제외된다. body 의 `clientHeight` 는 문서의 맨 처음부터 끝나는 지점까지의 높이를 의미한다.

### 2. viewport 하단 Y좌표 구하기

![image002.jpg](/assets/images/2021/2021-12-27-javascript30-day13-slide-in-on-scroll/image002.jpg)

현재 보이는 브라우저 하단의 좌표를 구하기 위해서 문서의 상단으로부터 얼마나 이동했는지와 브라우저의 높이를 더한다.

- `[window.scrollY](https://developer.mozilla.org/en-US/docs/Web/API/Window/scrollY)` : document 의 상단으로부터 수직으로 얼마나 이동했는지 반환하는 값이다. `innerHeight` 와 `scrollY` 값을 더하면 현재 보이는 화면(viewport)의 하단 Y좌표를 구할 수 있다.

```javascript
const viewportBottom = window.innerHeight + window.scrollY;
```

### 3. 이미지의 Y좌표 구하기

![image003.jpg](/assets/images/2021/2021-12-27-javascript30-day13-slide-in-on-scroll/image003.jpg)

이미지의 Y 좌표를 구하기 위해서 이미지가 문서 상단으로부터 얼마나 떨어져 있는지와 이미지의 높이를 구한다.

- `[HTMLElement.offsetTop](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/offsetTop)` : 부모 요소로부터 해당 요소의 상단 border 까지의 거리를 의미한다. 여기서 부모 요소는 문서의 맨 처음부터 시작했으므로 body 와 동일하지만, 부모 요소에 따라 값이 달라질 수 있음을 유의해야 한다.

```javascript
const imageHalfBottom = image.offsetTop + image.height / 2;
```

참고로 `[getBoundingClientRect()](https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect)` 는 viewport 로부터 대상까지의 거리를 구한다. 그래서 브라우저 크기에 따라 절대적인 값이 아닌 상대적인 값으로 반환된다.

### 4. 트리거 만들기

이미지가 절반 이상 지나갔을 때 나타나게 하기 위해서 다음과 같은 흐름을 따른다.

- `viewport 의 맨 밑바닥 좌표값`보다 `image 절반에 해당하는 좌표값`이 크다는 것은 `viewport` 에서 이미지가 절반 이상 보였다는 의미이다.

```javascript
const isHalfShown = viewportBottom > imageHalfBottom;
```

- 스크롤해서 이미지를 완전히 지나가면 사라지게 하기 위해서 변수 `isNotScrolledPast` 를 두어 이미지가 `viewport` 를 지나갔는지 판단한다.

```javascript
const isNotScrolledPast = window.scrollY < image.offsetTop + image.height;
```

- 이미지가 절반을 지나갔고, 아직 완전히 지나가지 않았다면 이미지에 `active` 클래스를 추가한다. 그리고 이미지를 완전히 지나갔다면 해당 클래스를 제거한다.

```javascript
if (isHalfShown && isNotScrolledPast) {
  image.classList.add("active");
} else {
  image.classList.add("active");
}
```

## 완성 코드

```javascript
const images = document.querySelectorAll(".slide-in");

const handleImageSlide = () => {
  images.forEach((image) => {
    const viewportBottom = window.scrollY + window.innerHeight;
    const imageHalfBottom = image.offsetTop + image.height / 2;
    const isHalfShown = viewportBottom > imageHalfBottom;
    const isNotScrolledPast = window.scrollY < image.offsetTop + image.height;

    if (isHalfShown && isNotScrolledPast) {
      image.classList.add("active");
    } else {
      image.classList.remove("active");
    }
  });
};

window.addEventListener("scroll", debounce(handleImageSlide, 100));
```

# 참고자료

- [쓰로틀링과 디바운싱](https://www.zerocho.com/category/javascript/post/59a8e9cb15ac0000182794fa)
- [Javascript - 디바운싱, 쓰로틀링](https://zinirun.github.io/2020/08/16/js-throttling-debouncing/)
- [[JS] Scroll에 대한 정리](https://velog.io/@sa02045/Scroll-%EC%A0%95%EB%A6%AC)
