---
title: Javascript - EventHandler를 object에 넣기
date: 2021-02-10 20:24:00 +0900
categories: [javascript]
tags: [javascript]
---

`const`로 정의한 `object`에 `handler`를 저장하고, 이를 외부에서 실행하는 방법은 다음과 같다. 

``` javascript
let text = document.querySelector("body h2");
const Handler = {
    mouserOver: function(){
        text.innerHTML = "Mouse is on"
        text.style.color = "#ff9999"
    }
}

function init(){
    text.addEventListner("mouseOver", Handler.mouseOver);
}

init()
```

외부에서 해당 `handler`를 실행하고자 하면, `객체명.key값`으로 접근해서 실행한다.

