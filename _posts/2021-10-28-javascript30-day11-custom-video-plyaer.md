---
title: Javascript30 - Day 11 Custom Video Player 내용 정리
date: 2021-10-28 17:30:00 +0900
categories: [javascript]
tags: [javascript30, javascript]
---
> [Javascript30](https://javascript30.com/)

# 완성 코드

```javascript
const video = document.querySelector("video");
const playBtn = document.querySelector(".player__button");
const rangeControls = document.querySelectorAll(".player__slider");
const progressControl = document.querySelector(".progress");
const progressBar = document.querySelector(".progress__filled");
const skipBtns = document.querySelectorAll("button[data-skip]");

let videoDuration = 0;
let mousedown = false;

const handlePlay = (e) => {
  if (video.paused) {
    video.play();
  } else {
    video.pause();
  }
};

// 함수는 한 가지 기능만 담당하도록 분리 (from handlePlay)
const updateButton = () => {
  playBtn.innerText = video.paused ? "▶️" : "⏸";
};

const handleSpaceBar = (e) => {
  if (e.code === "Space") {
    handlePlay();
  }
};

const handleProgressBar = () => {
  const percent = (video.currentTime / videoDuration) * 100;
  progressBar.style.flexBasis = `${percent}%`;
};

const handleLoadedMetaData = () => {
  console.log("loaded");
  videoDuration = video.duration;
  handleProgressBar();
};

const handleVolume = (e) => {
  const {
    target: { value },
  } = e;
  video.volume = value;
};

const handlePlaybackRate = (e) => {
  const {
    target: { value, name },
  } = e;
  console.log(name);
  video.playbackRate = value;
};

const handleRangeControl = (e) => {
  const {
    target: { name, value },
  } = e;
  video[name] = value;
};

const handleSkip = (e) => {
  let {
    target: {
      dataset: { skip },
    },
  } = e;
  skip = parseFloat(skip);
  if (video.currentTime + skip > 0) {
    video.currentTime += skip;
  } else {
    video.currentTime = 0;
  }
};

const handlePlayTime = (e) => {
  const { offsetX } = e;
  const { offsetWidth } = progressControl;
  video.currentTime = (offsetX / offsetWidth) * video.duration;
};

const handleMouseDown = () => {
  mousedown = mousedown ? false : true;
};

video.addEventListener("timeupdate", handleProgressBar);
video.addEventListener("click", handlePlay);
video.addEventListener("play", updateButton);
video.addEventListener("pause", updateButton);
playBtn.addEventListener("click", handlePlay);
document.addEventListener("keydown", handleSpaceBar);

rangeControls.forEach((control) =>
  control.addEventListener("input", handleRangeControl)
);
skipBtns.forEach((btn) => btn.addEventListener("click", handleSkip));

progressControl.addEventListener("click", handlePlayTime);
progressControl.addEventListener(
  "mousemove",
  (e) => mousedown && handlePlayTime(e)
);
progressControl.addEventListener("mousedown", handleMouseDown);
progressControl.addEventListener("mouseup", handleMouseDown);

if(video.readyState === 4) {
    handleLoadedMetaData()
}
```

# 💡배운 내용

## 1. `loadedmetadata` 가 비규칙적으로 실행되는 현상

### 문제 상황

- 비디오의 전체 길이(`video.duration`)을 알기 위해 `video` 요소에 이벤트 리스너로 `loadedmetadata`를 설정했다. 이를 통해 비디오의 현재 재생 위치를 표시할 수 있도록 했다.
- 하지만, `loadedmetadata`가 비규칙적으로 실행되었는데, 실행되지 않으면 현재 재생 위치를 제대로 표시할 수 없었다.

### 문제 원인

> [https://dev.opera.com/articles/consistent-event-firing-with-html5-video/](https://dev.opera.com/articles/consistent-event-firing-with-html5-video/)
> 

위의 글에 따르면 이벤트 리스너가 `video`에 걸리기 전에, `video`가 전부 로딩 되고 `loadedmetadata`가 먼저 실행 되었기 때문이라고 한다. 이는 이벤트 리스너와 `loadedmetadata`가 서로 경쟁 상태(race condition)에 있기 때문이다. 그래서 어느 것이 먼저 실행될 지는 랜덤으로 정해진다는 것이다. 

### 해결 방안

1. `loadedmetadata`가 실행되기 전에 먼저 이벤트 리스너를 등록하는 방법이 있다. 
    - `video` 태그 안에 직접 등록을 하는 방법
    
    ```javascript
    <video src="test.webm" onloadedmetadata="alert('Got loadedmetadata!')"></video>
    ```
    
    - `video` 태그를 새롭게 만들어서 설정하는 방법
    
    ```javascript
    let video = document.createElement('video');
    video.onloadedmetadata = function(e) {
      alert('Got loadedmetadata!');
    }
    video.src = 'test.webm';
    document.body.appendChild(video);
    ```
    
2. 이벤트 리스너가 아닌 `readyState` 를 기준으로 함수를 실행 시키는 방법.
    
    ```javascript
    const handleLoadedMetaData = () => {
    	...
    }
    
    /* ... */
    
    if (video.readyState === 4) {
    	handleLoadedMetaData()
    }
    ```
    
    이 방법은 스크립트의 맨 마지막에 추가해서 비디오가 충분히 불러와질 때까지 기다린다. `video.readyState` 가 4라는 것은 충분히 불러와져서 사용이 가능하다는 것이다. 
    
    아래의 링크를 통해 좀 더 자세한 정보를 참고할 수 있다.
    
    > [https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/readyState](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/readyState)
    > 

## 2. 단항 연산자 (unary operator)

### 단항 더하기(+)

String 타입의 정수 또는 실수를 Number로 변환하는 방법 중 하나이다. 단항 더하기 연산자는 피연산자 앞에 위치하는데, 만약 피연산자가 숫자가 아니면 숫자로 변환을 시도한다. 숫자로 변환할 수 없는 값이면 `NaN`을 반환한다.

```javascript
const x = 1;
const y = -1;
const z = "123";

console.log(+x) // 1
console.log(+y) // -1

console.log(z) // "123"
console.log(+z) // 123

console.log(+'') // 0

console.log(+true) // 1
console.log(+false) // 0

console.log(+"hello"); // NaN
```

### 단항 부정(-)

단항 더하기와 마찬가지로 숫자가 아니면 숫자로 변환을 시도한다. 양수는 음수로, 음수는 양수로 바꾼다.

```javascript
const x = 4;
const y = -4;
const z = "-123"

console.log(-x) // -4
console.log(-y) // 4

console.log(z) // "-123"
console.log(-z) // 123

console.log(-true) // -1
console.log(-false) // -0
```

## 3. 함수는 한 가지 기능만 하도록 분리

- 비디오를 재생 및 중지할 때, 처음에는 버튼 모양이 함께 바뀌도록 작성했다.
    
    ```javascript
    const handlePlay = (e) => {
      if (video.paused) {
        video.play();
      } else {
        video.pause();
      }
    	playBtn.innerText = video.paused ? "▶️" : "⏸";
    };
    
    video.addEventListener("click", handlePlay);
    ```
    
- 클릭을 했을 때 (1) 비디오 재생 (2) 버튼 변경, 두 가지가 발생하기 때문에, 이를 분리해서 관리할 수 있다.
    
    ```javascript
    const handlePlay = (e) => {
      if (video.paused) {
        video.play();
      } else {
        video.pause();
      }
    };
    
    // 함수는 한 가지 기능만 담당하도록 분리 (from handlePlay)
    const updateButton = () => {
      playBtn.innerText = video.paused ? "▶️" : "⏸";
    };
    
    video.addEventListener("click", handlePlay);
    video.addEventListener("play", updateButton);
    video.addEventListener("pause", updateButton);
    ```